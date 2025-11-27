from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.errors import error_if_false;
from hace.graph_util import node_info_of, edge_info_of, get_value_of_asg, remove_unused_operators, remap_edges, remove_unused_operators;



@check_invariants
@visualize_graphs
def create_branches(graph : AssociatedCDFG) -> CDFG:
	base_id = max(graph.graph.nodes) + 1;
	for i, bb in enumerate(graph.basic_blocks):
		outgoing_transitions = set(graph.graph.out_edges(bb, keys=True));
		branch_node = base_id + i;
		match len(outgoing_transitions):
			case 0:
				graph.graph.add_node(branch_node, info = Return());
				pass
			case 1:
				target = list(outgoing_transitions)[0];
				graph.graph.add_node(branch_node, info = UnconditionalBranch(target[1]));
				pass
			case _:
				error_if_false(all([isinstance(edge_info_of(graph, oe), ConditionalTransition) for oe in outgoing_transitions]), f"An outgoing transition did not carry a condition when multiple outgoing transitions were present", graph);
				error_if_false(len(outgoing_transitions) == 2, f"Expecting two outgoing branches at most, found {len(outgoing_transitions)}", graph);
				targets = list(outgoing_transitions);
				then_edge = targets[0];
				else_edge = targets[1];
				condition = cast(ConditionalTransition, edge_info_of(graph, then_edge)).condition;
				condition_asgs = list(graph.graph.predecessors(condition));
				error_if_false(len(condition_asgs) == 1, f"Expected a condition variable to only have a single predecessor", graph);
				condition_value = get_value_of_asg(graph, condition_asgs[0]);
				graph.graph.add_node(branch_node, info = ConditionalBranch(then_bb = then_edge[1], else_bb = else_edge[1]));
				graph.graph.add_edge(condition_value, branch_node, 0, info = ConditionEdge());
				pass
		graph.bb_of_node[branch_node] = bb;
		pass

	unused = remove_unused_operators(graph);
	vars = [
		n for n in graph.graph.nodes
		if isinstance(node_info_of(graph, n), Variable)
	];
	for var in vars:
		value = [get_value_of_asg(graph, asg) for asg in graph.graph.predecessors(var)][0];
		remap_edges(graph, list(graph.graph.out_edges(var, keys=True)), {var : value});
	to_remove = {n for n in graph.graph.nodes
		if isinstance(node_info_of(graph, n), AssignmentNode)
		or isinstance(node_info_of(graph, n), Variable)
	} | unused | remove_unused_operators(graph);

	for rem in to_remove:
		del graph.bb_of_node[rem];
	graph.graph.remove_nodes_from(to_remove);

	return CDFG(
		graph = graph.graph,
		do_not_remove = graph.do_not_remove,
		name = graph.name,
		basic_blocks = graph.basic_blocks,
		bb_of_node = graph.bb_of_node,
		start_bb     = graph.start_bb,
		stop_bb      = graph.stop_bb,
		inputs = graph.inputs,
		outputs = graph.outputs,
	);
