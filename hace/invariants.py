from hace.type_info import *;
from hace.meta import on_each_graph;
from hace.terminal_colors import TerminalColor;
from hace.graph_util import node_info_of, edge_info_of, get_in_edges_by_index;
from hace import verilog;
from hace.errors import error_if_false;

class InvariantError(Exception):
	pass

INVARIANTS_ARE_TERMINAL = True;

def invariant(cond : bool, explanation : str, graph : BaseGraph, node : Node | None):
	if not cond:
		node_str = "" if node is None else f"{node}@";
		message = f"{TerminalColor.FAIL}Invariant FAILURE {node_str}{type(graph).__name__}{TerminalColor.ENDC}: {explanation}";
		print(message);
		if INVARIANTS_ARE_TERMINAL:
			error_if_false(False, message, graph);
		raise InvariantError();

def check_invariants(func):
	def wrapper(*args, **kwargs):
		return on_each_graph(func, check_invariants_on_graph, *args, **kwargs);
	return wrapper;

def verilog_operation_has_correct_number_of_nodes(graph : BaseGraph, node : Node):
	info = node_info_of(graph, node);
	if not isinstance(info, VerilogOp):
		return;
	in_edge_mapping = get_in_edges_by_index(graph, node);
	if info.operation in verilog.binary:
		invariant(0 in in_edge_mapping and 1 in in_edge_mapping, f"Binary operators need 2 inputs", graph, node);
	if info.operation in verilog.unary:
		invariant(0 in in_edge_mapping, f"Unary operators need 1 input", graph, node);
	#invariant(len(list(graph.graph.out_edges(node, keys=True))) == 1, f"Every Operation node is only allowed to have a single output", graph, node);

def every_node_has_kind_field_which_is_of_correct_type(graph : BaseGraph, node : Node):
	invariant('info' in graph.graph.nodes[node], "'info' field missing", graph, node);
	invariant(issubclass(type(graph.graph.nodes[node]['info']), NodeKind), "'info' needs to be a subclass of NodeKind", graph, node);

def every_edge_has_info_field(graph : BaseGraph, edge : Tuple[Node, Node, int]):
	invariant('info' in graph.graph.edges[*edge], "'info' field missing", graph, edge[1]);
	invariant(issubclass(type(graph.graph.edges[edge]['info']), EdgeKind), "'info' needs to be a subclass of EdgeKind", graph, edge[1]);

def data_flow_and_control_flow_are_entire_graph(graph : BaseGraph):
	if isinstance(graph, SplitCFDFGraph):
		invariant((graph.data_flow_nodes | graph.control_flow_nodes) == set(graph.graph.nodes), "CF + DF needs to be entire graph", graph, None);

def constants_have_no_parents(graph : BaseGraph, node : Node):
	if isinstance(graph.graph.nodes[node]['info'], Constant):
		invariant(0 == len(list(graph.graph.predecessors(node))), "Constants are not allowed to have predecessors", graph, node);

def all_nodes_are_scheduled(graph : BaseGraph) -> None:
	if not isinstance(graph, AssociatedCDFG):
		return;
	scheduled_nodes : Set[Node] = set(graph.bb_of_node.keys());
	bb_nodes : Set[Node] = set(graph.basic_blocks);
	all_nodes : Set[Node] = set(graph.graph.nodes);
	
	not_scheduled = all_nodes - (bb_nodes | scheduled_nodes);
	not_in_graph = (bb_nodes | scheduled_nodes) - all_nodes;
	invariant(not_scheduled == set(), f"All nodes need to be scheduled in a CDFG {not_scheduled}", graph, None);
	invariant(not_in_graph == set(), f"All nodes that are scheduled need to be in the graph {not_in_graph}", graph, None);

def every_operation_is_dominated_by_its_arguments(graph : BaseGraph):
	if not isinstance(graph, AssociatedCDFG):
		return;
	from subgraphs import dominator_tree;
	dom_tree = dominator_tree(graph.graph, graph.start_bb);
	for n,n_info in [(n, node_info_of(graph, n)) for n in graph.graph.nodes]:
		if not isinstance(n_info, VerilogOp):
			continue;
		args = graph.graph.predecessors(n);
		bb = graph.bb_of_node[n];
		args_that_dont_dominate_uses = [
			a for a in args
			if not nx.has_path(dom_tree, graph.bb_of_node[a], bb)
		];
		invariant(args_that_dont_dominate_uses == [], f"All operations need to be dominated by their arguments\nFor Operation {n}\nArguments {args_that_dont_dominate_uses} don't dominate", graph, None);
		
	
	
graph_invariants : Dict[Type, List[Callable[[BaseGraph], None]]] = {
	BaseGraph : [
	],
	SplitCFDFGraph : [
		data_flow_and_control_flow_are_entire_graph,
	],
	AssociatedCDFG : [
		all_nodes_are_scheduled,
		every_operation_is_dominated_by_its_arguments,
	],
};

def all_incoming_edges_have_different_key(graph : BaseGraph, node : Node):
	keys = {ie[2] for ie in graph.graph.in_edges(node,keys=True)};
	n_incoming_edges = len(list(graph.graph.in_edges(node, keys=True)));
	invariant(len(keys) != n_incoming_edges, f"Some Edges share the same key", graph, node);

def variables_states_are_union_of_assignments_states(graph: BaseGraph, node : Node):
	node_info = node_info_of(graph, node);
	if "states_of_nodes" not in graph.__dict__:
		return
	if not isinstance(node_info, Variable):
		return
	asgs = list(graph.graph.predecessors(node));
	if not asgs:
		return
	states_should_be = set().union(*[graph.states_of_nodes.get(asg, set()) for asg in asgs]);
	states_have = graph.states_of_nodes.get(node, set());
	invariant(states_have == states_should_be, f"States of variable {node_info.name} should be union of predecessors\n{states_should_be}\nbut are\n{states_have}", graph, node);

def assignment_node_invariant(graph : BaseGraph, node : Node):
	info = node_info_of(graph, node);
	if not isinstance(info, AssignmentNode):
		return;
	incoming_value_edges = [ie for ie in graph.graph.in_edges(node, keys=True) if isinstance(edge_info_of(graph, ie), ValueEdge)];
	invariant(len(incoming_value_edges) == 1, f"Incorrect ammount of value edges for AssignmentNode, expected 1, got {len(incoming_value_edges)}", graph, node);
	
	incoming_condition_edges = [ie for ie in graph.graph.in_edges(node, keys=True) if isinstance(edge_info_of(graph, ie), ConditionEdge)];
	invariant(len(incoming_condition_edges) <= 1, f"Incorrect ammount of condition edges for AssignmentNode, expected 1, got {len(incoming_condition_edges)}", graph, node);
	outgoing_edges = list(graph.graph.out_edges(node, keys=True));
	invariant(len(outgoing_edges) <= 1, f"An assignment node always belongs to exactly a single Variable, this one belonged to {len(outgoing_edges)}",graph,node);
	

def variable_node_invariant(graph : BaseGraph, node : Node):
	info = node_info_of(graph, node);
	if not isinstance(info, Variable):
		return;
	all_parents_are_assignments = all([isinstance(node_info_of(graph, p), AssignmentNode) for p in graph.graph.predecessors(node)]);
	invariant(all_parents_are_assignments, f"Variable {info.name} has non assignment nodes as parents", graph, node);

def every_in_edge_has_unique_key(graph : BaseGraph, node : Node):
	in_edges = list(graph.graph.in_edges(node, keys=True));
	in_edge_keys = {ie[2] for ie in in_edges};
	invariant(len(in_edge_keys) == len(in_edges), "Every nodes in edge keys need to be unique", graph, node);

def every_node_executes_in_some_states(graph : BaseGraph, node : Node):
	if not isinstance(graph, AssociatedFSMGraph):
		return;
	if node not in graph.data_flow_nodes:
		return;
	#invariant(len(graph.states_of_nodes.get(node, set())) > 0, f"Node does not execute in any state", graph, node);


node_invariants : Dict[Type, List[Callable[[BaseGraph, Node], None]]] = {
	BaseGraph : [
		every_node_has_kind_field_which_is_of_correct_type,
		constants_have_no_parents,
		assignment_node_invariant,
		variable_node_invariant,
		every_in_edge_has_unique_key,
		verilog_operation_has_correct_number_of_nodes,
	],
	AssociatedFSMGraph : [
		every_node_executes_in_some_states,
		variables_states_are_union_of_assignments_states
	]

};

edge_invariants : Dict[Type, List[Callable[[BaseGraph, Tuple[Node, Node, int]], None]]] = {
	BaseGraph: [
		every_edge_has_info_field,
	]
}

def check_invariants_on_graph(graph : BaseGraph, name : str):
	all_graph_invs = sum([graph_invariants.get(t, []) for t in type(graph).__mro__], []);
	all_node_invs  = sum([ node_invariants.get(t, []) for t in type(graph).__mro__], []);
	all_edge_invs  = sum([ edge_invariants.get(t, []) for t in type(graph).__mro__], []);
	for inv in all_graph_invs:
		try:
			inv(graph);
		except InvariantError:
			pass

	for node in graph.graph.nodes:
		for node_inv in all_node_invs:
			try:
				node_inv(graph, node);
			except InvariantError:
				pass
	for e in graph.graph.edges(keys=True):
		for edge_inv in all_edge_invs:
			try:
				edge_inv(graph, e);
			except InvariantError:
				pass

