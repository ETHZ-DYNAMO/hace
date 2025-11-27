import sys;
import time;
from hace.reader import verilogReader;
import pickle

assert __name__ == "__main__", "This file should only be called as a main file"

print(f"Compiling {sys.argv[1]} into AST");
s = time.time();
netlist = verilogReader.parseVerilogToAST(open(sys.argv[1], "r").read());
e = time.time();
print(f"Done Compiling {sys.argv[1]} into AST, took {e-s}");

open(sys.argv[2], "wb").write(pickle.dumps(netlist));
