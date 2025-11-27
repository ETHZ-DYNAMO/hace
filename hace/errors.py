from hace.type_info import BaseGraph;


class TerminatingError(Exception):
	def __init__(self, message : str, graph : BaseGraph):
		self.message = message;
		self.graph   = graph;
	pass

# Missing: Line information in verilog file?
# Missing: Maybe debug .dot output?
def error_if_false(condition : bool, message : str, graph : BaseGraph):
	if not condition:
		raise TerminatingError(message, graph);
