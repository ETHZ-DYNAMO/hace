from enum import Enum, auto;

class VerilogOperation(Enum):
    # Automatically generate lowercase value for each enum member
    def _generate_next_value_(name, *_):
        return name.lower()
    # Binary operations
    BINARY_AND = auto()
    BINARY_OR = auto()
    BINARY_BITAND = auto()
    BINARY_XOR = auto()
    BINARY_XNOR = auto()
    BINARY_BITOR = auto()
    BINARY_EQ = auto()
    BINARY_NEQ = auto()
    BINARY_EQ_EXT = auto()
    BINARY_NEQ_EXT = auto()
    BINARY_LT = auto()
    BINARY_GT = auto()
    BINARY_LEQ = auto()
    BINARY_GEQ = auto()
    BINARY_RSHIFT = auto()
    BINARY_RSHIFT_EXT = auto()
    BINARY_LSHIFT = auto()
    BINARY_LSHIFT_EXT = auto()

    # Binary event operations
    BINARY_EVENT_AND = auto()
    BINARY_EVENT_OR = auto()

    # Arithmetic operations
    BINARY_ADD = auto()
    BINARY_SUB = auto()
    BINARY_MUL = auto()
    BINARY_DIV = auto()
    BINARY_MOD = auto()
    BINARY_POW = auto()

    # Unary operations
    UNARY_POS = auto()
    UNARY_NEG = auto()
    UNARY_NOT = auto()
    UNARY_INV = auto()
    UNARY_AND = auto()
    UNARY_OR = auto()
    UNARY_XOR = auto()
    UNARY_NAND = auto()
    UNARY_NOR = auto()
    UNARY_XNOR = auto()
    CONDITIONAL_EXPRESSION = auto()

    # Unary event operations
    UNARY_POSEDGE = auto()
    UNARY_NEGEDGE = auto()

    # Constants
    VARIABLE = auto()
    CONSTANT = auto()
    MACRO = auto()

    # Array operations
    ARRAY_CONCAT = auto()
    ARRAY_REPLICATE = auto()
    ARRAY_SLICE = auto()
    ARRAY_INDEX = auto()

    # Special operations
    FUNCTION_CALL = auto()

    # Signed operations
    FUNCTION_SIGNED = auto()


    # Signed operations
    FUNCTION_UNSIGNED = auto()

    # Event operations
    EVENT_INIT = auto()
    EVENT_COMB = auto()
    EVENT_ALWAYS = auto()

    # Miscellaneous
    UNKNOWN = auto()
    BLACKBOX = auto()

    # Assignments
    ASSIGN = auto()

comparisons = {
	VerilogOperation.BINARY_EQ: "==",
	VerilogOperation.BINARY_NEQ: "!=",
	VerilogOperation.BINARY_EQ_EXT: "===",
	VerilogOperation.BINARY_NEQ_EXT: "!==",
	VerilogOperation.BINARY_LT: "<",
	VerilogOperation.BINARY_GT: ">",
	VerilogOperation.BINARY_LEQ: "<=",
	VerilogOperation.BINARY_GEQ: ">=",
};

binary_logical = {
	VerilogOperation.BINARY_AND: "&&",
	VerilogOperation.BINARY_OR: "||",
	**comparisons,
};


binary = {
	**binary_logical,
	VerilogOperation.BINARY_BITAND: "&",
	VerilogOperation.BINARY_XOR: "^",
	VerilogOperation.BINARY_XNOR: "^~",
	VerilogOperation.BINARY_BITOR: "|",
	VerilogOperation.BINARY_RSHIFT: ">>",
	VerilogOperation.BINARY_RSHIFT_EXT: ">>>",
	VerilogOperation.BINARY_LSHIFT: "<<",
	VerilogOperation.BINARY_LSHIFT_EXT: "<<<",
	VerilogOperation.BINARY_ADD: "+",
	VerilogOperation.BINARY_SUB: "-",
	VerilogOperation.BINARY_MUL: "*",
	VerilogOperation.BINARY_DIV: "/",
	VerilogOperation.BINARY_MOD: "%",
	VerilogOperation.BINARY_POW: "**",
};

unary_1bit = {
	VerilogOperation.UNARY_NOT: "!",
	VerilogOperation.UNARY_AND: "&",
	VerilogOperation.UNARY_OR: "|",
	VerilogOperation.UNARY_XOR: "^",
	VerilogOperation.UNARY_NAND: "~&",
	VerilogOperation.UNARY_NOR: "~|",
	VerilogOperation.UNARY_XNOR: "~^",
};

unary = {
	VerilogOperation.UNARY_POS: "+",
	VerilogOperation.UNARY_NEG: "-",
	VerilogOperation.UNARY_INV: "~",
	**unary_1bit,
	# Signed operation
	VerilogOperation.FUNCTION_SIGNED: "signed",
	# Unsigned operation
	VerilogOperation.FUNCTION_UNSIGNED: "unsigned",
};

operations = {
	# Binary operations
	**binary,
	# Unary operations
	**unary,
	# Array operations
	VerilogOperation.ARRAY_CONCAT: "{{{}}}",
	VerilogOperation.ARRAY_REPLICATE: "{n{}}",
	VerilogOperation.ARRAY_SLICE: "[]",
	VerilogOperation.ARRAY_INDEX: "[]",
	# Conditional expression
	VerilogOperation.CONDITIONAL_EXPRESSION: "?:",
	# Event expressions
	VerilogOperation.UNARY_POSEDGE: "posedge",
	VerilogOperation.UNARY_NEGEDGE: "negedge",
	VerilogOperation.BINARY_EVENT_OR: "or",
	VerilogOperation.BINARY_EVENT_AND: "and",
	VerilogOperation.BLACKBOX: "Blackbox",
};


def verilog_constant_to_int(value : str) -> int:
	res : int | None = None;
	if "'d" in value:
		after_d = value[value.find('d') + 1:];
		res = int(after_d);
	elif "'b" in value:
		after_b = value[value.find('b') + 1:];
		res = int(after_b, base=2);
	elif "'h" in value:
		after_h = value[value.find('h') + 1:];
		res = int(after_h, base=16);
	else:
		res = int(value);
	assert res is not None;
	return res;
