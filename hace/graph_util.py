from hace.type_info import *;
from hace.errors import error_if_false;

def node_info_of(graph : BaseGraph, node : Node) -> NodeKind:
	error_if_false('info' in graph.graph.nodes[node], f"{node}", graph);
	return graph.graph.nodes[node]['info'];
def edge_info_of(graph : BaseGraph, edge : Tuple[Node, Node, int]) -> NodeKind:
	return graph.graph.edges[*edge]['info'];
	
def type_of(graph : BaseGraph, node : Node) -> Type:
	return type(node_info_of(graph, node));

def get_condition_of_asg(graph : BaseGraph, node : Node) -> Node | None:
	assert type(node_info_of(graph, node)) == AssignmentNode;
	ies = [ie for ie in graph.graph.in_edges(node, keys=True) if type(edge_info_of(graph, ie)) == ConditionEdge];
	if ies:
		return ies[0][0];
	else:
		return None;

def get_value_of_asg(graph : BaseGraph, node : Node) -> Node:
	assert type(node_info_of(graph, node)) == AssignmentNode, f"{node}";
	ies = [ie for ie in graph.graph.in_edges(node, keys=True) if type(edge_info_of(graph, ie)) == ValueEdge];
	error_if_false(len(ies) == 1, f"Expected an assignment node to have a value input {node} {ies}", graph);
	return ies[0][0];

def get_in_edges_by_index(graph : BaseGraph, node : Node) -> Dict[int, Tuple[Node, Node, int]]:
	return { e[2] : e for e in graph.graph.in_edges(node,keys=True) };


def add_nodes(graph: BaseGraph, infos : List[NodeKind]) -> List[Node]:
	old_nodes = set(graph.graph.nodes);
	start_at = max(set(graph.graph.nodes)) + 1;
	#print(f"Start at {start_at}");
	new_nodes = [];
	for i,info in enumerate(infos):
		new_nodes += [start_at + i];
		graph.graph.add_node(start_at + i, info = info);
	assert set(new_nodes).intersection(old_nodes) == set();
	return new_nodes;


def remap_edges(graph : BaseGraph, edges_to_remap : List[Tuple[Node, Node, int]], start_mapping : Dict[Node, Node] = {}, end_mapping : Dict[Node, Node] = {}):
	new_edges = [
		(start_mapping.get(edge[0], edge[0]), end_mapping.get(edge[1], edge[1]), edge[2], graph.graph.edges[edge]['info'])
		for edge in edges_to_remap
	];
	graph.graph.remove_edges_from(edges_to_remap);

	for new_edge in new_edges:
		graph.graph.add_edge(new_edge[0], new_edge[1], new_edge[2], info = new_edge[3]);
		
	pass


def remove_unused_operators(graph : BaseGraph) -> Set[Node]:
	removed_set : Set[Node] = set();
	worklist = list(graph.graph.nodes);
	while worklist:
		n = worklist.pop();
		info = node_info_of(graph, n);
		if n in graph.do_not_remove:
			continue;
		succs = set(graph.graph.successors(n));
		succs_without_removed = succs - removed_set;
		if type(info) in [VerilogOp, Value, Constant] and succs_without_removed == set():
			removed_set.add(n);
			worklist += list(graph.graph.predecessors(n));
			
	return removed_set;
