# HACE: HLS-Tool-Agnostic CDFG Extraction from RTL Designs
HACE is a tool designed to extract CDFG from RTL designs. It receives as input a Verilog code and it returns the MLIR representation of the CDFG.
For more details about the tool, please refer to the FPGA'26 paper publication. The following README explains the needed requirements to run the tool and the flow of the tool itself.

## Requirements
The following requirements are needed to run HACE:
1. [Python3](https://www.python.org/downloads/) version 3.12.0+
2. [hongfuzz](https://github.com/google/honggfuzz) version oss-fuzz
3. [LLVM](https://github.com/llvm/llvm-project) version 18.0.0+
4. [Graphviz](https://graphviz.org/doc/info/command.html) version 2.40.0+

Both hongfuzz and LLVM binaries should be included in the PATH environment variable.

Moreover, additional python packages should be installed using the command
```
python3 -m pip install -e HACE_DIRECTORY/
```

## Directory Structure
The following is the directory structure of this project:
```
HACE_DIRECTORY
├── docs
│   └── ARCHITECTURE.md		← It contains information related to the structure of the HACE code
├── hace					← It contains the scripts of HACE including parsing code and HLS tool specific information
	...
│   ├── hls_tool_specific   ← It contains information specific to HLS tools
	...
│   ├── modules				← It contains the abstraction modules to elaborate Lark output
	...						
│   ├── reader				← It contains the scripts to use Lark and extract the data structure
	...
├── LICENSE
├── MAINTAINERS				
├── Makefile				← It contains the code to run HACE and verify the extracted MLIR with hongfuzz
├── README.md
├── setup.py
└── tests					← It contains tests for integration and benchmarks
    ├── benchmarks			← It contains the list of benchmarks
	...
    ├── integration 		← It contains the list of unit tests for integration
	...
    ├── README.md			← It contains a README for the verification setup
    └── scripts				← It contains the scripts for verification with the fuzzer
	...
```

## Usage

Before running HACE, it is essential to run the following command to be sure that the correct python packages are used:
```
python3 -m pip install -e HACE_DIRECTORY/
```


### Running the Default Flow
To use HACE, simply invoke the predefined flow in the `Makefile`:

```bash
make
```

This command executes the full verification pipeline, which consists of:

1. Running HACE on the benchmarks used in the FPGA'26 paper.

2. Translating each benchmark's MLIR IR into LLVM IR using the LLVM toolchain.

3. Translating the C reference implementation of each benchmark into LLVM IR and using hongfuzz to compare the two LLVM IR versions (HACE-generated and C-generated).

For each benchmark, a successful run will print:

```
+++Fuzzing completed successfully.
```

All results are generated under `${CWD}/.build/<benchmark_path>/`.

### Enabling Debug Mode

To inspect intermediate results produced by HACE, enable the debug mode:

```bash
make DEBUG=1
```

Debug artifacts are placed under `.debug/` subdirectories inside each benchmark’s build directory. This folder contains dot representations of the AG after the different steps of the flow.


### Running HACE on a Specific Benchmark

To execute the flow on a specific Verilog file, use:

```bash
make VERILOGS=path/to/verilog.v
```

Example:

```bash
make VERILOGS=tests/benchmarks/non-pipelined/gemver/gemver.legup.v
```

### Visualize HACE Outputs

It is possible to visualize the intermediate outputs of HACE using the following command:

```bash
make debug_visualize
```

which generates a SVG file for each dot graph present in the `.debug` folder of each benchmark. This command only executes the SVG generation. Hence, it is necessary to run the flow in debug mode first before running this command.

Additionally, it is possible to visualize also the final output of HACE. In particular, it is possible to visualize the LLVM IR using LLVM. The following command:

```bash
make cdfg_visualize
```

runs the HACE flow and it also generates the dot file representing the cdfg as `benchmark_name.hls_tool.cdfg.dot` in the benchmark's output folder where `benchmark_name` is the name of the benchmark and `hls_tool` is the name of the HLS tool.

For instance, if running the following command:

```bash
make cdfg_visualize VERILOGS=tests/benchmarks/non-pipelined/mvt/mvt.legup.v
```

the output is saved in `.build/benchmarks/non-pipelined/mvt/mvt.legup.cdfg.dot`.

It is also possible to visualize only the CFG using the following command:

```bash
make cfg_visualize
```

which behaves similarly to the `cdfg_visualize` one but it saves its output with extension `.cfg.dot`.

### Benchmark Requirements

Source Verilog files are expected to reside under one of these two paths

```
HACE_DIRECTORY/tests/benchmarks/
HACE_DIRECTORY/tests/integration/
```

Generated outputs are stored under the corresponding:

```
HACE_DIRECTORY/.build/benchmarks/
HACE_DIRECTORY/.build/integration/
```

The Verilog file name must follow the pattern:

``name_benchmark.hls_tool_used.v``

where `hls_tool_used` specifies the HLS tool that produced the file.  
Currently, only two values are supported:

- `legup` for the LegUp HLS tool
- `vivado` for the Vivado HLS tool

This naming convention is required so that the flow can correctly detect which port-naming scheme should be applied.

Each benchmark directory must also include:

- A matching .json and .shim file used by the fuzzer

- A .c test harness file used during LLVM IR comparison

(See `tests/scripts/README.md` for details on these auxilary files.)

These files are essential to verify the correctness of the flow.


## How to parse the Verilog of another HLS tool?
In order to parse the Verilog of a new HLS tool, the user must specify the ports naming conventions of the HLS tool in the `hls_tool_specific` folder. The naming convention of the verilog file has to respect the HLS tool naming in `hls_tool_specific` in order to allow the Makefile to be aware of the HLS tool used. Additionally, the user should add a new command in the Makefile as follows:

```
.build/%.HLS_TOOL_USED.fuzz: tests/%.c .build/%.HLS_TOOL_USED.ll tests/%.json tests/%.HLS_TOOL_USED.shim
	-python3 tests/scripts/fuzzer.py --json_info $(word 3,$^) --working_dir $@.d/ --honggfuzz_path $(HONGGFUZZ) $(word 1,$^) $(word 2,$^) 2>&1 > $@
	@grep "Fuzzing completed successfully" $@
```
where `HLS_TOOL_USED` is the name of the HLS tool. Currently these steps should be executed manually but we plan to add an automated flow to facilitate this process.

## Invariants of HACE

During the execution of HACE, we analyze the graph generated at each step. There is a set of graph properties that should be respected at any point during HACE execution. The set of these properties are called invariants. The invariants enforced during the execution of the algorithm are defined in `hace/invariants.py`. These include **edge-level**, **node-level**, and **graph-level** invariants.

If any invariant is violated during execution, the algorithm automatically:
1. Prints an error message, and  
2. Dumps the erroneous graph into the build directory for inspection.

Although such violations should never occur during normal operation, they are invaluable for identifying incorrect assumptions made by the HACE algorithm and understanding how they were violated.

