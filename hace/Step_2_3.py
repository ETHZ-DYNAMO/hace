from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.graph_util import node_info_of, edge_info_of, get_value_of_asg, remap_edges, get_condition_of_asg, get_in_edges_by_index, add_nodes;
from hace.subgraphs import value_edge_subgraph;
from hace.Step_1_1 import binary, unary
from hace.verilog import *;
from hace.errors import error_if_false;

# TODO in gemver main_0_x_enable_a gets assigned the wrong states!!!

def states_of_memory_op(graph : FSMGraph, memory_node : Node, states : Set[Node], states_of_nodes : Dict[Node, Set[Node]]) -> Set[Node]:
	if not isinstance(node_info_of(graph, memory_node), MemoryOperation):
		return states;
	in_edges_by_index = get_in_edges_by_index(graph, memory_node);
	enable_var = in_edges_by_index[0][0];
	enable_states = set().union(*[
		states_of_nodes[enable_assignment]
		for enable_assignment in graph.graph.predecessors(enable_var)
		if isinstance(node_info_of(graph, get_value_of_asg(graph, enable_assignment)), Value)
			and cast(Value, node_info_of(graph, get_value_of_asg(graph, enable_assignment))).value == 1
	]);
	if enable_states == set():
		enable_states = states;
	return enable_states;


def no_change(graph : FSMGraph,  node : Node, states : Set[Node], states_of_nodes : Dict[Node, Set[Node]]) -> Set[Node]:
	return states;

refine_states : Dict[Type, Callable[[FSMGraph, Node, Set[Node], Dict[Node, Set[Node]]], Set[Node]]] = {
	MemoryOperation : states_of_memory_op,
};




def backpropagate_state_information(graph : FSMGraph, states_of_node_seeds : Dict[Node, Set[Node]]) -> Dict[Node, Set[Node]]:
	value_graph = value_edge_subgraph(graph);
	states_of_node : Dict[Node, Set[Node]] = {
		node : states_of_node_seeds[node]
		for node in graph.data_flow_nodes
		if node in states_of_node_seeds
	};
	worklist = sum([list(graph.graph.predecessors(seed)) for seed in states_of_node_seeds.keys()], []);
	while worklist:
		n = worklist.pop();

		if n in states_of_node_seeds:
			continue;
		if n not in graph.data_flow_nodes:
			continue;

		info = node_info_of(graph, n);

		old_states = states_of_node.get(n, set());
		new_states = set().union(*[
			states_of_node.get(oe[1], set())
			for oe in graph.graph.out_edges(n,keys=True)
			if isinstance(edge_info_of(graph, oe), ValueEdge)
		]);

		new_states = refine_states.get(type(info), no_change)(graph, n, new_states, states_of_node);


		if old_states != new_states and new_states != set():
			states_of_node[n] = new_states;
			worklist += [
				ie[0] for ie in graph.graph.in_edges(n,keys=True)
				if ie[0] in graph.data_flow_nodes
			];
		
	return states_of_node;


def backwards_refine_states(graph : FSMGraph, states_of_nodes : Dict[Node, Set[Node]], seeds : List[Node] | None = None, ignore : Set[Node] = set()) -> Dict[Node, Set[Node]]:
	dominator_tree = nx.DiGraph();
	idoms = nx.immediate_dominators(graph.graph, graph.start_state);
	_ = [dominator_tree.add_edge(idoms[n], n) for n in idoms if n != idoms[n]];

	worklist = seeds if seeds is not None else [
		asg
		for asg in graph.graph.nodes 
		if isinstance(node_info_of(graph, asg), AssignmentNode)
		if asg in graph.data_flow_nodes
	];
	worklist = list(graph.data_flow_nodes);
	while worklist:
		n = worklist.pop();
		if n not in graph.data_flow_nodes:
			continue;
		if n in ignore:
			continue;
		old_states = states_of_nodes.get(n, graph.states);
		per_use_intersection = [
			old_states & states_of_nodes.get(s, graph.states) for s in graph.graph.successors(n)
		];

		refined_states = set().union(*per_use_intersection);
		if any([int == set() for int in per_use_intersection]):
			continue;
		if refined_states != old_states and refined_states != set():
			states_of_nodes[n] = refined_states;
			worklist += list(graph.graph.predecessors(n));
	return states_of_nodes;
	

def forwards_refine_states(graph : FSMGraph, states_of_nodes : Dict[Node, Set[Node]]) -> Dict[Node, Set[Node]]:
	# Now there can be nodes which do not have any states, because
	#  they are not being visited previously.
	#  This happens when the condition of an assignment is not used in a condition:
	#  example:
	#   if(transition_condition && !stall) var = value;
	worklist : List[Node] = sum([
		[s for s in graph.graph.successors(n) if s not in states_of_nodes] for n in states_of_nodes
	], []);
	while worklist:
		n = worklist.pop();
		if n not in graph.data_flow_nodes:
			continue;
		states_of_n = states_of_nodes.get(n, set());
		non_value_preds_in_edges = [
			ie for ie in graph.graph.in_edges(n, keys=True)
			if not isinstance(node_info_of(graph, ie[0]), Value)
		];
		predecessor_states = set().union(*[
			states_of_nodes.get(ie[0], set()) for ie in non_value_preds_in_edges
			if ie[0] in graph.data_flow_nodes
			if isinstance(edge_info_of(graph, ie), ValueEdge)
		]) if non_value_preds_in_edges else graph.states;
		new_states = states_of_n | predecessor_states;

		if new_states != states_of_n:
			states_of_nodes[n] = new_states;
			worklist += [ oe[1] for oe in graph.graph.out_edges(n, keys=True)
				if isinstance(edge_info_of(graph, oe), ValueEdge)
			];
	return states_of_nodes;


def make_memories_more_precise(graph : FSMGraph, states_of_nodes : Dict[Node, Set[Node]]) -> Dict[Node, Set[Node]]:
	# For memories reduce the states of the value input for by looking at the we input of the memory
	memories = [n for n in graph.data_flow_nodes if isinstance(node_info_of(graph, n), MemoryOperation)];
	backwards_pass_worklist : List[Node] = [];
	for memory in memories:
		in_edges_by_index = get_in_edges_by_index(graph, memory);
		enable_states = set().union(*[
			states_of_nodes[asg]
			for asg in graph.graph.predecessors(in_edges_by_index[0][0])
			if isinstance(node_info_of(graph, get_value_of_asg(graph, asg)), Value)
			and cast(Value, node_info_of(graph, get_value_of_asg(graph, asg))).value == 1
		]);

		write_enable_states : Set[Node] = set();
		if 2 in in_edges_by_index and 3 in in_edges_by_index:
			write_enable_true_asgs = [
				asg
				for asg in graph.graph.predecessors(in_edges_by_index[2][0])
				if isinstance(node_info_of(graph, get_value_of_asg(graph, asg)), Value)
				and cast(Value, node_info_of(graph, get_value_of_asg(graph, asg))).value == 1
			];
			write_enable_states = set().union(*[states_of_nodes[asg] for asg in write_enable_true_asgs]);
			states_of_nodes[in_edges_by_index[3][0]] = write_enable_states;
			states_of_nodes[in_edges_by_index[2][0]] = write_enable_states;
			for asg in graph.graph.predecessors(in_edges_by_index[2][0]):
				if asg in write_enable_true_asgs:
					states_of_nodes[asg] = write_enable_states;
				else:
					states_of_nodes[asg] = enable_states - write_enable_states;
			for asg in graph.graph.predecessors(in_edges_by_index[3][0]):
				if asg not in states_of_nodes:
					states_of_nodes[asg] = write_enable_states;
			backwards_pass_worklist += [in_edges_by_index[3][0]];

		load_states = enable_states - write_enable_states
		load_state_succs = set().union(*[
			set(graph.graph.successors(ls)) for ls in load_states
		]);
		states_of_nodes[in_edges_by_index[0][0]] = enable_states;
		states_of_nodes[in_edges_by_index[1][0]] = enable_states;
		states_of_nodes[memory] = enable_states;
		for asg in graph.graph.predecessors(in_edges_by_index[1][0]):
			if asg not in states_of_nodes:
				states_of_nodes[asg] = enable_states;
		for asg in graph.graph.predecessors(in_edges_by_index[0][0]):
			if asg not in states_of_nodes:
				states_of_nodes[asg] = enable_states;
		for asg in graph.graph.successors(memory):
			states_of_nodes[asg] = load_state_succs;
			for out in graph.graph.successors(asg):
				states_of_nodes[out] = load_state_succs;

	seeds = sum([list(graph.graph.predecessors(memory_out)) for memory_out in backwards_pass_worklist], []);
	states_of_nodes = backwards_refine_states(graph, states_of_nodes, seeds, ignore = set(memories));
	return states_of_nodes;

@check_invariants
@visualize_graphs
def associate_operations_with_states(graph : FSMGraph) -> AssociatedFSMGraph:
	states_of_nodes = backpropagate_state_information(graph, graph.states_assignments_execute_in);
	for var in graph.data_flow_nodes:
		if isinstance(node_info_of(graph, var), Variable):
			if all([asg in states_of_nodes for asg in graph.graph.predecessors(var)]):
				states_of_nodes[var] = set().union(*[
					states_of_nodes[asg] for asg in graph.graph.predecessors(var)
				]);

	states_of_nodes = backwards_refine_states(graph, states_of_nodes);
	states_of_nodes = make_memories_more_precise(graph, states_of_nodes);
	# If this is removed in getTanh.legup.v some operators do not get values!
	states_of_nodes = forwards_refine_states(graph, states_of_nodes);

	for n in graph.data_flow_nodes:
		if isinstance(node_info_of(graph, n), Value):
			states_of_nodes[n] = graph.states;
	for var in graph.data_flow_nodes:
		if isinstance(node_info_of(graph, var), Variable):
			if all([asg in states_of_nodes for asg in graph.graph.predecessors(var)]):
				states_of_nodes[var] = set().union(*[
					states_of_nodes[asg] for asg in graph.graph.predecessors(var)
				]);

	not_set = set(graph.data_flow_nodes) - set(states_of_nodes.keys());
	error_if_false(not_set == set(), f"Nodes without a state: {not_set}", AssociatedFSMGraph(**graph.__dict__, states_of_nodes = states_of_nodes));


	outputs_ordered = list(graph.outputs);
	return_values = add_nodes(graph, [
		ReturnValue(**node_info_of(graph, output).__dict__)
		for output in outputs_ordered
	]);
	_ = [
		graph.graph.add_edge(output, return_value, 0, info=ValueEdge())
		for output, return_value in zip(outputs_ordered, return_values)
	];
	graph.outputs = return_values;
	graph.data_flow_nodes |= set(return_values);
	for input in graph.inputs:
		states_of_nodes[input] = {graph.start_state};

	for output in graph.outputs:
		states_of_nodes[output] = {graph.stop_state};
	
	return AssociatedFSMGraph(
		**graph.__dict__,
		states_of_nodes = states_of_nodes,
	);
