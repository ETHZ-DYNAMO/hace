# The current Makefile for HACE fuzzing flow
# It includes rules to convert Verilog to AST, MLIR, LLVM IR, and then run honggfuzz-based fuzzers
# It also includes rules to generate CFG dot files and SVGs for debugging
# All files are built under the .build/ directory to keep the workspace clean
#
# REQUIREMENTS:
# - Python 3 with necessary HACE dependencies installed
# - MLIR and LLVM tools installed and available in PATH
# - honggfuzz installed and available in PATH
# - unflatten and dot tools installed for CFG and SVG generation
#
# HACE FILE STRUCTURE:
# - Source Verilog files are expected under tests/benchmarks/ or tests/integration/
# - Generated files are stored under .build/tests/benchmarks/ or .build/tests/integration/
#
# VERIFICATION FILE STRUCTURE:
# - Each benchmark should have associated .json and .shim files for fuzzing in the same directory as the Verilog file.
#	These files provide necessary information for the fuzzer to operate correctly. More details can be found in the tests/scripts/README.md
# - Each benchmark should also have a corresponding .c file that contains the test harness for fuzzing.
#
# DEBUG FLAG:
# The Makefile supports a DEBUG flag to include debug information in the generated files
# The information will be stored in .debug/ subdirectories under each benchmark's build directory
#
# USAGE:
#   make          					# Run the full flow including fuzzing
#   make DEBUG=1  					# Run the flow with debug information 
#	make cdfg_visualize				# Run the flow and generate SVGs for control-data flow graphs (CDFG)
#	make cfg_visualize				# Run the flow and generate SVGs for control flow graphs (CFG)
#   make VERILOGS=path/to/your.v  	# Run the flow for a specific Verilog file
#	make debug_visualize			# Generate SVGs for each dot genereted when in debug mode
#   make clean    					# Clean all generated files
#

DEBUG ?= 0

HACE_FLAGS =
ifeq ($(DEBUG),1)
HACE_FLAGS += --debug
endif

SRC := $(wildcard hace/**/*.py) $(wildcard hace/*.py)

INTEGRATION := $(wildcard tests/integration/*/*.v)
LEGUP_V     := $(wildcard tests/benchmarks/non-pipelined/*/*.legup.v) \
VIVADO_V    := $(wildcard tests/benchmarks/non-pipelined/*/*.vivado.v) \

NEW_BENCHMARKS := \
	tests/benchmarks/non-pipelined/kmp/kmp.legup.v \
	tests/benchmarks/non-pipelined/gaussian/gaussian.legup.v \
	tests/benchmarks/non-pipelined/gaussian/gaussian.vivado.v \
	tests/benchmarks/non-pipelined/kmp/kmp.vivado.v \
	

FPGA_26_BENCHMARKS := \
	tests/benchmarks/non-pipelined/mvt/mvt.legup.v \
	tests/benchmarks/non-pipelined/mvt/mvt.vivado.v \
	tests/benchmarks/non-pipelined/gsum/gsum.legup.v \
	tests/benchmarks/non-pipelined/gsum/gsum.vivado.v \
	tests/benchmarks/non-pipelined/getTanh/getTanh.legup.v \
	tests/benchmarks/non-pipelined/getTanh/getTanh.vivado.v \
	tests/benchmarks/non-pipelined/matrix/matrix.legup.v \
	tests/benchmarks/non-pipelined/matrix/matrix.vivado.v \
	tests/benchmarks/non-pipelined/kernel_2mm/kernel_2mm.legup.v \
	tests/benchmarks/non-pipelined/kernel_2mm/kernel_2mm.vivado.v \
	tests/benchmarks/non-pipelined/kernel_3mm/kernel_3mm.legup.v \
	tests/benchmarks/non-pipelined/kernel_3mm/kernel_3mm.vivado.v\
	tests/benchmarks/non-pipelined/gemver/gemver.legup.v \
	tests/benchmarks/non-pipelined/gemver/gemver.vivado.v \
	tests/benchmarks/non-pipelined/covariance/covariance.legup.v \
	tests/benchmarks/non-pipelined/covariance/covariance.vivado.v \
	
	
VERILOGS  ?=  \
	$(FPGA_26_BENCHMARKS) \
	#$(NEW_BENCHMARKS) \
	#$(LEGUP_V) \
	#$(VIVADO_V) \
	#$(INTEGRATION) \



HONGGFUZZ=$$(which honggfuzz)


REBASED  := $(subst tests,.build,$(VERILOGS))
AST      := $(patsubst %.v,%.ast, $(REBASED))
MLIR     := $(patsubst %.ast,%.mlir, $(AST))
LLVMIR   := $(patsubst %.mlir,%.ll, $(MLIR))
FUZZ     := $(patsubst %.ll, %.fuzz, $(LLVMIR))


flow: all_fuzz
	echo -e "\a"
	
.PHONY: flow clean

.build/%.ast: tests/%.v
	mkdir -p $(dir $@)
	python3 hace/_1.py $< $@


.build/%.mlir: hace/flow.py tests/%.v $(SRC) .build/typecheck
	python3 $(word 1, $^) $(HACE_FLAGS) $(word 2, $^) $@

.build/%.legup.fuzz: tests/%.c .build/%.legup.ll tests/%.json tests/%.legup.shim
	-python3 tests/scripts/fuzzer.py --json_info $(word 3,$^) --working_dir $@.d/ --honggfuzz_path $(HONGGFUZZ) $(word 1,$^) $(word 2,$^) 2>&1 > $@
	@grep "Fuzzing completed successfully" $@

.build/%.vivado.fuzz: tests/%.c .build/%.vivado.ll tests/%.json tests/%.vivado.shim
	-python3 tests/scripts/fuzzer.py --json_info $(word 3,$^) --working_dir $@.d/ --honggfuzz_path $(HONGGFUZZ) $(word 1,$^) $(word 2,$^) 2>&1 > $@ 
	@grep "Fuzzing completed successfully" $@

.build/%.fuzz: tests/%.c .build/%.ll tests/%.json
	-python3 tests/scripts/fuzzer.py --json_info $(word 3,$^) --working_dir $@.d/ --honggfuzz_path $(HONGGFUZZ) $(word 1,$^) $(word 2,$^) 2>&1 > $@ 
	@grep "Fuzzing completed successfully" $@

.build/%.ll: .build/%.mlir
	/opt/polygeist/llvm-project/build/bin/mlir-opt $< --convert-to-llvm -o $@.inter
	/opt/polygeist/llvm-project/build/bin/mlir-translate $@.inter --mlir-to-llvmir -o $@

all_ast: $(AST)
all_svgs: $(SVGS)
all_mlir: $(MLIR)
all_llvmir: $(LLVMIR)
all_fuzz: $(FUZZ)
	
%.unf.dot: %.dot
	unflatten -o $@ $<

%.svg: %.unf.dot
	dot -Tsvg $< -o$@

ALL_DOT := $(wildcard .build/*/*/*/.debug/*.dot)
ALL_CDFG := $(patsubst %.ll, %.cdfg.dot, $(LLVMIR)) 
ALL_CFG := $(patsubst %.ll, %.cfg.dot, $(LLVMIR))
ALL_SVG := $(patsubst %.dot,%.svg, $(ALL_DOT))
ALL_UNF := $(patsubst %.dot,%.unf.dot, $(ALL_DOT))
all_unf: $(ALL_UNF)
all_svg: $(ALL_SVG)


.PRECIOUS: .build/**/*
.PHONY: .build/typecheck

.build/typecheck: $(wildcard hace/**/*.py)
	@mkdir -p $(dir $@)
	#mypy --config-file pyproject.toml --follow-imports skip $(wildcard hace/*.py) $(wildcard hace/hls_tool_specific/*.py)
	@touch $@

%.cdfg.dot: %.ll
	/opt/polygeist/llvm-project/build/bin/opt -passes=dot-cfg -cfg-dot-filename-prefix=$@. -o /dev/null $<
	mv $@..HACE* $@

%.cfg.dot: %.ll
	/opt/polygeist/llvm-project/build/bin/opt -passes=dot-cfg-only -cfg-dot-filename-prefix=$@. -o /dev/null $<
	mv $@..HACE* $@

all_cdfg: $(ALL_CDFG)
all_cfg: $(ALL_CFG)

debug_visualize: all_svg

cdfg_visualize: all_cdfg
cfg_visualize: all_cfg

clean:
	rm -rf .build/
	mkdir -p .build
