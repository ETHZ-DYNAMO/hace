from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.subgraphs import value_edge_subgraph;
from hace.graph_util import node_info_of;
from hace.errors import error_if_false;
from hace.verilog import comparisons;


@check_invariants
@visualize_graphs
def split_control_and_data_flow(graph : AssignmentGraph) -> PartitionedGraph:
	# Create the value edge subgraph which contains only value edges
	value_graph = value_edge_subgraph(graph);
	# Collect all comparison nodes
	comparison_nodes = {n for n in value_graph.nodes
		if isinstance(node_info_of(graph, n), VerilogOp)
		if cast(VerilogOp, node_info_of(graph, n)).operation in comparisons
	};
	# Remove all comparison nodes from the value graph
	value_graph = value_graph.edge_subgraph([
		e for e in value_graph.edges(keys=True)
		if e[0] not in comparison_nodes
	]);
	# Collect all memory operation nodes
	memory_nodes = {n for n in graph.graph.nodes if type(node_info_of(graph, n)) == MemoryOperation};
	# Ensure that all inputs, outputs, and memory nodes are still in the value graph
	error_if_false(all([ o in value_graph.nodes for o in graph.outputs]), f"Expected all outputs to remain in graph", graph);
	error_if_false(all([ i in value_graph.nodes for i in graph.inputs]) , f"Expected all inputs to remain in graph", graph);
	error_if_false(all([ m in value_graph.nodes for m in memory_nodes]) , f"Expected all memory nodes to remain in graph", graph);

	# Collect all data flow nodes as those that are connected to inputs, outputs, or memory nodes
	df_nodes : Set[Node] = set().union(*[
		set(nx.ancestors(value_graph, output)) | {output} for output in set(graph.outputs) | memory_nodes
	], *[
		set(nx.descendants(value_graph,input)) | {input}  for input  in set(graph.inputs) | memory_nodes
	]);
	to_add = {
		df_node : set(nx.ancestors(value_graph, df_node)) for df_node in df_nodes
	};
	added_by = {
		node : {df_node for df_node in to_add if node in to_add[df_node]}
		for node in set().union(*list(to_add.values()))
	};

	# Expand the data flow nodes to include all ancestors of data flow nodes
	df_nodes = df_nodes.union(*list(to_add.values()));
	# Define control flow nodes as those that are not data flow nodes
	cf_nodes : Set[Node] = set(graph.graph.nodes) - df_nodes;

	split = PartitionedGraph(
		graph = graph.graph, 
		do_not_remove = graph.do_not_remove,
		name = graph.name,
		control_flow_nodes = cf_nodes, 
		data_flow_nodes = df_nodes,
		inputs = graph.inputs,
		outputs = graph.outputs,
		control_io = graph.control_io,
	);
	return split;
	
