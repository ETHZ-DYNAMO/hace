//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Tue Sep 23 19:20:31 2025
// ----------------------------------------------------------------------------
`define MEMORY_CONTROLLER_ADDR_SIZE 32
`define MEMORY_CONTROLLER_DATA_SIZE 64
// Number of RAM elements: 3
`define MEMORY_CONTROLLER_TAG_SIZE 9
`timescale 1 ns / 1 ns
module matrix
(
	clk,
	clk2x,
	clk1x_follower,
	reset,
	memory_controller_waitrequest,
	start,
	finish,
	arg_in_a,
	arg_in_b,
	arg_out_c,
	main_0_in_a_write_enable_a,
	main_0_in_a_in_a,
	main_0_in_a_byteena_a,
	main_0_in_a_enable_a,
	main_0_in_a_address_a,
	main_0_in_a_out_a,
	main_0_in_a_write_enable_b,
	main_0_in_a_in_b,
	main_0_in_a_byteena_b,
	main_0_in_a_enable_b,
	main_0_in_a_address_b,
	main_0_in_a_out_b,
	main_0_in_b_write_enable_a,
	main_0_in_b_in_a,
	main_0_in_b_byteena_a,
	main_0_in_b_enable_a,
	main_0_in_b_address_a,
	main_0_in_b_out_a,
	main_0_in_b_write_enable_b,
	main_0_in_b_in_b,
	main_0_in_b_byteena_b,
	main_0_in_b_enable_b,
	main_0_in_b_address_b,
	main_0_in_b_out_b,
	main_0_out_c_write_enable_a,
	main_0_out_c_in_a,
	main_0_out_c_byteena_a,
	main_0_out_c_enable_a,
	main_0_out_c_address_a,
	main_0_out_c_out_a,
	main_0_out_c_write_enable_b,
	main_0_out_c_in_b,
	main_0_out_c_byteena_b,
	main_0_out_c_enable_b,
	main_0_out_c_address_b,
	main_0_out_c_out_b
);

parameter [3:0] LEGUP_0 = 4'd0;
parameter [3:0] LEGUP_F_matrix_BB__1_1 = 4'd1;
parameter [3:0] LEGUP_F_matrix_BB__3_2 = 4'd2;
parameter [3:0] LEGUP_F_matrix_BB__3_3 = 4'd3;
parameter [3:0] LEGUP_F_matrix_BB__5_4 = 4'd4;
parameter [3:0] LEGUP_F_matrix_BB__5_5 = 4'd5;
parameter [3:0] LEGUP_F_matrix_BB__5_6 = 4'd6;
parameter [3:0] LEGUP_F_matrix_BB__5_7 = 4'd7;
parameter [3:0] LEGUP_F_matrix_BB__14_8 = 4'd8;
parameter [3:0] LEGUP_F_matrix_BB__14_9 = 4'd9;
parameter [3:0] LEGUP_F_matrix_BB__16_10 = 4'd10;
parameter [3:0] LEGUP_F_matrix_BB__16_11 = 4'd11;
parameter [3:0] LEGUP_F_matrix_BB__18_12 = 4'd12;

input  clk;
input  clk2x;
input  clk1x_follower;
input  reset;
input  memory_controller_waitrequest;
input  start;
output reg  finish;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_in_a;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_in_b;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_out_c;
output  main_0_in_a_write_enable_a;
output [31:0] main_0_in_a_in_a;
output  main_0_in_a_byteena_a;
output reg  main_0_in_a_enable_a;
output reg [9:0] main_0_in_a_address_a;
input [31:0] main_0_in_a_out_a;
output  main_0_in_a_write_enable_b;
output [31:0] main_0_in_a_in_b;
output  main_0_in_a_byteena_b;
output  main_0_in_a_enable_b;
output [9:0] main_0_in_a_address_b;
input [31:0] main_0_in_a_out_b;
output  main_0_in_b_write_enable_a;
output [31:0] main_0_in_b_in_a;
output  main_0_in_b_byteena_a;
output reg  main_0_in_b_enable_a;
output reg [9:0] main_0_in_b_address_a;
input [31:0] main_0_in_b_out_a;
output  main_0_in_b_write_enable_b;
output [31:0] main_0_in_b_in_b;
output  main_0_in_b_byteena_b;
output  main_0_in_b_enable_b;
output [9:0] main_0_in_b_address_b;
input [31:0] main_0_in_b_out_b;
output reg  main_0_out_c_write_enable_a;
output reg [31:0] main_0_out_c_in_a;
output  main_0_out_c_byteena_a;
output reg  main_0_out_c_enable_a;
output reg [9:0] main_0_out_c_address_a;
input [31:0] main_0_out_c_out_a;
output  main_0_out_c_write_enable_b;
output [31:0] main_0_out_c_in_b;
output  main_0_out_c_byteena_b;
output  main_0_out_c_enable_b;
output [9:0] main_0_out_c_address_b;
input [31:0] main_0_out_c_out_b;
reg [3:0] cur_state;
reg [3:0] next_state;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_in_a_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_in_b_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_out_c_reg;
reg  fsm_stall;
reg [5:0] matrix_1_i04;
reg [5:0] matrix_1_i04_reg;
reg [11:0] matrix_1_2;
reg [11:0] matrix_1_2_reg;
reg [31:0] matrix_3_j03;
reg [31:0] matrix_3_j03_reg;
reg [31:0] matrix_3_4;
reg [31:0] matrix_3_4_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] matrix_3_scevgep4;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] matrix_3_scevgep4_reg;
reg [31:0] matrix_5_sum_mult02;
reg [31:0] matrix_5_sum_mult02_reg;
reg [31:0] matrix_5_k01;
reg [31:0] matrix_5_k01_reg;
reg [31:0] matrix_5_6;
reg [31:0] matrix_5_6_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] matrix_5_scevgep2;
reg [31:0] matrix_5_7;
reg [31:0] matrix_5_8;
reg [31:0] matrix_5_8_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] matrix_5_scevgep;
reg [31:0] matrix_5_9;
reg [31:0] matrix_5_10;
reg [31:0] matrix_5_11;
reg [31:0] matrix_5_12;
reg [31:0] matrix_5_13;
reg [31:0] matrix_5_13_reg;
reg  matrix_5_exitcond2;
reg  matrix_5_exitcond2_reg;
reg [31:0] matrix_14_lcssa;
reg [31:0] matrix_14_lcssa_reg;
reg [31:0] matrix_14_15;
reg [31:0] matrix_14_15_reg;
reg  matrix_14_exitcond6;
reg [6:0] matrix_16_17;
reg [6:0] matrix_16_17_reg;
reg  matrix_16_exitcond;
reg  legup_mult_1_unsigned_32_32_1_0_clock;
reg  legup_mult_1_unsigned_32_32_1_0_aclr;
reg  legup_mult_1_unsigned_32_32_1_0_sum;
reg  legup_mult_1_unsigned_32_32_1_0_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_0_result;
reg [63:0] legup_mult_matrix_5_11_out_actual;
reg [31:0] legup_mult_matrix_5_11_out;
reg  legup_mult_matrix_5_11_en;

/*   %11 = mul nsw i32 %9, %10, !MSB !5, !LSB !2, !extendFrom !5*/
legup_mult_1 legup_mult_1_unsigned_32_32_1_0 (
	.clock (legup_mult_1_unsigned_32_32_1_0_clock),
	.aclr (legup_mult_1_unsigned_32_32_1_0_aclr),
	.sum (legup_mult_1_unsigned_32_32_1_0_sum),
	.clken (legup_mult_1_unsigned_32_32_1_0_clken),
	.dataa (legup_mult_1_unsigned_32_32_1_0_dataa),
	.datab (legup_mult_1_unsigned_32_32_1_0_datab),
	.result (legup_mult_1_unsigned_32_32_1_0_result)
);

defparam
	legup_mult_1_unsigned_32_32_1_0.widtha = 32,
	legup_mult_1_unsigned_32_32_1_0.widthb = 32,
	legup_mult_1_unsigned_32_32_1_0.widthp = 64,
	legup_mult_1_unsigned_32_32_1_0.representation = "UNSIGNED";

// Local Rams

// End Local Rams

always @(posedge clk) begin
if (reset == 1'b1)
	cur_state <= LEGUP_0;
else if (!fsm_stall)
	cur_state <= next_state;
end

always @(*)
begin
next_state = cur_state;
case(cur_state)  // synthesis parallel_case  
LEGUP_0:
	if ((fsm_stall == 1'd0) && (start == 1'd1))
		next_state = LEGUP_F_matrix_BB__1_1;
LEGUP_F_matrix_BB__14_8:
		next_state = LEGUP_F_matrix_BB__14_9;
LEGUP_F_matrix_BB__14_9:
	if ((fsm_stall == 1'd0) && (matrix_14_exitcond6 == 1'd1))
		next_state = LEGUP_F_matrix_BB__16_10;
	else if ((fsm_stall == 1'd0) && (matrix_14_exitcond6 == 1'd0))
		next_state = LEGUP_F_matrix_BB__3_2;
LEGUP_F_matrix_BB__16_10:
		next_state = LEGUP_F_matrix_BB__16_11;
LEGUP_F_matrix_BB__16_11:
	if ((fsm_stall == 1'd0) && (matrix_16_exitcond == 1'd1))
		next_state = LEGUP_F_matrix_BB__18_12;
	else if ((fsm_stall == 1'd0) && (matrix_16_exitcond == 1'd0))
		next_state = LEGUP_F_matrix_BB__1_1;
LEGUP_F_matrix_BB__18_12:
		next_state = LEGUP_0;
LEGUP_F_matrix_BB__1_1:
		next_state = LEGUP_F_matrix_BB__3_2;
LEGUP_F_matrix_BB__3_2:
		next_state = LEGUP_F_matrix_BB__3_3;
LEGUP_F_matrix_BB__3_3:
		next_state = LEGUP_F_matrix_BB__5_4;
LEGUP_F_matrix_BB__5_4:
		next_state = LEGUP_F_matrix_BB__5_5;
LEGUP_F_matrix_BB__5_5:
		next_state = LEGUP_F_matrix_BB__5_6;
LEGUP_F_matrix_BB__5_6:
		next_state = LEGUP_F_matrix_BB__5_7;
LEGUP_F_matrix_BB__5_7:
	if ((fsm_stall == 1'd0) && (matrix_5_exitcond2_reg == 1'd1))
		next_state = LEGUP_F_matrix_BB__14_8;
	else if ((fsm_stall == 1'd0) && (matrix_5_exitcond2_reg == 1'd0))
		next_state = LEGUP_F_matrix_BB__5_4;
default:
	next_state = cur_state;
endcase

end
always @(posedge clk) begin
	if (start) begin
		arg_in_a_reg <= arg_in_a;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_in_b_reg <= arg_in_b;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_out_c_reg <= arg_out_c;
	end
end
always @(*) begin
	fsm_stall = 1'd0;
	if (reset) begin
		fsm_stall = 1'd0;
	end
	if (memory_controller_waitrequest) begin
		fsm_stall = 1'd1;
	end
end
always @(*) begin
	/* matrix: %1*/
	/*   %i.04 = phi i32 [ 0, %0 ], [ %17, %16 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		matrix_1_i04 = 32'd0;
	end
	/* matrix: %1*/
	/*   %i.04 = phi i32 [ 0, %0 ], [ %17, %16 ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_matrix_BB__16_11) & (fsm_stall == 1'd0)) & (matrix_16_exitcond == 1'd0))) */ begin
		matrix_1_i04 = matrix_16_17_reg;
	end
end
always @(posedge clk) begin
	/* matrix: %1*/
	/*   %i.04 = phi i32 [ 0, %0 ], [ %17, %16 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		matrix_1_i04_reg <= matrix_1_i04;
	end
	/* matrix: %1*/
	/*   %i.04 = phi i32 [ 0, %0 ], [ %17, %16 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_matrix_BB__16_11) & (fsm_stall == 1'd0)) & (matrix_16_exitcond == 1'd0))) begin
		matrix_1_i04_reg <= matrix_1_i04;
	end
end
always @(*) begin
	/* matrix: %1*/
	/*   %2 = mul i32 %i.04, 32, !MSB !4, !LSB !3, !extendFrom !4*/
		matrix_1_2 = ({6'd0,matrix_1_i04_reg} * 32'd32);
end
always @(posedge clk) begin
	/* matrix: %1*/
	/*   %2 = mul i32 %i.04, 32, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_matrix_BB__1_1)) begin
		matrix_1_2_reg <= matrix_1_2;
	end
end
always @(*) begin
	/* matrix: %3*/
	/*   %j.03 = phi i32 [ 0, %1 ], [ %15, %14 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__1_1) & (fsm_stall == 1'd0))) begin
		matrix_3_j03 = 32'd0;
	end
	/* matrix: %3*/
	/*   %j.03 = phi i32 [ 0, %1 ], [ %15, %14 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_matrix_BB__14_9) & (fsm_stall == 1'd0)) & (matrix_14_exitcond6 == 1'd0))) */ begin
		matrix_3_j03 = matrix_14_15_reg;
	end
end
always @(posedge clk) begin
	/* matrix: %3*/
	/*   %j.03 = phi i32 [ 0, %1 ], [ %15, %14 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__1_1) & (fsm_stall == 1'd0))) begin
		matrix_3_j03_reg <= matrix_3_j03;
	end
	/* matrix: %3*/
	/*   %j.03 = phi i32 [ 0, %1 ], [ %15, %14 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_matrix_BB__14_9) & (fsm_stall == 1'd0)) & (matrix_14_exitcond6 == 1'd0))) begin
		matrix_3_j03_reg <= matrix_3_j03;
	end
end
always @(*) begin
	/* matrix: %3*/
	/*   %4 = add i32 %2, %j.03, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_3_4 = ({20'd0,matrix_1_2_reg} + matrix_3_j03_reg);
end
always @(posedge clk) begin
	/* matrix: %3*/
	/*   %4 = add i32 %2, %j.03, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__3_2)) begin
		matrix_3_4_reg <= matrix_3_4;
	end
end
always @(*) begin
	/* matrix: %3*/
	/*   %scevgep4 = getelementptr i32* %out_c, i32 %4, !MSB !1, !LSB !2, !extendFrom !1*/
		matrix_3_scevgep4 = (arg_out_c_reg + (4 * matrix_3_4_reg));
end
always @(posedge clk) begin
	/* matrix: %3*/
	/*   %scevgep4 = getelementptr i32* %out_c, i32 %4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__3_3)) begin
		matrix_3_scevgep4_reg <= matrix_3_scevgep4;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %sum_mult.02 = phi i32 [ 0, %3 ], [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__3_3) & (fsm_stall == 1'd0))) begin
		matrix_5_sum_mult02 = 32'd0;
	end
	/* matrix: %5*/
	/*   %sum_mult.02 = phi i32 [ 0, %3 ], [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_matrix_BB__5_7) & (fsm_stall == 1'd0)) & (matrix_5_exitcond2_reg == 1'd0))) */ begin
		matrix_5_sum_mult02 = matrix_5_12;
	end
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %sum_mult.02 = phi i32 [ 0, %3 ], [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__3_3) & (fsm_stall == 1'd0))) begin
		matrix_5_sum_mult02_reg <= matrix_5_sum_mult02;
	end
	/* matrix: %5*/
	/*   %sum_mult.02 = phi i32 [ 0, %3 ], [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_matrix_BB__5_7) & (fsm_stall == 1'd0)) & (matrix_5_exitcond2_reg == 1'd0))) begin
		matrix_5_sum_mult02_reg <= matrix_5_sum_mult02;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %k.01 = phi i32 [ 0, %3 ], [ %13, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__3_3) & (fsm_stall == 1'd0))) begin
		matrix_5_k01 = 32'd0;
	end
	/* matrix: %5*/
	/*   %k.01 = phi i32 [ 0, %3 ], [ %13, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_matrix_BB__5_7) & (fsm_stall == 1'd0)) & (matrix_5_exitcond2_reg == 1'd0))) */ begin
		matrix_5_k01 = matrix_5_13_reg;
	end
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %k.01 = phi i32 [ 0, %3 ], [ %13, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_matrix_BB__3_3) & (fsm_stall == 1'd0))) begin
		matrix_5_k01_reg <= matrix_5_k01;
	end
	/* matrix: %5*/
	/*   %k.01 = phi i32 [ 0, %3 ], [ %13, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_matrix_BB__5_7) & (fsm_stall == 1'd0)) & (matrix_5_exitcond2_reg == 1'd0))) begin
		matrix_5_k01_reg <= matrix_5_k01;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %6 = add i32 %2, %k.01, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_6 = ({20'd0,matrix_1_2_reg} + matrix_5_k01_reg);
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %6 = add i32 %2, %k.01, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_4)) begin
		matrix_5_6_reg <= matrix_5_6;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %scevgep2 = getelementptr i32* %in_a, i32 %6, !MSB !1, !LSB !2, !extendFrom !1*/
		matrix_5_scevgep2 = (arg_in_a_reg + (4 * matrix_5_6_reg));
end
always @(*) begin
	/* matrix: %5*/
	/*   %7 = mul i32 %k.01, 32, !MSB !5, !LSB !3, !extendFrom !5*/
		matrix_5_7 = (matrix_5_k01_reg * 32'd32);
end
always @(*) begin
	/* matrix: %5*/
	/*   %8 = add i32 %j.03, %7, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_8 = (matrix_3_j03_reg + matrix_5_7);
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %8 = add i32 %j.03, %7, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_4)) begin
		matrix_5_8_reg <= matrix_5_8;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %scevgep = getelementptr i32* %in_b, i32 %8, !MSB !1, !LSB !2, !extendFrom !1*/
		matrix_5_scevgep = (arg_in_b_reg + (4 * matrix_5_8_reg));
end
always @(*) begin
	/* matrix: %5*/
	/*   %9 = load i32* %scevgep2, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_9 = main_0_in_a_out_a;
end
always @(*) begin
	/* matrix: %5*/
	/*   %10 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_10 = main_0_in_b_out_a;
end
always @(*) begin
	matrix_5_11 = legup_mult_matrix_5_11_out;
end
always @(*) begin
	/* matrix: %5*/
	/*   %12 = add nsw i32 %sum_mult.02, %11, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_12 = (matrix_5_sum_mult02_reg + matrix_5_11);
end
always @(*) begin
	/* matrix: %5*/
	/*   %13 = add nsw i32 %k.01, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_5_13 = (matrix_5_k01_reg + 32'd1);
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %13 = add nsw i32 %k.01, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_4)) begin
		matrix_5_13_reg <= matrix_5_13;
	end
end
always @(*) begin
	/* matrix: %5*/
	/*   %exitcond2 = icmp eq i32 %13, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		matrix_5_exitcond2 = (matrix_5_13_reg == 32'd32);
end
always @(posedge clk) begin
	/* matrix: %5*/
	/*   %exitcond2 = icmp eq i32 %13, 32, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_matrix_BB__5_5)) begin
		matrix_5_exitcond2_reg <= matrix_5_exitcond2;
	end
end
always @(*) begin
	/* matrix: %14*/
	/*   %.lcssa = phi i32 [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_14_lcssa = matrix_5_12;
end
always @(posedge clk) begin
	/* matrix: %14*/
	/*   %.lcssa = phi i32 [ %12, %5 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_matrix_BB__5_7) & (fsm_stall == 1'd0)) & (matrix_5_exitcond2_reg == 1'd1))) begin
		matrix_14_lcssa_reg <= matrix_14_lcssa;
	end
end
always @(*) begin
	/* matrix: %14*/
	/*   %15 = add nsw i32 %j.03, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		matrix_14_15 = (matrix_3_j03_reg + 32'd1);
end
always @(posedge clk) begin
	/* matrix: %14*/
	/*   %15 = add nsw i32 %j.03, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__14_8)) begin
		matrix_14_15_reg <= matrix_14_15;
	end
end
always @(*) begin
	/* matrix: %14*/
	/*   %exitcond6 = icmp eq i32 %15, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		matrix_14_exitcond6 = (matrix_14_15_reg == 32'd32);
end
always @(*) begin
	/* matrix: %16*/
	/*   %17 = add nsw i32 %i.04, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		matrix_16_17 = ({1'd0,matrix_1_i04_reg} + 32'd1);
end
always @(posedge clk) begin
	/* matrix: %16*/
	/*   %17 = add nsw i32 %i.04, 1, !MSB !6, !LSB !2, !extendFrom !6*/
	if ((cur_state == LEGUP_F_matrix_BB__16_10)) begin
		matrix_16_17_reg <= matrix_16_17;
	end
end
always @(*) begin
	/* matrix: %16*/
	/*   %exitcond = icmp eq i32 %17, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		matrix_16_exitcond = (matrix_16_17_reg == 32'd32);
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_clock = clk;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_aclr = reset;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_sum = 1'd0;
if (reset) begin legup_mult_1_unsigned_32_32_1_0_sum = 0; end
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_clken = legup_mult_matrix_5_11_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_dataa = matrix_5_9;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_datab = matrix_5_10;
end
always @(*) begin
	legup_mult_matrix_5_11_out_actual = legup_mult_1_unsigned_32_32_1_0_result;
end
always @(*) begin
	legup_mult_matrix_5_11_out = legup_mult_matrix_5_11_out_actual[31:0];
end
always @(*) begin
	legup_mult_matrix_5_11_en = ~(fsm_stall);
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* matrix: %18*/
	/*   ret void, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__18_12)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
assign main_0_in_a_write_enable_a = 1'd0;
assign main_0_in_a_in_a = 0;
assign main_0_in_a_byteena_a = 1'd1;
always @(*) begin
	main_0_in_a_enable_a = 1'd0;
	/* matrix: %5*/
	/*   %9 = load i32* %scevgep2, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_5)) begin
		main_0_in_a_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_in_a_address_a = 10'd0;
	/* matrix: %5*/
	/*   %9 = load i32* %scevgep2, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_5)) begin
		main_0_in_a_address_a = (matrix_5_scevgep2 >>> 3'd2);
	end
end
assign main_0_in_a_write_enable_b = 1'd0;
assign main_0_in_a_in_b = 0;
assign main_0_in_a_byteena_b = 1'd1;
assign main_0_in_a_enable_b = 1'd0;
assign main_0_in_a_address_b = 10'd0;
assign main_0_in_b_write_enable_a = 1'd0;
assign main_0_in_b_in_a = 0;
assign main_0_in_b_byteena_a = 1'd1;
always @(*) begin
	main_0_in_b_enable_a = 1'd0;
	/* matrix: %5*/
	/*   %10 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_5)) begin
		main_0_in_b_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_in_b_address_a = 10'd0;
	/* matrix: %5*/
	/*   %10 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_matrix_BB__5_5)) begin
		main_0_in_b_address_a = (matrix_5_scevgep >>> 3'd2);
	end
end
assign main_0_in_b_write_enable_b = 1'd0;
assign main_0_in_b_in_b = 0;
assign main_0_in_b_byteena_b = 1'd1;
assign main_0_in_b_enable_b = 1'd0;
assign main_0_in_b_address_b = 10'd0;
always @(*) begin
	main_0_out_c_write_enable_a = 1'd0;
	/* matrix: %14*/
	/*   store i32 %.lcssa, i32* %scevgep4, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__14_8)) begin
		main_0_out_c_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_out_c_in_a = 0;
	/* matrix: %14*/
	/*   store i32 %.lcssa, i32* %scevgep4, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__14_8)) begin
		main_0_out_c_in_a = matrix_14_lcssa_reg;
	end
end
assign main_0_out_c_byteena_a = 1'd1;
always @(*) begin
	main_0_out_c_enable_a = 1'd0;
	/* matrix: %14*/
	/*   store i32 %.lcssa, i32* %scevgep4, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__14_8)) begin
		main_0_out_c_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_out_c_address_a = 10'd0;
	/* matrix: %14*/
	/*   store i32 %.lcssa, i32* %scevgep4, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_matrix_BB__14_8)) begin
		main_0_out_c_address_a = (matrix_3_scevgep4_reg >>> 3'd2);
	end
end
assign main_0_out_c_write_enable_b = 1'd0;
assign main_0_out_c_in_b = 0;
assign main_0_out_c_byteena_b = 1'd1;
assign main_0_out_c_enable_b = 1'd0;
assign main_0_out_c_address_b = 10'd0;

endmodule

