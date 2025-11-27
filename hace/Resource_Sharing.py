import networkx as nx;
import itertools;
import copy;
from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.errors import error_if_false;
from hace.debug import visualize_graphs;
from hace.graph_util import edge_info_of, node_info_of, get_in_edges_by_index, get_value_of_asg, get_condition_of_asg, add_nodes;
from hace.memory_port import *;




@dataclass
class SharedCluster:
	nodes : List[Node];
	muxes : List[Node];
	demuxes : List[Node];

@dataclass
class FifoSlot:
	# Input Mux -> Node it consumes
	input_nodes : Dict[Node, List[Node]];
	# Output Mux -> Node that consumes it
	output_nodes : Dict[Node, List[Tuple[Node, Node, int]]];
	execution_state : Node;

@dataclass 
class SharedClusterWithFifo(SharedCluster):
	fifo : List[FifoSlot];

def find_input_to_output_map(graph : AssociatedFSMGraph, shared : SharedCluster) -> SharedClusterWithFifo:
	# Assume: Per State at most one value can be put into the shared resouce
	# Assume: Per State at most one value can be extracted from the shared resource

	Fifo = List[List[Node]];
	FifoPerMux = Dict[Node, Fifo];

	producers_per_state_per_mux   : Dict[Node, Dict[Node, List[Node]]] = {
		state : {
			mux : [asg for asg in graph.graph.predecessors(mux) if state in graph.states_of_nodes[asg]]
			for mux in shared.muxes
		} for state in graph.states
	};
	shared_states = set().union(*[
		graph.states_of_nodes[node] for node in shared.nodes
	]);
	consuming_states : Set[Node] = set().union(*[
		graph.states_of_nodes[demux] for demux in shared.demuxes
	]) if shared.demuxes else set().union(*[
		set(graph.graph.successors(shared_state)) for shared_state in shared_states
	]);

	vivado_load_special_case = all([isinstance(node_info_of(graph, shared_node), Load) for shared_node in shared.nodes]);
	if vivado_load_special_case:
		new_states = set().union(*[set(graph.graph.successors(shared_state)) for shared_state in shared_states]);
		if consuming_states.issubset(new_states):
			consuming_states = consuming_states | new_states;
	#print(f"Shared {shared.nodes}");
	#print(f"Shared States {shared_states}");
	#print(f"Consuming States {consuming_states}");

	#for pstate in graph.states:
	#	print(f"State {pstate}:");
	#	print(f"\tProducers {producers_per_state_per_mux[pstate]}");
	#print(f"Consuming {consuming_states}");

		



	fifo_at_state : Dict[Node, FifoPerMux] = { state : { mux : [] for mux in shared.muxes} for state in graph.states };
	consumed_per_state : Dict[Node, Dict[Node, List[Node]]] = { state : { mux : [] for mux in shared.muxes} for state in graph.states };

	def merge_fifos(muxes : List[Node], fifos : List[FifoPerMux]) -> FifoPerMux:
		#print(f"\tFifos: {fifos}");
		def merge_fifo(fifos : List[Fifo]) -> Fifo:
			res = [];
			for i, same_fifo_depth in enumerate(itertools.zip_longest(*fifos, fillvalue=[])):
				at_depth : List[Node] = sum([cast(List[Node], input_values) for input_values in same_fifo_depth], []);
				#print(f"\t{i}: {same_fifo_depth} -> {at_depth}");
				if at_depth:
					res += [list(set(at_depth))];
			#print(f"\tmerged {res}");
			return res;
			
		return { mux : merge_fifo([fifo[mux] for fifo in fifos]) for mux in muxes };
	
	def remove_consumers(fifo : FifoPerMux) -> Tuple[FifoPerMux, Dict[Node, List[Node]]]:
		#print(fifo);
		if any([len(fifo[mux]) == 0 for mux in fifo]):
			return fifo, { mux : [] for mux in shared.muxes};
		else:
			return {mux : fifo[mux][1:] for mux in fifo}, {mux : fifo[mux][0] for mux in fifo};

	def add_producers(fifo : FifoPerMux, producers_per_mux : Dict[Node, List[Node]]) -> FifoPerMux:
		#print(f"Adding producers {producers_per_mux}");
		return {
			mux : fifo[mux] + [producers_per_mux[mux]]
			for mux in fifo
		};


	limit = 200 * len(graph.states);
	visited : Set[Node] = set();
	worklist = [graph.start_state];
	while worklist:
		limit -= 1;
		error_if_false(limit != 0, f"Reached iteration limit in Resource Sharing for finding the Fixed Point of the Shared Resources Fifos\nShared: {shared.nodes}", graph);
		state : Node = worklist.pop();
		#print(f"State {state}");
		old_fifo = fifo_at_state[state];
		predecessor_fifos = [fifo_at_state[pred_state] for pred_state in graph.graph.predecessors(state)];
		merged_fifo = merge_fifos(shared.muxes, predecessor_fifos);


		if state in consuming_states:
			merged_fifo, consumed_per_state[state]  = remove_consumers(merged_fifo);

		merged_fifo = add_producers(merged_fifo, producers_per_state_per_mux[state]);



		fifo_at_state[state] = merged_fifo;
		if old_fifo != fifo_at_state[state] or state not in visited:
			worklist += list(graph.graph.successors(state));
			visited.add(state);
	
	def find_uses_for_variable_in_decendants_of_state(demux : Node, start_state : Node, stop_states : Set[Node]) -> List[Tuple[Node, Node, int]]:
		stop_states = stop_states - {start_state};
		uses_of_demux = list(graph.graph.out_edges(demux, keys=True));
		visited_states : Set[Node] = set();
		def find_uses_rec(state : Node):
			if state in visited_states:
				return [];
			visited_states.add(state);
			uses =  [use for use in uses_of_demux if state in graph.states_of_nodes[use[1]]]
			uses += sum([
				find_uses_rec(successor_state) 
				for successor_state in graph.graph.successors(state) 
				if successor_state not in stop_states
			], []);
			return uses;
		return find_uses_rec(start_state);

	# Fix this for vivado
	fifo : List[FifoSlot] = [];
	for state in consumed_per_state:
		if all([consumed_per_state[state][mux] == [] for mux in shared.muxes]):
			continue;
		parent_states = set(graph.graph.predecessors(state));
		# This might be overfitted to 1 cycle delay shared resources...
		execution_states = parent_states & shared_states;
		#error_if_false(len(execution_states) == 1, f"Expected Shared resource to only execute in a singular state {shared}\n{execution_states}\nParent: {parent_states}\nshared {shared_states}", graph);
		for execution_state in execution_states:
			demux_mapping = {
				demux : find_uses_for_variable_in_decendants_of_state(demux, state, consuming_states)
				for demux in shared.demuxes
			};
			fifo += [FifoSlot(input_nodes = consumed_per_state[state], output_nodes = demux_mapping, execution_state = execution_state)];
		pass

	return SharedClusterWithFifo(**shared.__dict__, fifo = fifo);



def kahn_topo_order(G):
	# condensation returns a DAG of components; C.graph['mapping'] maps original->component_id
	C = nx.condensation(G)
	comp_order = list(nx.topological_sort(C))
	mapping = C.graph['mapping']  # original_node -> comp_id

	# build comp_id -> [members]
	comp_members = {}
	for node, comp_id in mapping.items():
		comp_members.setdefault(comp_id, []).append(node)

	# expand components in topo order. For multi-node SCCs pick an internal order (here DFS order)
	expanded_order = []
	for comp_id in comp_order:
		members = comp_members[comp_id]
		if len(members) == 1:
			expanded_order.append(members[0])
		else:
			# order nodes inside SCC by a deterministic traversal (e.g., DFS postorder)
			sub = G.subgraph(members).copy()
			# use DFS postorder (deterministic if nodes are sorted)
			start = sorted(members)[0]
			internal = list(nx.dfs_postorder_nodes(sub, source=start))
			# invert the order to get a valid topo order
			internal.reverse()
			expanded_order.extend(internal)

	return expanded_order




@check_invariants
@visualize_graphs
def unshare_resources(graph : AssociatedFSMGraph) -> AssociatedFSMGraph:
	nodes_with_multiple_states = {
		node for node in graph.data_flow_nodes
		if node in graph.states_of_nodes and len(graph.states_of_nodes[node]) > 1
	};
	merge_graph = nx.from_edgelist([
		(e[0], e[1]) for e in graph.graph.edges(keys=True)
		if e[0] in nodes_with_multiple_states 
			and e[0] in graph.data_flow_nodes
			# Just because you are connected to the same value node does not mean you are in the same cluster ...
			and type(node_info_of(graph, e[0])) not in [Constant, Value]
		if e[1] in nodes_with_multiple_states 
			and e[1] in graph.data_flow_nodes
		if type(edge_info_of(graph, e)) == ValueEdge
		#if not Variable in [type(node_info_of(graph, e[0])), type(node_info_of(graph, e[1]))]
		if len(graph.states_of_nodes[e[0]]) == len(graph.states_of_nodes[e[1]])
	]);

	# Remove from the merge graph the border nodes which should be multiplexers or demultiplexers
	border_nodes = set().union(*[
		[
			n for n in cc
			for ie in graph.graph.in_edges(n, keys=True)
			if ie[0] not in cc
			if ie[0] in graph.data_flow_nodes
			if type(node_info_of(graph, n)) == Variable
		] + [
			n for n in cc
			for oe in graph.graph.out_edges(n, keys=True)
			if oe[1] not in cc
			if oe[1] in graph.data_flow_nodes
			if type(node_info_of(graph, n)) == Variable
		] for cc in nx.connected_components(merge_graph)
	]);
	merge_graph.remove_nodes_from(border_nodes);

	
	shared_clusters : List[List[Node]] = list(filter(lambda cc: any([type(node_info_of(graph, node)) not in [Variable, AssignmentNode, Constant, Value] for node in cc]), [
		list(cc) for cc in nx.connected_components(merge_graph)
	] + [
		[n] for n in nodes_with_multiple_states
		if n not in merge_graph
	]));
	shared_clusters_with_muxes_and_demuxes : List[SharedCluster] = [];
	for shared_nodes in shared_clusters:
		in_edges : List[Tuple[Node, Node, int]] = sum([
			[
				ie for ie in graph.graph.in_edges(node, keys=True)
				if ie[0] not in shared_nodes
			] for node in shared_nodes
		], []);
		if not all([
			isinstance(node_info_of(graph, ie[0]), Value)
			or isinstance(node_info_of(graph, ie[0]), Variable)
			for ie in in_edges
		]):
			continue;
		muxes = sum([
			[pred for pred in graph.graph.predecessors(node)
				if pred not in shared_nodes
				if pred in graph.data_flow_nodes
				if type(node_info_of(graph, pred)) == Variable
			] for node in shared_nodes
		], []);
		if any([
			not set(graph.graph.successors(mux)).issubset(shared_nodes)
			for mux in muxes
		]):
			continue;
		demuxes = sum([
			[var for oe in graph.graph.out_edges(node, keys=True)
				for var in graph.graph.successors(oe[1])
				if isinstance(node_info_of(graph, var), Variable)
				if isinstance(node_info_of(graph, oe[1]), AssignmentNode)
				if isinstance(edge_info_of(graph, oe), ValueEdge)
				if var not in shared_nodes
			] for node in shared_nodes
		], []);
		if any([len(list(graph.graph.predecessors(demux))) != 1
			for demux in demuxes
		]):
			continue;
		non_demux_outputs = sum([
			[
				oe[1] for oe in graph.graph.out_edges(n, keys=True)
				if oe[1] not in shared_nodes
				if isinstance(edge_info_of(graph, oe), ValueEdge)
				if not isinstance(node_info_of(graph, oe[1]), AssignmentNode)
				if oe[1] not in demuxes
			] for n in shared_nodes 
		], []);
		if len(demuxes) == 0:
			continue;
		if not (len(demuxes) > 0 or non_demux_outputs == []):
			continue;
		shared_clusters_with_muxes_and_demuxes += [ SharedCluster(shared_nodes, muxes, demuxes) ];

	all_states_topo_order = kahn_topo_order(graph.graph.subgraph(graph.states).to_directed());
	# Split the shared clusters by splitting multiplexers and demultiplexers and replicate the shared resource for each copy of mux/demux usage
	for shared in shared_clusters_with_muxes_and_demuxes:
		# First check that all muxes and demuxes have the same number of states
		states_mux = graph.states_of_nodes[shared.muxes[0]];
		for mux in shared.muxes:
			error_if_false(len(graph.states_of_nodes[mux]) == len(states_mux), f"Muxes in shared resource do not have the same number of states\nShared: {shared.nodes}\nMuxes: {shared.muxes}", graph);
		states_demux = graph.states_of_nodes[shared.demuxes[0]] if shared.demuxes else set();
		for demux in shared.demuxes:
			error_if_false(len(graph.states_of_nodes[demux]) == len(states_demux), f"Demuxes in shared resource do not have the same number of states\nShared: {shared.nodes}\nDemuxes: {shared.demuxes}", graph);
		number_copies = len(states_mux);	
		error_if_false(number_copies > 1, f"Expected at least one copy for shared resource\nShared: {shared.nodes}", graph);
		# Now find the input to output mapping using state information
		all_mux_states = set().union(*[graph.states_of_nodes[mux] for mux in shared.muxes]);
		all_demux_states = set().union(*[graph.states_of_nodes[demux] for demux in shared.demuxes]) if shared.demuxes else set();
		# Order them in topological order
		ordered_mux_states = [state for state in all_states_topo_order if state in all_mux_states];
		ordered_demux_states = [state for state in all_states_topo_order if state in all_demux_states] if shared.demuxes else [];
		muxes_ordered_inputs : Dict[Node, List[Node]] = {};
		# For each mux, order its inputs according to the ordered states
		for mux in shared.muxes:
			mux_states = list(graph.states_of_nodes[mux])
			# Check that each input assignment only takes place in one state
			for asg in graph.graph.predecessors(mux):
				error_if_false(len(graph.states_of_nodes[asg]) == 1, f"The input of a mux should take place only in one state (len({graph.states_of_nodes[asg]}) > 1)", graph);
			# Collect the list of all assignments states and mux states ordered
			states_asgs = list()
			for pred in graph.graph.predecessors(mux):
				states_asgs.extend(list(graph.states_of_nodes[pred]))
			all_states = mux_states;
			all_states.extend(states_asgs)
			ordered_states =  sorted(all_states, key=lambda state: all_states_topo_order.index(state) if state in all_states_topo_order else -1);
			inputs_per_mux_state = {};
			# Assert that the ordered states alternates between assignments and mux states
			for i in range(len(ordered_states)):
				state = ordered_states[i];
				if (i%2) == 1:
					error_if_false(state in mux_states, f"Expected mux states to be in odd positions in ordered states {ordered_states} for mux {mux}", graph);
				else:
					error_if_false(state in states_asgs, f"Expected assignment states to be in even positions in ordered states {ordered_states} for mux {mux}", graph);
					asg = [asg for asg in graph.graph.predecessors(mux) if state == list(graph.states_of_nodes[asg])[0]][0]
					inputs_per_mux_state[asg] = [ordered_states[i+1]];
			
			# Order the inputs using the state in which the mux considers it
			ordered_inputs = sorted(inputs_per_mux_state.keys(), key=lambda asg: ordered_mux_states.index(inputs_per_mux_state[asg][0]));
			muxes_ordered_inputs[mux] = ordered_inputs
		# For each demux, order its outputs according to the ordered states
		demuxes_ordered_outputs : Dict[Node, List[Node]] = {};
		for demux in shared.demuxes:
			demux_states = list(graph.states_of_nodes[demux])
			# Check that each output use only takes place in one state
			for oe in graph.graph.out_edges(demux, keys=True):
				use = oe[1];
				error_if_false(len(graph.states_of_nodes[use]) == 1, f"The output use of a demux {demux} should take place only in one state (len({graph.states_of_nodes[use]}) > 1)", graph);
			# Collect the list of all assignments states and demux states ordered
			states_uses = list()
			for succ in graph.graph.successors(demux):
				states_uses.extend(list(graph.states_of_nodes[succ]))
			all_states = demux_states;
			all_states.extend(states_uses)
			ordered_states = sorted(all_states, key=lambda state: all_states_topo_order.index(state) if state in all_states_topo_order else -1);
			uses_per_demux_state = {}
			# Assert that the ordered_states alternates between demux and assignments states
			for i in range(len(ordered_states)):
				state = ordered_states[i];
				if i % 2 == 0:
					error_if_false(state in demux_states, f"Expected mux states to be in even positions in ordered states {ordered_states} for demux {demux}", graph);
				else:
					error_if_false(state in states_uses, f"Expected assignment states to be in odd positions in ordered states {ordered_states} for demux {demux}", graph);
					asg = [asg for asg in graph.graph.successors(demux) if state == list(graph.states_of_nodes[asg])[0]][0]
					uses_per_demux_state[asg] = [ordered_states[i-1]]
			
			# Order the outputs using the state in which the demux considers it
			ordered_outputs = sorted(uses_per_demux_state.keys(), key=lambda oe: ordered_demux_states.index(uses_per_demux_state[oe][0]));
			demuxes_ordered_outputs[demux] = ordered_outputs;
		# Check all duplicated nodes have the same number of states
		states_shared_nodes = graph.states_of_nodes[shared.nodes[0]];
		for shared_node in shared.nodes:
			error_if_false(len(graph.states_of_nodes[shared_node]) == len(states_shared_nodes), f"Shared resource nodes do not have the same number of states\nShared: {shared.nodes}", graph);
		error_if_false(len(states_shared_nodes) == number_copies, f"Expected number of copies to be equal to number of states in shared resource nodes\nShared: {shared.nodes}", graph);
		# For each copy of the shared resource, assign the correct inputs and outputs
		for ith_copy in range(number_copies):
			# Copy the shared resource nodes
			duplicated_nodes = shared.nodes;			
			duplicated_graph = graph.graph.subgraph(duplicated_nodes).copy();
			base_id = max(graph.graph.nodes) + 1;
			# Relabel the duplicated nodes to new unique ids
			relabel_map = { n : base_id + j for j,n in enumerate(duplicated_nodes) };
			duplicated_graph_relabeled = nx.relabel_nodes(duplicated_graph, relabel_map, copy=True);
			# Add the duplicated nodes and edges to the graph
			graph.graph.add_nodes_from(duplicated_graph_relabeled.nodes(data=True));
			graph.graph.add_edges_from(duplicated_graph_relabeled.edges(keys=True,data=True));
			graph.data_flow_nodes = graph.data_flow_nodes | set(relabel_map.values());
			# Assign the correct state to each duplicated node
			for node in duplicated_nodes:
				states_dup_node = graph.states_of_nodes[node];
				ordered_states_shared_nodes = sorted(states_dup_node, key=lambda state: all_states_topo_order.index(state) if state in all_states_topo_order else -1);
				graph.states_of_nodes[ relabel_map[node] ] = { ordered_states_shared_nodes[ith_copy] };
			# Update base_id for next duplication
			base_id += len(duplicated_nodes);
			# Connect the borders of the shared resource to inputs and outputs respectively
			for dup_node in duplicated_nodes:
				# Check if the duplicated node is connected to a mux or demux
				for pred in list(graph.graph.predecessors(dup_node)):
					if pred in shared.muxes:
						# Create a new variable node for the unshared mux
						mux = pred;
						mux_states = list(graph.states_of_nodes[mux]);
						mux_states_ordered = sorted(mux_states, key=lambda state: all_states_topo_order.index(state) if state in all_states_topo_order else -1);
						new_var = base_id + 1;
						mux_info = graph.graph.nodes[mux]['info'];
						graph.graph.add_node(new_var, info = Variable(**mux_info.__dict__));
						graph.data_flow_nodes.add(new_var);
						cast(Variable, graph.graph.nodes[new_var]['info']).name += f" Unshared copy {ith_copy}";
						# Connect the correct input to the new variable
						input_asg = muxes_ordered_inputs[mux][ith_copy];
						# Find the existing edge input_asg -> mux
						existing_edge = None;
						for edge in graph.graph.out_edges(input_asg, keys=True):
							if edge[1] == mux:
								existing_edge = edge;
								break;
						error_if_false(existing_edge is not None, f"Could not find existing edge from {input_asg} to mux {mux}", graph);
						# Connect the input assignment to the new variable
						graph.graph.add_edge(existing_edge[0], new_var, existing_edge[2], info = copy.copy(graph.graph.edges[existing_edge]['info']));
						# Find the existing edge mux -> shared node
						existing_edge = None;
						for edge in graph.graph.out_edges(mux, keys=True):
							if edge[1] == dup_node:
								existing_edge = edge;
								break;
						error_if_false(existing_edge is not None, f"Could not find existing edge from mux {mux} to {dup_node}", graph);
						# Connect the new variable to the duplicated node
						graph.graph.add_edge(new_var, relabel_map[dup_node], existing_edge[2], info = copy.copy(graph.graph.edges[existing_edge]['info']));
						# Assign state to new variable
						graph.states_of_nodes[new_var] = { mux_states_ordered[ith_copy] };
						base_id += 1;
				for succ in list(graph.graph.successors(dup_node)):
					if succ in shared.demuxes:
						# Create a new variable node for the unshared demux
						demux = succ;
						demux_states = list(graph.states_of_nodes[demux]);
						demux_states_ordered = sorted(demux_states, key=lambda state: all_states_topo_order.index(state) if state in all_states_topo_order else -1);
						new_var = base_id + 1;
						demux_info = graph.graph.nodes[demux]['info'];
						graph.graph.add_node(new_var, info = Variable(**demux_info.__dict__));
						graph.data_flow_nodes.add(new_var);
						cast(Variable, graph.graph.nodes[new_var]['info']).name += f" Unshared copy {ith_copy}";
						# Find the existing edge shared node -> demux
						existing_edge = None;
						for edge in graph.graph.out_edges(dup_node, keys=True):
							if edge[1] == demux:
								existing_edge = edge;
								break;
						error_if_false(existing_edge is not None, f"Could not find existing edge from {dup_node} to demux {demux}", graph);
						# Connect the duplicated node to the new variable
						graph.graph.add_edge(relabel_map[dup_node], new_var, existing_edge[2], info = copy.copy(graph.graph.edges[existing_edge]['info']));
						# Connect the new variable to the correct output use
						output_asg = demuxes_ordered_outputs[demux][ith_copy]
						# Find the existing edge demux -> output_asg
						existing_edge = None;
						for edge in graph.graph.out_edges(demux, keys=True):
							if edge[1] == output_asg:
								existing_edge = edge;
								break;
						error_if_false(existing_edge is not None, f"Could not find existing edge from demux {demux} to {output_asg}", graph);
						# Connect the new variable to the output use
						graph.graph.add_edge(new_var, existing_edge[1], existing_edge[2], info = copy.copy(graph.graph.edges[existing_edge]['info']));
						# Assign state to new variable
						graph.states_of_nodes[new_var] = { demux_states_ordered[ith_copy] };
						base_id += 1;

		# Remove the original shared resource nodes, muxes and demuxes
		to_rem = shared.nodes + shared.muxes + shared.demuxes;
		graph.graph.remove_nodes_from(to_rem);
		graph.data_flow_nodes = graph.data_flow_nodes - set(to_rem);
		pass

	return graph;
