# Script that fuzzes two inputs (C code or LLVM IR) against each other
import argparse
import os
import subprocess
import json, re, struct

def c_type_to_llvm_type(c_type):
    """
    Convert C types to LLVM IR types.
    """
    if c_type == "void":
        return "void"
    type_mapping = {
        'int': 'i32',
        'float': 'float',
        'double': 'double',
        'char': 'i8',
        'int*': 'i32*',
        'float*': 'float*',
        'double*': 'double*'
    }
    return type_mapping.get(c_type, None)

def run_fuzzer(honggfuzz_path, bash_script, input_seed_folder, crash_folder ,log_file):
    """
    Run the fuzzing process using the generated bash script.
    The script will execute the two compiled binaries with the input files and compare their outputs.
    """
    try:
        # Run the bash script and capture its output
        result = subprocess.run([honggfuzz_path, '--exit_upon_crash', '-u', '-W', crash_folder , '-l', log_file, '-N', '10000', '-i', input_seed_folder, '--', bash_script, '___FILE___'], check=True, capture_output=True, text=True)
        print("\033[32m+++Fuzzing completed successfully.\033[0m")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("\033[31m---Fuzzing failed with differences detected.\033[0m")
        print(e.stderr)

    assert os.path.exists(log_file), "Log file does not exist after fuzzing."
    # Check if there is any crash in the log file
    with open(log_file, 'r') as f:
        log_content = f.read()
        if "Crash: saved as" in log_content:
            print(f"Crash detected during fuzzing. Check the crash folder `{crash_folder}` for details.")
        else:
            print("No crashes detected during fuzzing.")

def create_input_seed_file(input_seed_file, arguments):
    """
    Create a sample input seed file with random data of the specified size.
    The size is in bytes.
    """
    type_to_struct = {
        'int': 'i',    
        'float': 'f',  
        'char': 'b',   
    }
    data = []
    struct_format = ''
    for type, size in arguments:
        if type in type_to_struct:
            struct_format = struct_format + type_to_struct[type] * size
            data.extend(range(size))
        elif type.endswith('*'):
            # For pointer types, we assume the size is the number of elements
            element_type = type[:-1]
            if element_type in type_to_struct:
                struct_format = struct_format + type_to_struct[element_type] * size
                data.extend(range(size))
            else:
                raise ValueError(f"Unsupported pointer type: {type}")
        else:
            raise ValueError(f"Unsupported type: {type}")

    # Export to file input_seed_file
    size = len(data)
    if size == 0:
        raise ValueError("No valid arguments provided for input seed file.")
    # Create a binary file with the specified size
    with open(input_seed_file, 'wb') as f:
        # Write the data to the file using the struct format
        f.write(struct.pack(struct_format, *data))

def generate_bash_script(filename, input_file1, input_file2):
    """
    Generate a bash script that runs the two compiled binaries with the input files.
    The script will compare the outputs of the two binaries and report any differences.
    """
    bash_script = f"""#!/bin/bash
BIN1={input_file1}
BIN2={input_file2}
OUT1=$(mktemp)
OUT2=$(mktemp)
$BIN1 "$1" > "$OUT1"
if [ $? -ne 0 ]; then
    echo "Error running $BIN1"
    kill -SIGABRT $$
    exit 1
fi
$BIN2 "$1" > "$OUT2"
if [ $? -ne 0 ]; then
    echo "Error running $BIN2"
    kill -SIGABRT $$
    exit 1
fi
if ! cmp -s "$OUT1" "$OUT2"; then
    echo "Difference detected!"
	diff -a <(xxd $OUT1) <(xxd $OUT2)
    kill -SIGABRT $$
    exit 1
fi
exit 0
"""
    # Write the generated bash script to the specified file
    with open(filename, 'w') as f:
        f.write(bash_script)

def generate_c_main(filename, json_data):
    """
    Generate a C main file that includes the necessary headers and calls the function specified in the JSON data.
    The generated C code will read inputs from files, call the function, and write the output to stdout.
    """
    function_name = json_data["name_function"]
    return_type = json_data["return_type"]
    arguments = json_data["arguments"]

    # Create the C code as a string
    c_code = f"""
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>"""

    # Add the function prototype
    c_code += f"\nextern {return_type} {function_name}("
    c_code += ", ".join([f"{arg['type']} {arg['name']}" for arg in arguments])
    c_code += ");\n\n"

    # Add the main function
    c_code += f"""
int main(int argc, char **argv) {{
    FILE *f = fopen(argv[1], "rb");
    if (!f) return 1;
    int num_read;
    """

    # Add code to read inputs based on their types
    for arg in arguments:
        if arg["type"] in ["int", "float", "double"]:
            c_code += f"""
    {arg['type']} {arg['name']} = 0;
    num_read = fread(&{arg['name']}, sizeof({arg['type']}), {arg['size']}, f);"""
        elif arg["type"] in ["int*", "float*", "double*"]:
            var_type = arg['type'].replace("*","")
            c_code += f"""
    {var_type} {arg['name']}[{arg['size']}] = {{0}};
    num_read = fread({arg['name']}, sizeof({var_type}), {arg['size']}, f);"""
        else:
            raise ValueError(f"Unsupported argument type: {arg['type']}")

    # Check if there is a limit-max in the value of the argument
    for arg in arguments:
        if "limit-max" in arg:
            if arg["type"] in ["int", "float", "double"]:
                c_code += f"""
    if ({arg['name']} > {arg['limit-max']}) {{
        {arg['name']} = {arg['limit-max']};
    }}"""
            elif arg["type"] in ["int*", "float*", "double*"]:
                c_code += f"""
    for (int i = 0; i < {arg['size']}; i++) {{
        if ({arg['name']}[i] > {arg['limit-max']}) {{
            {arg['name']}[i] = {arg['limit-max']};
        }}
    }}"""
                
    # Check if there is a limit-min in the value of the argument
    for arg in arguments:
        if "limit-min" in arg:
            if arg["type"] in ["int", "float", "double"]:
                c_code += f"""
    if ({arg['name']} < {arg['limit-min']}) {{
        {arg['name']} = {arg['limit-min']};
    }}"""
            elif arg["type"] in ["int*", "float*", "double*"]:
                c_code += f"""
    for (int i = 0; i < {arg['size']}; i++) {{
        if ({arg['name']}[i] < {arg['limit-min']}) {{
            {arg['name']}[i] = {arg['limit-min']};
        }}
    }}"""

    # Close the file after reading inputs
    c_code += f"""
    fclose(f);"""

    # Call the function with the read arguments
    if return_type != "void":
        c_code += f"""
    {return_type} result = {function_name}( {", ".join([arg['name'] for arg in arguments])} );"""
    else:
        c_code += f"""
    {function_name}( {", ".join([arg['name'] for arg in arguments]) });"""

    # Add code to write the output to stdout
    c_code += f"""
    // Output the modified values (assuming they are all arrays)"""
    for arg in arguments:
        if arg["type"] in ["int", "float", "double"]:
            c_code += f"""
    fwrite(&{arg['name']}, sizeof({arg['type']}), {arg['size']}, stdout);"""
        elif arg["type"] in ["int*", "float*", "double*"]:
            var_type = arg['type'].replace("*","")
            c_code += f"""
    fwrite({arg['name']}, sizeof({var_type}), {arg['size']}, stdout);"""
        else:
            raise ValueError(f"Unsupported argument type: {arg['type']}")

    # If the function returns a value, print it
    if return_type != "void":
        c_code += f"""
    printf("result: %d\\n", result);"""

    c_code += f"""
    return 0;
}}"""

    # Write the generated C code to the specified file
    with open(filename, 'w') as f:
        f.write(c_code)
        

def read_json_info(json_file):
    """
    Read the JSON file containing function information and validate its structure.
    The JSON file should contain:
    - "name_function": Name of the function to be fuzzed.
    - "return_type": Type of the return value (int, float, double).
    - "arguments": List of arguments, each with:
        - "name": Name of the argument.
        - "type": Type of the argument (int, float, double, char, int*, float*, double*).
        - "size": Size of the argument (1 for scalar types).
    Returns a dictionary with function names and their details.
    """
    with open(json_file, 'r') as f:
        data = json.load(f)
    # Validate the JSON structure and its data
    assert isinstance(data, dict), "JSON file must contain a dictionary at the top level."
    assert "name_function" in data, "JSON file must contain 'name_function' key."

    assert "return_type" in data, "JSON file must contain 'return_type' key"
    return_type = data["return_type"]
    assert return_type in ["int", "float", "double", "void", "char"], "Return type must be 'int', 'float', 'double', or 'void'."

    assert "arguments" in data, "JSON file must contain 'arguments' key."
    assert isinstance(data["arguments"], list), "'arguments' must be a list."
    for arg in data["arguments"]:
        assert "name" in arg, "Each argument must have a 'name' key."
        assert "type" in arg, "Each argument must have a 'type' key."
        assert "size" in arg, "Each argument must have a 'size' key."
        assert isinstance(arg["size"], int), "Size must be an integer."
        type_arg = arg["type"]
        assert type_arg in ["int", "float", "double", "char", "int*", "float*", "double*"], \
                f"Argument type '{type_arg}' is not supported. Supported types are 'int', 'float', 'double', 'char', 'int*', 'float*', 'double*'."
        size_arg = arg["size"]
        if type_arg in ["int", "float", "double"]:
            assert size_arg == 1, f"Size for type '{type_arg}' must be 1."

    return data

def check_function_in_llvm_ir(llvm_ir_filename, json_data):
    """
    Check if the LLVM IR contains the function specified in the JSON data.
    The function name is expected to be in the 'name_function' field of the JSON data.
    """
    with open(llvm_ir_filename, 'r') as llvm_ir:
        llvm_ir_content = llvm_ir.read()
        function_name = json_data["name_function"]
        return_type = json_data["return_type"]
        # Use a regex to find the function definition in the LLVM IR
        pattern = re.compile(rf"define\s+{c_type_to_llvm_type(return_type)}\s+@{function_name}\s*\(.*\)\s*(#[0-9]+)?\s*\{{")
        match = pattern.search(llvm_ir_content)
        if not match:
            raise ValueError(f"Function '{function_name}' not found in the LLVM IR file. Please check the JSON file and the LLVM IR content.")  
        match_arguments = re.findall(r"(\w+)\s+%(\w+)", match.group(0))
        if not match_arguments:
            raise ValueError(f"Function '{function_name}' has no arguments in the LLVM IR file. Please check the JSON file and the LLVM IR content.")
        # Check the arguments against the JSON data
        json_arguments = json_data["arguments"]
        if len(match_arguments) != len(json_arguments):
            raise ValueError(f"Function '{function_name}' in the LLVM IR file has {len(match_arguments)} arguments, but {len(json_arguments)} arguments are specified in the JSON file.")

def compile_exec_file(input_file, library_file, output_file):
    """
    Compile the input file to an executable file.
    """
    subprocess.run(['clang', input_file, library_file, '-o', output_file ], check=True)

def compile_obj_file(input_file, output_file, json_data):
    """
    Compile the input file to an object file. 
    If the input file is a LLVM IR file, check that it contains the same function as specified in the JSON file.
    Supports both C code and LLVM IR.
    """
    if input_file.endswith('.c'):
        # Compile C code to object file
        subprocess.run(['gcc', '-c', input_file, '-o', output_file], check=True)
    elif input_file.endswith('.ll'):
        # Check if the LLVM IR file contains the function specified in the JSON data
        check_function_in_llvm_ir(input_file, json_data)
        # Compile LLVM IR to object file
        subprocess.run(['llc', '-mtriple=x86_64-pc-linux-gnu', '-filetype=obj', input_file, '-o', output_file], check=True)
    else:
        raise ValueError("Unsupported file type. Only .c and .ll files are supported.")

def main(file_input1, file_input2, json_info_file, honggfuzz_path, working_dir):
    """ 
    Main function to handle the fuzzing process.
    This function compiles the input files, generates a C main file,
    and runs the fuzzing process.
    """
    # Check if the JSON info file exists
    if not os.path.exists(json_info_file):
        raise FileNotFoundError(f"JSON info file {json_info_file} does not exist.")
    # Read the JSON info file to get function information
    json_data = read_json_info(json_info_file)

    # Compile the first input
    obj_input1 = f"{working_dir}/input1.o"
    compile_obj_file(file_input1, obj_input1, json_data)

    # Compile the second input
    obj_input2 = f"{working_dir}/input2.o"
    compile_obj_file(file_input2, obj_input2, json_data)

    # Generate C code that extracts the fuzzing inputs and calls the compiled objects
    c_main_file = f"{working_dir}/main.c"
    generate_c_main(c_main_file, json_data)

    # Compile the generated C main file to create executables
    exec1 = f"{working_dir}/exec1"
    compile_exec_file(c_main_file, obj_input1, exec1)
    # Compile the second executable
    exec2 = f"{working_dir}/exec2"
    compile_exec_file(c_main_file, obj_input2, exec2)

    # Generate the bash script to run the fuzzing
    bash_script = f"{working_dir}/run_fuzzing.sh"
    generate_bash_script(bash_script, f"./{exec1}", f"./{exec2}")
    # Make the bash script executable
    os.chmod(bash_script, 0o755)

    # Create a folder for input seeds
    input_seed_folder = f"{working_dir}/input_seeds"
    if not os.path.exists(input_seed_folder):
        os.makedirs(input_seed_folder)
    # Create a sample input file for fuzzing
    all_arguments = [(type_arg, size_arg) for arg in json_data["arguments"] for type_arg, size_arg in [(arg["type"], arg["size"])]]
    create_input_seed_file(os.path.join(input_seed_folder, "input_seed.txt"), all_arguments)

    # Test the bash script to ensure it runs correctly
    try:
        subprocess.run(['bash', bash_script, os.path.join(input_seed_folder, "input_seed.txt")], check=True)
    except subprocess.CalledProcessError as e:
        print("Bash script execution failed:", e)
        raise RuntimeError("Bash script execution failed. Check if it failed due to an error or if it detected differences between the two binaries already with input seed file.")

    # Create a folder for crash dumps
    crash_folder = f"{working_dir}/crash_dumps"
    if not os.path.exists(crash_folder):
        os.makedirs(crash_folder)
    else:
        os.system(f"rm -rf {crash_folder}/*")  # Clear previous crash dumps
    # Run the fuzzing process
    run_fuzzer(honggfuzz_path, bash_script, input_seed_folder, crash_folder, f"{working_dir}/log.txt")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fuzz two inputs against each other.")
    parser.add_argument("input1", type=str, help="Path to the first input file (C code or LLVM IR)")
    parser.add_argument("input2", type=str, help="Path to the second input file (C code or LLVM IR)")
    parser.add_argument("--json_info", type=str, required=True, help="Name of the JSON file with function information. Please look at the README.md for more information related to JSON structure.")
    parser.add_argument("--honggfuzz_path", type=str, required=True, help="Path to the honggfuzz executable.")
    parser.add_argument("--working_dir", type=str, default="./work", help="Working directory for the fuzzing process. Default is the ./work directory.")

    args = parser.parse_args()

    file_input1 = args.input1
    file_input2 = args.input2
    json_info_file = args.json_info
    honggfuzz_path = args.honggfuzz_path
    working_dir = args.working_dir

    # Check if both inputs exist
    if not os.path.exists(file_input1):
        raise FileNotFoundError(f"Input file {file_input1} does not exist.")
    if not os.path.exists(file_input2):
        raise FileNotFoundError(f"Input file {file_input2} does not exist.")

    # Check if inputs are C code or LLVM IR
    if not (file_input1.endswith('.c') or file_input1.endswith('.ll')) or not (file_input2.endswith('.c') or file_input2.endswith('.ll')):
        raise ValueError("Both inputs must be either C code (.c) or LLVM IR (.ll) files.")
    
    # Check if working directory exists, if not create it
    if not os.path.exists(working_dir):
        os.makedirs(working_dir)
    else:
        # Clear the working directory if it already exists
        os.system(f"rm -rf {working_dir}/*")

    main(file_input1, file_input2, json_info_file, honggfuzz_path, working_dir)    
