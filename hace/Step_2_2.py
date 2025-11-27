from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs, debug_write_graph;
from hace.graph_util import node_info_of, edge_info_of, get_value_of_asg, remap_edges, get_condition_of_asg, add_nodes, get_in_edges_by_index;
from hace.subgraphs import value_edge_subgraph;
from hace.predefined_ports import start_inputs;
from hace.errors import error_if_false;
from hace.Step_2_1 import COMPARISON_OPERATORS;
from hace.predefined_ports import stall_conditions;
from hace.verilog import binary, unary, comparisons;

@check_invariants
@visualize_graphs
def idempotent_remove(graph : SplitCFDFGraph, nodes_to_remove : List[Node]) -> SplitCFDFGraph:
	worklist = list(nodes_to_remove);
	while worklist:
		n = worklist.pop();
		if n not in graph.graph:
			continue;
		n_info = node_info_of(graph, n);
		succs = list(graph.graph.successors(n));

		if n in nodes_to_remove:
			graph.graph.remove_node(n);
		elif type(n_info) == AssignmentNode:
			if 0 not in get_in_edges_by_index(graph, n):
				add_worklist = sum([
					list(graph.graph.successors(succ)) for succ in graph.graph.successors(n)
				], []);
				graph.graph.remove_nodes_from([n] + list(graph.graph.successors(n)));
				worklist += add_worklist;
			else:
				value = get_value_of_asg(graph, n);
		elif isinstance(n_info, VerilogOp):
			if n_info.operation in comparisons:
				if len(list(graph.graph.in_edges(n, keys=True))) != 2:
					graph.graph.remove_node(n);
			elif n_info.operation in binary:
				# EQ comparisons need to just be removed, not replaced with the other parent
				parents = list(graph.graph.in_edges(n, keys=True));
				match len(parents):
					case 0:
						graph.graph.remove_node(n);
					case 1:
						other_value = parents[0][0];
						remap_edges(graph, list(graph.graph.out_edges(n, keys=True)), start_mapping = {n : other_value});
						graph.graph.remove_node(n);
					case 2:
						pass
			elif n_info.operation in unary:
				if len(list(graph.graph.in_edges(n, keys=True))) != 1:
					graph.graph.remove_node(n);
			else:
				pass
		elif isinstance(n_info, Variable):
			if len(list(graph.graph.predecessors(n))) == 0:
				graph.graph.remove_node(n);

		if n not in graph.graph:
			worklist += succs;

	graph.control_flow_nodes = graph.control_flow_nodes & set(graph.graph.nodes);
	graph.data_flow_nodes = graph.data_flow_nodes & set(graph.graph.nodes);

	return graph;


def forward_propagate_state_information(graph : FSMWithStateComparisons, states : Set[Node], start_inputs : List[Node]) -> Dict[Node, Set[Node]]:
	states_of_comparison = {
		cmp : state
		for state in states
		for cmp in cast(State, node_info_of(graph, state)).comparisons
	};
	# Replace all a == 0 with !
	# Replace all a == 1 with a
	for n in list(graph.control_flow_nodes):
		if n in states_of_comparison:
			continue;
		info = node_info_of(graph, n);
		if not isinstance(info, VerilogOp):
			continue;
		if info.operation != VerilogOperation.BINARY_EQ:
			continue;
		ies = list(graph.graph.in_edges(n, keys=True));
		if any([ie[0] in start_inputs for ie in ies]):
			continue;
		value_ies = [ie for ie in ies if isinstance(node_info_of(graph, ie[0]), Value)];
		if len(value_ies) == 0:
			continue;
		const_ie = value_ies[0]; 
		const_info = cast(Value, node_info_of(graph, const_ie[0]));
		other_ie = list(set(ies) - {const_ie})[0];
		other = other_ie[0];
		if isinstance(node_info_of(graph, other), Value):
			continue;
		if const_info.value in [0,1]:
			if const_info.value == 1:
				for oe in graph.graph.out_edges(n, keys=True):
					graph.graph.add_edge(other, oe[1], oe[2], info = edge_info_of(graph, oe));
			else:
				not_node = add_nodes(graph, [VerilogOp(1, Signedness.Signed, VerilogOperation.UNARY_NOT)])[0];
				if other in graph.data_flow_nodes:
					graph.data_flow_nodes.add(not_node);
				else:
					graph.control_flow_nodes.add(not_node);
				graph.graph.add_edge(other, not_node, 0, info = ValueEdge());
				for oe in graph.graph.out_edges(n, keys=True):
					graph.graph.add_edge(not_node, oe[1], oe[2], info = edge_info_of(graph, oe));
			graph.graph.remove_node(n);
			graph.control_flow_nodes.remove(n);

	debug_write_graph(graph, "eq_elim");


	value_subg = value_edge_subgraph(graph)
	depending_on_state_comparisons = set().union(*[
		set(nx.descendants(value_subg, comp)) for comp in states_of_comparison
	]);
	comparison_subg = value_subg.subgraph(depending_on_state_comparisons | set(states_of_comparison.keys()));

	error_if_false(all([
		cast(NodeWithValue, node_info_of(graph, n)).bit_width == 1 for n in comparison_subg.nodes
	]), f"Expected all assignment determining conditions to be of bit width 1", graph);

	# IF Var you need to only have a single input!
	var_nodes = [n for n in comparison_subg.nodes if isinstance(node_info_of(graph, n), Variable)];
	error_if_false(all([
		len(list(comparison_subg.predecessors(var))) == 1 for var in var_nodes
	]), f"All variables in the comparison subg need to have exactly 1 input {var_nodes}", graph);

	debug_write_graph(BaseGraph(comparison_subg, set(), "", set(), set()), "comparison_subg");
	import z3;
	node_to_z3_var : Dict[Node, Any] = {
		n : z3.Bool(f"Node_{n}")
		for n in comparison_subg.nodes
	};
	free_variables = [];
	to_add = [];
	free_variables_assignments = [];
	for n, n_var in list(node_to_z3_var.items()):
		info = node_info_of(graph, n);
		if isinstance(info, VerilogOp):
			ies = list(graph.graph.in_edges(n, keys=True));
			new_free_variables = [
			];
			for ie in ies:
				if ie[0] not in node_to_z3_var:
					node_to_z3_var[ie[0]] = z3.Bool(f"Free_{ie[0]}");
					free_variables += [node_to_z3_var[ie[0]]];
					new_free_variables += [node_to_z3_var[ie[0]]];
			match info.operation:
				case VerilogOperation.BINARY_AND | VerilogOperation.BINARY_BITAND:
					to_add.append(n_var == z3.And(*[node_to_z3_var[ie[0]] for ie in ies]));
					for nfv in new_free_variables:
						free_variables_assignments.append(True == nfv);
				case VerilogOperation.BINARY_OR | VerilogOperation.BINARY_BITOR:
					to_add.append(n_var == z3.Or(*[node_to_z3_var[ie[0]] for ie in ies]));
					for nfv in new_free_variables:
						free_variables_assignments.append(False == nfv);
				case VerilogOperation.UNARY_NOT | VerilogOperation.UNARY_INV:
					to_add.append(n_var == z3.Not(node_to_z3_var[ies[0][0]]));
					for nfv in new_free_variables:
						free_variables_assignments.append(False == nfv);
				case _:
					pass
		elif isinstance(info, AssignmentNode):
			value = get_value_of_asg(graph, n);
			to_add.append(n_var == node_to_z3_var[value]);
		elif isinstance(info, Variable):
			value = list(comparison_subg.predecessors(n))[0];
			to_add.append(n_var == node_to_z3_var[value]);
		else:
			error_if_false(False, f"Unimplemented {n} {info}", graph);

	solver = z3.Solver();
	_ = [solver.add(eq) for eq in to_add];
	#_ = [solver.add(free_var == True) for free_var in free_variables];
	
	# Collect all conditions that are not a constant value
	non_trivial_condition_assgs = [
		get_condition_of_asg(graph, assignment) for assignment in graph.data_flow_nodes
			if isinstance(node_info_of(graph, assignment), AssignmentNode)
			for cond in [get_condition_of_asg(graph, assignment)]
			if cond is not None
			if not(isinstance(node_info_of(graph, cond), Value))
		];


	true_in_states : Dict[Node, Set[Node]] = {
		node : set(states) for node in graph.graph.nodes if node in non_trivial_condition_assgs
	};

	for n in comparison_subg.nodes:
		solver.push();
		solver.add(node_to_z3_var[n] == True);
		# Add free variables assignments temporarily since they might cause a conflict
		solver.push();
		_ = [solver.add(fva) for fva in free_variables_assignments];
		sat_for_states : Set[Node] = set();
		for state in states:
			solver.push();
			true_comps = set(cast(State, node_info_of(graph, state)).comparisons) & set(node_to_z3_var);
			for cmp in states_of_comparison:
				solver.add(node_to_z3_var[cmp] == (cmp in true_comps));
			if solver.check() == z3.sat:
				sat_for_states.add(state);
			solver.pop();
			pass

		solver.pop(); # remove free variable assignments
		if sat_for_states.__len__() == 0:
			# Re-iterate through states without free variable assignments
			for state in states:
				solver.push();
				true_comps = set(cast(State, node_info_of(graph, state)).comparisons) & set(node_to_z3_var);
				for cmp in states_of_comparison:
					solver.add(node_to_z3_var[cmp] == (cmp in true_comps));
				if solver.check() == z3.sat:
					sat_for_states.add(state);
				solver.pop();
				pass
		true_in_states[n] = sat_for_states;
		#print(f"{n}: {sat_for_states}");
		solver.pop();
		pass

	return true_in_states;

@check_invariants
@visualize_graphs
def create_fsm(graph : FSMWithStateComparisons) -> FSMGraph:
	# Create the value edge subgraph which contains only value edges
	value_graph = value_edge_subgraph(graph);
	# Find the value node used in each comparison operator for the current state
	value_node_of_current_state_for_each_comparison : Dict[Node, Node] = {
		comparison : [p for p in graph.graph.predecessors(comparison) if p != graph.current_state_node][0]
		for comparison in graph.state_comparisons
	};
	# Find all state values used in comparisons
	start_control_inputs = [n for n in graph.control_io 
		if type(node_info_of(graph, n)) == Variable
		if cast(Variable, node_info_of(graph, n)).name in start_inputs
	];

	
	# Map from comparison operator to its info
	info_of_comparison : Dict[Node, VerilogOp] = {
		comparison : cast(VerilogOp, node_info_of(graph, comparison))
		for comparison in value_node_of_current_state_for_each_comparison
	};

	def default_value_of_comparison(graph : BaseGraph, comp : Node) -> int:
		error_if_false(False, f"not supporting comparison  {comp}", graph);
		assert False;

	# Define how to get the value that makes the comparison true for binary eq operators
	def value_of_binary_eq(graph : BaseGraph, comparison : Node) -> int:
		value_used = value_node_of_current_state_for_each_comparison[comparison];
		info = node_info_of(graph, value_used);
		error_if_false(isinstance(info, Value), f"Expected the comparison to only have the current_state and a value (immediate or parameter/localparam)", graph);
		assert isinstance(info, Value);
		return info.value;

	# Define how to get the value that makes the comparison true for array index operators
	def value_of_index(graph : BaseGraph, comparison : Node) -> int:
		value_used = value_node_of_current_state_for_each_comparison[comparison];
		info = node_info_of(graph, value_used);
		error_if_false(isinstance(info, Value), f"Expected the comparison to only have the current_state and a value (immediate or parameter/localparam)", graph);
		assert isinstance(info, Value);
		return 1 << info.value;
		

	VALUE_FOR_COMP : Dict[VerilogOperation, Callable[[BaseGraph, Node], int]] = {
		VerilogOperation.BINARY_EQ : value_of_binary_eq,
		VerilogOperation.ARRAY_INDEX : value_of_index,
	};
	error_if_false(set(VALUE_FOR_COMP.keys()) == set(COMPARISON_OPERATORS), f"Expected to have a value producing procedure per supported comparison", graph);

	# Find the value that makes each comparison true
	value_making_comparison_true : Dict[Node, int|None] = {
		comparison : 
			VALUE_FOR_COMP.get(info_of_comparison[comparison].operation, default_value_of_comparison)(graph, comparison)
		for comparison in info_of_comparison
	};

	error_if_false(all([value_making_comparison_true[comp] is not None for comp in value_making_comparison_true]),
	f"""Found state values but there was no unique match of them to the values used in the state 
transitions, most likely a single state value was repeated multiple times.
State Values used in comparisons: {list(value_making_comparison_true.values())}
Values making comparison true: {value_making_comparison_true}
	""", graph);
	value_making_comparison_true_checked : Dict[Node, Node] = cast(Dict[Node, Node], value_making_comparison_true);
	value_to_comparison : Dict[int , List[Node]] = {
		value : [cmp for cmp in value_making_comparison_true_checked.keys() if value_making_comparison_true_checked[cmp] == value]
		for value in value_making_comparison_true_checked.values()
	};


	# Map from state value to the comparisons that match it
	state_value_to_comparisons_match : Dict[Node, List[Node]] = {
		state_value : value_to_comparison[cast(Value, node_info_of(graph, state_value)).value]
		for state_value in graph.state_values
	};

	# Create the states
	states = set(add_nodes(graph, [State(
			state_constant = state_value,
			value          = cast(Value, node_info_of(graph, state_value)).value,
			comparisons     = state_value_to_comparisons_match[state_value],
		) for state_value in state_value_to_comparisons_match]
	));
	graph.control_flow_nodes = graph.control_flow_nodes | set(states);

	#Maps the state which we are going to, to the assignments which execute for that
	assignments_which_change_the_states : Dict[Node, List[Node]] = {
		state : [const_oe[1] 
			for const_oe in graph.graph.out_edges(cast(State, node_info_of(graph, state)).state_constant, keys=True) 
			if type(node_info_of(graph, const_oe[1])) == AssignmentNode
			if type(edge_info_of(graph, const_oe))    == ValueEdge
			if nx.has_path(value_graph, const_oe[1], graph.current_state_node)
		]
		for state in states
	};

	# Now I want to know which assignments execute in which states
	#  because that informs the state transitions
	only_true_in_state = forward_propagate_state_information(graph, states, start_control_inputs);

	states_assignments_execute_in : Dict[Node, Set[Node]] = {
		asg : s for asg,s in
		{
			assignment : only_true_in_state[cast(Node, get_condition_of_asg(graph, assignment))]
			for assignment in graph.data_flow_nodes
			if isinstance(node_info_of(graph, assignment), AssignmentNode)
			for cond in [get_condition_of_asg(graph, assignment)]
			if cond is not None
			if not(isinstance(node_info_of(graph, cond), Value))
		}.items()
	};
	
	# ComeFromState, GoToState -> condition for the edge
	fsm_edges : Dict[Tuple[Node, Node], List[Node]] = {};
	for go_to_state in assignments_which_change_the_states:
		#print(f"Go to {go_to_state}");
		for asg in assignments_which_change_the_states[go_to_state]:
			#print(f"\tAsg {asg}");
			condition_of_asg = get_condition_of_asg(graph, asg);
			assert condition_of_asg is not None;
			states_of_condition = only_true_in_state[condition_of_asg];
			for come_from_state in states_of_condition:
				#print(f"\t\tComing from {come_from_state}");
				edge_tuple =  (come_from_state, go_to_state);
				fsm_edges[edge_tuple] = fsm_edges.get(edge_tuple, []) + [asg];

	#print(fsm_edges);

	# Find edges which are depending on a start condition, remove them, 
	#  each votes for the come_from state to be the start state.
	start_node_score = { state : 0 for state in states };
	for fsm_edge in fsm_edges:
		for assignment in fsm_edges[fsm_edge]:
			condition = get_condition_of_asg(graph, assignment);
			if any([nx.has_path(value_graph, start, condition) for start in start_control_inputs if start in value_graph]):
				start_node_score[fsm_edge[0]] += 1;
			graph.graph.add_edge(fsm_edge[0], fsm_edge[1], len(set(graph.graph.in_edges(fsm_edge[1], keys=True))),info = Transition(assignment));

	# Select the start state
	start_states_scored = sorted(list(states), key=lambda s: -start_node_score[s]);

	error_if_false(len(start_states_scored) >= 1, f"Did not find a state as a candidate for the starting state {start_states_scored} States: {state_value_to_comparisons_match}", graph);
	error_if_false(start_node_score[start_states_scored[0]] != start_node_score[start_states_scored[1]], 
	f"""Expected there to be an unambigous start state, but all had the same scoring
Score of first  {start_node_score[start_states_scored[0]]} (Node {start_states_scored[0]})
Score of second {start_node_score[start_states_scored[1]]} (Node {start_states_scored[1]})
""", graph);
	start_state = start_states_scored[0];
	for ie in list(graph.graph.in_edges(start_state, keys=True)):
		if ie[0] == start_state and ie[1] == start_state:
			graph.graph.remove_edge(*ie);
	start_state_incoming = [ie for ie in graph.graph.in_edges(start_state, keys=True)];

	# Create a stop state which all start state incoming edges go to
	stop_state = max(graph.graph.nodes) + 1;
	states.add(stop_state);
	graph.control_flow_nodes.add(stop_state);
	graph.graph.add_node(stop_state, info = State(0,0,[]));
	for ie in graph.graph.in_edges(start_state, keys=True):
		graph.graph.add_edge(ie[0], stop_state, ie[2], info = edge_info_of(graph, ie));
	graph.graph.remove_edges_from(list(graph.graph.in_edges(start_state,keys=True)));

	# After that clean the state comparisons from the conditions on the state transitions
	#  Remove all state comparison nodes
	#  Idempotent replace! 
	#  Stop at condition edges
	state_comparisons = sum([
		cast(State, node_info_of(graph, state)).comparisons for state in states
	], []);
	stall_condition_nodes = [n for n in graph.control_io
		if isinstance(node_info_of(graph, n), Variable)
		if cast(Variable, node_info_of(graph, n)).name in stall_conditions
	];
	idempotent_remove(graph, stall_condition_nodes + state_comparisons + start_control_inputs);


	# Now convert the FSM transitions to ConditionalTransitions and UnconditionalTransitions
	fsm_transition_assignments = [
		cast(Transition, edge_info_of(graph, e)).assignment
		for e in graph.graph.edges(keys=True)
		if isinstance(edge_info_of(graph, e), Transition)
	];
	# Now the fsm conditions do not exist anymore
	#  replace them with their cleaned nodes
	base_id = max(graph.graph.nodes) + 1;
	for transition in [e for e in graph.graph.edges(keys=True) if isinstance(edge_info_of(graph, e), Transition)]:
		info = edge_info_of(graph, transition);
		assert isinstance(info, Transition);
		condition = get_condition_of_asg(graph, info.assignment);
		if condition:
			ancs = set(nx.ancestors(graph.graph, condition)) | {condition};
			graph.control_flow_nodes = graph.control_flow_nodes - ancs;
			graph.data_flow_nodes = graph.data_flow_nodes | ancs;

			condition_info = node_info_of(graph, condition);
			assert isinstance(condition_info, NodeWithValue);
			bw = condition_info.bit_width;
			signed = condition_info.signed;
			asg_node = base_id; base_id += 1;
			condition_var_node = base_id; base_id += 1;
			graph.graph.add_node(asg_node, info = AssignmentNode(bit_width = bw, signed = signed));
			graph.graph.add_node(condition_var_node, info = Variable(bit_width = bw, signed = signed, name = f"Condition {transition[0]} -> {transition[1]}"));
			graph.graph.add_edge( asg_node, condition_var_node, info = ValueEdge());
			graph.graph.add_edge(condition,           asg_node, info = ValueEdge());
			states_assignments_execute_in[asg_node] = {transition[0]};
			graph.data_flow_nodes = graph.data_flow_nodes | {asg_node, condition_var_node};


			graph.graph.edges[transition]['info'] = ConditionalTransition(condition_var_node);
			graph.do_not_remove.add(condition_var_node);
		else:
			graph.graph.edges[transition]['info'] = UnconditionalTransition();
			pass
		pass

	graph.graph.remove_nodes_from(fsm_transition_assignments);
	graph.control_flow_nodes = graph.control_flow_nodes - set(fsm_transition_assignments);


	# Final clean up of the graph
	condition_nodes_attached_to_df = {
		ie[0] for ie in graph.graph.edges(keys=True)
		if ie[0] not in graph.data_flow_nodes
		if ie[1]     in graph.data_flow_nodes
		if isinstance(edge_info_of(graph, ie), ConditionEdge)
	};
	for condition in condition_nodes_attached_to_df:
		ancs = set(nx.ancestors(graph.graph, condition)) | {condition};
		graph.control_flow_nodes = graph.control_flow_nodes - ancs;
		graph.data_flow_nodes = graph.data_flow_nodes | ancs;
	
	# Final invariant checks
	for transition in [e for e in graph.graph.edges(keys=True) if isinstance(edge_info_of(graph, e), Transition)]:
		assert type(edge_info_of(graph, transition)) in [ConditionalTransition, UnconditionalTransition];

	# Ensure all states are reachable from the start state
	states_reachable_from_start = {
		state for state in states
		if nx.has_path(graph.graph, start_state, state)
	};
	error_if_false(states_reachable_from_start == states, f"Expected the Start State to be able to reach all other States\nUnreachable States {states - states_reachable_from_start}", graph);


	return FSMGraph(
		graph = graph.graph,
		do_not_remove = graph.do_not_remove,
		name = graph.name,
		control_flow_nodes = graph.control_flow_nodes,
		data_flow_nodes    = graph.data_flow_nodes,
		current_state_node = graph.current_state_node,
		states = states,
		states_assignments_execute_in = states_assignments_execute_in,
		start_state = start_state,
		stop_state = stop_state,
		inputs = graph.inputs,
		outputs = graph.outputs,
	);
		
