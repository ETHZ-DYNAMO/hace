from enum import Enum, auto;
from dataclasses import dataclass, field;
import networkx as nx;
from typing import *;

from hace.verilog import VerilogOperation;

# This file defines the main types used for the HACE algorithm
# The Graph, Nodes and Edges use subtyping to achive Rust-Enum like 
# NamedValue + associated data semantics


def unreachable_none(message : str):
	assert False, message;

class Signedness(Enum):
	Signed = auto();
	Unsigned = auto();
	NOT_IMPLEMENTED = auto();

Node = int;

# The various Graphs in here serve as a Rust style enum
@dataclass
class BaseGraph:
	graph : nx.MultiDiGraph;
	do_not_remove : Set[Node];
	name : str;
	inputs : Set[Node];
	outputs : Set[Node];

@dataclass
class AssignmentGraph(BaseGraph):
	control_io : Set[Node];
	inputs     : Set[Node];
	outputs    : Set[Node];
	pass

@dataclass
class SplitCFDFGraph(BaseGraph):
	control_flow_nodes : Set[Node];
	data_flow_nodes    : Set[Node];

@dataclass
class PartitionedGraph(SplitCFDFGraph):
	control_io : Set[Node];
	pass

@dataclass
class FSMWithStateComparisons(SplitCFDFGraph):
	control_io         : Set[Node];
	current_state_node : Node;
	state_comparisons  : Set[Node];
	state_values       : Set[Node];

@dataclass
class FSMGraph(SplitCFDFGraph):
	current_state_node : Node;
	states : Set[Node];
	states_assignments_execute_in : Dict[Node, Set[Node]];
	start_state : Node;
	stop_state  : Node;

@dataclass
class AssociatedFSMGraph(FSMGraph):
	states_of_nodes : Dict[Node, Set[Node]];

@dataclass
class DataFlowWithFSMGraph(SplitCFDFGraph):
	states : Set[Node];
	states_of_nodes : Dict[Node, Set[Node]];
	start_state : Node;
	stop_state  : Node;

@dataclass
class UnassociatedCDFG(SplitCFDFGraph):
	states_of_nodes : Dict[Node, Set[Node]];
	states_to_bb_mapping : Dict[Node, Node];
	basic_blocks : Set[Node];
	states     : Set[Node];
	start_state : Node;
	stop_state  : Node;

@dataclass
class AssociatedCDFG(BaseGraph):
	basic_blocks : Set[Node]
	bb_of_node : Dict[Node, Node];
	start_bb : Node;
	stop_bb : Node;
	pass

@dataclass
class CDFG(AssociatedCDFG):
	pass

@dataclass
class NodeKind:
	pass

@dataclass
class NodeWithValue(NodeKind):
	bit_width : int;
	signed    : Signedness;

@dataclass
class Value(NodeWithValue):
	value : int;

@dataclass 
class Constant(Value):
	name  : int;

@dataclass
class Variable(NodeWithValue):
	name : str;
	pass


@dataclass
class VerilogOp(NodeWithValue):
	operation : VerilogOperation;
	name : str | None = None;
	pass

@dataclass
class AssignmentNode(NodeWithValue):
	pass

@dataclass
class SideEffectfulOperation(NodeWithValue):
	pass

@dataclass
class MemoryOperation(SideEffectfulOperation):
	memory : Tuple[str, str];
	pass

@dataclass
class Load(NodeWithValue):
	memory : str;

@dataclass
class Store(SideEffectfulOperation):
	memory : str;

@dataclass
class State(NodeKind):
	state_constant : Node;
	value          : int;
	comparisons    : List[Node];

@dataclass
class BasicBlock(NodeKind):
	pass

@dataclass
class ReturnValue(NodeWithValue):
	name : str;
	pass

@dataclass
class ArgumentNode(NodeWithValue):
	name : str;
	pass

@dataclass
class Phi(NodeWithValue):
	pass

@dataclass 
class BranchNode(NodeKind):
	pass

@dataclass
class Return(BranchNode):
	pass
@dataclass
class UnconditionalBranch(BranchNode):
	target : Node;

@dataclass
class ConditionalBranch(BranchNode):
	then_bb : Node;
	else_bb : Node;

@dataclass
class EdgeKind:
	pass

@dataclass
class ValueEdge(EdgeKind):
	pass

@dataclass
class ConditionEdge(EdgeKind):
	pass

@dataclass
class MemoryDependency(EdgeKind):
	pass

@dataclass
class Transition(EdgeKind):
	assignment : Node;
	pass

@dataclass
class ClassifiedTransition(EdgeKind):
	pass

@dataclass 
class ConditionalTransition(ClassifiedTransition):
	condition : Node;

@dataclass 
class UnconditionalTransition(ClassifiedTransition):
	pass


