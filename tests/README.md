# Testing Framework Documentation

This directory contains scripts and resources for **differential testing** of two implementations (in C or LLVM IR) of the same function. The primary goal is to ensure that, given identical inputs, both implementations produce matching outputs. The testing is automated using the [honggfuzz](https://github.com/google/honggfuzz) fuzzing engine.

---

## Table of Contents

- [Testing Framework Documentation](#testing-framework-documentation)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Supported Input Types](#supported-input-types)
  - [Prerequisites](#prerequisites)
  - [Example Usage](#example-usage)
  - [Function Definition Specification (JSON)](#function-definition-specification-json)
  - [There are also two additional optional field that can be added in the argument which are `limit-max` and `limit-min` which ensure that the value of the argument does not go over the limit-max value or does not go lower than the limit-min value.](#there-are-also-two-additional-optional-field-that-can-be-added-in-the-argument-which-are-limit-max-and-limit-min-which-ensure-that-the-value-of-the-argument-does-not-go-over-the-limit-max-value-or-does-not-go-lower-than-the-limit-min-value)
  - [Workflow](#workflow)
  - [Main Script: `fuzzer.py`](#main-script-fuzzerpy)
  - [Notes](#notes)

---

## Overview

This testing setup is designed to:
- Compare two function implementations (in C or LLVM IR).
- Automatically generate inputs and check for output mismatches using fuzzing.
- Provide a reproducible and extensible framework for regression and equivalence testing.

---

## Supported Input Types

- **C source code** files
- **LLVM IR** (`.ll`) files

Both files must contain the definition of a function with the same name, return type, and argument list.

**IMPORTANT**: the order of the arguments must match between the two definitions.

---

## Prerequisites

- [honggfuzz](https://github.com/google/honggfuzz) (clone, and compile it)
- `clang` and `llc` for C and LLVM IR compilation.
- Python 3 for scripting.
- Standard build tools (`make`, `gcc/clang`, etc.).

---

## Example Usage

This is an example of how you can call the fuzzer script from the current directory:

```bash
python scripts/fuzzer.py --json_info benchmarks/mvt/mvt.json --honggfuzz_path ~/honggfuzz/honggfuzz benchmarks/mvt/mvt.c benchmarks/mvt/mvt.ll
```

In this case the JSON file is `benchmarks/mvt/mvt.json`, the path to honggfuzz executable is `~/honggfuzz/honggfuzz` and we are comparing two inputs one in C `benchmarks/mvt/mvt.c` and one in LLVM IR `benchmarks/mvt/mvt.ll`.

---

## Function Definition Specification (JSON)

A JSON file describes the function signature to be tested. This file is required for the automation scripts to correctly generate harnesses and interpret inputs.

**JSON format:**
```json
{
    "name_function": "FUNCTION_NAME",
    "return_type": "RETURN_TYPE",
    "arguments": [
        {
            "name": "ARGUMENT_NAME",
            "type": "ARGUMENT_TYPE",
            "size": ARGUMENT_SIZE
        }
        // ... more arguments ...
    ]
}
```

- `name_function`: The function's name.
- `return_type`: The return type of the function.
- `arguments`: A list of argument specifications, each with:
  - `name`: Argument name.
  - `type`: Argument type.
  - `size`: Number of elements (for pointers/arrays).

There are also two additional optional field that can be added in the argument which are `limit-max` and `limit-min` which ensure that the value of the argument does not go over the limit-max value or does not go lower than the limit-min value.
---

## Workflow

1. **Parse Function Signature:**  
   Read the JSON to extract function name, return type, and argument details.

2. **Compile Source Files:**  
   Convert both C and LLVM IR files to object files.

3. **Generate Test Harness:**  
   Automatically write a main function that:
   - Reads input from a file.
   - Parses and passes arguments to the target function.
   - Captures and outputs the result.

4. **Build Executables:**  
   Compile two main executables, each linked to one of the object files.

5. **Create Differential Wrapper:**  
   Write a bash script that:
   - Runs both executables on the same input.
   - Compares their outputs.
   - Signals a difference (crash) if outputs do not match.

6. **Seed Input Generation:**  
   Generate an initial binary input file based on the argument types and sizes.

7. **Run Fuzzer:**  
   Launch honggfuzz with the wrapper script to automate input mutation and output comparison.


---

## Main Script: `fuzzer.py`

This Python script orchestrates the entire testing process.  
**Inputs:**
- `file1` and `file2`: The two implementations to compare.
- `function.json`: The JSON file specifying the function signature.

---


## Notes

- Both implementations **must** have the same function signature.
- The JSON file must accurately reflect the function's arguments and their sizes.
- Output mismatches are treated as crashes by the fuzzer and saved for further analysis.

---

**For more details on honggfuzz usage and advanced options, refer to the [honggfuzz documentation](https://github.com/google/honggfuzz).**

