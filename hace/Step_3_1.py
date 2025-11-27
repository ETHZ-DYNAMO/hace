from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
import hace.memory_port as MEMORY;
from hace.graph_util import node_info_of, get_in_edges_by_index, get_value_of_asg, edge_info_of;
from hace.errors import error_if_false;



def get_variable_assignment_with_states(graph : AssociatedFSMGraph, node : Node) -> List[Node]:
	if not isinstance(node_info_of(graph, node), Variable):
		return [];
	res = [
		assignment 
		for assignment in graph.graph.predecessors(node)
		if len(graph.states_of_nodes[assignment])
	];
	return res;

@check_invariants
@visualize_graphs
def classify_memory_nodes(graph : AssociatedFSMGraph) -> AssociatedFSMGraph:
	memory_operations : Set[Node] = {node for node  in graph.data_flow_nodes if isinstance(node_info_of(graph, node), MemoryOperation)};
	to_remove : Set[Node] = set();
	base_id = max(graph.graph.nodes) + 1;

	# Process each memory operation
	for memory in memory_operations:
		# Get the input edges by index ( dict where the key is the port index and the value is the edge info (src, memory, key) )
		in_edges_by_index = get_in_edges_by_index(graph, memory);
		# Determine the states in which the memory is enabled
		enable_states = set().union(*[
			graph.states_of_nodes.get(asg, set())
			for asg in graph.graph.predecessors(in_edges_by_index[0][0])
			if isinstance(node_info_of(graph, get_value_of_asg(graph, asg)), Value)
			and cast(Value, node_info_of(graph, get_value_of_asg(graph, asg))).value == 1
		]);
		# Determine the states in which the memory is storing vs loading
		store_states = enable_states & (set().union(*[
			graph.states_of_nodes[asg]
			for asg in graph.graph.predecessors(in_edges_by_index[2][0])
			if isinstance(node_info_of(graph, get_value_of_asg(graph, asg)), Value)
			and cast(Value, node_info_of(graph, get_value_of_asg(graph, asg))).value == 1
		])  if 2 in in_edges_by_index and 3 in in_edges_by_index else set());
		load_states  = enable_states - store_states;
		memory_info = node_info_of(graph, memory);
		assert isinstance(memory_info, MemoryOperation);

		if load_states:
			# Get the address port
			address_out = in_edges_by_index[1][0];
			# Get all assignments to the address which occur in the load states
			address_assignments = [asg 
				for asg in graph.graph.predecessors(address_out)
				if graph.states_of_nodes[asg] & load_states != set()
			];
			# Duplicate the memory load and its relevant inputs for the load states
			nodes_to_duplicate = [
				memory, address_out,
				*address_assignments
			];
			relabel_map = { old : base_id + i for i, old in enumerate(nodes_to_duplicate) };
			base_id = max(base_id, max(relabel_map.values()) + 1);
			duplicate = nx.relabel_nodes(graph.graph.subgraph(relabel_map.keys()), relabel_map, copy=True);
			graph.graph.add_nodes_from(duplicate.nodes(data=True));
			graph.graph.add_edges_from(duplicate.edges(keys=True,data=True));
			graph.data_flow_nodes = graph.data_flow_nodes | set(relabel_map.values());
			graph.states_of_nodes[relabel_map[memory]] = load_states;
			graph.states_of_nodes[relabel_map[address_out]] = graph.states_of_nodes[address_out] & load_states;
			graph.do_not_remove |= {relabel_map[address_out]};
			for asg in address_assignments:
				graph.states_of_nodes[relabel_map[asg]] = graph.states_of_nodes[asg] & load_states;

			for asg in address_assignments:
				for ie in graph.graph.in_edges(asg, keys=True):
					graph.graph.add_edge(ie[0], relabel_map[ie[1]], ie[2], info = edge_info_of(graph, ie));
			for oe in graph.graph.out_edges(memory, keys=True):
				graph.graph.add_edge(relabel_map[oe[0]], oe[1], oe[2], info = edge_info_of(graph, oe));
				graph.states_of_nodes[oe[1]] = load_states;
				for c in graph.graph.successors(oe[1]):
					graph.states_of_nodes[c] = load_states;

			graph.graph.nodes[relabel_map[memory]]['info'] = Load(
				memory_info.bit_width,
				memory_info.signed,
				memory_info.memory[0],
			);
			# If there are no users of this load
			if len(nx.descendants(graph.graph, memory)) == 2:
				to_rem = list(relabel_map.values()) + list(nx.descendants(graph.graph, relabel_map[memory]));
				graph.graph.remove_nodes_from(to_rem);
				graph.data_flow_nodes = graph.data_flow_nodes - set(to_rem);
			pass
		else:
			if len(nx.descendants(graph.graph, memory)) == 2:
				to_rem = list(nx.descendants(graph.graph, memory));
				graph.graph.remove_nodes_from(to_rem);
				graph.data_flow_nodes = graph.data_flow_nodes - set(to_rem);
			

		if store_states:
			# Get the address port
			address_out = in_edges_by_index[1][0];
			# Get all assignments to the address which occur in the store states and duplicate if happen in multiple store states
			address_assignments = [asg 
				for asg in graph.graph.predecessors(address_out)
				for store_state in store_states
				if store_state in graph.states_of_nodes[asg]
			];
			# Get the value port
			value_out = in_edges_by_index[3][0];
			# Get all assignments to the value which occur in the store states and duplicate if happen in multiple store states
			value_assignments = [asg
				for asg in graph.graph.predecessors(value_out)
				for store_state in store_states
				if store_state in graph.states_of_nodes[asg]
			];
			# Assert the number of address assignments is equal to the number of value assignments which should be equal to the number of store states
			error_if_false(len(address_assignments) == len(value_assignments) == len(store_states), f"Expected the number of address assignments {address_assignments} and value assignments {value_assignments} to be equal to the number of store states {store_states} for memory {memory}", graph);			

			# Duplicate the memory store and its relevant inputs for each store state
			for store_state in store_states:
				# Find the assignments relevant to this store state
				address_assignments = [asg 
					for asg in graph.graph.predecessors(address_out)
					if store_state in graph.states_of_nodes[asg]
				];
				value_assignments = [asg
					for asg in graph.graph.predecessors(value_out)
					if store_state in graph.states_of_nodes[asg]
				];
				# Assert they are exactly one each
				error_if_false(len(address_assignments) == 1, f"Expected exactly one address assignment for store state {store_state} for memory {memory}, found {address_assignments}", graph);
				error_if_false(len(value_assignments) == 1, f"Expected exactly one value assignment for store state {store_state} for memory {memory}, found {value_assignments}", graph);
				address_assignment = address_assignments[0];
				value_assignment = value_assignments[0];
				nodes_to_duplicate = [
					memory, address_out, value_out,
					address_assignment,
					value_assignment
				];
				relabel_map = { old : base_id + i for i, old in enumerate(nodes_to_duplicate) };
				base_id = max(base_id, max(relabel_map.values()) + 1);
				duplicate = nx.relabel_nodes(graph.graph.subgraph(relabel_map.keys()), relabel_map, copy=True);
				graph.graph.add_nodes_from(duplicate.nodes(data=True));
				graph.graph.add_edges_from(duplicate.edges(keys=True,data=True));
				graph.data_flow_nodes = graph.data_flow_nodes | set(relabel_map.values());

				graph.states_of_nodes[relabel_map[memory]] = {store_state};
				graph.states_of_nodes[relabel_map[address_out]] = graph.states_of_nodes[address_out] & {store_state};
				graph.states_of_nodes[relabel_map[value_out]] = graph.states_of_nodes[value_out] & {store_state};
				graph.do_not_remove |= {relabel_map[address_out], relabel_map[value_out]};
				for asg in [address_assignment, value_assignment]:
					graph.states_of_nodes[relabel_map[asg]] = graph.states_of_nodes[asg] & {store_state};
				
				for asg in [address_assignment, value_assignment]:
					for ie in graph.graph.in_edges(asg, keys=True):
						graph.graph.add_edge(ie[0], relabel_map[ie[1]], ie[2], info = edge_info_of(graph, ie));
				graph.graph.nodes[relabel_map[memory]]['info'] = Store(
					memory_info.bit_width,
					memory_info.signed,
					memory_info.memory[0],
				);
				pass

		all_preds = list(graph.graph.predecessors(memory));
		all_asgs = sum([list(graph.graph.predecessors(pred)) for pred in all_preds], []);
		all = all_preds + all_asgs + [memory];
		graph.graph.remove_nodes_from(all);
		graph.data_flow_nodes = graph.data_flow_nodes - set(all);
		pass
	return graph;
