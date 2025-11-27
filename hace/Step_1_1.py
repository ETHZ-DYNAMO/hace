import networkx as nx;
from typing import *;
import lark;


from hace.predefined_ports import *;
from hace.type_info import *;
from hace.verilog import *;
from hace.invariants import check_invariants, check_invariants_on_graph;
from hace.debug import *;
from hace.errors import error_if_false;

class PortDirection(Enum):
	INPUT = auto();
	OUTPUT = auto();

@dataclass
class Graph:
	graph : nx.DiGraph;
	name : str;
	inputs : Set;
	outputs : Set;

def get_value(g, node):
	assert g.nodes[node]['type'] == NodeType.ASSIGNMENT, f"{node} was {g.nodes[node]['type']}";
	ie = g.in_edges(node, keys=True,data=True);
	#assert len(preds) == 2;
	value_node_candidates = [e[0] for e in ie if e[3]['type'] == EdgeType.VALUE];
	assert len(value_node_candidates) == 1, f"{value_node_candidates} for node {node}";
	return value_node_candidates[0];

def get_condition(g, node):
	assert g.nodes[node]['type'] == NodeType.ASSIGNMENT, f"was {g.nodes[node]['type']}";
	ie = g.in_edges(node, keys=True,data=True);
	#assert len(preds) == 2, f"preds of '{g.nodes[node]['label']}' = {preds}";
	condition_node_candidates = [e[0] for e in ie if e[3]['type'] == EdgeType.CONDITION];
	assert len(condition_node_candidates) == 1, f"{condition_node_candidates} for node {node}";
	return condition_node_candidates[0];

def named(g, l):
	if type(l) is type(None):
		return "";
	elif type(l) is list or type(l) is set or type(l) is tuple:
		return [named(g, n) for n in l];
	elif type(l) is int:
		return g.nodes[l]['label'];
	else:
		assert False, f"Unkown kind for l {l} is {type(l)}";

class NodeType(Enum):
        ASSIGNMENT = 0;
        OPERATOR   = 1;
        VARIABLE   = 2;
        CONSTANT   = 3;
        VALUE      = 4;
        STATE      = 5;
        STORE      = 6;
        LOAD       = 7;
        BASIC_BLOCK = 8;
        ANNOTATION = 9;
        PHI        = 10;
        PROCEDURE_ARGUMENT     = 11;
        PROCEDURE_RETURN_VALUE = 12;
        BRANCH      = 13;
        COND_BRANCH = 14;
        RETURN      = 15;
        MEMORY_OP   = 16;

class EdgeType(Enum):
        VALUE     = 0;
        CONDITION = 1;
        TRANSITION = 2;
        ANNOTATION = 3;

def add_node(g, type_, direction = None, label = None, id = None, **kwargs) -> int:
	if 'type' in kwargs:
		del kwargs['type'];
	if id is None:
		id = max(g.nodes) + 1;
	assert type(type_) == NodeType;
	assert type(label) == str or type(label) == type(None);
	if label is None:
		label = str(id);
	g.add_node(id, type = type_, label = label, **kwargs);
	if direction is not None:
		g.nodes[id]['direction'] = direction;
	return id;

# currently not capturing the following constructs correctly
# - Last assignment wins rule

def expr_has_a_reset(expr, resets):
	if expr is None:
		return False;
	if expr.isVariable():
		return expr.variable_name in resets;
	else:
		return any([expr_has_a_reset(c, resets) for c in expr.children]);


def references_any(ast_node, any_of_these):
	return len([n for n in ast_node.scan_values(lambda v: isinstance(v, lark.Token) and v.type == "NAME") if n in any_of_these]) > 0;


TIMED_CONSTRUCTS = resets + clocks;

class Assignment:
	def __init__(self, condition, lhs_expr, rhs_expr, blocking):
		"""
		condition: Expression object for the condition (if applicable)
		lhs_expr: LHSExpression object for the left-hand side
		rhs_expr: Expression object for the right-hand side
		blocking: True if this is a blocking assignment, False if non-blocking
		"""
		self.condition = condition  # Can be None for unconditional assignments
		self.lhs_expr = lhs_expr  # LHSExpression object
		self.rhs_expr = rhs_expr  # Expression object for the right-hand side
		self.blocking = blocking  # True for blocking assignments, False for non-blocking
	
	def is_variable_assignment(self, variable_name, msb=None, lsb=None):
		"""
		Check if this assignment is for the given variable name.
		Optionally check for a specific range (msb, lsb).
		For now, the range is only with constant values.
		"""
		assert (isinstance(msb, Expression) and msb.is_constant()) or msb is None, "MSB must be a constant Expression or None";
		assert (isinstance(lsb, Expression) and lsb.is_constant()) or lsb is None, "LSB must be a constant Expression or None";
		assert (msb is None and lsb is None) or (msb is not None and lsb is not None), "Both MSB and LSB must be provided or both must be None";
		vars_assigned = self.lhs_expr.get_vars_assigned()
		for var, range_value in vars_assigned:
			if var == variable_name:
				if range_value is None:
					return True
				if msb is None and lsb is None:
					return True
				range_msb, range_lsb = range_value
				if range_msb.get_constant() == msb.get_constant() and range_lsb.get_constant() == lsb.get_constant():
					return True
		return False

	def get_variable_names(self):
		"""
		Return a list of variable names assigned in this assignment.
		This is used to identify the variables in the graph.
		"""
		vars_assigned = self.lhs_expr.get_vars_assigned()
		return [var for var, _ in vars_assigned]

	def get_lhs(self):
		"""
		Return the left-hand side expression of this assignment.
		This is used to identify the variable being assigned in the graph.
		"""
		return self.lhs_expr
	
	def get_rhs(self):
		"""
		Return the right-hand side expression of this assignment.
		This is used to identify the value being assigned in the graph.
		"""
		return self.rhs_expr

	def get_blocking(self):
		"""
		Return whether this is a blocking assignment.
		This is used to determine the type of assignment in the graph.
		"""
		return self.blocking

	def set_condition(self, condition):
		"""
		Set the condition for this assignment.
		This is used to add a condition to the assignment in the graph.
		"""
		assert isinstance(condition, Expression) or condition is None, "Condition must be an Expression or None";
		self.condition = condition

	def get_condition(self):
		"""
		Return the condition of this assignment.
		This is used to identify the condition in the graph.
		"""
		return self.condition

	def __repr__(self, level=0):
		"""
		Return a string representation of the Assignment object.
		This is used for debugging and logging purposes.
		"""
		str = f"Assignment: ";
		pred = "\n" + "  " * (level + 1);
		if self.condition is not None:
			str += pred + f"condition= {self.condition._to_str(level + 1)}"
		else:
			str += pred + "condition= None"
		if self.lhs_expr is not None:
			str += pred + f"lhs_expr= {self.lhs_expr._to_str(level + 1)}"
		if self.rhs_expr is not None:
			str += pred + f"rhs_expr= {self.rhs_expr._to_str(level + 1)}"
		str += pred + f"blocking= {self.blocking!r}"
		return str

class Argument:
	def __init__(self, name, expression):
		"""
		name: Name of the argument
		expression: Expression object for the argument value
		"""
		self.name = name
		self.expression = expression  # Expression object for the argument value

	@staticmethod
	def from_tree(tree):
		"""
		Parse an argument subtree and return an Argument object.
		Assumes the rule: NAME "=" expression
		"""
		if tree.data == "named_argument":
			assert len(tree.children) == 2, f"Expected 2 children in named_argument, got {len(tree.children)}: {tree.pretty()}"
			name = str(tree.children[0])
			expression = Expression.from_tree(tree.children[1])
		elif tree.data == "positional_argument":
			assert len(tree.children) == 1, f"Expected 1 child in positional_argument, got {len(tree.children)}: {tree.pretty()}"
			name = None
			expression = Expression.from_tree(tree.children[0])
		else:
			raise ValueError(f"Unsupported argument type: {tree.data}")
		return Argument(name, expression)

	def get_name(self):
		"""
		Return the name of the argument.
		This is used to identify the argument in the graph.
		"""
		return self.name

	def get_expression(self):
		"""
		Return the expression for the argument value.
		This is used to identify the value assigned to the argument in the graph.
		"""
		assert self.expression is not None, "Argument must have an expression";
		assert self.expression.is_variable() or self.expression.is_constant(), "Argument expression must be a variable or constant";
		if self.expression.is_variable():
			return self.expression.get_variable()
		elif self.expression.is_constant():
			return self.expression.get_constant()

	def __repr__(self, level=0):
		"""
		Return a string representation of the Argument object.
		This is used for debugging and logging purposes.
		"""
		str = f"Argument: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"name= {self.name!r}"
		if self.expression is not None:
			str += pred + f"expression= {self.expression._to_str(level + 1)}"
		else:
			str += pred + "expression= None"
		return str

class ModuleInstantiation:
	def __init__(self, name, generics=None, ports=None):
		"""
		name: Name of the module instantiation
		generics: List of Argument objects for generics (optional)
		ports: List of Argument objects for ports (optional)
		"""
		self.name = name
		self.generics = generics if generics is not None else []
		self.ports = ports if ports is not None else []

	@staticmethod
	def from_tree(tree):
		"""
		Parse a module subtree and return a Module object.
		Assumes the rule: "module" NAME (port_list)? (declaration_list)? (statement_list)?
		"""
		assert tree.data == 'module_instantiation', f"Expected module, got {tree.data}";
		children_data = [child.value if isinstance(child, lark.Token) else child for child in tree.children];
		assert len(children_data) in [4], f"Expected 4 children in module_instantiation, got {len(children_data)}: {tree.pretty()}";

		name, generics, name_inst, port_list = children_data

		_generics = []
		_ports = []
		if generics is not None:
			for gen in generics.children:
				assert isinstance(gen, lark.Tree), f"Expected generic to be a Tree, got {type(gen)}: {gen.pretty()}"
				generic = Argument.from_tree(gen)
				_generics.append(generic)
		if port_list is not None:
			for port in port_list.children:
				assert isinstance(port, lark.Tree), f"Expected port to be a Tree, got {type(port)}: {port.pretty()}"
				_ports.append(Argument.from_tree(port))
		return ModuleInstantiation(name, _generics, _ports)

	def get_name(self):
		"""
		Return the name of the module instantiation.
		This is used to identify the module in the graph.
		"""
		return self.name

	def get_ports(self):
		"""
		Return a list of Argument objects for the ports in this module instantiation.
		This is used to identify the ports in the graph.
		"""
		return self.ports

	def get_ports_names(self):
		"""
		Return a list of port names in this module instantiation.
		This is used to identify the ports in the graph.
		"""
		return [port.get_name() for port in self.ports]

	def get_port_expression(self, port_name):
		"""
		Return the expression for the given port name.
		This is used to identify the value assigned to the port in the graph.
		"""
		for port in self.ports:
			if port.get_name() == port_name:
				return port.get_expression()
		return None

	def __repr__(self, level=0):
		"""
		Return a string representation of the ModuleInstantiation object.
		This is used for debugging and logging purposes.
		"""
		str = f"ModuleInstantiation: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"name= {self.name!r}"
		if self.generics:
			str += pred + f"generics= {[g.name for g in self.generics]}"
		else:
			str += pred + "generics= None"
		if self.ports:
			str += pred + f"ports= {[p.name for p in self.ports]}"
		else:
			str += pred + "ports= None"
		return str

class LHSExpression:
	def __init__(self, variables=None, index=None, range_=None):
		"""
		variables: base name of the variable (e.g. 'a', 'b', 'c')
		index: index expression for array access (e.g. 'a[0]', 'b[i]')
		range_: tuple for range selection (e.g. (7,0))
		"""
		self.variables = variables 
		self.index = index  # This is an Expression object
		self.range_ = range_

	@staticmethod
	def from_tree(tree):
		"""
		Parse an lhs_expression subtree and return an LHSExpression object.
		Handles simple identifiers, bit selects, part selects, and concatenations.
		"""
		assert tree.data == 'lhs_expression', f"Expected lhs_expression, got {tree.data}";

		variables = None
		index = None
		range_ = None

		# Most simple lhs_expression: variable or variable[expr] or variable[msb:lsb]
		for child in tree.children:
			if isinstance(child, str):
				variables.append(child)  # variable as string
			elif hasattr(child, 'data'):
				if child.data == 'variable':
					variables = [str(child.children[0])]  # variable as string
				elif child.data == 'array_concat' or child.data == 'array_replicate':
					variables = [Expression.from_tree(c) for c in child.children]
				elif child.data == 'array_index':
					# e.g. variable[expr]
					variables = [Expression.from_tree(child.children[0])]
					index = Expression.from_tree(child.children[1])
				elif child.data == 'array_slice':
					# e.g. [msb:lsb]
					variables = [Expression.from_tree(child.children[0])]
					msb = Expression.from_tree(child.children[1])
					lsb = Expression.from_tree(child.children[2])
					range_ = (msb, lsb)
				else:
					raise ValueError(f"Unsupported child in lhs_expression: {child.data}")
		return LHSExpression(variables, index, range_)

	def get_vars_assigned(self):
		"""
		Return a list of pairs of variable names and an array index if applicable.
		"""
		assert len(self.variables) > 0, "LHSExpression must have at least one variable";
		range_value = None
		if self.range_ is not None:
			range_value = (self.range_[0].get_constant(), self.range_[1].get_constant())
		if self.index is not None:
			range_value = (self.index.get_constant(), self.index.get_constant())
		if range_value is not None:
			assert len(self.variables) == 1, "LHSExpression with index or range must have exactly one variable";
		return [(v.get_variable() if not(type(v) is str) else v, range_value) for v in self.variables]

	def get_vars_assigned_expressions(self):
		"""
		Return a list of pairs of variable names and an array index if applicable.
		This is used to identify the variables assigned in the LHSExpression.
		"""
		assert len(self.variables) > 0, "LHSExpression must have at least one variable";
		range_value = None
		if self.range_ is not None:
			range_value = (self.range_[0], self.range_[1])
		if self.index is not None:
			range_value = (self.index, self.index)
		if range_value is not None:
			assert len(self.variables) == 1, "LHSExpression with index or range must have exactly one variable";
		return [(v if (isinstance(v, Expression) or isinstance(v, LHSExpression)) else Expression.from_tree(lark.Tree("string", [v])), range_value) for v in self.variables]

	def get_variable(self):
		"""
		Return the first variable in the LHSExpression.
		This is used to identify the variable in the graph.
		"""
		assert len(self.variables) > 0, "LHSExpression must have at least one variable";
		assert len(self.variables) == 1, "We assume that LHSExpression has exactly one variable";
		return self.variables[0]

	def get_variable_name(self):
		"""
		Return the base name of the first variable in the LHSExpression.
		This is used to identify the variable in the graph.
		"""
		variable = self.get_variable()
		if isinstance(variable, str):
			return variable
		elif isinstance(variable, LHSExpression):
			return variable.get_variable_name()
		elif isinstance(variable, Expression):
			return variable.get_variable()
		else:
			raise ValueError(f"Unsupported variable type in LHSExpression: {type(variable)}");

	def get_names(self):
		"""
		Return the base name of the LHSExpression.
		This is used to identify the variable in the graph.
		"""
		names = []
		for v in self.variables:
			if isinstance(v, str):
				names.append(v)
			elif isinstance(v, Expression):
				names.extend(v.get_names())
		return names
	
	def get_bitwidth(self, variables_definition):
		"""
		Return the bit width of the LHSExpression.
		This is used to identify the bit width in the graph.
		"""
		if self.index is not None:
			return 1
		elif self.range_ is not None:
			msb, lsb = self.range_
			assert msb.is_constant() and lsb.is_constant(), "MSB and LSB must be constant expressions";
			msb_value = int(msb.get_constant())
			lsb_value = int(lsb.get_constant())
			return msb_value - lsb_value + 1
		else:
			total_bitwidth = 0
			for v in self.variables:
				if isinstance(v, str):
					v_name = v
				elif isinstance(v, Expression):
					total_bitwidth += v.get_bitwidth(variables_definition)
					continue  
				else:
					raise ValueError(f"Unsupported variable type in LHSExpression: {type(v)}");
				assert v_name in variables_definition, f"Variable '{v_name}' not found in variables_definition";
				total_bitwidth += variables_definition[v_name].get_bitwidth()
			return total_bitwidth

	def is_slice(self):
		"""
		Check if this LHSExpression is a slice (i.e. has a range).
		This is used to identify slices in the graph.
		"""
		is_slice = self.range_ is not None or self.index is not None
		if is_slice:
			assert len(self.variables) == 1, "LHSExpression with index or range must have exactly one variable";
		return is_slice
	
	def get_slice_range(self):
		"""
		Return the slice of this LHSExpression if it is a slice.
		This is used to identify the slice in the graph.
		"""
		assert self.is_slice(), "LHSExpression is not a slice";
		if self.range_ is not None:
			msb, lsb = self.range_
			assert msb.is_constant() and lsb.is_constant(), "MSB and LSB must be constant expressions";
			return (int(msb.get_constant()), int(lsb.get_constant()))
		elif self.index is not None:
			assert self.index.is_constant(), "Index must be a constant expression";
			return (int(self.index.get_constant()), int(self.index.get_constant()))
		else:
			raise ValueError("LHSExpression is not a slice");

	def references_any(self, any_of_these):
		"""
		Check if this LHSExpression references any of the given names.
		This is used to check if the LHSExpression is related to a specific variable.
		"""
		for v in self.variables:
			if isinstance(v, str):
				if v in any_of_these:
					return True
			elif isinstance(v, Expression):
				if v.references_any(any_of_these):
					return True
		return False

	def get_unique_id(self):
		"""
		Return a unique identifier for this LHSExpression using its variables and index/range.
		This is used to uniquely identify the LHSExpression in the graph.
		"""
		components = []
		if self.variables:
			components.append(f"{self.variables}")
		if self.index is not None:
			components.append(f"{self.index.get_unique_id()}")
		if self.range_ is not None:
			msb, lsb = self.range_
			components.append(f"{msb.get_unique_id()}:{lsb.get_unique_id()}")
		if components != []:
			return "".join(components)
		else:
			return ""

	def _to_str(self, level=0):
		"""
		Convert the LHSExpression to a string representation.
		Handles indices and ranges.
		"""
		_str = f"LHSExpression: ";
		pred = "\n" + "  " * (level + 1);
		if self.variables is not None:
			_str += pred + f"variables= "
			for var in self.variables:
				if isinstance(var, str):
					_str += f"{var!r} "
				else:
					_str += f"{var._to_str(level + 1)} "
		if self.index is not None:
			_str += pred + f"index= {self.index._to_str(level + 1)}"
		if self.range_ is not None:
			_str += pred + f"range= "
			_str += f"MSB: {self.range_[0]._to_str(level + 1)}"
			_str += f"LSB: {self.range_[1]._to_str(level + 1)}"
		return _str

	def __repr__(self):
		return self._to_str()

class Expression:
	def __init__(self, expr_type, constant=None, variable=None, condition=None, lhs_expr=None, rhs_expr=None):
		"""
		expr_type: type of the expression (e.g. 'binary', 'unary', 'conditional', etc.)
		constant: if this is a constant expression, its value
		variable: if this is a variable reference, its name
		condition: condition for conditional expressions (if applicable)
		lhs_expr: LHSExpression for left-hand side (if applicable)
		rhs_expr: LHSExpression for right-hand side (if applicable)
		children: list of child expressions (for binary, unary, etc.)
		"""
		self.expr_type = expr_type
		self.constant = constant
		self.variable = variable  # For variable references
		self.condition = condition  # For conditional expressions
		self.lhs_expr = lhs_expr  
		self.rhs_expr = rhs_expr  

	@staticmethod
	def from_tree(tree):
		"""
		Parse an expression subtree and return an Expression object.
		Handles binary, unary, conditional, and constant expressions.
		"""
		expr_type = tree.data
		constant = None
		variable = None
		condition = None
		lhs_expr = None
		rhs_expr = None

		if tree.data == 'lhs_expression':
			# If it's a lhs_expression, we can treat it as a variable reference
			lhs_expr = LHSExpression.from_tree(tree)
		elif tree.data in ["extended_based_number", "regular_number", "based_number", "macro_usage"]:
			# If it's a constant expression, we can treat it as a constant value
			constant = str(tree.children[0]) if tree.children else None
		elif tree.data == 'string':
			# If it's a string, it's probably a variable
			variable = str(tree.children[0]) if tree.children else None
		elif tree.data == 'function_call':
			function_name = str(tree.children[0])
			if function_name == operations[VerilogOperation.FUNCTION_SIGNED]:
				# If it's a signed function call, we can treat it as a unary operation
				assert len(tree.children) == 2, f"Expected 2 children in signed function call, got {len(tree.children)}: {tree.pretty()}"
				lhs_expr = Expression.from_tree(tree.children[1])
				return Expression(VerilogOperation.FUNCTION_SIGNED, lhs_expr=lhs_expr)
			elif function_name == operations[VerilogOperation.FUNCTION_UNSIGNED]:
				# If it's an unsigned function call, we can treat it as a unary operation
				assert len(tree.children) == 2, f"Expected 2 children in unsigned function call, got {len(tree.children)}: {tree.pretty()}"
				lhs_expr = Expression.from_tree(tree.children[1])
				return Expression(VerilogOperation.FUNCTION_UNSIGNED, lhs_expr=lhs_expr)
			else:
				raise NotImplementedError(f"Function calls are not yet supported in expressions ({function_name} unsupported)");
		else:
			expr_type = None
			for op_type, symbol in operations.items():
				if tree.data == op_type.value:
					expr_type = op_type
					if op_type in binary:
						# Binary expression: lhs_expr op rhs_expr
						assert len(tree.children) == 2, f"Expected 2 children in binary expression, got {len(tree.children)}: {tree.pretty()}"
						lhs_expr = Expression.from_tree(tree.children[0])
						rhs_expr = Expression.from_tree(tree.children[1])
					elif op_type in unary:
						# Unary expression: op lhs_expr
						assert len(tree.children) == 1, f"Expected 1 child in unary expression, got {len(tree.children)}: {tree.pretty()}"
						lhs_expr = Expression.from_tree(tree.children[0])
					elif op_type == VerilogOperation.CONDITIONAL_EXPRESSION:
						# Conditional expression: condition ? true_expr : false_expr
						assert len(tree.children) == 3, f"Expected 3 children in conditional_expression, got {len(tree.children)}: {tree.pretty()}"
						condition = Expression.from_tree(tree.children[0])
						lhs_expr = Expression.from_tree(tree.children[1])
						rhs_expr = Expression.from_tree(tree.children[2])
					elif op_type in [VerilogOperation.ARRAY_CONCAT, VerilogOperation.ARRAY_REPLICATE, VerilogOperation.ARRAY_SLICE, VerilogOperation.ARRAY_INDEX]:
						# Array operations: e.g. {a, b, c}, {n{a}}, a[0:7], a[0]
						# This is warkaround for lark not correctly identifying lhs_expression
						new_tree = lark.Tree("lhs_expression", [tree])
						lhs_expr = LHSExpression.from_tree(new_tree) 
					else:
						raise ValueError(f"Unsupported expression type: {tree.data} for operation {op_type.value}")

			assert expr_type is not None, f"Unsupported expression type: {tree.data}";

		return Expression(expr_type, constant, variable, condition, lhs_expr, rhs_expr)

	@staticmethod
	def and_expr(lhs_expr, rhs_expr):
		"""
		Create a binary AND expression.
		This is used to combine two expressions with a logical AND.
	 	"""
		assert lhs_expr is not None, "Left-hand side expression cannot be None for AND operation"
		assert isinstance(lhs_expr, Expression), "Left-hand side expression must be an Expression object for AND operation"
		assert rhs_expr is not None, "Right-hand side expression cannot be None for AND operation"
		assert isinstance(rhs_expr, Expression), "Right-hand side expression must be an Expression object for AND operation"
		return Expression(VerilogOperation.BINARY_AND, lhs_expr=lhs_expr, rhs_expr=rhs_expr)

	@staticmethod
	def not_expr(expr):
		"""
		Create a unary NOT expression.
		This is used to negate an expression.
		"""
		assert expr is not None, "Expression cannot be None for NOT operation"
		assert isinstance(expr, Expression), "Expression must be an Expression object for NOT operation"
		return Expression(VerilogOperation.UNARY_NOT, lhs_expr=expr)

	@staticmethod
	def eq_expr(lhs_expr, rhs_expr):
		"""
		Create a binary equality expression.
		This is used to compare two expressions for equality.
		"""
		assert lhs_expr is not None, "Left-hand side expression cannot be None for equality operation"
		assert isinstance(lhs_expr, Expression) or isinstance(lhs_expr, LHSExpression), "Left-hand side expression must be an Expression or LHSExpression object for equality operation"
		assert rhs_expr is not None, "Right-hand side expression cannot be None for equality operation"
		assert isinstance(rhs_expr, Expression), "Right-hand side expression must be an Expression object for equality operation"
		return Expression(VerilogOperation.BINARY_EQ, lhs_expr=lhs_expr, rhs_expr=rhs_expr)

	@staticmethod
	def concat_expr(expressions):
		"""
		Create an array concatenation expression.
		This is used to concatenate multiple expressions into an array.
		"""
		assert isinstance(expressions, list), "Expressions must be a list for concatenation"
		assert all((isinstance(expr, LHSExpression) or isinstance(expr, Expression)) for expr in expressions), "All expressions must be LHSExpression or Expression objects for concatenation"
		return Expression(VerilogOperation.ARRAY_CONCAT, lhs_expr=LHSExpression(variables=expressions))

	@staticmethod
	def slice_expr(variable, msb, lsb):
		"""
		Create an array slice expression.
		This is used to select a range of bits from a variable.
		"""
		# Check which instance it is the variable print it
		assert variable is not None, "Variable cannot be None for slice operation"
		assert isinstance(variable, LHSExpression) or isinstance(variable, Expression), "Variable must be an LHSExpression or Expression object for slice operation"
		assert msb is not None, "MSB cannot be None for slice operation"
		assert isinstance(msb, int) or (isinstance(msb, Expression) and msb.is_constant()), "MSB must be an integer or constant Expression for slice operation"
		assert lsb is not None, "LSB cannot be None for slice operation"
		assert isinstance(lsb, int) or (isinstance(lsb, Expression) and lsb.is_constant()), "LSB must be an integer or constant Expression for slice operation"
		if isinstance(msb, int):
			msb = Expression("regular_number", constant=str(msb))
		if isinstance(lsb, int):
			lsb = Expression("regular_number", constant=str(lsb))
		return Expression(VerilogOperation.ARRAY_SLICE, lhs_expr=LHSExpression(variables=[variable], range_=(msb, lsb)))

	@staticmethod
	def constant_expr(value, bitwidth=None):
		"""
		Create a constant expression.
		This is used to represent a constant value in the expression graph.
		"""
		assert value is not None, "Value cannot be None for constant expression"
		assert isinstance(value, int), "Value must be an integer for constant expression"
		if bitwidth == None:
			bitwidth = max(1, value.bit_length())
		assert isinstance(bitwidth, int) and bitwidth > 0, "Bitwidth must be a positive integer for constant expression"
		# Assert the bitwidth is enough to represent the value
		assert value >= 0 and value < (1 << bitwidth), f"Value {value} cannot be represented with {bitwidth} bits"
		# Return the bitwidth'dvalue format
		return Expression("based_number", constant=f"{bitwidth}'d{value}")

	def compute_constant_value(self):
		"""
		Compute the value of this expression if it is a constant or a funtion depending only on constants.
		This is used to evaluate constant expressions in the graph.
		"""
		if self.is_constant() and self.get_constant() in macros:
			# If this is a macro usage, we can compute its value
			macro_value = macros[self.get_constant()]
			if isinstance(macro_value, Expression):
				return macro_value.compute_constant_value()
			else:
				raise ValueError(f"Unsupported macro value type: {type(macro_value)} for macro {self.get_variable()}")
		elif self.is_constant():
			return int(self.get_constant())
		elif self.expr_type in [VerilogOperation.BINARY_ADD, VerilogOperation.BINARY_SUB, VerilogOperation.BINARY_MUL, VerilogOperation.BINARY_DIV, VerilogOperation.BINARY_MOD]:
			lhs_value = self.lhs_expr.compute_constant_value() if self.lhs_expr else None
			rhs_value = self.rhs_expr.compute_constant_value() if self.rhs_expr else None
			if lhs_value is not None and rhs_value is not None:
				if self.expr_type == VerilogOperation.BINARY_ADD:
					return lhs_value + rhs_value
				elif self.expr_type == VerilogOperation.BINARY_SUB:
					return lhs_value - rhs_value
				elif self.expr_type == VerilogOperation.BINARY_MUL:
					return lhs_value * rhs_value
				elif self.expr_type == VerilogOperation.BINARY_DIV:
					return lhs_value / rhs_value
				elif self.expr_type == VerilogOperation.BINARY_MOD:
					return lhs_value % rhs_value
			else:
				raise ValueError(f"Cannot compute value for binary operation {self.expr_type} with lhs_value={lhs_value} and rhs_value={rhs_value}")
		else:
			raise NotImplementedError(f"Cannot compute value for expression type: {self.expr_type}")
		assert False, f"Expression type {self.expr_type} is not supported for constant value computation"

	def is_constant(self):
		"""
		Check if this expression is a constant.
		This is used to identify constant expressions in the graph.
		"""
		return self.expr_type in ["extended_based_number", "regular_number", "based_number", "macro_usage"] and self.constant is not None
	
	def get_constant(self):
		"""
		Return the constant value of this expression.
		This is used to identify constant values in the graph.
		"""
		assert self.is_constant(), "This expression is not a constant"
		return self.constant

	def is_variable(self):
		"""
		Check if this expression is a variable reference.
		This is used to identify variable references in the graph.
		"""
		return (self.expr_type == "string" and self.variable is not None) or (self.expr_type == "lhs_expression" and self.lhs_expr is not None)

	def get_variable(self):
		"""
		Return the variable name of this expression.
		This is used to identify variable names in the graph.
		"""
		assert self.is_variable(), "This expression is not a variable reference"
		if self.lhs_expr is not None:
			assert len(self.lhs_expr.get_names()) == 1, f"We assume that lhs_expression has exactly one name, got {len(self.lhs_expr.get_names())}: {self.lhs_expr.get_names()}"
		return self.variable if self.variable is not None else self.lhs_expr.get_names()[0]

	def is_type(self, expr_type):
		"""
		Check if this expression is of the given type.
		This is used to identify specific types of expressions in the graph.
		"""
		return self.expr_type == expr_type

	def get_type(self):
		"""
		Return the type of this expression.
		This is used to identify the type of expression in the graph.
		"""
		return self.expr_type

	def get_condition(self):
		"""
		Return the condition of this expression if it is a conditional expression.
		This is used to identify the condition in the graph.
		"""
		return self.condition
	
	def get_lhs_expr(self):
		"""
		Return the left-hand side expression of this expression.
		This is used to identify the left-hand side in the graph.
		"""
		return self.lhs_expr

	def get_rhs_expr(self):
		"""
		Return the right-hand side expression of this expression.
		This is used to identify the right-hand side in the graph.
		"""
		return self.rhs_expr


	def get_bitwidth(self, variables_definition):
		"""
		Return the bitwidth of this expression if it is a constant or variable.
		This is used to identify the bitwidth in the graph.
		"""
		if self.expr_type in binary_logical or self.expr_type in unary_1bit:
			return 1;  # Logical operations are always 1 bit wide
		elif self.expr_type in operations or self.expr_type in "lhs_expression":
			# For binary and unary operations, we need to check the bitwidth of the operands
			assert self.lhs_expr is not None, "Expression must have a left-hand side expression"
			if self.expr_type in unary or self.expr_type in ["lhs_expression"]:
				return self.lhs_expr.get_bitwidth(variables_definition)
			if self.expr_type == VerilogOperation.ARRAY_INDEX:
				# Array index returns 1 bit
				return 1
			if self.expr_type == VerilogOperation.ARRAY_SLICE:
				# Array slice returns the bitwidth of the slice
				msb, lsb = self.lhs_expr.get_slice_range()
				return msb - lsb + 1
			if self.expr_type == VerilogOperation.ARRAY_CONCAT:
				# Array concatenation returns the sum of the bitwidths of the concatenated expressions
				bitwidth = 0
				for v in self.lhs_expr.variables:
					bitwidth += v.get_bitwidth(variables_definition)
				return bitwidth
			if self.expr_type == VerilogOperation.ARRAY_REPLICATE:
				# Array replication returns the bitwidth of the replicated expression times the replication count
				assert len(self.lhs_expr.variables) == 2, "Array replication must have exactly two variables: count and expression"
				count_expr = self.lhs_expr.variables[0]
				replicated_expr = self.lhs_expr.variables[1]
				assert count_expr.is_constant(), "Array replication count must be a constant expression"
				count = int(count_expr.get_constant())
				bitwidth = count * replicated_expr.get_bitwidth(variables_definition)
				return bitwidth
			# For binary operations, we need to check both sides to check if they are constants or variables
			if self.lhs_expr.is_constant():
				return self.rhs_expr.get_bitwidth(variables_definition)
			return self.lhs_expr.get_bitwidth(variables_definition)

		elif self.expr_type == "string":
			assert self.variable in variables_definition, f"Variable '{self.variable}' not found in variables_definition";
			return variables_definition[self.variable].get_bitwidth()
		elif self.expr_type == "extended_based_number":
			# Extended based numbers are structured as follows: /([0-9]*)'[bdhoBDHO][0-9a-fA-F_xXzZ]+/
			# We can extract the bitwidth from the constant value
			assert self.constant is not None, "Extended based number must have a constant value"
			# The bitwidth is the number before the apostrophe
			bitwidth_str = int(self.constant.split("'")[0])
			assert bitwidth_str > 0, f"Bitwidth must be greater than 0, got {bitwidth_str}"
			return bitwidth_str
		elif self.expr_type in ["regular_number", "based_number"]:
			# Regular and based numbers are structured as follows: [0-9a-fA-F_xXzZ]+
			# We can extract the bitwidth from the constant value
			assert self.constant is not None, "Regular or based number must have a constant value"
			# We assume for now a constant value of 32
			return 32
		else:
			raise ValueError(f"Unsupported expression type for bitwidth calculation: {self.expr_type}")

	def get_names(self):
		"""
		Return the variable names referenced in this expression.
		This is used to identify the variables in the graph.
		"""
		names = []
		if self.variable is not None:
			names.append(self.variable)
		if self.lhs_expr is not None:
			names.extend(self.lhs_expr.get_names())
		if self.rhs_expr is not None:
			names.extend(self.rhs_expr.get_names())
		return names

	def references_any(self, any_of_these):
		"""
		Check if this expression references any of the given names.
		This is used to check if the expression is related to a specific variable.
		"""
		if self.variable is not None and self.variable in any_of_these:
			return True
		if self.lhs_expr is not None and self.lhs_expr.references_any(any_of_these):
			return True
		if self.rhs_expr is not None and self.rhs_expr.references_any(any_of_these):
			return True
		return False

	def get_unique_id(self):
		"""
		Return a unique identifier for this expression using all its components.
		This is used to uniquely identify the expression in the graph.
		"""
		components = [ operations[self.expr_type] if self.expr_type in operations else "" ] 
		if self.constant is not None:
			components.append(f"{self.constant}")
		if self.variable is not None:
			components.append(f"{self.variable}")
		if self.condition is not None:
			components.append(f"{self.condition.get_unique_id()}")
		if self.lhs_expr is not None:
			components.append(f"{self.lhs_expr.get_unique_id()}")
		if self.rhs_expr is not None:
			components.append(f"{self.rhs_expr.get_unique_id()}")
		return "".join(components)

	def _to_str(self, level=0):
		"""
		Convert the Expression to a string representation.
		Handles binary, unary, conditional, and constant expressions.
		"""
		str =  f"Expression: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"expr_type= {self.expr_type!r}"
		if self.constant is not None:
			str += pred + f"constant= {self.constant!r}"
		if self.variable is not None:
			str += pred + f"variable= {self.variable!r}"
		if self.condition is not None:
			str += pred + f"condition= {self.condition!r}"
		if self.lhs_expr is not None:
			str += pred + f"lhs_expr= {self.lhs_expr._to_str(level + 1)}"
		if self.rhs_expr is not None:
			str += pred + f"rhs_expr= {self.rhs_expr._to_str(level + 1)}"
		return str


	def __repr__(self):
		return self._to_str()

class Port:
	def __init__(self, name, direction=None, ptype=None, signedness=None, width=None, lhs_expr=None):
		self.name = name
		self.direction = direction	# 'input', 'output', 'inout', or None
		self.ptype = ptype			# 'wire', 'reg', or None
		self.signedness = signedness  # 'signed', 'unsigned', or None
		self.width = width			# (msb, lsb) tuple or None
		self.lhs_expr = lhs_expr    # LHSExpression object or None

	@staticmethod
	def from_tree(tree):
		"""
		Parse a port_definition subtree and return a Port object.
		Assumes the rule: [port_direction] [port_type] [signedness] [port_range] lhs_expression
		"""
		assert tree.data == 'port_definition', f"Expected port_definition, got {tree.data}";
		direction = None
		ptype = None
		signedness = None
		width = None
		name = None
		lhs_expr = None

		child_data = [child.data if hasattr(child, 'data') else None for child in tree.children];
		assert len(child_data) in [4, 5], f"Expected 4 or 5 children in port_definition, got {len(child_data)}: {tree.pretty()}";
		if len(child_data) == 4:
			[direction, ptype, port_range, lhs_expr] = child_data
		else:
			[direction, ptype, signedness, port_range, lhs_expr] = child_data
		
		lhs_expr = tree.children[-1] 
		port_range = tree.children[-2]

		assert type(lhs_expr) is lark.Tree, f"Expected lhs_expression to be a Tree, got {type(lhs_expr)}: {lhs_expr.pretty()}"
		assert type(port_range) is lark.Tree or port_range is None, f"Expected port_range to be a Tree or None, got {type(port_range)}: {port_range.pretty()}"

		lhs_expr = LHSExpression.from_tree(lhs_expr)
		lhs_expr_names = lhs_expr.get_names()  # Get name from LHSExpression
		assert len(lhs_expr_names) == 1, f"Expected exactly one name in lhs_expression, got {len(lhs_expr_names)}: {lhs_expr_names}"
		name = lhs_expr_names[0]  # Use the name from LHSExpression

		if port_range is not None:
			nums = []
			for tok in port_range.children:
				if tok.data == 'regular_number':
					nums.append(int(tok.children[0]))
				else:
					raise ValueError(f"Unexpected token in port_range: {tok.pretty()}")
			assert len(nums) == 2, f"Expected 2 numbers in port_range, got {len(nums)}: {nums}"
			width = (nums[0], nums[1])

		return Port(name, direction, ptype, signedness, width, lhs_expr)

	@staticmethod
	def from_declaration(declaration):
		"""
		Create a Port object from a Declaration object.
		This is used to convert a declaration to a port definition.
		"""
		assert isinstance(declaration, Declaration), "Expected Declaration object"
		ports = []
		for name in declaration.get_names():
			ports.append(Port(name, declaration.direction, declaration.dtype, declaration.signedness, declaration.width, name))
		return ports
	
	def get_bitwidth(self):
		"""
		Return bitwidth of the declared variable.
		"""
		if self.width is not None:
			return int(self.width[0]) - int(self.width[1]) + 1
		else:
			return 1

	def is_signed(self):
		"""
		Check if this port is signed.
		"""
		return self.signedness == 'signed'

	def get_name(self):
		"""
		Return the name of the port.
		This is used to identify the port in the graph.
		"""
		return self.name

	def _to_str(self, level=0):
		"""
		Convert the Port to a string representation.
		Handles direction, type, signedness, width, and name.
		"""
		str = f"Port: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"name= {self.name!r}"
		if self.direction is not None:
			str += pred + f"direction= {self.direction!r}"
		if self.ptype is not None:
			str += pred + f"ptype= {self.ptype!r}"
		if self.signedness is not None:
			str += pred + f"signedness= {self.signedness!r}"
		if self.width is not None:
			str += pred + f"width= {self.width!r}"
		return str

	def __repr__(self):
		return self._to_str()

class Declaration:
	def __init__(self, variable_list, names, direction=None, dtype=None, signedness=None, width=None, expression=None):
		"""
		variable_list: list of LHSExpression objects for the variables declared
		names: list of variable names declared
		direction: 'input', 'output', 'inout', or None
		dtype: 'wire', 'reg', etc., or None
		signedness: 'signed', 'unsigned', or None
		width: (msb, lsb) tuple or None
		expression: initial value expression as a string or LHSExpression, or None
		"""
		self.variable_list = variable_list  # List of LHSExpression objects
		self.names = names
		self.direction = direction
		self.dtype = dtype
		self.signedness = signedness
		self.width = width
		self.expression = expression  # Can be a string or LHSExpression

	@staticmethod
	def from_tree(tree):
		"""
		Parse a declaration subtree and return a Declaration object.
		"""
		assert tree.data == 'declaration', f"Expected declaration, got {tree.data}";
		direction = None
		dtype = None
		signedness = None
		width = None
		names = []
		variables = []
		expression = None
		
		child_data = [child.data if hasattr(child, 'data') else None for child in tree.children ];
		assert len(child_data) in [5, 6], f"Expected 5 or 6 children in declaration, got {len(child_data)}: {tree.pretty()}";

		if len(child_data) == 5:
			[direction, dtype, port_range, variable_list, expression] = child_data
		else:
			[direction, dtype, signedness, port_range, variable_list, expression] = child_data

		port_range = tree.children[-3]
		variable_list = tree.children[-2]
		expression = tree.children[-1] 

		assert type(port_range) is lark.Tree or port_range is None, f"Expected port_range to be a Tree or None, got {type(port_range)}: {port_range.pretty()}"
		assert type(variable_list) is lark.Tree, f"Expected variable_list to be a Tree, got {type(variable_list)}: {variable_list.pretty()}"
		assert type(expression) is lark.Tree or expression is None , f"Expected expression to be a Tree or None, got {type(expression)}: {expression.pretty()}"

		if port_range is not None:
			nums = []
			for tok in port_range.children:
				range_expr = Expression.from_tree(tok)
				value = range_expr.compute_constant_value()  # Ensure the expression is evaluated
				assert value is not None, f"Expected a valid port range value, got {value}: {tok.pretty()}"
				nums.append(int(value))
			assert len(nums) == 2, f"Expected 2 numbers in port_range, got {len(nums)}: {nums}"
			width = (nums[0], nums[1])

		if variable_list is not None:
			# variable_list: (variable ("," variable)*) 
			for v in variable_list.children:
				lhs_expr = LHSExpression.from_tree(v)
				lhs_expr_names = lhs_expr.get_names()  # Get name from LHSExpression
				assert len(lhs_expr_names) == 1, f"Expected exactly one name in lhs_expression, got {len(lhs_expr_names)}: {lhs_expr_names}"
				names.append(lhs_expr_names[0])  # Use the name from LHSExpression
				variables.append(lhs_expr)

		if expression is not None:
			expression = Expression.from_tree(expression)

		return Declaration(variables, names, direction, dtype, signedness, width, expression)

	def is_signed(self):
		"""
		Check if this declaration is signed.
		"""
		return self.signedness == 'signed'

	def _get_assignments(self):
		"""
		Return the list of assignments in this declaration.
		This is used to identify the variables in the graph.
		"""
		assignments = []
		if self.expression is not None:
			# If there is an initial expression, create an assignment for it
			for lhs_expr in self.variable_list:
				assign = Assignment(None, lhs_expr, self.expression, True)
				assignments.append(assign)
		return assignments

	def get_assignments(self, condition=None):
		"""
		Return the list of assignments in this declaration.
		This is used to identify the variables in the graph.
		"""
		assignments = []
		if self.expression is not None:
			# If there is an initial expression, create an assignment for it
			for lhs_expr in self.variable_list:
				assign = Assignment(condition, lhs_expr, self.expression, True)
				assignments.append(assign)
		return assignments
	
	def get_bitwidth(self):
		"""
		Return bitwidth of the declared variable.
		"""
		if self.width is not None:
			return int(self.width[0]) - int(self.width[1]) + 1
		else:
			return 1

	def get_names(self):
		"""
		Return the list of variable names declared in this declaration.
		This is used to identify the variables in the graph.
		"""
		return self.names

	def get_direction(self):
		"""
		Return the direction of the port if it is a port declaration.
		This is used to identify the direction in the graph.
		"""
		return self.direction

	def _to_str(self, level=0):
		"""
		Convert the Declaration to a string representation.
		Handles direction, type, signedness, width, names, and expression.
		"""
		str = f"Declaration: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"names= {self.names!r}"
		if self.direction is not None:
			str += pred + f"direction= {self.direction!r}"
		if self.dtype is not None:
			str += pred + f"dtype= {self.dtype!r}"
		if self.signedness is not None:
			str += pred + f"signedness= {self.signedness!r}"
		if self.width is not None:
			str += pred + f"width= {self.width!r}"
		if self.expression is not None:
			str += pred + f"expression= {self.expression!r}"
		return str

	def __repr__(self):
		return self._to_str()

class Statement:
	def __init__(self, statements):
		"""
		statements: list of SingleStatement objects
		"""
		self.statements = statements

	@staticmethod
	def from_tree(tree):
		"""
		Parse a statement subtree and return a Statement object.
		Assumes the rule: statement: single_statement | always_block | module_instantiation
		"""
		assert tree.data == 'statement', f"Expected statement, got {tree.data}";
		for child in tree.children:
			if child.data == "single_statement":
				# single_statement: declaration | assignment | conditional_statement | loop_statement
				return Statement([SingleStatement.from_tree(child)])
			elif child.data == "statement_block":
				# statement_block: "begin" single_statement* "end"
				statements = []
				for single_stmt in child.children:
					if hasattr(single_stmt, 'data'):
						if single_stmt.data == "single_statement":
							new_tree = single_stmt
						else:
							# This is a workaround since lark does not correctly identify single_statement
							new_tree = lark.Tree("single_statement", [single_stmt]);
						statements.append(SingleStatement.from_tree(new_tree))
				return Statement(statements)
			else:
				new_tree = lark.Tree("single_statement", [child]);
				# This is a workaround since lark does not correctly identify single_statement
				return Statement([SingleStatement.from_tree(new_tree)])

	def _get_assignments(self):
		"""
		Return the list of assignments in this statement.
		This is used to identify the assignments in the graph.
		"""
		assignments = []
		for stmt in self.statements:
			assignments.extend(stmt.get_assignments())
		return assignments

	def get_assignments(self, condition=None):
		"""
		Return the list of assignments in this statement.
		This is used to identify the assignments in the graph.
		"""
		assignments = []
		for stmt in self.statements:
			assignments.extend(stmt.get_assignments(condition))
		return assignments

	def _to_str(self, level=0):
		"""
		Convert the Statement to a string representation.
		Handles the list of SingleStatement objects.
		"""
		str = f"Statement: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"statements: ";
		for s in self.statements:
			str += s._to_str(level + 1)
		return str

	def __repr__(self):
		return self._to_str()

class CaseItem:
	def __init__(self, condition, statement):
		"""
		condition: expression or None for default case
		statement: Statement object containing the statements to execute for this case item
		"""
		self.condition = condition  # Can be None for default case
		self.statement = statement

	@staticmethod
	def from_tree(tree):
		"""
		Parse a case_item subtree and return a CaseItem object.
		Assumes the rule: case_item: "default" ":" statement_or_block | expression ":" statement_or_block
		"""
		if tree.data == "default_case":
			# This extra step is due to inconsistencies in lark parsing
			if tree.children[0].data in ["statement_block", "single_statement"]:
				new_tree = lark.Tree("statement", [tree.children[0]])
			else:
				new_tree = tree.children[0]
			return CaseItem(None, Statement.from_tree(new_tree))
		elif tree.data == "regular_case":
			condition = Expression.from_tree(tree.children[0])
			# This extra step is due to inconsistencies in lark parsing
			if tree.children[1].data in ["statement_block", "single_statement"]:
				new_tree = lark.Tree("statement", [tree.children[1]])
			else:
				new_tree = tree.children[1]
			statement = Statement.from_tree(new_tree) 
			return CaseItem(condition, statement)
		else:
			raise ValueError(f"Unsupported case item type: {tree.data}")

	def get_condition(self):
		"""
		Return the condition of this case item.
		This is used to identify the condition in the graph.
		"""
		return self.condition

	def get_statement(self):
		"""
		Return the statement of this case item.
		This is used to identify the statements in the graph.
		"""
		return self.statement

	def _to_str(self, level=0):
		"""
		Convert the CaseItem to a string representation.
		Handles the condition and list of statements.
		"""
		str = f"CaseItem: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"condition= {self.condition._to_str(level+1)!r}"
		str += pred + f"statements= {self.statement._to_str(level+1)!r}"
		return str

	def __repr__(self):
		return self._to_str()

class SingleStatement:
	def __init__(self, assignments=None, conditional_statements=None, declarations=None):
		"""
		assignments: list of (lhs_expr, rhs_expr, blocking) tuples
		conditional_statements: list of conditional statements (if-else)
		declarations: list of Declaration objects
		"""
		self.assignments = assignments or []
		self.conditional_statements = conditional_statements or []
		self.declarations = declarations or []

	@staticmethod
	def from_tree(tree):
		"""
		Parse a single_statement subtree and return a SingleStatement object.
		Assumes the rule: single_statement: declaration | assignment | conditional_statement | loop_statement
		"""
		assert tree.data == 'single_statement', f"Expected single_statement, got {tree.data}";
		assignments = []
		conditional_statements = []
		declarations = []

		for child in tree.children:
			if hasattr(child, 'data'):
				if child.data == "blocking_assignment":
					# blocking_assignment: lhs_expression "=" expression ";"
					lhs_expr = LHSExpression.from_tree(child.children[0]);
					rhs_expr = Expression.from_tree(child.children[1]);
					blocking = True
					assignments.append( (lhs_expr, rhs_expr, blocking) )
				elif child.data == "non_blocking_assignment":
					# non_blocking_assignment: lhs_expression "<=" expression ";"
					# This is a workaround since lark does not correctly identify lhs_expression
					if child.children[0].data != "lhs_expression":
						new_tree = lark.Tree("lhs_expression", [child.children[0]])
					else:
						new_tree = child.children[0]
					lhs_expr = LHSExpression.from_tree(new_tree);
					rhs_expr = Expression.from_tree(child.children[1]);
					blocking = False
					assignments.append( (lhs_expr, rhs_expr, blocking) )
				elif child.data == "declaration":
					# declaration: [port_direction] [port_type] [signedness] [port_range] variable_list ["=" expression] ";"
					declaration = Declaration.from_tree(child)
					declarations.append(declaration)
				elif child.data == "conditional_statement":
					# conditional_statement: if_statement else_if_statement* else_statement?
					prev_conditions = []
					for if_child in child.children:
						if if_child.data == "if_statement":
							# if_statement: "if" "(" expression ")" statement_or_block
							assert prev_conditions == [], "Nested if statements are not supported"
							condition = Expression.from_tree(if_child.children[0])

							# TODO: Fix this temporary solution
							# Temporary solution to skip conditions that reference clocks or resets
							if condition is not None:
								# If the condition is a reference to a clock or reset, skip it
								if condition.references_any(TIMED_CONSTRUCTS):
									continue;

							statement = Statement.from_tree(if_child.children[1])
							conditional_statements.append((condition, statement))
							prev_conditions.append(condition)
						elif if_child.data == "else_if_statement":
							# else_if_statement: "else" "if" "(" expression ")" statement_or_block

							# TODO: Fix this temporary solution
							# Temporary solution to skip conditions that reference clocks or resets
							if len(prev_conditions) == 0:
								condition = Expression.from_tree(if_child.children[0])
							else:

								assert len(prev_conditions) > 0, "else_if_statement without previous if_statement"
								not_condition = Expression.not_expr(prev_conditions[0])
								for ith_condition in prev_conditions[1:]:
									not_condition = Expression.and_expr(Expression.not_expr(ith_condition), not_condition)
								else_if_condition = Expression.from_tree(if_child.children[0])
								condition = Expression.and_expr(not_condition, else_if_condition)
								prev_conditions.append(else_if_condition)

							# TODO: Fix this temporary solution
							# Temporary solution to skip conditions that reference clocks or resets
							if condition is not None:
								if condition.references_any(TIMED_CONSTRUCTS):
									continue;
							
							statement = Statement.from_tree(if_child.children[1])
							conditional_statements.append((condition, statement))
						elif if_child.data == "else_statement":
							# else_statement: "else" statement_or_block

							# TODO: Fix this temporary solution
							# Temporary solution to skip conditions that reference clocks or resets
							if len(prev_conditions) == 0:
								not_condition = None
							else:

								assert len(prev_conditions) > 0, "else_statement without previous if_statement"
								not_condition = Expression.not_expr(prev_conditions[0])
								for ith_condition in prev_conditions[1:]:
									not_condition = Expression.and_expr(Expression.not_expr(ith_condition), not_condition)
							statement = Statement.from_tree(if_child.children[0])
							conditional_statements.append((not_condition, statement))
						else:
							raise ValueError(f"Unsupported child in conditional_statement: {if_child.data}")
				elif child.data == "case_statement":
					# case_statement: "case" expression "case_item"*
					# case_item: "default" ":" statement_or_block | expression ":" statement_or_block
					case_condition = LHSExpression.from_tree(child.children[0])
					case_items = [CaseItem.from_tree(item) for item in child.children[1:] if hasattr(item, 'data')]
					prev_conditions = []
					for case_item in case_items:
						# Add case item as a conditional statement
						case_item_condition = case_item.get_condition()
						if case_item_condition is None:
							# Default case
							assert len(prev_conditions) > 0, "Default case without previous conditions"
							not_condition = Expression.not_expr(prev_conditions[0])
							for ith_condition in prev_conditions[1:]:
								not_condition = Expression.and_expr(not_condition, Expression.not_expr(ith_condition))
							conditional_statements.append((not_condition, case_item.get_statement()))
						else:
							condition = Expression.eq_expr(case_condition, case_item_condition)
							conditional_statements.append((condition, case_item.get_statement()))
							prev_conditions.append(condition)
				elif child.data == "function_call_statement":
					raise NotImplementedError("Function call statements are not yet supported")
				elif child.data == "dollar_identifier":
					raise NotImplementedError("Dollar identifiers (e.g. $display) are not yet supported")
				else:
					raise ValueError(f"Unsupported child in single_statement: {child.data}")
		return SingleStatement(assignments, conditional_statements, declarations)

	def _get_assignments(self):
		"""
		Return the list of assignments in this single statement.
		This is used to identify the assignments in the graph.
		"""
		assignments = []
		if self.assignments:
			for lhs_expr, rhs_expr, blocking in self.assignments:
				assign = Assignment(None, lhs_expr, rhs_expr, blocking)
				assignments.append(assign)
		if self.declarations:
			for decl in self.declarations:
				assignments.extend(decl.get_assignments())
		if self.conditional_statements:
			for condition, stmt in self.conditional_statements:
				assignment_list = stmt.get_assignments()
				for ith_assign in assignment_list:
					# Add condition to the assignment
					new_condition = condition
					if ith_assign.get_condition() is not None:
						if new_condition is None:
							new_condition = ith_assign.get_condition()
						else:
							new_condition = Expression.and_expr(new_condition, ith_assign.get_condition())
					assignment = Assignment(new_condition, ith_assign.get_lhs(), ith_assign.get_rhs(), ith_assign.get_blocking())
					assignments.append(assignment)
		return assignments

	def get_assignments(self, base_condition=None):
		"""
		Return the list of assignments in this single statement.
		This is used to identify the assignments in the graph.
		"""
		assignments = []
		if self.assignments:
			for lhs_expr, rhs_expr, blocking in self.assignments:
				assign = Assignment(base_condition, lhs_expr, rhs_expr, blocking)
				assignments.append(assign)
		if self.declarations:
			for decl in self.declarations:
				assignments.extend(decl.get_assignments(base_condition))
		if self.conditional_statements:
			for condition, stmt in self.conditional_statements:
				if condition is not None:
					if base_condition is not None:
						new_condition = Expression.and_expr(base_condition, condition)
					else:
						new_condition = condition
				else:
					new_condition = base_condition
				assignment_list = stmt.get_assignments(new_condition)
				for ith_assign in assignment_list:
					assignments.append(ith_assign)
		return assignments

	def _to_str(self, level=0):
		"""
		Convert the SingleStatement to a string representation.
		Handles assignments, conditional statements, declarations, case condition, and case items.
		"""
		str = f"SingleStatement: ";
		pred = "\n" + "  " * (level + 1);
		if self.assignments != []:
			str += pred + f"assignments= ";
			for lhs, rhs, blocking in self.assignments:
				str += pred + "  lhs:"
				str += lhs._to_str(level + 2)
				str += pred + "  rhs:"
				str += rhs._to_str(level + 2)
				str += pred + f"blocking= {blocking!r}"
		if self.conditional_statements != []:
			str += pred + f"conditional_statements= "
			for conditions, statements in self.conditional_statements:
				str += pred + "  conditions: "
				if conditions is None:
					str += "None"
				else:
					str += conditions._to_str(level + 2)
				str += pred + "  statements: "
				str += statements._to_str(level + 2)
		if self.declarations != []:
			str += pred + f"declarations= {self.declarations!r}"
		return str

	def __repr__(self):
		return self._to_str()

class EventExpression:
	def __init__(self, lhs_event=None, rhs_event=None, type=None):
		"""
		lhs_event: left-hand side event (can be a string for named events, or another EventExpression for edge-sensitive events)
		rhs_event: right-hand side event (for binary event expressions)
		type: type of the event expression (e.g. 'unary_posedge', 'binary_event_or', etc.)
		"""
		self.lhs_event = lhs_event  # Can be a string (named event) or another EventExpression
		self.rhs_event = rhs_event  # For binary event expressions
		self.type = type

	@staticmethod
	def from_tree(tree):
		"""
		Parse a Lark AST subtree for an event expression.
		Handles edge, level, wildcard, and named events.
		"""
		lhs_event = None
		rhs_event = None
		type = tree.data
		# tree.data might be 'event_expression', 'sensitivity_list', or similar
		child = tree
		if hasattr(child, 'data'):
			if child.data == 'event_variable':
				# Named event: variable
				lhs_event = str(child.children[0])
			elif child.data in ('unary_posedge', 'unary_negedge'):
				# Edge-sensitive: posedge clk, negedge rst_n
				lhs_event = EventExpression.from_tree(child.children[0])
			elif child.data == 'combinational_event_expression':
				# Combinational event expression: @(*)
				lhs_event = "any"
			elif child.data == 'binary_event_or':
				# Binary event expression: event_expression "or" event_expression
				lhs_event = EventExpression.from_tree(child.children[0])
				rhs_event = EventExpression.from_tree(child.children[1])
			elif child.data == 'binary_event_and':
				# Binary event expression: event_expression "and" event_expression
				lhs_event = EventExpression.from_tree(child.children[0])
				rhs_event = EventExpression.from_tree(child.children[1])
			elif child.data == 'event_parenthesis':
				lhs_event = EventExpression.from_tree(child.children[0])
			else:
				raise ValueError(f"Unsupported child in event_expression: {child.data}")
		elif isinstance(child, str):
			if child == '*':
				lhs_event = "any"
				type = 'combinational_event_expression'
			else:
				raise ValueError(f"Unexpected string in event_expression: {child}")
		return EventExpression(lhs_event, rhs_event, type)

	def get_sensitivity_list(self):
		"""
		Return a list of sensitivity signals from the event expression.
		"""
		assert self.lhs_event is not None, "LHS event must be defined for sensitivity list"
		signals = []
		if type in ["event_variable", "combinational_event_expression"]:
			signals.append(self.lhs_event)
		elif type in ["unary_posedge", "unary_negedge", "event_parenthesis"]:
			signals.extend(self.lhs_event.get_sensitivity_list())
		elif type in ["binary_event_or", "binary_event_and"]:
			signals.extend(self.lhs_event.get_sensitivity_list())
			signals.extend(self.rhs_event.get_sensitivity_list())
		else:
			raise ValueError(f"Unsupported event type: {self.type}")
		return signals

	def _to_str(self, level=0):
		"""
		Convert the EventExpression to a string representation.
		Handles the list of events.
		"""
		str = f"EventExpression: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"type= {self.type!r}"
		str += pred + f"events= "
		if self.lhs_event is not None:
			if self.type in ["event_variable", "combinational_event_expression"]:
				str += f"{self.lhs_event!r} "
			elif isinstance(self.lhs_event, EventExpression):
				str += self.lhs_event._to_str(level + 1)
		if self.rhs_event is not None:
			if isinstance(self.rhs_event, str):
				str += f"{self.rhs_event!r} "
			elif isinstance(self.rhs_event, EventExpression):
				str += self.rhs_event._to_str(level + 1)
		return str		

	def __repr__(self):
		return self._to_str()

class AlwaysBlock:
	def __init__(self, event_expression, statement):
		"""
		event_expression: EventExpression object representing the sensitivity list
		statement: Statement object representing the block of statements
		"""
		self.event_expression = event_expression
		self.statement = statement

	@staticmethod
	def from_tree(tree):
		"""
		Parse an always block subtree and return an AlwaysBlock object.
		Assumes the rule: always_block: "always" "@" "(" sensitivity_list ")" statement_or_block
		"""
		assert tree.data == 'always_block', f"Expected always_block, got {tree.data}";
		statement_or_block = None

		child_data = [child for child in tree.children];
		assert len(child_data) == 2, f"Expected 2 children in always_block"
		[event_expression, statement_or_block] = child_data

		event_expression = EventExpression.from_tree(event_expression)  # This should be the sensitivity list
		statement_or_block = Statement.from_tree(statement_or_block)

		return AlwaysBlock(event_expression, statement_or_block)

	def get_assignments(self):
		"""
		Return a list of assignments in this always block.
		This is used to identify the assignments in the graph.
	 	"""
		assignments = self.statement.get_assignments()
		return assignments

	def _to_str(self, level=0):
		"""
		Convert the AlwaysBlock to a string representation.
		Handles the sensitivity list and list of statements.
		"""
		str = f"AlwaysBlock: ";
		pred = "\n" + "  " * (level + 1);
		str += pred + f"event_expression= {self.event_expression._to_str(level + 1)}"
		str += pred + f"statements= {self.statement._to_str(level + 1)}"
		return str

	def __repr__(self):
		return self._to_str()

def AST_equal(a, b):
	#print(f"{type(a)}, {type(b)}");
	assert a is None or type(a) == lark.Tree or type(a) == lark.Token;
	assert b is None or type(b) == lark.Tree or type(b) == lark.Token;
	return lark.Tree(VerilogOperation.BINARY_EQ.value, [a,b]);

def AST_and  (a, b):
	#print(f"{type(a)}, {type(b)}");
	assert a is None or type(a) == lark.Tree or type(a) == lark.Token;
	assert b is None or type(b) == lark.Tree or type(b) == lark.Token;
	return lark.Tree(VerilogOperation.BINARY_AND.value, [a,b]);

def AST_not  (a   ):
	#print(f"{type(a)}");
	assert a is None or type(a) == lark.Tree or type(a) == lark.Token;
	return lark.Tree(VerilogOperation.UNARY_NOT.value, [a]);

def AST_Const(val):
	return lark.Tree("regular_number", [val]);

def add_asg(g, var_node, value, cond, variables, bitwidth, is_signed):
	if cond is None:
		cond = add_expression(g, AST_Const(1), variables);
	asg = add_node(g, NodeType.ASSIGNMENT, label = "=", bit_width = bitwidth, signed = is_signed);
	g.add_edge(value, asg, type = EdgeType.VALUE);
	g.add_edge(cond, asg, type = EdgeType.CONDITION);
	g.add_edge(asg, var_node, type = EdgeType.VALUE);


def get_bitwidth_for_op(g, op, children):
	if op in binary_logical.keys():
		return 1;
	elif op in binary.keys():
		#assert all bw the same?
		return g.nodes[children[0]]['bit_width'];

	if op in unary_1bit.keys():
		return 1;
	elif op in unary.keys():
		return g.nodes[children[0]]['bit_width'];

	match op:
		case VerilogOperation.CONDITIONAL_EXPRESSION:
			return g.nodes[children[1]]['bit_width'];
		case VerilogOperation.ARRAY_CONCAT:
			return sum([g.nodes[c]['bit_width'] for c in children], 0);
		case VerilogOperation.ARRAY_REPLICATE:
			assert False, f"array replicate, children : {children}";
		case VerilogOperation.ARRAY_SLICE:
			lower_bound = children[2];
			upper_bound = children[1];
			assert g.nodes[lower_bound]['type'] == NodeType.VALUE;
			assert g.nodes[upper_bound]['type'] == NodeType.VALUE;
			return verilog_constant_to_int(named(g, upper_bound)) - verilog_constant_to_int(named(g, lower_bound));
		case VerilogOperation.ARRAY_INDEX:
			assert False, f"array index, should be 1?, children : {children}";
	return -1;
	

def add_slicing_to_assignments(assignments, variables_def):

	replacement_assignments = [];
	for assign in assignments:
		lhs_expr = assign.get_lhs();
		lhs_bitwidth = lhs_expr.get_bitwidth(variables_def);
		rhs_expr = assign.get_rhs();
		if rhs_expr.is_constant() and rhs_expr.get_constant() == '\'bx':
			continue
		rhs_bitwidth = rhs_expr.get_bitwidth(variables_def);
		if lhs_bitwidth < rhs_bitwidth:
			#print(f"Warning: LHS bitwidth {lhs_bitwidth} is less than RHS bitwidth {rhs_bitwidth} in assignment {assign}. Slicing RHS to match LHS.");
			if rhs_expr.is_constant():
				if lhs_bitwidth == 1:
					# This is a shortcut to avoid assigning to parameters wrong values
					# TODO: Assign to parameters the real bitwidth that they have which is not specified in the declaration
					continue; 
				verilog_constant_value = rhs_expr.get_constant()
				#print(f"Old constant: {verilog_constant_value} with desired bitwidth {lhs_bitwidth}");
				constant_value = verilog_constant_to_int(verilog_constant_value)
				new_constant = Expression.constant_expr(int(constant_value), lhs_bitwidth)
				new_assign = Assignment(assign.get_condition(), lhs_expr, new_constant, assign.get_blocking());
				replacement_assignments.append((assign, new_assign));
				#print(f"new constant: {new_constant}");
			else:
				msb = lhs_bitwidth - 1;
				lsb = 0;
				slice_expr = Expression.slice_expr(rhs_expr, msb, lsb); 
				new_assign = Assignment(assign.get_condition(), lhs_expr, slice_expr, assign.get_blocking());
				replacement_assignments.append((assign, new_assign));

	for old_assign, new_assign in replacement_assignments:
		assignments.remove(old_assign);
		assignments.append(new_assign);




def adjust_sliced_assignments(assignments, variables_def):
	sliced_assignments = [];
	for assign in assignments:
		lhs_expr = assign.get_lhs();
		if lhs_expr.is_slice():
			sliced_assignments.append(assign);

	for assign in sliced_assignments:
		lhs_expr = assign.get_lhs();
		rhs_expr = assign.get_rhs();
		slice_range = lhs_expr.get_slice_range();
		assert slice_range is not None, f"Slice range should not be None for {lhs_expr}";
		msb, lsb = slice_range;
		var_name = lhs_expr.get_variable_name();
		assert var_name in variables_def, f"Variable {var_name} not found in variables_def";
		bitwidth_var = variables_def[var_name].get_bitwidth();
		var_expression = Expression("string", variable=var_name);
		new_lhs_expr = LHSExpression([var_expression]);
		antedef = None;
		postdef = None;
		if lsb > 0:
			new_lsb = Expression("regular_number", constant = f"0");
			if lsb == 1:
				antedef = Expression("lhs_expression", lhs_expr=LHSExpression([var_expression],index=new_lsb));
			else:
				new_msb = Expression("regular_number", constant = f"{lsb-1}");
				antedef = Expression("lhs_expression", lhs_expr=LHSExpression([var_expression], range_=(new_msb, new_lsb)));
		if msb < bitwidth_var - 1:
			new_msb = Expression("regular_number", constant = f"{bitwidth_var - 1}");
			if msb == bitwidth_var - 2:
				postdef = Expression("lhs_expression", lhs_expr=LHSExpression([var_expression],index=new_msb));
			else:
				new_lsb = Expression("regular_number", constant = f"{msb + 1}");
				postdef = Expression("lhs_expression", lhs_expr=LHSExpression([var_expression], range_=(new_msb, new_lsb)));
		if antedef is not None:
			if postdef is not None:
				new_rhs_expr = Expression.concat_expr([antedef, rhs_expr, postdef]);
			else:
				new_rhs_expr = Expression.concat_expr([antedef, rhs_expr]);
		else:
			if postdef is not None:
				new_rhs_expr = Expression.concat_expr([rhs_expr, postdef]);
			else:
				raise ValueError(f"Both antedef and postdef are None for {lhs_expr}");
		new_assign = Assignment(assign.get_condition(), new_lhs_expr, new_rhs_expr, assign.get_blocking());
		assignments.remove(assign);
		assignments.append(new_assign);

# For now special case function with two unconditional assignments
# TODO: Merge it in the calling function to make it more general
def adjust_sliced_assignments_constants_2(var_uncond_assigns, var_assigns, assignments, variables_def):

	assert len(var_uncond_assigns) == 2, f"Expected exactly two unconditional assignments, got {len(var_uncond_assigns)}"
	if var_uncond_assigns[0].get_lhs().get_slice_range()[0] < var_uncond_assigns[1].get_lhs().get_slice_range()[0]:
		antedef = var_uncond_assigns[0]
		postdef = var_uncond_assigns[1]
	else:
		antedef = var_uncond_assigns[1]
		postdef = var_uncond_assigns[0]
	assignments.remove(antedef);
	assignments.remove(postdef);
	# Get the value assigned in the unconditional assignments
	antedef_value = antedef.get_rhs();
	postdef_value = postdef.get_rhs();
	# Get the slice range of the unconditional assignments
	antedef_lhs = antedef.get_lhs();
	antedef_slice = antedef_lhs.get_slice_range();
	assert antedef_slice is not None, f"Unconditional assignment for {antedef_lhs} should have a slice range";
	msb_antedef, lsb_antedef = antedef_slice;
	postdef_lhs = postdef.get_lhs();
	postdef_slice = postdef_lhs.get_slice_range();
	assert postdef_slice is not None, f"Unconditional assignment for {postdef_lhs} should have a slice range";
	msb_postdef, lsb_postdef = postdef_slice;
	assert lsb_antedef == 0, f"Expected antedef to start at 0, got {lsb_antedef}";
	assert msb_postdef == variables_def[antedef_lhs.get_variable_name()].get_bitwidth() - 1, f"Expected postdef to end at bitwidth-1, got {msb_postdef}";
	# Then iterate over the other assignment and adjust them adding the unconditional value as antedef and postdef
	for assign in var_assigns:
		if assign in var_uncond_assigns:
			continue;
		lhs_expr = assign.get_lhs();
		rhs_expr = assign.get_rhs();
		slice_range = lhs_expr.get_slice_range();
		assert slice_range is not None, f"Slice range should not be None for {lhs_expr}";
		msb, lsb = slice_range;
		var_name = lhs_expr.get_variable_name();
		assert var_name in variables_def, f"Variable {var_name} not found in variables_def";
		bitwidth_var = variables_def[var_name].get_bitwidth();
		new_rhs_expr = Expression.concat_expr([postdef_value, rhs_expr, antedef_value]);
		# Create the new lhs_expression
		var_expression = Expression("string", variable=var_name);
		new_lhs_expr = LHSExpression([var_expression]);
		new_assign = Assignment(assign.get_condition(), new_lhs_expr, new_rhs_expr, assign.get_blocking());
		assignments.remove(assign);
		assignments.append(new_assign);



def adjust_sliced_assignments_constants(assignments, variables_def):
	sliced_assignments = {}; # Order them by variable name
	for assign in assignments:
		lhs_expr = assign.get_lhs();
		if lhs_expr.is_slice():
			var_name = lhs_expr.get_variable_name();
			if var_name not in sliced_assignments:
				sliced_assignments[var_name] = [];
			sliced_assignments[var_name].append(assign);

	for var_name, assigns in sliced_assignments.items():
		# First find the unconditional assignment and assert it exists and it is only one
		# For now we only handle the case of one unconditional assignment 
		# TODO: Handle multiple unconditional assignments
		uncond_assigns = [a for a in assigns if a.get_condition() is None];
		if len(uncond_assigns) == 2:
			adjust_sliced_assignments_constants_2(uncond_assigns, assigns, assignments, variables_def);
			continue;
		assert len(uncond_assigns) == 1, f"Expected exactly one unconditional assignment for {var_name}, found {len(uncond_assigns)}";
		uncond_assign = uncond_assigns[0];
		assignments.remove(uncond_assign);
		# Get the value assigned in the unconditional assignment
		uncond_value = uncond_assign.get_rhs();
		# Get the slice range of the unconditional assignment
		uncond_lhs = uncond_assign.get_lhs();
		uncond_slice = uncond_lhs.get_slice_range();
		assert uncond_slice is not None, f"Unconditional assignment for {var_name} should have a slice range";
		msb_uncond, lsb_uncond = uncond_slice;
		# Then iterate over the other assignment and adjust them adding the unconditional value as antedef or postdef
		for assign in assigns:
			if assign == uncond_assign:
				continue;
			lhs_expr = assign.get_lhs();
			rhs_expr = assign.get_rhs();
			slice_range = lhs_expr.get_slice_range();
			assert slice_range is not None, f"Slice range should not be None for {lhs_expr}";
			msb, lsb = slice_range;
			var_name = lhs_expr.get_variable_name();
			assert var_name in variables_def, f"Variable {var_name} not found in variables_def";
			bitwidth_var = variables_def[var_name].get_bitwidth();
			# In this case we assume that the slice of the conditional assignemnt + the slice of the unconditional assignment covers the entire variable
			# i.e. if the unconditional assignment is [7:4], the conditional assignments can be only be [3:0] or [7:0] if the bitwidth is 8
			assert (msb - lsb) == bitwidth_var or (lsb == 0 and msb == lsb_uncond - 1 and msb_uncond == bitwidth_var - 1) or (msb == bitwidth_var - 1 and lsb == msb_uncond + 1 and lsb_uncond == 0), f"Slices do not cover the entire variable {var_name} with bitwidth {bitwidth_var}: unconditional [{msb_uncond}:{lsb_uncond}], conditional [{msb}:{lsb}]";
			# Create the new lhs_expression
			var_expression = Expression("string", variable=var_name);
			new_lhs_expr = LHSExpression([var_expression]);
			# Consider the case when the conditional assignment is the entire variable
			if (msb - lsb) == bitwidth_var:
				new_assign = Assignment(assign.get_condition(), new_lhs_expr, rhs_expr, assign.get_blocking());
				assignments.remove(assign);
				assignments.append(new_assign);
				continue;
			antedef = None;
			postdef = None;
			if lsb == 0:
				new_rhs_expr = Expression.concat_expr([uncond_value, rhs_expr]);
			elif lsb_uncond == 0:
				new_rhs_expr = Expression.concat_expr([rhs_expr, uncond_value]);
			else:
				raise ValueError(f"Neither lsb == 0 nor lsb_uncond == 0 for {lhs_expr}");
			new_assign = Assignment(assign.get_condition(), new_lhs_expr, new_rhs_expr, assign.get_blocking());
			assignments.remove(assign);
			assignments.append(new_assign);

exprs_seen : Dict[lark.Tree, Node | None] = {};
def add_expression(g, expr, variables) -> Node | None:
	assert expr is not None;
	if expr in exprs_seen:
		return exprs_seen[expr];
	ret = None;
	if expr.data in ["extended_based_number", "regular_number"]:
		if "x" in str(expr.children[0]):
			ret = None;
		else:
			value = str(expr.children[0]);
			bit_width = 32 if expr.data == "regular_number" else int(value.split("'")[0]);
			ret =  add_node(g, NodeType.VALUE, label = value, bit_width = bit_width);
	elif expr.data == "lhs_expression":
		ret =  variables[str(expr.children[0].children[0])];
	else:
		for op_type, symbol in operations.items():
			if expr.data == op_type.value:
				children = [add_expression(g, c, variables) for c in expr.children];
				bw = get_bitwidth_for_op(g, op_type, children);
				node = add_node(g, NodeType.OPERATOR, label = symbol, operator = op_type, bit_width = bw);
				for i,c in enumerate(children):
					g.add_edge(c, node, type = EdgeType.VALUE, index = i);
				ret = node;
				break;
	exprs_seen[expr] = ret;
	return ret;

merge_only_vars = True;
def add_ast_expression(ast_graph, expression, variables, signed_expr):
	"""
	Add an expression to the AST graph.
	Handles different types of expressions and their relationships.
	"""
	assert expression is not None, "Expression cannot be None";
	assert isinstance(expression, Expression) or isinstance(expression, LHSExpression), \
		f"Expected Expression or LHSExpression, got {type(expression)}: {expression}";
	if expression.get_unique_id() in exprs_seen:
		return exprs_seen[expression.get_unique_id()];
	ret = None;
	if isinstance(expression, LHSExpression):
		if not expression.is_slice():
			ret = variables["id"][str(expression.get_variable_name())];
			exprs_seen[expression] = ret;
			return ret;
		else:
			# Handle slice expressions
			msb, lsb = expression.get_slice_range();
			var_name = expression.get_variable_name();
			assert var_name in variables["id"], f"Variable {var_name} not found in variables_id";
			var_ast = variables["id"][str(var_name)];
			msb_ast =  add_node(ast_graph, NodeType.VALUE, label=str(msb), bit_width=32, signed=False);
			if msb == lsb:
				# If msb == lsb, it is a single
				operation_node = add_node(ast_graph, NodeType.OPERATOR, label=operations[VerilogOperation.ARRAY_INDEX], operator=VerilogOperation.ARRAY_INDEX, bit_width=1, signed=False);
				ast_graph.add_edge(var_ast, operation_node, type=EdgeType.VALUE, index=0);
				ast_graph.add_edge(msb_ast, operation_node, type=EdgeType.VALUE, index=1);
			else:
				# If msb != lsb, it is a slice
				operation_node = add_node(ast_graph, NodeType.OPERATOR, label=operations[VerilogOperation.ARRAY_SLICE], operator=VerilogOperation.ARRAY_SLICE, bit_width=expression.get_bitwidth(variables["def"]), signed=False);
				ast_graph.add_edge(var_ast, operation_node, type=EdgeType.VALUE, index=0);
				ast_graph.add_edge(msb_ast, operation_node, type=EdgeType.VALUE, index=1);
				lsb_ast = add_node(ast_graph, NodeType.VALUE, label=str(lsb), bit_width=32, signed=False);
				ast_graph.add_edge(lsb_ast, operation_node, type=EdgeType.VALUE, index=2);
			ret = operation_node;
			if not merge_only_vars:
				exprs_seen[expression.get_unique_id()] = ret;
			return ret;
	if expression.is_constant():
		# Handle constant expressions
		if "x" in str(expression.get_constant()):
			ret = None;
		else:
			ret = add_node(ast_graph, NodeType.VALUE, label=str(expression.get_constant()), bit_width=expression.get_bitwidth(variables["def"]), signed=False);
	elif expression.is_variable():
		ret = variables["id"][str(expression.get_variable())];
		exprs_seen[expression.get_unique_id()] = ret;
	elif expression.is_type(VerilogOperation.CONDITIONAL_EXPRESSION):
		# Conditional expression: a ? b : c
		ret = add_node(ast_graph, NodeType.OPERATOR, label="?:", operator=VerilogOperation.CONDITIONAL_EXPRESSION, bit_width=expression.get_bitwidth(variables["def"]), signed=signed_expr);
		ast_graph.add_edge(add_ast_expression(ast_graph, expression.get_lhs_expr(), variables, signed_expr), ret, type=EdgeType.VALUE, index=0);
		ast_graph.add_edge(add_ast_expression(ast_graph, expression.get_rhs_expr(), variables, signed_expr), ret, type=EdgeType.VALUE, index=1);
		ast_graph.add_edge(add_ast_expression(ast_graph, expression.get_condition(), variables, signed_expr), ret, type=EdgeType.CONDITION, index=2);
	elif expression.get_type() in binary or expression.get_type() in unary:
		# Handle binary and unary operations
		op_type = expression.get_type();
		symbol = operations[op_type];
		lhs_ast = add_ast_expression(ast_graph, expression.get_lhs_expr(), variables, signed_expr);
		if op_type in binary:
			rhs_ast = add_ast_expression(ast_graph, expression.get_rhs_expr(), variables, signed_expr);
		ret = add_node(ast_graph, NodeType.OPERATOR, label=symbol, operator= op_type, bit_width=expression.get_bitwidth(variables["def"]), signed=signed_expr);
		ast_graph.add_edge(lhs_ast, ret, type=EdgeType.VALUE, index=0);
		if op_type in binary:
			ast_graph.add_edge(rhs_ast, ret, type=EdgeType.VALUE, index=1);
	elif expression.get_type() in [VerilogOperation.ARRAY_CONCAT, VerilogOperation.ARRAY_REPLICATE, VerilogOperation.ARRAY_INDEX, VerilogOperation.ARRAY_SLICE]:
		# Handle array operations
		lhs_expr = expression.get_lhs_expr();
		assert isinstance(lhs_expr, LHSExpression), \
			f"Expected LHSExpression for array operations, got {type(lhs_expr)}: {lhs_expr}";
		vars_ast = []
		for var, range in lhs_expr.get_vars_assigned_expressions():
			if isinstance(var, Expression) and var.expr_type == "lhs_expression":
				var = var.get_lhs_expr()
			vars_ast.append(add_ast_expression(ast_graph, var, variables, signed_expr));
			if range is not None:
				# Handle range if it exists
				msb, lsb = range;
				vars_ast.append(add_ast_expression(ast_graph, msb, variables, signed_expr));
				if msb != lsb:
					vars_ast.append(add_ast_expression(ast_graph, lsb, variables, signed_expr));
		operation_node = add_node(ast_graph, NodeType.OPERATOR, label=operations[expression.get_type()], operator=expression.get_type(), bit_width=expression.get_bitwidth(variables["def"]), signed=signed_expr);
		for i, var_ast in enumerate(vars_ast):
			ast_graph.add_edge(var_ast, operation_node, type=EdgeType.VALUE, index=i);
		ret = operation_node;
	else:
		# Handle other types of expressions
		raise ValueError(f"Unsupported expression type: {expression.get_type()}");
	if not merge_only_vars:
		exprs_seen[expression.get_unique_id()] = ret;
	return ret;

# Function to mark operators as signed based on their inputs
def mark_signed_operators(ast_graph):
	"""
	Mark operators as signed based on their input nodes.
	"""
	changed = True
	while changed:
		changed = False
		for node in ast_graph.nodes:
			if ast_graph.nodes[node]['type'] == NodeType.OPERATOR:
				if not ast_graph.nodes[node]['signed']:
					if ast_graph.nodes[node]['operator'] in [VerilogOperation.FUNCTION_UNSIGNED]:
						continue
					inputs = [pred for pred, _, data in ast_graph.in_edges(node, data=True) if data['type'] == EdgeType.VALUE]
					if all(ast_graph.nodes[input_node]['type'] == NodeType.CONSTANT for input_node in inputs):
						continue
					if all(ast_graph.nodes[input_node]['signed'] or ast_graph.nodes[input_node]['type'] == NodeType.CONSTANT or (ast_graph.nodes[input_node]['type'] == NodeType.OPERATOR and ast_graph.nodes[input_node]['operator'] == VerilogOperation.FUNCTION_SIGNED) for input_node in inputs):
						ast_graph.nodes[node]['signed'] = True
						changed = True
				else:
					if ast_graph.nodes[node]['operator'] in [VerilogOperation.FUNCTION_UNSIGNED]:
						ast_graph.nodes[node]['signed'] = False
						changed = True


def parse_external_module(ast_graph, module, assignments_per_var, variables_info, top_ports):
	"""
	Parse an external module.
	Handles the modules specified in external_modules.
	"""
	assert isinstance(module, ModuleInstantiation), \
		f"Expected ModuleInstantiation, got {type(module)}: {module}";
	corresponding_module = None
	for mod in external_modules.keys():
		if module.get_name() == mod:
			corresponding_module = mod;
			break;
		if mod in module.get_name():
			corresponding_module = mod;
			break;
	# Check if the module is defined in external_modules
	assert corresponding_module is not None, \
		f"Module {module.get_name()} is not defined in external_modules";
	
	ports = module.get_ports();
	inputs = [p.get_name() for p in ports if len(assignments_per_var.get(p.get_expression() ,[])) > 0 or (any(p.get_expression() in top_port.get_name() and not(top_port.get_name() in TIMED_CONSTRUCTS) for top_port in top_ports))];
	outputs = [p.get_name() for p in ports if len(assignments_per_var.get(p.get_expression() ,[])) == 0];
	inputs_definition = external_modules[corresponding_module]["inputs"];
	outputs_definition = external_modules[corresponding_module]["outputs"];
	assert set(inputs_definition).issubset(set(inputs)), \
		f"Inputs {inputs} does not contain the expected inputs {inputs_definition} for module {corresponding_module}";
	assert set(outputs_definition).issubset(set(outputs)), \
		f"Outputs {outputs} does not contain the expected outputs {outputs_definition} for module {corresponding_module}";
	# Get the values attached to the inputs and outputs ports
	input_expressions = [module.get_port_expression(name) for name in inputs_definition];
	output_expressions = [module.get_port_expression(name) for name in outputs_definition];
	assert all(expr is not None for expr in input_expressions), \
		f"Module {corresponding_module} must have expressions for all inputs: {inputs_definition}";
	assert all(expr is not None for expr in output_expressions), \
		f"Module {corresponding_module} must have expressions for all outputs: {outputs_definition}";
	# Determine the bit width for the node based on the outputs	
	node_bitwidth = -1
	node_signed = False
	for output in output_expressions:
		assert output in variables_info["def"], \
			f"Output {output} not found in variables_info for module {corresponding_module}";
		output_bitwidth = variables_info['def'][output].get_bitwidth();
		if output_bitwidth > node_bitwidth:
			node_bitwidth = output_bitwidth;
		if variables_info['def'][output].is_signed():
			node_signed = True
	assert node_bitwidth > 0, f"Node bit width must be greater than 0 for module {corresponding_module}";
	# Create a node for the external module
	operator_definition = external_modules[corresponding_module]["operator"];
	external_module_node = add_node(ast_graph, NodeType.OPERATOR, 
		label= operations[operator_definition] if operator_definition != VerilogOperation.BLACKBOX else corresponding_module,
		operator=operator_definition,
		bit_width=node_bitwidth,
		signed=node_signed
	);
	# Add edges for inputs and outputs
	for i, input_expr in enumerate(input_expressions):
		assert input_expr in variables_info["id"], \
			f"Input expression {input_expr} not found in variables_info for module {corresponding_module}";
		ast_graph.add_edge(variables_info["id"][input_expr], external_module_node, type=EdgeType.VALUE, index=i);
	for i, output_expr in enumerate(output_expressions):
		assert output_expr in variables_info["id"], \
			f"Output expression {output_expr} not found in variables_info for module {corresponding_module}";
		add_asg(ast_graph, variables_info["id"][output_expr], external_module_node, None, variables_info["id"], node_bitwidth, node_signed);
	# Clean up unused variables
	to_remove_vars = inputs + outputs;
	to_remove_vars = set(to_remove_vars);
	# Remove variables that are not part of the external module's inputs or outputs
	to_remove_vars = to_remove_vars - set(inputs_definition) - set(outputs_definition);
	to_remove = {variables_info["id"][n] for n in list(to_remove_vars) if n in variables_info["id"]};
	ast_graph.remove_nodes_from(to_remove);

def legup_parse_mult_1(g, ast_node, assignments_per_variable, variables):
	name = str(ast_node.children[2]);

	for na in ast_node.children[3].children:
		assert na.data == "named_argument";
	ports  = [(str(arg.children[0]), str(arg.children[1].children[0].children[0])) for arg in ast_node.children[3].children];
	inputs  = [p for p in ports if len(assignments_per_variable[p[1]]) > 0];
	outputs = [p for p in ports if len(assignments_per_variable[p[1]]) == 0];
	inputs  = {k:v for k,v in inputs};
	outputs = {k:v for k,v in outputs};
	mult_node = add_node(g, NodeType.OPERATOR, 
		label = operations[VerilogOperation.BINARY_MUL],
		operator = VerilogOperation.BINARY_MUL,
		bit_width = 32
	);
	g.add_edge(variables[inputs["dataa"]], mult_node, type = EdgeType.VALUE, index = 0);
	g.add_edge(variables[inputs["datab"]], mult_node, type = EdgeType.VALUE, index = 1);
	add_asg(g, variables[outputs["result"]], mult_node, None, variables);
	del inputs['dataa'];
	del inputs['datab'];
	del outputs['result'];
	to_remove_vars = list(inputs.values()) + list(outputs.values());
	to_remove = {variables[n] for n in inputs .values()}.union({variables[n] for n in outputs.values()});
	g.remove_nodes_from(to_remove);
	for n in to_remove_vars:
		del variables[n];
		del assignments_per_variable[n];

	
	pass

external_modules = {
	"legup_mult_1" : {
		"inputs"  : ["dataa", "datab"],
		"outputs" : ["result"],
		"operator" : VerilogOperation.BINARY_MUL
	},
	"lpm_divide" : {
		"inputs"  : ["numer", "denom"],
		"outputs" : ["quotient", "remain"],
		"operator" : VerilogOperation.BLACKBOX
	},
	"_mul_32s_" : {
		"inputs" : ["din0", "din1"],
		"outputs": ["dout"],
		"operator": VerilogOperation.BINARY_MUL
	}
}

module_parsers = {
	"legup_mult_1" : legup_parse_mult_1,
};

macros = {}

def extract_macros_from_tree(tree):
	"""
	Extract macros from the given Lark tree.
	Assumes the rule: macro_definition: "define" identifier expression
	"""
	assert tree.data == "macro_definition", f"Expected macro_definition, got {tree.data}";
	name = str(tree.children[0]);
	if name in macros:
		raise ValueError(f"Macro {name} already defined");
	macros[name] = Expression.from_tree(tree.children[1]);

def from_AST(top): 
	assert isinstance(top, lark.Tree);

	for main_elements in top.children:
		if main_elements.data == "macro_definition":
			extract_macros_from_tree(main_elements);

	ast_graph = nx.MultiDiGraph();
	for c in top.children:
		assert isinstance(c, lark.Tree);
		if c.data == "module":
			top = c;
	module_name = str(top.children[0]);
	
	d = {};
	for c in top.children:
		if isinstance(c, lark.Tree):
			c_data = f"{c.data}";
			if c_data in d:
				d[c_data].append(c);
			else:
				d[c_data] = [c];
	assert len(d["port_list"]) == 1;
	#
	# get port list
	#

	variables  = {};
	bit_widths = { "": ""};
	variables_def = {}

	ports = [];	
	node_id = 0;
	if "single_statement" in d.keys():
		for stmt in d["single_statement"]:
			t = stmt.children[0];
			declaration = Declaration.from_tree(t);
			# Check if the declaration has a direction field
			# If it does, it is a port declaration
			if declaration.get_direction() is not None:
				extracted_ports = Port.from_declaration(declaration);
				ports.extend(extracted_ports);
				continue;
			vars_in_stmt = declaration.get_names();
			for vis in vars_in_stmt:
				variables[vis] = node_id;
				bit_widths[vis] = 32;
				node_id += 1;
				variables_def[vis] = declaration;
	for port in ports:
		port_name = port.get_name();
		if port_name not in variables:
			variables[port_name] = node_id;
			node_id += 1;
			variables_def[port_name] = port;
	
	for v in variables:
		add_node(ast_graph, NodeType.VARIABLE, label = v, id = variables[v], bit_width= variables_def[v].get_bitwidth(), signed= variables_def[v].is_signed());

	TIMED_CONSTRUCTS = resets + clocks;
	
	assignments_per_variable = { v : [] for v in variables};
	
	def add_assignment(variable, condition, value):
		assert type(variable) == str;
		assert condition is None or type(condition) == lark.Tree or type(condition) == lark.Token;
		assert value is None     or type(value) == lark.Tree or type(value) == lark.Token;
		#print(f"{variable}: is {value} if  {condition}");
		assignments_per_variable[variable].append( (condition, value) );
		

	
	def add_statement(g, statement, surrounding_condition):
		assert "NONE" not in g.nodes;
		assert type(surrounding_condition) == lark.Tree or surrounding_condition is None;
		if statement is None:
			return;
		elif statement.data == "statement":
			add_statement(g, statement.children[0], surrounding_condition);
		elif statement.data == "single_statement":
			add_statement(g, statement.children[0], surrounding_condition);
		elif statement.data == "declaration":
			if statement.children[4] is None:
				return;
			expr = statement.children[4];
			for v in [n.children[0].children[0] for n in statement.children[3].children]:
				add_assignment(str(v), surrounding_condition, expr);

		elif statement.data == "conditional_statement":
			# if else chain
			else_condition = None;
			for conditional in statement.children:
				if conditional.data != "else_statement":
					condition = conditional.children[0];
					if references_any(condition, TIMED_CONSTRUCTS):
						continue;
						pass
				
					if else_condition is not None:
						else_condition = AST_and(else_condition, AST_not(condition));
						condition      = AST_and(else_condition, condition);
					else:
						else_condition = AST_not(condition);

					if surrounding_condition is not None:
						condition = AST_and(surrounding_condition, condition);
					then      = conditional.children[1];
					add_statement(g, then, condition);
				else:
					if surrounding_condition is not None:
						else_condition = AST_and(surrounding_condition, else_condition);
					add_statement(g, conditional.children[0], else_condition);

		elif statement.data == "case_statement":
			switch_on = statement.children[0];
			cases = [];
			default_case = None;
			for case in statement.children[1:]:
				assert case.data in ["regular_case", "default_case"];
				if case.data != "regular_case":
					default_case = case;
					continue;
				case_value = case.children[0];
				case_equal = AST_equal(switch_on, case_value);
				cases.append(case_equal);
				if surrounding_condition is not None:
					case_equal = AST_and(g, surrounding_condition, case_equal);
				add_statement(g, case.children[1], case_equal);
			
			while len(cases) > 1:
				a = cases.pop();
				b = cases.pop();
				cases.append(AST_and(a, b));
			default_case_cond = AST_not(cases[0]);
			add_statement(g, default_case.children[0], default_case_cond);
		elif statement.data == "statement_block":
			for s in statement.children:
				add_statement(g, s, surrounding_condition);
		elif statement.data == "non_blocking_assignment":
			lhs = statement.children[0].children[0].children[0];
			rhs = statement.children[1];
			condition = surrounding_condition;
			add_assignment(str(lhs), condition, rhs);
		elif statement.data == "blocking_assignment":
			lhs = statement.children[0].children[0].children[0];
			rhs = statement.children[1];
			condition = surrounding_condition;
			add_assignment(str(lhs), condition, rhs);
		else:
			print(f"Unhandled {statement.pretty()}"); 
			#assert false;

	assignemnts = [];

	if "always_block" in d.keys():
		for always_block in d["always_block"]:
			block = AlwaysBlock.from_tree(always_block);
			assignemnts.extend(block.get_assignments());
			#add_statement(ast_graph, always_block.children[1], None);
	if "single_statement" in d.keys():
		for stmt in d["single_statement"]:
			new_tree = lark.Tree("statement", [stmt]);
			statement = Statement.from_tree(new_tree);
			assignemnts.extend(statement.get_assignments());
			#add_statement(ast_graph, stmt, None);
	if "blocking_assignment" in d.keys():
		for stmt in d["blocking_assignment"]:
			new_tree = lark.Tree("statement", [stmt]);
			statement = Statement.from_tree(new_tree);
			assignemnts.extend(statement.get_assignments());
	
	# Adjust assignments where the left side is sliced
	# For instance, translate 'a[10:3] <= b;' into 'a <= {a[:11], b, a[2:]};'
	#adjust_sliced_assignments(assignemnts, variables_def)
	# Different approach from above, translate the following assignments:
	# a[0] <= 0; // unconditional
	# a[10:1] <= b; // conditional
	# Translate into: a <= {b, 0} // conditional
	# For now we do not handle multiple conditional ones
	adjust_sliced_assignments_constants(assignemnts, variables_def)


	# Add slicing when lhs and rhs have different bitwidths
	add_slicing_to_assignments(assignemnts, variables_def);


	assignements_var = {}
	# Arrange assignments per variable
	for assign in assignemnts:
		vars = assign.get_variable_names();
		assert len(vars) > 0, f"Assignment {assign} has no variable names";
		for v in vars:
			assert v in variables, f"Variable {v} not found in variables";
			if v not in assignements_var:
				assignements_var[v] = [];
			assignements_var[v].append(assign);


	# Add condition for the unconditional assignments where other assignments are conditional
	sorted_vars = sorted(variables.keys(), key=lambda x: variables[x]);
	for v in sorted_vars:
		if v not in assignements_var:
			# No assignments for this variable, skip it
			continue;
		assigns = assignements_var[v];
		unconditional_assigns = [a for a in assigns if a.get_condition() is None];
		assert len(unconditional_assigns) <= 1, f"Multiple unconditional assignments for variable {v}: {unconditional_assigns}";
		if len(unconditional_assigns) == 0 or len(assigns) == 1:
			# No unconditional assignment or only one assignment, no need to add condition
			continue;
		unconditional_assign = unconditional_assigns[0];
		condition = None;
		for assign in assigns:
			if assign == unconditional_assign:
				continue;
			cond = assign.get_condition();
			if condition is None:
				condition = Expression.not_expr(cond);
			else:
				condition = Expression.and_expr(Expression.not_expr(cond), condition);
		assert condition is not None, f"Condition for variable {v} is None";
		unconditional_assign.set_condition(condition);

	variables_all_info = {"id": variables, "def": variables_def};
	# Transform the assignments into the graph
	for v in sorted_vars:
		if v not in assignements_var:
			# No assignments for this variable, skip it
			continue;
		assigns = assignements_var[v];
		for assign in assigns:
			cond = assign.get_condition();
			# Add the assignment to the graph
			value = add_ast_expression(ast_graph, assign.get_rhs(), variables_all_info, variables_def[v].is_signed());
			if value is None:
				# This is a don't care assignment, skip it
				continue;
			if cond is None:
				assert len(assigns) == 1, f"Unconditional assignment for variable {v} with multiple assignments: {assigns}";
				cond = Expression(expr_type="regular_number", constant="1");
			add_node(ast_graph, NodeType.ASSIGNMENT, label = "=", bit_width = variables_def[v].get_bitwidth(), signed= variables_def[v].is_signed());
			cond = add_ast_expression(ast_graph, cond, variables_all_info, False);
			add_asg(ast_graph, variables[v], value, cond, variables, variables_def[v].get_bitwidth(), variables_def[v].is_signed());
	

	# Not sure how to handle module instantiations because we do not know which way to connect the nodes?
	for inst in d.get("module_instantiation", []):
		module = ModuleInstantiation.from_tree(inst);
		parse_external_module(ast_graph, module, assignements_var, variables_all_info, ports);
		#name      = inst.children[0];
		#assert name in module_parsers.keys(), f"Cannot parse unknown module '{name}'";
		#module_parsers[name](ast_graph, inst, assignments_per_variable, variables);


	# Need better port handling
	inputs  = set();
	outputs = set();
	for port in ports:
		p = port.get_name();
		node = variables[p];
		if len(list(ast_graph.in_edges(node))) == 0:
			ast_graph.nodes[node]['direction'] = PortDirection.INPUT;
			inputs.add(node);
		else:
			ast_graph.nodes[node]['direction'] = PortDirection.OUTPUT;
			outputs.add(node);

	# Added line to be compatible with the rest of the code
	g = ast_graph;
	


	#
	# Remove all value nodes without children
	#
	value_nodes = [n for n in g.nodes if g.nodes[n]['type'] != NodeType.VARIABLE];
	worklist = value_nodes.copy();
	while len(worklist) > 0:
		n = worklist.pop();
		if n not in g.nodes:
			continue;
		if len(list(g.successors(n))) == 0:
			worklist += [n for n in list(g.predecessors(n)) if g.nodes[n]['type'] != NodeType.VARIABLE];
			g.remove_node(n);
	value_dict = {};
	

	if not merge_only_vars:
		# Merge all value nodes with the same label
		for n in list(g.nodes):
			if not n in g.nodes:
				continue;
			if g.nodes[n]['type'] != NodeType.VALUE:
				continue;
			if g.nodes[n]['label'] in value_dict:
				other_node = value_dict[g.nodes[n]['label']];
				g = nx.contracted_nodes(g, other_node, n);
			else:
				value_dict[g.nodes[n]['label']] = n;


	for n in [n for n in g.nodes if g.nodes[n]['type'] == NodeType.VARIABLE]:
		preds = list(g.predecessors(n));
		if len(preds) != 1:
			continue;
		if g.nodes[get_value(g, preds[0])]['type'] == NodeType.VALUE and n not in inputs | outputs:
			g.add_edge(get_value(g, preds[0]), n, type = EdgeType.VALUE);
			g.nodes[n]['type'] = NodeType.CONSTANT;
			g.remove_node(preds[0]);


	# Mark operators as signed if any of their inputs are signed
	mark_signed_operators(g);

	#for value_node in [n for n in g.nodes if g.nodes[n]['type'] == NodeType.VALUE]:
	#	   succs =  list(g.successors(value_node));
	#	   for oe in list(g.out_edges(value_node, keys=True)):
	#			   v_for_s = add_node(g, g.nodes[value_node]['type'], label = g.nodes[value_node]['label'], bit_width = g.nodes[value_node]['bit_width']);
	#			   g.add_edge(v_for_s, oe[1], **g.out_edges[oe]);
	#	   g.remove_node(value_node);


	stall_nodes = [n for n in g.nodes if g.nodes[n]['label'] in stall_conditions];
	#for stall in stall_nodes:
	#	g.nodes[stall]['type']  = NodeType.VALUE;
	#	g.nodes[stall]['label'] = "1'b0";
	#	g.remove_nodes_from(list(g.predecessors(stall)));
	control_io = [n for n in g if named(g, n) in (control_inputs + control_outputs)] + stall_nodes;
	inputs  = inputs.intersection(set(g.nodes)).difference(set(control_io));
	outputs = outputs.intersection(set(g.nodes)).difference(set(control_io));

	#
	#  Create Memory nodes
	#
	
	import hace.hls_tool_specific.vivado as VIVADO;
	import hace.hls_tool_specific.legup  as LEGUP;
	import hace.memory_port as MEMORY;
	import re;

	memory_port_parsers = [
		LEGUP.parse,
		VIVADO.parse, 
	];
	
	
	# Find all memory ports
	ports = {};
	for k in inputs.union(outputs):
		for port_parse in memory_port_parsers:
			belongs_to_port = port_parse(named(g, k));
			if belongs_to_port is not None:
				ports[belongs_to_port[0]] = ports.get(belongs_to_port[0], []) + [(k , belongs_to_port[1])];
	
	# Group ports into memories
	ports = {p : { name : node  for node, name in ports[p] }
		for p in ports 
		if MEMORY.full_memory_sub.issubset({p[1] for p in ports[p]})
		or MEMORY.read_memory_sub.issubset({p[1] for p in ports[p]})
		or MEMORY.write_memory_sub.issubset({p[1] for p in ports[p]})
	};

	do_not_remove = set();

	# Create memory nodes
	for p in ports:
		outputs = outputs - set(ports[p].values());
		inputs  = inputs  - set(ports[p].values());
		# Determine bitwidth from read or write data port
		bitwidth_determining_node = ports[p][MEMORY.READ_DATA] if MEMORY.READ_DATA in ports[p] else ports[p][MEMORY.WRITE_DATA];
		bw = g.nodes[bitwidth_determining_node]['bit_width'];
		# Create memory node
		mem = add_node(g, NodeType.MEMORY_OP, bit_width = bw, label=f"MEMORY OPERATION on {p}", port = p, info = ports[p], signed=False);
		# Connect ports for enable, address, write enable, write data, read data
		g.add_edge(ports[p][MEMORY.ENABLE   ],                        mem, type=EdgeType.VALUE, index = 0);
		do_not_remove.add(ports[p][MEMORY.ENABLE]);
		g.add_edge(ports[p][MEMORY.ADDRESS  ],                        mem, type=EdgeType.VALUE, index = 1);
		do_not_remove.add(ports[p][MEMORY.ADDRESS]);
		if MEMORY.WRITE_ENABLE in ports[p]:
			g.add_edge(ports[p][MEMORY.WRITE_ENABLE], mem, type=EdgeType.VALUE, index = 2);
			do_not_remove.add(ports[p][MEMORY.WRITE_ENABLE]);
		if MEMORY.WRITE_DATA in ports[p]:
			g.add_edge(ports[p][MEMORY.WRITE_DATA], mem, type=EdgeType.VALUE, index = 3);
			do_not_remove.add(ports[p][MEMORY.WRITE_DATA]);

		if MEMORY.READ_DATA in ports[p]:
			c1           = add_node(g, NodeType.VALUE, bit_width = 1, label = "1", signed=False);
			asg_for_read = add_node(g, NodeType.ASSIGNMENT, bit_width = g.nodes[ports[p][MEMORY.READ_DATA]]['bit_width'], signed= g.nodes[ports[p][MEMORY.READ_DATA]]['signed']);
			g.add_edge(mem, asg_for_read, type=EdgeType.VALUE);
			g.add_edge(asg_for_read, ports[p][MEMORY.READ_DATA], type=EdgeType.VALUE);
			g.add_edge(c1, asg_for_read, type=EdgeType.CONDITION);
			do_not_remove.add(ports[p][MEMORY.READ_DATA]);

		for i, memory_io in enumerate([memory_io for memory_io in ports[p] if memory_io not in MEMORY.full_memory_sub and memory_io not in MEMORY.read_memory_sub]):
			g.remove_node(ports[p][memory_io]);

				



	graph = Graph(g, module_name, inputs, outputs);
	graph.control_io = control_io;

	return graph;



@check_invariants
@visualize_graphs
def translate_ast_to_ag(ast : lark.Tree) -> AssignmentGraph:
	old_graph = from_AST(ast);
	new_graph = AssignmentGraph(
		graph = nx.MultiDiGraph(),
		name = old_graph.name,
		do_not_remove = set(),
		control_io = old_graph.control_io,
		inputs  = old_graph.inputs,
		outputs = old_graph.outputs,
	);
	for old_node in old_graph.graph.nodes:
		# For now, all control io is zero
		if old_node in old_graph.control_io and old_graph.graph.nodes[old_node]['label'] not in start_inputs:
			old_graph.graph.nodes[old_node]['type'] = NodeType.VALUE;
			old_graph.graph.nodes[old_node]['label'] = "0";
		t = old_graph.graph.nodes[old_node]['type'];
		info : None | NodeKind;
		signed = Signedness.NOT_IMPLEMENTED if 'signed' not in old_graph.graph.nodes[old_node] else Signedness.Signed if old_graph.graph.nodes[old_node]['signed'] else Signedness.Unsigned;
		old_ies = list(old_graph.graph.in_edges(old_node, data=True));
		match t:
			case NodeType.VARIABLE:
				info = Variable(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed = signed,
					name   = old_graph.graph.nodes[old_node]['label'],
				);
			case NodeType.CONSTANT:
				value_node = list(old_graph.graph.predecessors(old_node))[0];
				value      = verilog_constant_to_int(old_graph.graph.nodes[value_node]['label']);
				info = Constant(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed    = signed,
					value     = value,
					name      = old_graph.graph.nodes[old_node]['label'],
				);
			case NodeType.VALUE:
				info = Value(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed    = signed,
					value     = verilog_constant_to_int(old_graph.graph.nodes[old_node]['label']),
				);
			case NodeType.OPERATOR:
				operation = old_graph.graph.nodes[old_node]['operator'];
				info = VerilogOp(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed    = signed,
					operation = operation,
					name = old_graph.graph.nodes[old_node]['label'] if operation == VerilogOperation.BLACKBOX else None,
				);
			case NodeType.ASSIGNMENT:
				info = AssignmentNode(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed    = signed,
				);
			case NodeType.MEMORY_OP:
				new_graph.do_not_remove |= set([ie[0] for ie in old_ies]);
				memory = old_graph.graph.nodes[old_node]['port'];
				info = MemoryOperation(
					bit_width = old_graph.graph.nodes[old_node]['bit_width'],
					signed    = signed,
					memory    = memory,
				);
			case _:
				assert False, f"Unhandled {t}";
		new_graph.graph.add_node(old_node, info = info);

		match t:
			case NodeType.CONSTANT | NodeType.VALUE:
				pass
			case NodeType.ASSIGNMENT:
				condition = get_condition(old_graph.graph, old_node);
				value     = get_value(old_graph.graph, old_node);
				new_graph.graph.add_edge(value,     old_node, 0, info = ValueEdge());
				new_graph.graph.add_edge(condition, old_node, 1, info = ConditionEdge());
			case NodeType.VARIABLE:
				for i, ie in enumerate(old_ies):
					new_graph.graph.add_edge(ie[0], ie[1], i, info = ValueEdge());
			case _:
				index_mapping = {ie[2]['index'] : ie for ie in old_ies};
				for index in index_mapping:
					edge_info : EdgeKind = ValueEdge() if index_mapping[index][2]['type'] == EdgeType.VALUE else ConditionEdge();
					new_graph.graph.add_edge(index_mapping[index][0], index_mapping[index][1], index, info = edge_info);
			


	return new_graph;
