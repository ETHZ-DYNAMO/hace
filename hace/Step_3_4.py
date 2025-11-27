from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs, debug_write_graph;
from hace.graph_util import node_info_of, edge_info_of, get_value_of_asg, add_nodes, remap_edges, remove_unused_operators;
from hace.errors import error_if_false;
from hace.subgraphs import dominator_tree, first_common_postdominator;



def get_preceeding_assignments(graph, var : Node) -> Tuple[List[Node], List[Node]]:
	visited = set();
	preceeding_assignments = [];
	worklist = list(graph.graph.predecessors(var));
	while worklist:
		new_worklist = [];
		for n in worklist:
			n_info = node_info_of(graph, n);
			if isinstance(n_info, AssignmentNode):
				preceeding_assignments += [n];
			else:
				visited.add(n);
				new_worklist += [ie[0]
					for ie in graph.graph.in_edges(n, keys=True)
					#if isinstance(edge_info_of(graph, ie), ValueEdge)
				];
		worklist = new_worklist;
		
	return preceeding_assignments, list(visited);


@check_invariants
@visualize_graphs
def associate_nodes_with_bbs(graph : UnassociatedCDFG) -> AssociatedCDFG:
	# Determine the basic block for each node
	# Get first and last basic blocks
	starting_bb = graph.states_to_bb_mapping[graph.start_state];
	stop_bb     = graph.states_to_bb_mapping[graph.stop_state];
	# Create dominator and post-dominator trees for the basic blocks
	bb_graph = graph.graph.subgraph(graph.basic_blocks);
	post_doms = dominator_tree(bb_graph.reverse(), stop_bb);
	dom_frontier = nx.dominance_frontiers(bb_graph, starting_bb);

	# Collect a list of assignment nodes
	assignment_nodes = [
		n for n in graph.data_flow_nodes
		if isinstance(node_info_of(graph, n), AssignmentNode)
	];
	# Mapping from node to basic block
	bb_of_node = {
		node : graph.states_to_bb_mapping[list(graph.states_of_nodes[node])[0]]
		for node in assignment_nodes
		if node in graph.states_of_nodes
		if len(graph.states_of_nodes[node]) == 1
	};

	# Assign basic blocks to inputs and outputs
	for n in graph.inputs:
		n_info = node_info_of(graph, n);
		new = add_nodes(graph, [
			AssignmentNode(n_info.bit_width, n_info.signed),
			ArgumentNode(**n_info.__dict__),
		]);
		graph.graph.add_edge(new[1], new[0], info = ValueEdge());
		graph.graph.add_edge(new[0],      n, info = ValueEdge());
		bb_of_node[new[0]] = starting_bb;
		bb_of_node[new[1]] = starting_bb;

	for n in graph.outputs:
		n_info = node_info_of(graph, n);
		new = add_nodes(graph, [ReturnValue(**n_info.__dict__)])[0];
		graph.graph.add_edge(n, new, info = ValueEdge());
		bb_of_node[n] = stop_bb;
		bb_of_node[new] = stop_bb;

	# Worklist algorithm to assign basic blocks to assignment nodes
	# which have not yet been assigned a basic block since their state is not unique
	worklist = list(set(assignment_nodes) - set(bb_of_node.keys()));
	while worklist:
		new_worklist = [];
		for asg in worklist:
			asg_info = node_info_of(graph, asg);
			parent_asgs = get_preceeding_assignments(graph, asg)[0];
			if any([n not in bb_of_node for n in parent_asgs]):
				new_worklist += [asg];
				continue;
			#print(f"{asg} has no unscheduled preceeding assignments");
			#print(f"Preceeding variables {parent_asgs}");
			if len(parent_asgs) == 0:
				bbs_of_preceeding = [starting_bb];
			else:
				bbs_of_preceeding = [bb_of_node[p] for p in parent_asgs];
			bb_of_asg = first_common_postdominator(post_doms, bbs_of_preceeding);
			bb_of_node[asg] = bb_of_asg;
		if len(new_worklist) == len(worklist):
			error_if_false(False, f"No progress is being made\n{worklist}", graph);
			break;
		worklist = new_worklist;

	# Assign basic blocks to memory operations based on their states
	mop = [n for n in graph.data_flow_nodes if type(node_info_of(graph, n)) in [Store]];
	for mem_op in mop:
		error_if_false(len(graph.states_of_nodes[mem_op]) == 1, f"Store {mem_op} has an invalid number of states associated with it", graph);
		state_of_mem_op = list(graph.states_of_nodes[mem_op])[0];
		bb_of_node[mem_op] = graph.states_to_bb_mapping[state_of_mem_op];
		for p in graph.graph.predecessors(mem_op):
			bb_of_node[p] = bb_of_node[mem_op];
	
	for asg in assignment_nodes:
		preceeding_asgs, preceeding_nodes = get_preceeding_assignments(graph, asg);
		for n in preceeding_nodes:
			n_info = node_info_of(graph, n);
			bb_of_node[n] = bb_of_node[asg];

	nodes_without_outputs = set([ n for n in graph.data_flow_nodes
		if list(graph.graph.successors(n)) == []
		if not isinstance(node_info_of(graph, n), SideEffectfulOperation)
	]);
	graph.data_flow_nodes -= nodes_without_outputs;
	# Remove state machine and other control flow nodes
	to_remove = ((graph.control_flow_nodes - graph.basic_blocks) | nodes_without_outputs) - set(graph.do_not_remove);
	graph.graph.remove_nodes_from(to_remove)

	vars = [n for n in graph.graph.nodes if isinstance(node_info_of(graph, n), Variable)];
	
	for var in vars:
		var_info = node_info_of(graph, var);
		if not isinstance(var_info, Variable):
			continue;
		error_if_false(len(list(graph.graph.predecessors(var))) <= 1, f"Every var should only have a single assignment now, {var_info.name} did not", graph);
		pass


	
	
	for var in vars:
		asgs = list(graph.graph.predecessors(var));
		if len(asgs) < 1:
			continue;
		if var in graph.do_not_remove:
			bb_of_node[var] = bb_of_node[asgs[0]];
			continue;
		asg = asgs[0];
		value = [ie[0] for ie in graph.graph.in_edges(asg, keys=True) if isinstance(edge_info_of(graph, ie), ValueEdge)][0];
		remap_edges(graph, list(graph.graph.out_edges(var, keys=True)), {var : value});
		graph.graph.remove_nodes_from([asg, var]);
		if asg in bb_of_node:
			del bb_of_node[asg];
		if var in bb_of_node:
			del bb_of_node[var];
	rem = remove_unused_operators(graph);
	graph.graph.remove_nodes_from(rem);
	for n in rem:
		if n in bb_of_node:
			del bb_of_node[n];

	for n in graph.graph.nodes:
		if isinstance(node_info_of(graph, n), Value):
			bb_of_node[n] = starting_bb;

	return AssociatedCDFG(
		graph = graph.graph,	
		do_not_remove = graph.do_not_remove,
		name = graph.name,
		bb_of_node = bb_of_node,
		basic_blocks = graph.basic_blocks,
		start_bb = starting_bb,
		stop_bb  = stop_bb,
		inputs = graph.inputs,
		outputs = graph.outputs,
	);
