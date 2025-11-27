import sys;
import os;
import subprocess as sp;
import pickle;
import argparse;
import pathlib;
import time;

import hace.debug as debug;
from hace import Step_1_1;
from hace import Step_1_2;
from hace import Step_2_1;
from hace import Step_2_2;
from hace import Step_2_3;
from hace import Step_3_1;
from hace import Step_3_2;
from hace import Step_3_3;
from hace import Step_3_4;
from hace import Step_3_5;
from hace import Step_3_6;
from hace import Resource_Sharing;
from hace import errors;
from hace.terminal_colors import TerminalColor;

assert __name__ == "__main__", "This file should only be called as a main file"

parser = argparse.ArgumentParser(
	prog = 'HACE',
	description = "The default HACE flow"
);
parser.add_argument('verilog_file', type = pathlib.Path);
parser.add_argument('output_mlir',  type = pathlib.Path);
parser.add_argument('--debug', action='store_true', default=False);

args = parser.parse_args();

verilog_file : pathlib.Path = args.verilog_file;
output_mlir  : pathlib.Path = args.output_mlir;
output_directory : pathlib.Path = args.output_mlir.parent;
if args.debug:
	debug.debug_path = output_directory / ".debug";

base_path    = args.verilog_file;
shim_file    = pathlib.Path(base_path).with_suffix(".shim");
ast_file     = pathlib.Path(output_mlir).with_suffix(".ast");


shim = "";
if os.path.isfile(shim_file):
	shim = open(shim_file, "r").read();

s = time.time();
sp.run(["make", ast_file]);
netlist = pickle.loads(open(ast_file, "rb").read());
print(f"Creating AST and loading it with pickle took {time.time() - s:.3f}");

s = time.time();
try:
	g = Step_1_1.translate_ast_to_ag(netlist);
	g = Step_1_2.split_control_and_data_flow(g);
	g = Step_2_1.find_current_state_variable(g);
	g = Step_2_2.create_fsm(g);
	g = Step_2_3.associate_operations_with_states(g);
	g = Step_3_1.classify_memory_nodes(g);
	g = Step_3_2.construct_cfg(g);
	g = Step_3_3.create_phi_nodes(g);
	g = Resource_Sharing.unshare_resources(g);
	g = Step_3_4.associate_nodes_with_bbs(g);
	g = Step_3_5.create_branches(g);
	g, mlir = Step_3_6.generate_mlir(g, shim);
	open(f"{output_mlir}", "w").write(mlir);
except errors.TerminatingError as err:
	reason = err.message;
	print(f"{TerminalColor.UNDERLINE}{TerminalColor.FAIL}Failed reconstruction\n{TerminalColor.ENDC}{reason}\n");
	error_file_path = output_mlir.with_suffix(".error_state.dot");
	open(error_file_path, "w").write(debug.graph_to_dot(err.graph));
	print(f"{TerminalColor.OKCYAN}In a bug report please include {error_file_path.absolute()}{TerminalColor.ENDC}");
	exit(1);
except AssertionError as err:
	print(f"In file {output_mlir}");
	raise err;

print(f"Took {time.time() - s:.3f} seconds");


