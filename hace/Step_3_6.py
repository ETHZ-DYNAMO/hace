import networkx as nx;
from hace.type_info import *;
from hace.invariants import check_invariants;
from hace.debug import visualize_graphs;
from hace.graph_util import node_info_of, get_in_edges_by_index, remap_edges, edge_info_of;
from hace.errors import error_if_false;
from hace.mlir import *;


def convert_to_bit_width(graph : CDFG, node : Node, target_bw : int, new_node : Node):
	assert node in graph.bb_of_node, f"{node}";
	node_info = node_info_of(graph, node);
	if not isinstance(node_info, NodeWithValue):
		return;
	if node_info.bit_width == target_bw:
		return;
	operation = (MLIR_OP.EXTSI if node_info.signed == Signedness.Signed else MLIR_OP.EXTUI) if target_bw > node_info.bit_width else MLIR_OP.TRUNCI
	graph.graph.add_node(new_node, info = 
		MlirValue(
			bit_width = target_bw,	
			signed = node_info.signed,
			operation = operation.value,
	));
	graph.graph.add_edge(node, new_node, 0, info = ValueEdge());
	graph.bb_of_node[new_node] = graph.bb_of_node[node];

@visualize_graphs
@check_invariants
def convert_nodes_to_mlir(graph : CDFG) -> CDFG:
	new_node_id = max(graph.graph.nodes) + 1;
	nodes_per_bitwidth_used : Dict[Tuple[Node, int], Node] = {
		(n, cast(NodeWithValue, node_info_of(graph, n)).bit_width) : n 
		for n in graph.bb_of_node
		if isinstance(node_info_of(graph, n), NodeWithValue)
	};

	for n in list(graph.bb_of_node):
		n_info = node_info_of(graph, n);
		if not isinstance(n_info, NodeWithValue):
			continue;
		in_edges_by_index = get_in_edges_by_index(graph, n)
		target_bw : Dict[int, int] = {
			index : n_info.bit_width
			for index in in_edges_by_index
		};

		if isinstance(n_info, VerilogOp):
			if n_info.operation in OP_TO_COMPARISON:
				max_bw = max([cast(NodeWithValue, node_info_of(graph, in_edges_by_index[index][0])).bit_width
				for index in in_edges_by_index]);
				target_bw = { index : max_bw for index in in_edges_by_index };
			elif n_info.operation == VerilogOperation.CONDITIONAL_EXPRESSION:
				target_bw[2] = 1;
			elif n_info.operation in [VerilogOperation.ARRAY_CONCAT, VerilogOperation.ARRAY_REPLICATE]:
				target_bw = {
					index : cast(NodeWithValue, node_info_of(graph, in_edges_by_index[index][0])).bit_width
					for index in in_edges_by_index
				};
			elif n_info.operation in [VerilogOperation.ARRAY_SLICE, VerilogOperation.ARRAY_INDEX]:
				target_bw = {
					index : cast(NodeWithValue, node_info_of(graph, in_edges_by_index[index][0])).bit_width
					for index in in_edges_by_index
				};
			
		elif isinstance(n_info, BranchNode):
			target_bw = { index : 1 for index in in_edges_by_index };
		
		for index in in_edges_by_index:
			if (in_edges_by_index[index][0], target_bw[index]) not in nodes_per_bitwidth_used:
				nodes_per_bitwidth_used[(in_edges_by_index[index][0], target_bw[index])] = new_node_id; new_node_id += 1;


		for ie in list(graph.graph.in_edges(n, keys=True)):
			info = edge_info_of(graph, ie);
			graph.graph.remove_edge(*ie);
			graph.graph.add_edge(nodes_per_bitwidth_used[(ie[0], target_bw[ie[2]])], ie[1], ie[2], info = info);
			
	for n, bw in nodes_per_bitwidth_used:
		if not isinstance(node_info_of(graph, n), NodeWithValue):
			continue;
		if n != nodes_per_bitwidth_used[(n, bw)]:
			convert_to_bit_width(graph, n, bw, nodes_per_bitwidth_used[(n, bw)]);

	return graph;

def find_phi_input_in_bb_or_dominator(graph : CDFGWithDominator, bb : Node, phi : Node) -> Node:
	input_nodes = list(graph.graph.predecessors(phi));
	input_nodes_per_bb : Dict[Node, Node] = {
		graph.bb_of_node[n] : n 
		for n in input_nodes
	};
	current_bb : Node | None = bb;
	while current_bb is not None:
		if current_bb in input_nodes_per_bb:
			return input_nodes_per_bb[current_bb];
		dominating_bbs = list(graph.dominator_tree.predecessors(current_bb));
		if not dominating_bbs:
			break;
		current_bb = dominating_bbs[0];
	error_if_false(False, f"Did not find an input for Phi {phi} for bb {bb}", graph);
	assert False;


def argument_list_func(graph : CDFG, nodes : List[Node]) -> str:
	res = ", ".join([f"%{node} : {mlir_type_of_node(graph, node)}" for node in nodes]);
	return res;

def argument_list_bb(graph : CDFG, nodes : List[Node]) -> str:
	res_values = ", ".join([f"%{node}" for node in nodes]);
	res_types =  ", ".join([f"{mlir_type_of_node(graph, node)}" for node in nodes]);
	return f"{res_values} : {res_types}";

def serialize_mlir(graph : CDFGWithDominator, node : Node, phis_per_bb : Dict[Node, List[Node]]) -> List[str]:
	assert node in graph.bb_of_node;

	node_info = node_info_of(graph, node);
	node_type = mlir_type_of_node(graph, node) if isinstance(node_info, NodeWithValue) else "";
	node_bb = graph.bb_of_node[node];
	in_edge_mapping = get_in_edges_by_index(graph, node);
	input : Dict[int, Node] = {
		index : ie[0]
		for index, ie in in_edge_mapping.items()
	};
	input_type : Dict[int, str] = {
		ie[2] : mlir_type_of_node(graph, ie[0])
		for ie in in_edge_mapping.values()
	};
	res : List[str] = [];
	if isinstance(node_info, Value):
		res = [ MLIR_OP.CONST.value.format(node = node, node_type = node_type, value = node_info.value) ];
	elif isinstance(node_info, VerilogOp):
		if node_info.operation in OP_TO_COMPARISON:
			comparison = OP_TO_COMPARISON[node_info.operation];
			if comparison not in ["eq", "ne"]:
				comparison = comparison.replace("u", "s") if node_info.signed == Signedness.Signed else comparison;
			res += [
				MLIR_OP.CMPI.value.format(node = node, input = input, input_type = input_type, comparison = comparison),
			];

		else:
			match node_info.operation:
				case VerilogOperation.UNARY_NOT:
					value = list(graph.graph.predecessors(node))[0];
					res += [
						MLIR_OP.CONST.value.format(node = f"c0.{node}", node_type = node_type, value = 0),
						MLIR_OP.CMPI.value.format(node = node,
						 comparison = OP_TO_COMPARISON[VerilogOperation.BINARY_EQ],
						 input = {0 : input[0], 1 : f"c0.{node}"}, input_type = {0 : node_type}),

					];
				case VerilogOperation.BINARY_AND | VerilogOperation.BINARY_BITAND:
					error_if_false(0 in input and 1 in input, f"Binary and has not both inputs {node}", graph);
					res += [
						MLIR_OP.ANDI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.BINARY_BITOR:
					res += [
						MLIR_OP.ORI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.BINARY_RSHIFT_EXT:
					res += [
						MLIR_OP.SHRSI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.BINARY_LSHIFT:
					res += [
						MLIR_OP.SHLI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.BINARY_MUL:
					res += [
						MLIR_OP.MULI.value.format(node = node, node_type = node_type, input = input)
					];
				case VerilogOperation.BINARY_ADD:
					res += [
						MLIR_OP.ADDI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.BINARY_SUB:
					res += [
						MLIR_OP.SUBI.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.FUNCTION_SIGNED:
					res += [
						MLIR_OP.BITCAST.value.format(node = node, node_type = node_type, input = input, input_type = input_type),
					];
				case VerilogOperation.CONDITIONAL_EXPRESSION:
					res += [
						MLIR_OP.SELECT.value.format(node = node, node_type = node_type, input = input),
					];
				case VerilogOperation.UNARY_NEG:
					res += [
						MLIR_OP.CONST.value.format (node = f"cn1.{node}", value = -1, node_type = node_type),
						MLIR_OP.MULI.value.format(node = node, input = { 0 : input[0], 1 : f"cn1.{node}"}, node_type = node_type),
					];
				case VerilogOperation.ARRAY_CONCAT:
					res += [
						(MLIR_OP.EXTUI if cast(NodeWithValue, node_info_of(graph, ie[0])).bit_width < node_info.bit_width else MLIR_OP.BITCAST if cast(NodeWithValue, node_info_of(graph, ie[0])).bit_width == node_info.bit_width else MLIR_OP.TRUNCI ) .value.format(node = f"ext.{node}.{ie[0]}", node_type = node_type, input_type = {0 : input_type[ie[2]]}, input = { 0 : ie[0]})	
						for i, ie in in_edge_mapping.items()
					];
					suffix_sum = {
						outter_ie[2] : sum([cast(NodeWithValue, node_info_of(graph, ie[0])).bit_width for ie in in_edge_mapping.values() if ie[2] > outter_ie[2]])
						for outter_ie in in_edge_mapping.values()
					};
					res += sum([
						[MLIR_OP.CONST.value.format(node = f"c.{node}.{ie[0]}", node_type = node_type, value = suffix_sum[ie[2]]),
						MLIR_OP.SHLI.value.format(node = f"shift.{node}.{ie[0]}", node_type = node_type, input = { 0 : f"ext.{node}.{ie[0]}", 1 : f"c.{node}.{ie[0]}"})
						] for i, ie in in_edge_mapping.items()
					], []);
					res += [
						MLIR_OP.CONST.value.format(node = f"c0.{node}", node_type = node_type, value = 0),
					];
					to_reduce : List[str] = ([ f"c0.{node}"] if len(in_edge_mapping.keys()) == 1 else []) + [
						f"shift.{node}.{ie[0]}" for i, ie in in_edge_mapping.items()
					];

					it = 0;
					while len(to_reduce) > 2:
						it += 1;
						a = to_reduce.pop();
						b = to_reduce.pop();
						reduced = f"reduce.{node}.{it}";
						res += [
							MLIR_OP.ORI.value.format(node = reduced, node_type = node_type, input = {0 : a, 1 : b}),
						];
						to_reduce += [reduced];
						pass 
					error_if_false(len(to_reduce) == 2, f"CONCAT after reduction with {len(to_reduce)} on node {node}", graph);
					res += [
						MLIR_OP.ORI.value.format(node = node, node_type = node_type, input = {0 : to_reduce[0], 1 : to_reduce[1]})
					];
				case VerilogOperation.BLACKBOX:
					name = node_info.name;
					error_if_false(name is not None, f"Blackbox without a name {node}", graph);
					input_list = ", ".join([ f"%{input[index]}" for index in input ]);
					input_list_type = ", ".join([ mlir_type_of_node(graph, input[index]) for index in input ]);
					res += [
						MLIR_OP.CALL.value.format(node = node, procedure = name, input_list = input_list, input_list_type = input_list_type, node_type = node_type),
					];
				case VerilogOperation.ARRAY_INDEX:
					value_node         = input[0];
					value_node_type = mlir_type_of_node(graph, value_node);
					bit_position_node  = input[1];
					bit_position_info = node_info_of(graph, bit_position_node);
					assert isinstance(bit_position_info, Value);
					res += [
						MLIR_OP.CONST.value.format(node = f"const.{node}", node_type = value_node_type, value = bit_position_info.value),
						MLIR_OP.SHRUI.value.format(node = f"shifted.{node}", node_type = value_node_type, input = { 0 : value_node, 1 : f"const.{node}"}),
						MLIR_OP.TRUNCI.value.format(node = node, node_type = node_type, input = { 0 : f"shifted.{node}"}, input_type = { 0 : value_node_type }),
					];
				case VerilogOperation.ARRAY_REPLICATE:
					number_to_replicate = input[0];
					value_to_replicate = input[1];
					value_to_replicate_info = node_info_of(graph, value_to_replicate);

					number_to_replicate_info = node_info_of(graph, number_to_replicate);
					error_if_false(isinstance(number_to_replicate_info, Value), f"n in n{{}} needs to be a compile time known", graph);
					assert isinstance(number_to_replicate_info, Value);
					assert isinstance(value_to_replicate_info, NodeWithValue);
					res += [
						MLIR_OP.CONST.value.format(node = f"repl.{node}.or{0}", value = 0, node_type = node_type),
					];
					error_if_false(value_to_replicate_info.bit_width * number_to_replicate_info.value == node_info.bit_width, f"Expected Replication to replicate entire resulting bit width {node}\n{value_to_replicate_info.bit_width} * {number_to_replicate_info.value} != {node_info.bit_width}", graph);
					extended = str(value_to_replicate);
					if value_to_replicate_info.bit_width != node_info.bit_width:
						pass
						extended = f"repl.{node}.extended.{value_to_replicate}";
						res += [
							MLIR_OP.EXTUI.value.format(node = extended, input = {0 : value_to_replicate}, input_type = { 0 : mlir_type_of_node(graph, value_to_replicate)}, node_type = node_type)
						];
					res += sum([
						[
						MLIR_OP.CONST.value.format(node = f"repl.{node}.shift_ammount.{i}", value = i * value_to_replicate_info.bit_width, node_type = node_type),
						MLIR_OP.SHLI.value.format(node = f"repl.{node}.shifted{i}", input = { 0 : extended, 1 : f"repl.{node}.shift_ammount.{i}"}, node_type = node_type),
						MLIR_OP.ORI.value.format(node = f"repl.{node}.or{i + 1}", input = {0 : f"repl.{node}.or{i}", 1 : f"repl.{node}.shifted{i}"}, node_type = node_type)
						] for i in range(number_to_replicate_info.value)
					], [])
					res += [
						MLIR_OP.ORI.value.format(node = node, input = { 0 : f"repl.{node}.or{number_to_replicate_info.value}", 1 : f"repl.{node}.or0"}, node_type = node_type)
					];
				case VerilogOperation.ARRAY_SLICE:
					lower_pos = input[2];
					upper_pos = input[1];
					value     = input[0];
					value_info = node_info_of(graph, value);
					assert isinstance(value_info, NodeWithValue);
					value_type = mlir_type_of_info(value_info);
					lower_info = node_info_of(graph, lower_pos);
					assert isinstance(lower_info, Value);
					cast_op = MLIR_OP.TRUNCI if value_info.bit_width > node_info.bit_width else MLIR_OP.BITCAST;
					res += [
						MLIR_OP.CONST.value.format(node = f"slice.{node}.lower", value = lower_info.value, node_type = value_type),
						MLIR_OP.SHRUI.value.format(node = f"slice.{node}", input = {0 : value, 1 : f"slice.{node}.lower"}, node_type = value_type),
						cast_op.value.format(node = node, node_type = node_type, input = {0 : f"slice.{node}"}, input_type = {0 : value_type})
					];
					pass
				case VerilogOperation.FUNCTION_UNSIGNED:
					res += [
						MLIR_OP.BITCAST.value.format(node = node, node_type = node_type, input = input, input_type = input_type),
					];
				case _:
					error_if_false(False, f"Unhandled {node_info.operation} in MLIR serialization\nNode {node}", graph);
	elif isinstance(node_info, UnconditionalBranch):
		operands_sorted = [
			find_phi_input_in_bb_or_dominator(graph, node_bb, phi) for phi in phis_per_bb[node_info.target]
		];
		operands = "(" + argument_list_bb(graph, operands_sorted) + ")" if operands_sorted else "";
		res = [
			MLIR_OP.BRANCH.value.format(dest = node_info.target, operands = operands),
		];
	elif isinstance(node_info, ConditionalBranch):
		input_to_phis_then = [ find_phi_input_in_bb_or_dominator(graph, node_bb, phi) for phi in phis_per_bb[node_info.then_bb] ];
		input_to_phis_else = [ find_phi_input_in_bb_or_dominator(graph, node_bb, phi) for phi in phis_per_bb[node_info.else_bb] ];
		operands_then = "(" + argument_list_bb(graph, input_to_phis_then) + ")" if input_to_phis_then else "";
		operands_else = "(" + argument_list_bb(graph, input_to_phis_else) + ")" if input_to_phis_else else "";
		res = [
			MLIR_OP.COND_BRANCH.value.format(condition = in_edge_mapping[0][0], bb_then = node_info.then_bb, bb_else = node_info.else_bb, operands_then = operands_then, operands_else = operands_else),
		];
	elif isinstance(node_info, Return):
		returns = argument_list_bb(graph, [list(graph.graph.predecessors(ret))[0] for ret in graph.return_values]) if graph.return_values else "";
		res = [
			MLIR_OP.RETURN.value.format(returns = returns),
		];
	elif isinstance(node_info, MlirValue):
		res = [
			node_info.operation.format(node = node, node_type = mlir_type_of_info(node_info), input = input, input_type = input_type),
		];
	elif isinstance(node_info, Load):
		addr_node = f"addr.{node}";
		res = [
			MLIR_OP.GEP.value.format(node = addr_node, memory = node_info.memory, input = input, input_type = input_type, memory_type = mlir_type_of_info(node_info)),
			MLIR_OP.LOAD.value.format(node = node, node_type = mlir_type_of_info(node_info), input = {1: addr_node}),
		]
	elif isinstance(node_info, Store):
		addr_node = f"addr.{node}";
		res = [
			MLIR_OP.GEP.value.format(node = addr_node, memory = node_info.memory, input = input, input_type = input_type, memory_type = mlir_type_of_info(node_info)),
			MLIR_OP.STORE.value.format(input = {1 : addr_node, 3 : input[3]}, input_type = {3 : input_type[3]}),
		]
		
	else:
		error_if_false(False, f"Unhandled {type(node_info)} in MLIR serialization", graph);

	return res;




@check_invariants
@visualize_graphs
def generate_mlir(graph : CDFG, shim : str) -> Tuple[CDFG, str]:
	graph = convert_nodes_to_mlir(graph);
	dominator_tree = nx.DiGraph();
	idoms = nx.immediate_dominators(graph.graph, graph.start_bb);
	_ = [dominator_tree.add_edge(idoms[n], n) for n in idoms if n != idoms[n]];
	graph = CDFGWithDominator(**graph.__dict__, dominator_tree = dominator_tree, return_values = sorted(list(graph.outputs), key = lambda a:cast(ReturnValue, node_info_of(graph, a)).name));
	
	nodes_per_bb : Dict[Node, List[Node]] = {bb : [] for bb in graph.basic_blocks};
	for n in graph.graph.nodes:
		if n in graph.bb_of_node:
			nodes_per_bb[graph.bb_of_node[n]] += [n];
	nodes_per_bb_without_special_nodes : Dict[Node, Set[Node]] = {
		bb : {node for node in nodes_per_bb[bb]
			if not isinstance(node_info_of(graph, node), Phi)
			if not isinstance(node_info_of(graph, node), ArgumentNode)
			if not isinstance(node_info_of(graph, node), ReturnValue)
			if not isinstance(node_info_of(graph, node), Return)
			if not isinstance(node_info_of(graph, node), ConditionalBranch)
			if not isinstance(node_info_of(graph, node), UnconditionalBranch)
		}
		for bb in graph.basic_blocks
	};

	phis_per_bb : Dict[Node, List[Node]] = {
		bb : list(sorted([phi for phi in nodes_per_bb[bb] if isinstance(node_info_of(graph, phi), Phi)]))
		for bb in graph.basic_blocks
	};
	topo_sorted_nodes_per_bb : Dict[Node, List[Node]] = {
		bb : list(nx.topological_sort(graph.graph.subgraph(nodes_per_bb_without_special_nodes[bb])))
		for bb in graph.basic_blocks
	};
	# There ever is only one terminator node per BB!
	block_terminator_per_bb : Dict[Node, Node] = {
		bb : [terminator for terminator in nodes_per_bb[bb]
			if type(node_info_of(graph, terminator)) in [Return, ConditionalBranch, UnconditionalBranch]
		][0] for bb in graph.basic_blocks
	};
	mlir_per_bb = {
		bb : sum([serialize_mlir(graph, node, phis_per_bb) for node in topo_sorted_nodes_per_bb[bb]], [])
		+ serialize_mlir(graph, block_terminator_per_bb[bb], phis_per_bb)
		 for bb in topo_sorted_nodes_per_bb
	};
	sorted_bbs = sum([list(layer) for layer in nx.bfs_layers(graph.graph.subgraph(set(graph.basic_blocks)), graph.start_bb)], []);
	error_if_false(sorted_bbs[0] == graph.start_bb, f"Expected the Starting BB {graph.start_bb} to be the first bb, but it was {sorted_bbs[0]}", graph);
	mlir = shim;
	arguments : List[Node] = sorted([node for node in graph.graph.nodes if isinstance(node_info_of(graph, node), ArgumentNode)], key = lambda a:cast(ArgumentNode, node_info_of(graph, a)).name);
	for a in arguments:
		mlir += f"//{a} = {cast(ArgumentNode, node_info_of(graph, a)).name}\n";
	memory_arguments : List[str] = [f"%{mem} : !llvm.ptr" for mem in sorted(list({
		cast(Load, node_info_of(graph, node)).memory for node in graph.bb_of_node
		if isinstance(node_info_of(graph, node), Load)
	} | {
		cast(Store, node_info_of(graph, node)).memory for node in graph.bb_of_node
		if isinstance(node_info_of(graph, node), Store)
	}))];
	return_types     : List[str] = [mlir_type_of_node(graph, ret) for ret in graph.outputs];
	mlir += f"func.func @HACE.{graph.name}({argument_list_func(graph, arguments)}{', ' if arguments and memory_arguments else ''}{', '.join(memory_arguments) if memory_arguments else ''}) {'-> (' + ', '.join(return_types) + ')' if return_types else ''}\n";
	mlir += "{\n";
	basic_blocks = {
		bb : '\n'.join(["\t" + stmt for stmt in mlir_per_bb[bb]]) for bb in sorted_bbs
	};
	basic_blocks_with_headers = [
		(f"^bb{bb}({argument_list_func(graph, phis_per_bb[bb]) if phis_per_bb[bb] else ''}):\n" if bb != graph.start_bb else "") + basic_blocks[bb] for bb in sorted_bbs
	];
	mlir += '\n'.join(basic_blocks_with_headers);
	mlir += "\n}\n";
	
	return graph, mlir;
