import pathlib;

from hace.type_info import *;
from hace.meta import on_each_graph;
from hace.graph_util import edge_info_of, node_info_of;
from hace.verilog import VerilogOperation, operations;


debug_path : pathlib.Path = None;

def visualize_graphs(func):
	def wrapper(*args, **kwargs):
		return on_each_graph(func, debug_write_graph, *args, **kwargs);
	return wrapper;


debug_n = 0;

def debug_write_graph(graph : BaseGraph, name : str) -> None:
	global debug_path;
	global debug_n;
	if debug_path is None:
		return;

	debug_n += 1;
	output_dot = debug_path/ f"{name}.{debug_n}.dot";

	debug_path.mkdir(exist_ok = True);
	open(output_dot, "w").write(graph_to_dot(graph));


def graph_to_dot(graph : BaseGraph) -> str:
	nodes_sorted = sorted(list(set(graph.graph.nodes)));
	edges_sorted = sorted(list(set(graph.graph.edges(keys=True))));
	
	def subgraph(name : str, nodes : List[Node], other_subgraphs : List[str] = []):
		subgraph_dot = f"subgraph cluster_{name.replace(' ', '_')} {{\n";
		subgraph_dot += f'\t"label" = "{name}"\n';
		for n in nodes:
			subgraph_dot += f"\t{n}\n";
		for os in other_subgraphs:
			subgraph_dot += "\n".join(["\t" + line for line in os.split("\n")]);
		subgraph_dot += "}\n";
		return subgraph_dot;

	dot = "digraph {\n";
	for n in nodes_sorted:
		info = node_info_of(graph, n);
		label_of_node = type(info).__name__;
		if isinstance(info, VerilogOp):
			label_of_node = str(operations[info.operation]);
			if info.operation == VerilogOperation.BLACKBOX:
				label_of_node = str(info.name);
		elif isinstance(info, Variable) or isinstance(info, ReturnValue) or isinstance(info, ArgumentNode):
			label_of_node = info.name;
		elif isinstance(info, Constant):	
			label_of_node = f"{info.name} = {info.value}";
		elif isinstance(info, AssignmentNode):
			label_of_node = "=";
		elif isinstance(info, Value):
			label_of_node = str(info.value);
		elif isinstance(info, MemoryOperation):
			label_of_node = f"Memory Op {info.memory}";
		elif isinstance(info, Load) or isinstance(info, Store):
			label_of_node = f"{type(info).__name__} {info.memory}";
		elif isinstance(info, ConditionalBranch):
			label_of_node = f"then {info.then_bb} else {info.else_bb}";
		label_of_node += f" ID {n} ";
		if isinstance(info, NodeWithValue):
			signed = "S" if info.signed == Signedness.Signed else "U" if info.signed == Signedness.Unsigned else "X";
			bw = info.bit_width;
			label_of_node += f"\n{signed}[{bw}]";
		if isinstance(graph, AssociatedFSMGraph) or isinstance(graph, UnassociatedCDFG):
			label_of_node += f"\nStates {graph.states_of_nodes.get(n, 'Not Set')}";
		elif isinstance(graph, FSMGraph):
			label_of_node += f"\nStates {graph.states_assignments_execute_in.get(n, 'Not Set')}";


		dot += f'\t{n} ["label" = "{label_of_node}", "info" = "{str(graph.graph.nodes[n]['info'])}"]\n';
	for e in edges_sorted:
		label_of_edge = f"{e[2]}";
		info = edge_info_of(graph, e);
		if isinstance(info, ConditionalTransition):
			label_of_edge += f" Condition on {info.condition}";
		constraint = 'constraint=true, color=gray' if isinstance(info, ConditionEdge) else "";
		dot += f'\t{e[0]} -> {e[1]} ["label" = "{label_of_edge}", {constraint}]\n';
	cf_subs = [];
	df_subs : List[str] = [];
	if isinstance(graph, FSMGraph):
		cf_subs += [ subgraph("FSM", list(graph.states)) ];
	if isinstance(graph, UnassociatedCDFG):
		cf_subs += [ subgraph("FSM", list(graph.states)) ];
		cf_subs += [ subgraph("BBs", list(graph.basic_blocks)) ];

	if isinstance(graph, SplitCFDFGraph):
		dot += subgraph("Control Flow", [n for n in nodes_sorted if n in graph.control_flow_nodes], cf_subs);
		dot += subgraph("Data Flow", [n for n in nodes_sorted if n in graph.data_flow_nodes], df_subs);
	if isinstance(graph, CDFG) or isinstance(graph, AssociatedCDFG):
		for bb in graph.basic_blocks:
			dot += subgraph(f"BB {bb}", [n for n in nodes_sorted if n in graph.bb_of_node and graph.bb_of_node[n] == bb]);



	dot += "}";
	return dot;


