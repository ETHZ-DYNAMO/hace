from hace.type_info import *;
from hace.graph_util import node_info_of;
from hace.errors import error_if_false;
from enum import Enum;

class MLIR_OP(Enum):
	CONST  = "%{node} = arith.constant {value} : {node_type}";
	CMPI   = "%{node} = arith.cmpi {comparison}, %{input[0]}, %{input[1]} : {input_type[0]}";
	MULI   = "%{node} = arith.muli %{input[0]}, %{input[1]} : {node_type}";
	ADDI   = "%{node} = arith.addi %{input[0]}, %{input[1]} : {node_type}";
	SUBI   = "%{node} = arith.subi %{input[0]}, %{input[1]} : {node_type}";
	ANDI   = "%{node} = arith.andi %{input[0]}, %{input[1]} : {node_type}";
	ORI    = "%{node} = arith.ori %{input[0]}, %{input[1]} : {node_type}";
	EXTUI  = "%{node} = arith.extui  %{input[0]} : {input_type[0]} to {node_type}";
	EXTSI  = "%{node} = arith.extsi  %{input[0]} : {input_type[0]} to {node_type}";
	TRUNCI = "%{node} = arith.trunci %{input[0]} : {input_type[0]} to {node_type}";
	SHRSI  = "%{node} = arith.shrsi  %{input[0]}, %{input[1]} : {node_type}";
	SHRUI  = "%{node} = arith.shrui  %{input[0]}, %{input[1]} : {node_type}";
	SHLI   = "%{node} = arith.shli  %{input[0]}, %{input[1]} : {node_type}";
	BITCAST = "%{node} = arith.bitcast %{input[0]} : {input_type[0]} to {node_type}";
	SELECT = "%{node} = arith.select %{input[2]}, %{input[0]}, %{input[1]} : {node_type}";


	LOAD   = "%{node} = llvm.load  %{input[1]} : !llvm.ptr -> {node_type}";
	STORE  = "llvm.store %{input[3]}, %{input[1]} : {input_type[3]}, !llvm.ptr";
	GEP    = "%{node} = llvm.getelementptr %{memory}[%{input[1]}] : (!llvm.ptr, {input_type[1]}) -> !llvm.ptr, {memory_type}";
	RETURN = "func.return {returns}"
	BRANCH      = "cf.br ^bb{dest}{operands}";
	COND_BRANCH = "cf.cond_br %{condition}, ^bb{bb_then} {operands_then}, ^bb{bb_else} {operands_else}";
	CALL   = "%{node} = func.call @{procedure}({input_list}) : ({input_list_type}) -> {node_type}";

OP_TO_COMPARISON = {
	VerilogOperation.BINARY_EQ: "eq",
	VerilogOperation.BINARY_EQ_EXT: "eq",
	VerilogOperation.BINARY_GEQ: "uge",
	VerilogOperation.BINARY_GT: "ugt",
	VerilogOperation.BINARY_LEQ: "ule",
	VerilogOperation.BINARY_LT: "ult",
	VerilogOperation.BINARY_NEQ: "ne",
}

@dataclass
class MlirNode(NodeKind):
	operation : str;
	pass

@dataclass
class MlirValue(NodeWithValue):
	operation : str;
	pass

@dataclass
class CDFGWithDominator(CDFG):
	dominator_tree : nx.DiGraph;
	return_values : List[Node];

def mlir_type_of_info(info : NodeWithValue) -> str:
	signed = 's' if info.signed == Signedness.Signed else 'u' if info.signed == Signedness.Unsigned else '';
	bit_width = info.bit_width;
	# For now do not use sign information, because MLIR is really stupid about it
	return f"i{bit_width}";

def mlir_type_of_node(graph : CDFG, node : Node) -> str:
	info = node_info_of(graph, node);
	assert isinstance(info, NodeWithValue);
	return mlir_type_of_info(info);


