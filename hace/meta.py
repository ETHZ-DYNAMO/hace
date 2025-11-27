from hace.type_info import BaseGraph;
from typing import *;

def on_each_graph(func, func_to_call_on_graph : Callable[[BaseGraph, str], None], *args, **kwargs):
	graph_args = [a for a in args if issubclass(type(a), BaseGraph)];
	for g in graph_args:
		func_to_call_on_graph(g, func.__name__);

	r = func(*args, **kwargs);

	if isinstance(r, tuple):
		for g in r:
			if isinstance(r, BaseGraph):
				func_to_call_on_graph(g, func.__name__);
	else:
		assert issubclass(type(r), BaseGraph), f"Expected return argument to be {BaseGraph} or a Tuple containing it, but was {type(r)}";
		func_to_call_on_graph(r, func.__name__);
	return r;
