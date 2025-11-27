//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Thu Sep 25 17:26:07 2025
// ----------------------------------------------------------------------------
`define MEMORY_CONTROLLER_ADDR_SIZE 32
`define MEMORY_CONTROLLER_DATA_SIZE 64
// Number of RAM elements: 1
`define MEMORY_CONTROLLER_TAG_SIZE 9
`timescale 1 ns / 1 ns
module gsum
(
	clk,
	clk2x,
	clk1x_follower,
	reset,
	memory_controller_waitrequest,
	start,
	finish,
	return_val,
	arg_a,
	main_0_a_write_enable_a,
	main_0_a_in_a,
	main_0_a_byteena_a,
	main_0_a_enable_a,
	main_0_a_address_a,
	main_0_a_out_a,
	main_0_a_write_enable_b,
	main_0_a_in_b,
	main_0_a_byteena_b,
	main_0_a_enable_b,
	main_0_a_address_b,
	main_0_a_out_b
);

parameter [3:0] LEGUP_0 = 4'd0;
parameter [3:0] LEGUP_F_gsum_BB__1_1 = 4'd1;
parameter [3:0] LEGUP_F_gsum_BB__1_2 = 4'd2;
parameter [3:0] LEGUP_F_gsum_BB__4_3 = 4'd3;
parameter [3:0] LEGUP_F_gsum_BB__4_4 = 4'd4;
parameter [3:0] LEGUP_F_gsum_BB__4_5 = 4'd5;
parameter [3:0] LEGUP_F_gsum_BB__4_6 = 4'd6;
parameter [3:0] LEGUP_F_gsum_BB__4_7 = 4'd7;
parameter [3:0] LEGUP_F_gsum_BB__14_8 = 4'd8;
parameter [3:0] LEGUP_F_gsum_BB__16_9 = 4'd9;

input  clk;
input  clk2x;
input  clk1x_follower;
input  reset;
input  memory_controller_waitrequest;
input  start;
output reg  finish;
output reg [31:0] return_val;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_a;
output  main_0_a_write_enable_a;
output [31:0] main_0_a_in_a;
output  main_0_a_byteena_a;
output reg  main_0_a_enable_a;
output reg [9:0] main_0_a_address_a;
input [31:0] main_0_a_out_a;
output  main_0_a_write_enable_b;
output [31:0] main_0_a_in_b;
output  main_0_a_byteena_b;
output  main_0_a_enable_b;
output [9:0] main_0_a_address_b;
input [31:0] main_0_a_out_b;
reg [3:0] cur_state;
reg [3:0] next_state;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_a_reg;
reg  fsm_stall;
reg [31:0] gsum_1_s02;
reg [31:0] gsum_1_s02_reg;
reg [9:0] gsum_1_i01;
reg [9:0] gsum_1_i01_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] gsum_1_scevgep;
reg [31:0] gsum_1_2;
reg [31:0] gsum_1_2_reg;
reg  gsum_1_3;
reg [31:0] gsum_4_5;
reg [31:0] gsum_4_6;
reg [31:0] gsum_4_6_reg;
reg [31:0] gsum_4_7;
reg [31:0] gsum_4_7_reg;
reg [31:0] gsum_4_8;
reg [31:0] gsum_4_9;
reg [31:0] gsum_4_10;
reg [31:0] gsum_4_10_reg;
reg [31:0] gsum_4_11;
reg [31:0] gsum_4_11_reg;
reg [31:0] gsum_4_12;
reg [31:0] gsum_4_13;
reg [31:0] gsum_14_s1;
reg [31:0] gsum_14_s1_reg;
reg [10:0] gsum_14_15;
reg  gsum_14_exitcond;
reg [31:0] gsum_16_s1lcssa;
reg [31:0] gsum_16_s1lcssa_reg;
reg [2:0] gsum_1_3_op1_temp;
reg  legup_mult_1_unsigned_32_32_1_0_clock;
reg  legup_mult_1_unsigned_32_32_1_0_aclr;
reg  legup_mult_1_unsigned_32_32_1_0_sum;
reg  legup_mult_1_unsigned_32_32_1_0_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_0_result;
reg [63:0] legup_mult_gsum_4_6_out_actual;
reg [31:0] legup_mult_gsum_4_6_out;
reg  legup_mult_gsum_4_6_en;
reg  legup_mult_1_unsigned_32_32_1_1_clock;
reg  legup_mult_1_unsigned_32_32_1_1_aclr;
reg  legup_mult_1_unsigned_32_32_1_1_sum;
reg  legup_mult_1_unsigned_32_32_1_1_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_1_result;
reg [63:0] legup_mult_gsum_4_8_out_actual;
reg [31:0] legup_mult_gsum_4_8_out;
reg  legup_mult_gsum_4_8_en;
reg  legup_mult_1_unsigned_32_32_1_2_clock;
reg  legup_mult_1_unsigned_32_32_1_2_aclr;
reg  legup_mult_1_unsigned_32_32_1_2_sum;
reg  legup_mult_1_unsigned_32_32_1_2_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_2_result;
reg [63:0] legup_mult_gsum_4_10_out_actual;
reg [31:0] legup_mult_gsum_4_10_out;
reg  legup_mult_gsum_4_10_en;
reg  legup_mult_1_unsigned_32_32_1_3_clock;
reg  legup_mult_1_unsigned_32_32_1_3_aclr;
reg  legup_mult_1_unsigned_32_32_1_3_sum;
reg  legup_mult_1_unsigned_32_32_1_3_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_3_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_3_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_3_result;
reg [63:0] legup_mult_gsum_4_12_out_actual;
reg [31:0] legup_mult_gsum_4_12_out;
reg  legup_mult_gsum_4_12_en;

/*   %6 = mul nsw i32 %5, %2, !MSB !4, !LSB !3, !extendFrom !4*/
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

/*   %8 = mul nsw i32 %7, %2, !MSB !4, !LSB !3, !extendFrom !4*/
legup_mult_1 legup_mult_1_unsigned_32_32_1_1 (
	.clock (legup_mult_1_unsigned_32_32_1_1_clock),
	.aclr (legup_mult_1_unsigned_32_32_1_1_aclr),
	.sum (legup_mult_1_unsigned_32_32_1_1_sum),
	.clken (legup_mult_1_unsigned_32_32_1_1_clken),
	.dataa (legup_mult_1_unsigned_32_32_1_1_dataa),
	.datab (legup_mult_1_unsigned_32_32_1_1_datab),
	.result (legup_mult_1_unsigned_32_32_1_1_result)
);

defparam
	legup_mult_1_unsigned_32_32_1_1.widtha = 32,
	legup_mult_1_unsigned_32_32_1_1.widthb = 32,
	legup_mult_1_unsigned_32_32_1_1.widthp = 64,
	legup_mult_1_unsigned_32_32_1_1.representation = "UNSIGNED";

/*   %10 = mul nsw i32 %9, %2, !MSB !4, !LSB !3, !extendFrom !4*/
legup_mult_1 legup_mult_1_unsigned_32_32_1_2 (
	.clock (legup_mult_1_unsigned_32_32_1_2_clock),
	.aclr (legup_mult_1_unsigned_32_32_1_2_aclr),
	.sum (legup_mult_1_unsigned_32_32_1_2_sum),
	.clken (legup_mult_1_unsigned_32_32_1_2_clken),
	.dataa (legup_mult_1_unsigned_32_32_1_2_dataa),
	.datab (legup_mult_1_unsigned_32_32_1_2_datab),
	.result (legup_mult_1_unsigned_32_32_1_2_result)
);

defparam
	legup_mult_1_unsigned_32_32_1_2.widtha = 32,
	legup_mult_1_unsigned_32_32_1_2.widthb = 32,
	legup_mult_1_unsigned_32_32_1_2.widthp = 64,
	legup_mult_1_unsigned_32_32_1_2.representation = "UNSIGNED";

/*   %12 = mul nsw i32 %11, %2, !MSB !4, !LSB !3, !extendFrom !4*/
legup_mult_1 legup_mult_1_unsigned_32_32_1_3 (
	.clock (legup_mult_1_unsigned_32_32_1_3_clock),
	.aclr (legup_mult_1_unsigned_32_32_1_3_aclr),
	.sum (legup_mult_1_unsigned_32_32_1_3_sum),
	.clken (legup_mult_1_unsigned_32_32_1_3_clken),
	.dataa (legup_mult_1_unsigned_32_32_1_3_dataa),
	.datab (legup_mult_1_unsigned_32_32_1_3_datab),
	.result (legup_mult_1_unsigned_32_32_1_3_result)
);

defparam
	legup_mult_1_unsigned_32_32_1_3.widtha = 32,
	legup_mult_1_unsigned_32_32_1_3.widthb = 32,
	legup_mult_1_unsigned_32_32_1_3.widthp = 64,
	legup_mult_1_unsigned_32_32_1_3.representation = "UNSIGNED";

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
		next_state = LEGUP_F_gsum_BB__1_1;
LEGUP_F_gsum_BB__14_8:
	if ((fsm_stall == 1'd0) && (gsum_14_exitcond == 1'd1))
		next_state = LEGUP_F_gsum_BB__16_9;
	else if ((fsm_stall == 1'd0) && (gsum_14_exitcond == 1'd0))
		next_state = LEGUP_F_gsum_BB__1_1;
LEGUP_F_gsum_BB__16_9:
		next_state = LEGUP_0;
LEGUP_F_gsum_BB__1_1:
		next_state = LEGUP_F_gsum_BB__1_2;
LEGUP_F_gsum_BB__1_2:
	if ((fsm_stall == 1'd0) && (gsum_1_3 == 1'd1))
		next_state = LEGUP_F_gsum_BB__4_3;
	else if ((fsm_stall == 1'd0) && (gsum_1_3 == 1'd0))
		next_state = LEGUP_F_gsum_BB__14_8;
LEGUP_F_gsum_BB__4_3:
		next_state = LEGUP_F_gsum_BB__4_4;
LEGUP_F_gsum_BB__4_4:
		next_state = LEGUP_F_gsum_BB__4_5;
LEGUP_F_gsum_BB__4_5:
		next_state = LEGUP_F_gsum_BB__4_6;
LEGUP_F_gsum_BB__4_6:
		next_state = LEGUP_F_gsum_BB__4_7;
LEGUP_F_gsum_BB__4_7:
		next_state = LEGUP_F_gsum_BB__14_8;
default:
	next_state = cur_state;
endcase

end
always @(posedge clk) begin
	if (start) begin
		arg_a_reg <= arg_a;
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
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_s02 = 32'd0;
	end
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_gsum_BB__14_8) & (fsm_stall == 1'd0)) & (gsum_14_exitcond == 1'd0))) */ begin
		gsum_1_s02 = gsum_14_s1_reg;
	end
end
always @(posedge clk) begin
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_s02_reg <= gsum_1_s02;
	end
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__14_8) & (fsm_stall == 1'd0)) & (gsum_14_exitcond == 1'd0))) begin
		gsum_1_s02_reg <= gsum_1_s02;
	end
end
always @(*) begin
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %15, %14 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_i01 = 32'd0;
	end
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %15, %14 ], !MSB !5, !LSB !3, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_gsum_BB__14_8) & (fsm_stall == 1'd0)) & (gsum_14_exitcond == 1'd0))) */ begin
		gsum_1_i01 = gsum_14_15;
	end
end
always @(posedge clk) begin
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %15, %14 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_i01_reg <= gsum_1_i01;
	end
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %15, %14 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_gsum_BB__14_8) & (fsm_stall == 1'd0)) & (gsum_14_exitcond == 1'd0))) begin
		gsum_1_i01_reg <= gsum_1_i01;
	end
end
always @(*) begin
	/* gsum: %1*/
	/*   %scevgep = getelementptr i32* %a, i32 %i.01, !MSB !2, !LSB !3, !extendFrom !2*/
		gsum_1_scevgep = (arg_a_reg + (4 * {22'd0,gsum_1_i01_reg}));
end
always @(*) begin
	/* gsum: %1*/
	/*   %2 = load i32* %scevgep, align 4, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_1_2 = main_0_a_out_a;
end
always @(posedge clk) begin
	/* gsum: %1*/
	/*   %2 = load i32* %scevgep, align 4, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__1_2)) begin
		gsum_1_2_reg <= gsum_1_2;
	end
end
always @(*) begin
	/* gsum: %1*/
	/*   %3 = icmp sgt i32 %2, 3, !MSB !3, !LSB !3, !extendFrom !3*/
		gsum_1_3 = ($signed(gsum_1_2) > $signed({29'd0,gsum_1_3_op1_temp}));
end
always @(*) begin
	/* gsum: %4*/
	/*   %5 = add nsw i32 %2, 3, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_5 = (gsum_1_2_reg + 32'd3);
end
always @(*) begin
	gsum_4_6 = legup_mult_gsum_4_6_out;
end
always @(posedge clk) begin
	/* gsum: %4*/
	/*   %6 = mul nsw i32 %5, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_4)) begin
		gsum_4_6_reg <= gsum_4_6;
	end
	/* gsum: %4*/
	/*   %6 = mul nsw i32 %5, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_4)) begin
		gsum_4_6_reg <= gsum_4_6;
	end
end
always @(*) begin
	/* gsum: %4*/
	/*   %7 = add nsw i32 %6, 5, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_7 = (gsum_4_6_reg + 32'd5);
end
always @(posedge clk) begin
	/* gsum: %4*/
	/*   %7 = add nsw i32 %6, 5, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_3)) begin
		gsum_4_7_reg <= gsum_4_7;
	end
end
always @(*) begin
	gsum_4_8 = legup_mult_gsum_4_8_out;
end
always @(*) begin
	/* gsum: %4*/
	/*   %9 = add nsw i32 %8, 7, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_9 = (gsum_4_8 + 32'd7);
end
always @(*) begin
	gsum_4_10 = legup_mult_gsum_4_10_out;
end
always @(posedge clk) begin
	/* gsum: %4*/
	/*   %10 = mul nsw i32 %9, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_6)) begin
		gsum_4_10_reg <= gsum_4_10;
	end
	/* gsum: %4*/
	/*   %10 = mul nsw i32 %9, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_6)) begin
		gsum_4_10_reg <= gsum_4_10;
	end
end
always @(*) begin
	/* gsum: %4*/
	/*   %11 = add nsw i32 %10, 12, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_11 = (gsum_4_10_reg + 32'd12);
end
always @(posedge clk) begin
	/* gsum: %4*/
	/*   %11 = add nsw i32 %10, 12, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_3)) begin
		gsum_4_11_reg <= gsum_4_11;
	end
end
always @(*) begin
	gsum_4_12 = legup_mult_gsum_4_12_out;
end
always @(*) begin
	/* gsum: %4*/
	/*   %13 = add nsw i32 %s.02, %12, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_13 = (gsum_1_s02_reg + gsum_4_12);
end
always @(*) begin
	/* gsum: %14*/
	/*   %s.1 = phi i32 [ %13, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__1_2) & (fsm_stall == 1'd0)) & (gsum_1_3 == 1'd0))) begin
		gsum_14_s1 = gsum_1_s02_reg;
	end
	/* gsum: %14*/
	/*   %s.1 = phi i32 [ %13, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	else /* if (((cur_state == LEGUP_F_gsum_BB__4_7) & (fsm_stall == 1'd0))) */ begin
		gsum_14_s1 = gsum_4_13;
	end
end
always @(posedge clk) begin
	/* gsum: %14*/
	/*   %s.1 = phi i32 [ %13, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__1_2) & (fsm_stall == 1'd0)) & (gsum_1_3 == 1'd0))) begin
		gsum_14_s1_reg <= gsum_14_s1;
	end
	/* gsum: %14*/
	/*   %s.1 = phi i32 [ %13, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if (((cur_state == LEGUP_F_gsum_BB__4_7) & (fsm_stall == 1'd0))) begin
		gsum_14_s1_reg <= gsum_14_s1;
	end
end
always @(*) begin
	/* gsum: %14*/
	/*   %15 = add nsw i32 %i.01, 1, !MSB !6, !LSB !3, !extendFrom !6*/
		gsum_14_15 = ({1'd0,gsum_1_i01_reg} + 32'd1);
end
always @(*) begin
	/* gsum: %14*/
	/*   %exitcond = icmp eq i32 %15, 1000, !MSB !3, !LSB !3, !extendFrom !3*/
		gsum_14_exitcond = (gsum_14_15 == 32'd1000);
end
always @(*) begin
	/* gsum: %16*/
	/*   %s.1.lcssa = phi i32 [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_16_s1lcssa = gsum_14_s1_reg;
end
always @(posedge clk) begin
	/* gsum: %16*/
	/*   %s.1.lcssa = phi i32 [ %s.1, %14 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__14_8) & (fsm_stall == 1'd0)) & (gsum_14_exitcond == 1'd1))) begin
		gsum_16_s1lcssa_reg <= gsum_16_s1lcssa;
	end
end
always @(*) begin
	gsum_1_3_op1_temp = 32'd3;
if (reset) begin gsum_1_3_op1_temp = 0; end
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
	legup_mult_1_unsigned_32_32_1_0_clken = legup_mult_gsum_4_6_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_dataa = gsum_4_5;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_6_out_actual = legup_mult_1_unsigned_32_32_1_0_result;
end
always @(*) begin
	legup_mult_gsum_4_6_out = legup_mult_gsum_4_6_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_6_en = ~(fsm_stall);
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_clock = clk;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_aclr = reset;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_sum = 1'd0;
if (reset) begin legup_mult_1_unsigned_32_32_1_1_sum = 0; end
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_clken = legup_mult_gsum_4_8_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_dataa = gsum_4_7_reg;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_8_out_actual = legup_mult_1_unsigned_32_32_1_1_result;
end
always @(*) begin
	legup_mult_gsum_4_8_out = legup_mult_gsum_4_8_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_8_en = ~(fsm_stall);
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_clock = clk;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_aclr = reset;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_sum = 1'd0;
if (reset) begin legup_mult_1_unsigned_32_32_1_2_sum = 0; end
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_clken = legup_mult_gsum_4_10_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_dataa = gsum_4_9;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_10_out_actual = legup_mult_1_unsigned_32_32_1_2_result;
end
always @(*) begin
	legup_mult_gsum_4_10_out = legup_mult_gsum_4_10_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_10_en = ~(fsm_stall);
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_clock = clk;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_aclr = reset;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_sum = 1'd0;
if (reset) begin legup_mult_1_unsigned_32_32_1_3_sum = 0; end
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_clken = legup_mult_gsum_4_12_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_dataa = gsum_4_11_reg;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_12_out_actual = legup_mult_1_unsigned_32_32_1_3_result;
end
always @(*) begin
	legup_mult_gsum_4_12_out = legup_mult_gsum_4_12_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_12_en = ~(fsm_stall);
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* gsum: %16*/
	/*   ret i32 %s.1.lcssa, !MSB !2, !LSB !3, !extendFrom !2*/
	if ((cur_state == LEGUP_F_gsum_BB__16_9)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		return_val <= 0;
	end
	/* gsum: %16*/
	/*   ret i32 %s.1.lcssa, !MSB !2, !LSB !3, !extendFrom !2*/
	if ((cur_state == LEGUP_F_gsum_BB__16_9)) begin
		return_val <= gsum_16_s1lcssa_reg;
	end
end
assign main_0_a_write_enable_a = 1'd0;
assign main_0_a_in_a = 0;
assign main_0_a_byteena_a = 1'd1;
always @(*) begin
	main_0_a_enable_a = 1'd0;
	/* gsum: %1*/
	/*   %2 = load i32* %scevgep, align 4, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__1_1)) begin
		main_0_a_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_a_address_a = 10'd0;
	/* gsum: %1*/
	/*   %2 = load i32* %scevgep, align 4, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__1_1)) begin
		main_0_a_address_a = (gsum_1_scevgep >>> 3'd2);
	end
end
assign main_0_a_write_enable_b = 1'd0;
assign main_0_a_in_b = 0;
assign main_0_a_byteena_b = 1'd1;
assign main_0_a_enable_b = 1'd0;
assign main_0_a_address_b = 10'd0;

endmodule
