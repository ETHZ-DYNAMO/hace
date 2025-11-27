from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.graph_util import get_value_of_asg, edge_info_of, node_info_of, remove_unused_operators, add_nodes, remap_edges;
from hace.errors import error_if_false;
from hace.subgraphs import dominator_tree, first_common_postdominator;



@check_invariants
@visualize_graphs
def create_phi_nodes(graph : UnassociatedCDFG) -> UnassociatedCDFG:
	for var, var_info in [(var, node_info_of(graph, var)) for var in graph.graph.nodes if isinstance(node_info_of(graph, var), Variable)]:
		asgs = list(graph.graph.predecessors(var));
		values = set([get_value_of_asg(graph, asg) for asg in asgs]);
		if len(asgs) < 2:
			continue;
		if len(values) != 1:
			continue;
		if not var in graph.data_flow_nodes:
			continue;
		if var in graph.do_not_remove:
			continue;
		remap_edges(graph, list(graph.graph.out_edges(var, keys=True)), {var : list(values)[0]});
		to_remove = [var] + list(graph.graph.predecessors(var));
		graph.graph.remove_nodes_from(to_remove);
		graph.data_flow_nodes -= set(to_remove);
		


	state_graph = graph.graph.subgraph(graph.states);
	dom_frontier = nx.dominance_frontiers(state_graph, graph.start_state);
	post_doms = dominator_tree(state_graph.reverse(), graph.stop_state);
	# Iterate over all variables to see if one of them represents a phi node
	for var, var_info in [(var, node_info_of(graph, var)) for var in graph.graph.nodes if isinstance(node_info_of(graph, var), Variable)]:
		# If the variable is not in the data flow nodes, it cannot be a phi node
		if not var in graph.data_flow_nodes:
			continue;
		preds = list(graph.graph.predecessors(var));
		# If there is only one predecessor, it cannot be a phi node since it needs multiple assignments
		if len(preds) <= 1:
			continue;
		states = set().union(*[
			graph.states_of_nodes.get(asg, graph.states) for asg in preds
		]);
		# If the states of the assignments is the set of all states, then it cannot be a phi node
		if states == graph.states:
			continue;
		asgs_per_state = {
			state : [asg for asg in preds if graph.states_of_nodes.get(asg, set()) & {state} != set()]
			for state in states
		};
		#print(f"Candidate phi for variable {var} assigned in states {states} with assignments per state {asgs_per_state}");
		# Collect the BBs corresponding to the states of the assignments
		bbs = { graph.states_to_bb_mapping[s] for s in  states };
		# Find the list of successors for each BB and find their intersection
		successors = [set(graph.graph.successors(bb)) for bb in bbs]
		successor_bbs = set().union(*successors);
		# If there is only one BB, then it cannot be a phi node since it needs multiple assignments from different BBs
		if len(bbs) <= 1:
			#print(f"Skipping phi for variable {var} since there is only one BB {bbs}");
			continue;
		common_succs = successor_bbs.intersection(*successors);
		error_if_false(len(common_succs) <= 1, f"Expected there to only be one merge point but found {common_succs} for {var} {var_info.name}", graph);
		if len(common_succs) == 0:
			# If there is no common direct successor BB, check for common successors in the long term
			long_term_succs = [set(nx.descendants(graph.graph, bb)).union({bb}) for bb in bbs];
			common_succs = set().union(*long_term_succs).intersection(*long_term_succs);
			if len(common_succs) == 0 or len(common_succs) > 1:
				#print(f"Skipping phi for variable {var} since there is no common successor BB for BBs {bbs} long term successors {long_term_succs}");
				continue;
		error_if_false(len(common_succs) == 1, f"Expected there to only be one merge point but found {common_succs} for {var} {var_info.name}", graph);
		merge_BB = list(common_succs)[0];
		# Find the corresponding state for the merge BB as the first one in the list of the mapping between states and BBs
		merge_state = list([s for s in graph.states if graph.states_to_bb_mapping[s] == merge_BB])[0];
		# Generate the phi node and the assignment node
		phi, phi_asg = add_nodes(graph, [
			Phi(var_info.bit_width, var_info.signed),
			AssignmentNode(var_info.bit_width, var_info.signed),
		]);
		graph.data_flow_nodes |= {phi, phi_asg};
		graph.graph.add_edge(    phi, phi_asg, 0, info=ValueEdge());
		graph.graph.add_edge(phi_asg,     var, 0, info=ValueEdge());
		var_info.name += " Phi";
		# Assign to the phi node the merge_state
		graph.states_of_nodes[phi] = {merge_state};
		graph.states_of_nodes[phi_asg] = {merge_state};
		graph.states_of_nodes[var] = {merge_state};
		#print(f"Created phi node {phi} for variable {var} in merge state {merge_state} (BB {merge_BB})");
		# For each predecessor, create a new variable node to connect to the phi node
		for i, pred in enumerate(preds):
			var_for_pred = add_nodes(graph, [Variable(var_info.bit_width, var_info.signed, var_info.name + f" {i}")])[0];
			remap_edges(graph, list(graph.graph.out_edges(pred, keys=True)), {}, {var : var_for_pred});
			graph.graph.add_edge(var_for_pred, phi, i, info=ValueEdge());
			graph.data_flow_nodes |= {var_for_pred};
		pass
	return graph;
