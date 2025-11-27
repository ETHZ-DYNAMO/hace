
from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.subgraphs import value_edge_subgraph;
from hace.graph_util import type_of, node_info_of, edge_info_of;
from hace.errors import error_if_false;


COMPARISON_OPERATORS = [
	VerilogOperation.BINARY_EQ,
	VerilogOperation.ARRAY_INDEX,
];


@check_invariants
@visualize_graphs
def find_current_state_variable(graph : PartitionedGraph) -> FSMWithStateComparisons:
	# Create the value edge subgraph which contains only value edges
	value_graph = value_edge_subgraph(graph);
	# Find all variables in the control flow that have inputs
	only_variables = list(filter(lambda n: isinstance(graph.graph.nodes[n]['info'], Variable), graph.graph.nodes));
	that_have_inputs = list(filter(lambda n: len(list(graph.graph.predecessors(n))) > 0, only_variables));
	inside_control = list(filter(lambda n: n in graph.control_flow_nodes and n in value_graph, that_have_inputs));
	# Find all variables whose values are only derived from constants
	all_values_are_constants = list(filter(
		lambda n: {type_of(graph, anc) for anc in nx.ancestors(value_graph, n)}.issubset({Constant, Variable, AssignmentNode, Value}), inside_control
	));

	error_if_false(len(all_values_are_constants) >= 1, f"Expected to find variables whose values can only be constants {all_values_are_constants}", graph);
	
	# Helper to determine if a node is constant
	def node_is_constant(node : Node):
		ancestor_graph = graph.graph.subgraph(set(nx.ancestors(graph.graph, node)) | {node});
		all_inputs = [n for n in ancestor_graph if list(graph.graph.predecessors(n)) == []];
		is_constant = all([type(node_info_of(graph, input)) in [Value, Constant] for input in all_inputs]);
		return is_constant;

	# Find all control nodes that are attached to data flow via condition edges
	all_control_nodes_attached_to_data_flow : Set[Node] = set(filter(
		lambda n: any([
			type(edge_info_of(graph, oe)) == ConditionEdge for oe in graph.graph.out_edges(n, keys=True) if oe[1] in graph.data_flow_nodes
		]) and not isinstance(node_info_of(graph, n), Value) 
		and n not in graph.control_io
		and not node_is_constant(n)

		, graph.control_flow_nodes
	));

	# Find all nodes that determine all condition edges to data flow nodes
	determines_all_condition_edges = list(filter(
		lambda n: all_control_nodes_attached_to_data_flow.issubset(set(nx.descendants(graph.graph, n))),
		all_values_are_constants
	));
	error_if_false(len(determines_all_condition_edges) >= 1, f"Expected to find nodes which determine the Data Flow {determines_all_condition_edges}", graph);

	# Helper to find comparison operators that use the node
	def comparisons_of_node(node : Node) -> List[Node]:
		operations : Dict[Node, VerilogOp] = {
			n : cast(VerilogOp, node_info_of(graph, n))
			for n in graph.graph.successors(node)
			if isinstance(node_info_of(graph, n), VerilogOp)
		};
		return [n for n in operations
			if operations[n].operation in COMPARISON_OPERATORS 
			# More precisely they need to gate the assignments, but hey
			if nx.has_path(graph.graph, n, node)
		];

	# At this point we should only have multiple candidates, take the ones with the most? comparisons?
	# How about the one that determines the most nodes in data flow?
	sorted_by_number_of_comparisons_directly_using_the_node = sorted(
		determines_all_condition_edges,
		key = lambda n: -len(comparisons_of_node(n))
	);
	# Take the one with the most comparisons directly using it
	current_state_nodes = list(sorted_by_number_of_comparisons_directly_using_the_node);
	error_if_false(len(current_state_nodes) >= 1, f"Expected to find a singular current state node, but found {current_state_nodes}", graph);
	current_state_node = current_state_nodes[0];
	
	# Find all comparison operators that use the current state node
	state_comparison_operators = [
		node for node in graph.graph.successors(current_state_node)
		if isinstance(node_info_of(graph, node), VerilogOp) and cast(VerilogOp, node_info_of(graph, node)).operation in COMPARISON_OPERATORS
	];
	# Find all state values used in comparisons
	state_values = {anc for anc in nx.ancestors(value_graph, current_state_node) if type(node_info_of(graph, anc)) in [Constant, Value]};

	return FSMWithStateComparisons(
		**graph.__dict__,
		current_state_node = current_state_node,
		state_comparisons = set(state_comparison_operators),
		state_values      = state_values,
	);
