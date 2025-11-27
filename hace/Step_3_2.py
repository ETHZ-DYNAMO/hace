from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.graph_util import edge_info_of, node_info_of;


@check_invariants
@visualize_graphs
def construct_cfg(graph : AssociatedFSMGraph) -> UnassociatedCDFG:

	edges_in_fsm : Set[Tuple[Node, Node, int]] = {
		e for e in graph.graph.edges(keys=True)
		if isinstance(edge_info_of(graph, e), ClassifiedTransition)
	};

	states_of_bb : Dict[Node, Set[Node]] = { state : {state} for state in graph.states };
	assert all([state in graph.control_flow_nodes for state in graph.states]);
	 
	# TODO, do not modify the FSM graph here, we still need it!
	bb_graph = graph.graph.subgraph(graph.states).copy();
	worklist = list(edges_in_fsm);
	while worklist:
		e = worklist.pop();
		if e not in bb_graph.edges:
			continue;
		succs_of_parent = set(bb_graph.successors  (e[0]));
		preds_of_child  = set(bb_graph.predecessors(e[1]));
		if len(succs_of_parent) == 1 and len(preds_of_child) == 1:
			bb_graph.remove_edge(*e);
			bb_graph = nx.contracted_nodes(bb_graph, e[1], e[0], self_loops = True);
			states_of_bb[e[1]] = states_of_bb[e[1]] | states_of_bb[e[0]]
			del states_of_bb[e[0]];
			worklist += [e for e in bb_graph. in_edges(e[1], keys=True)];
			worklist += [e for e in bb_graph.out_edges(e[1], keys=True)];

	merged_states = set(states_of_bb.keys());
	base_id = max(graph.graph.nodes) + 1;
	merged_state_to_bb_mapping : Dict[Node, Node] = { state : base_id + i for i, state in enumerate(merged_states) };
	
	states_to_bb = {
		state : merged_state_to_bb_mapping[merged_state]
		for state in graph.states
		for merged_state in states_of_bb
		if state in states_of_bb[merged_state]
	};

	for state, bb_node in merged_state_to_bb_mapping.items():
		graph.graph.add_node(bb_node, info = BasicBlock());
		for oe in graph.graph.out_edges(state, keys=True,data=True):
			graph.graph.add_edge(bb_node, states_to_bb[oe[1]], oe[2], info = oe[3]['info']);

	basic_blocks = set(merged_state_to_bb_mapping.values());
	control_flow_nodes = graph.control_flow_nodes | basic_blocks;
	assert set(states_to_bb.keys()) == graph.states;
	assert set(states_to_bb.values()) == basic_blocks;
	
	return UnassociatedCDFG(
		graph = graph.graph,
		do_not_remove = graph.do_not_remove,
		name = graph.name,
		data_flow_nodes = graph.data_flow_nodes,
		control_flow_nodes = control_flow_nodes,
		states_of_nodes = graph.states_of_nodes,
		states_to_bb_mapping = states_to_bb,
		start_state = graph.start_state,
		stop_state  = graph.stop_state,
		basic_blocks = basic_blocks,
		states = graph.states,
		inputs = graph.inputs,
		outputs = graph.outputs,
	);
