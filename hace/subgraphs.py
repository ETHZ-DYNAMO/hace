from hace.type_info import *;
import networkx as nx;
from hace.graph_util import edge_info_of;
from functools import reduce;

def value_edge_subgraph(graph : BaseGraph) -> nx.MultiDiGraph:
	return graph.graph.edge_subgraph([e for e in graph.graph.edges(keys=True) if issubclass(type(edge_info_of(graph, e)), ValueEdge)]);


def dominator_tree(graph : nx.DiGraph, start : Node, reverse=False) -> nx.DiGraph:
	doms = nx.DiGraph();
	idoms = nx.immediate_dominators(graph, start);
	for n in idoms:
		if idoms[n] != n:
			doms.add_edge(idoms[n], n);
	return doms;
			


def first_common_postdominator(post_dom_tree, bbs : List[Node]) -> Node:
	bb = reduce(lambda a,b: nx.lowest_common_ancestor(post_dom_tree, a, b), bbs);
	return bb;
