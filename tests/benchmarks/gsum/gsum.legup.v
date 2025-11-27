//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Sat Oct  5 10:10:13 2024
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

parameter [2:0] LEGUP_0 = 3'd0;
parameter [2:0] LEGUP_F_gsum_BB__1_1 = 3'd1;
parameter [2:0] LEGUP_F_gsum_BB__1_2 = 3'd2;
parameter [2:0] LEGUP_F_gsum_BB__4_3 = 3'd3;
parameter [2:0] LEGUP_F_gsum_BB__4_4 = 3'd4;
parameter [2:0] LEGUP_F_gsum_BB__4_5 = 3'd5;
parameter [2:0] LEGUP_F_gsum_BB__10_6 = 3'd6;
parameter [2:0] LEGUP_F_gsum_BB__12_7 = 3'd7;

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
reg [2:0] cur_state;
reg [2:0] next_state;
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
reg [31:0] gsum_4_5_reg;
reg [31:0] gsum_4_6;
reg [31:0] gsum_4_6_reg;
reg [31:0] gsum_4_7;
reg [31:0] gsum_4_8;
reg [31:0] gsum_4_9;
reg [31:0] gsum_10_s1;
reg [31:0] gsum_10_s1_reg;
reg [10:0] gsum_10_11;
reg  gsum_10_exitcond;
reg [31:0] gsum_12_s1lcssa;
reg [31:0] gsum_12_s1lcssa_reg;
reg  legup_mult_1_unsigned_32_32_1_0_clock;
reg  legup_mult_1_unsigned_32_32_1_0_aclr;
reg  legup_mult_1_unsigned_32_32_1_0_sum;
reg  legup_mult_1_unsigned_32_32_1_0_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_0_result;
reg [63:0] legup_mult_gsum_4_5_out_actual;
reg [31:0] legup_mult_gsum_4_5_out;
reg  legup_mult_gsum_4_5_en;
reg  legup_mult_1_unsigned_32_32_1_1_clock;
reg  legup_mult_1_unsigned_32_32_1_1_aclr;
reg  legup_mult_1_unsigned_32_32_1_1_sum;
reg  legup_mult_1_unsigned_32_32_1_1_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_1_result;
reg [63:0] legup_mult_gsum_4_6_out_actual;
reg [31:0] legup_mult_gsum_4_6_out;
reg  legup_mult_gsum_4_6_en;
reg  legup_mult_1_unsigned_32_32_1_2_clock;
reg  legup_mult_1_unsigned_32_32_1_2_aclr;
reg  legup_mult_1_unsigned_32_32_1_2_sum;
reg  legup_mult_1_unsigned_32_32_1_2_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_2_result;
reg [63:0] legup_mult_gsum_4_7_out_actual;
reg [31:0] legup_mult_gsum_4_7_out;
reg  legup_mult_gsum_4_7_en;
reg  legup_mult_1_unsigned_32_32_1_3_clock;
reg  legup_mult_1_unsigned_32_32_1_3_aclr;
reg  legup_mult_1_unsigned_32_32_1_3_sum;
reg  legup_mult_1_unsigned_32_32_1_3_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_3_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_3_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_3_result;
reg [63:0] legup_mult_gsum_4_8_out_actual;
reg [31:0] legup_mult_gsum_4_8_out;
reg  legup_mult_gsum_4_8_en;

/*   %5 = mul nsw i32 %2, %2, !MSB !4, !LSB !3, !extendFrom !4*/
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

/*   %6 = mul nsw i32 %5, %2, !MSB !4, !LSB !3, !extendFrom !4*/
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

/*   %7 = mul nsw i32 %6, %2, !MSB !4, !LSB !3, !extendFrom !4*/
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

/*   %8 = mul nsw i32 %7, %2, !MSB !4, !LSB !3, !extendFrom !4*/
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
LEGUP_F_gsum_BB__10_6:
	if ((fsm_stall == 1'd0) && (gsum_10_exitcond == 1'd1))
		next_state = LEGUP_F_gsum_BB__12_7;
	else if ((fsm_stall == 1'd0) && (gsum_10_exitcond == 1'd0))
		next_state = LEGUP_F_gsum_BB__1_1;
LEGUP_F_gsum_BB__12_7:
		next_state = LEGUP_0;
LEGUP_F_gsum_BB__1_1:
		next_state = LEGUP_F_gsum_BB__1_2;
LEGUP_F_gsum_BB__1_2:
	if ((fsm_stall == 1'd0) && (gsum_1_3 == 1'd1))
		next_state = LEGUP_F_gsum_BB__4_3;
	else if ((fsm_stall == 1'd0) && (gsum_1_3 == 1'd0))
		next_state = LEGUP_F_gsum_BB__10_6;
LEGUP_F_gsum_BB__4_3:
		next_state = LEGUP_F_gsum_BB__4_4;
LEGUP_F_gsum_BB__4_4:
		next_state = LEGUP_F_gsum_BB__4_5;
LEGUP_F_gsum_BB__4_5:
		next_state = LEGUP_F_gsum_BB__10_6;
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
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_s02 = 32'd0;
	end
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_gsum_BB__10_6) & (fsm_stall == 1'd0)) & (gsum_10_exitcond == 1'd0))) */ begin
		gsum_1_s02 = gsum_10_s1_reg;
	end
end
always @(posedge clk) begin
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_s02_reg <= gsum_1_s02;
	end
	/* gsum: %1*/
	/*   %s.02 = phi i32 [ 0, %0 ], [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__10_6) & (fsm_stall == 1'd0)) & (gsum_10_exitcond == 1'd0))) begin
		gsum_1_s02_reg <= gsum_1_s02;
	end
end
always @(*) begin
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %11, %10 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_i01 = 32'd0;
	end
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %11, %10 ], !MSB !5, !LSB !3, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_gsum_BB__10_6) & (fsm_stall == 1'd0)) & (gsum_10_exitcond == 1'd0))) */ begin
		gsum_1_i01 = gsum_10_11;
	end
end
always @(posedge clk) begin
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %11, %10 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		gsum_1_i01_reg <= gsum_1_i01;
	end
	/* gsum: %1*/
	/*   %i.01 = phi i32 [ 0, %0 ], [ %11, %10 ], !MSB !5, !LSB !3, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_gsum_BB__10_6) & (fsm_stall == 1'd0)) & (gsum_10_exitcond == 1'd0))) begin
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
	/*   %3 = icmp sgt i32 %2, -1, !MSB !3, !LSB !3, !extendFrom !3*/
		gsum_1_3 = ($signed(gsum_1_2) > $signed($signed(-32'd1)));
end
always @(*) begin
	gsum_4_5 = legup_mult_gsum_4_5_out;
end
always @(posedge clk) begin
	/* gsum: %4*/
	/*   %5 = mul nsw i32 %2, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_4)) begin
		gsum_4_5_reg <= gsum_4_5;
	end
	/* gsum: %4*/
	/*   %5 = mul nsw i32 %2, %2, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_gsum_BB__4_4)) begin
		gsum_4_5_reg <= gsum_4_5;
	end
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
	gsum_4_7 = legup_mult_gsum_4_7_out;
end
always @(*) begin
	gsum_4_8 = legup_mult_gsum_4_8_out;
end
always @(*) begin
	/* gsum: %4*/
	/*   %9 = add nsw i32 %s.02, %8, !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_4_9 = (gsum_1_s02_reg + gsum_4_8);
end
always @(*) begin
	/* gsum: %10*/
	/*   %s.1 = phi i32 [ %9, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__1_2) & (fsm_stall == 1'd0)) & (gsum_1_3 == 1'd0))) begin
		gsum_10_s1 = gsum_1_s02_reg;
	end
	/* gsum: %10*/
	/*   %s.1 = phi i32 [ %9, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	else /* if (((cur_state == LEGUP_F_gsum_BB__4_5) & (fsm_stall == 1'd0))) */ begin
		gsum_10_s1 = gsum_4_9;
	end
end
always @(posedge clk) begin
	/* gsum: %10*/
	/*   %s.1 = phi i32 [ %9, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__1_2) & (fsm_stall == 1'd0)) & (gsum_1_3 == 1'd0))) begin
		gsum_10_s1_reg <= gsum_10_s1;
	end
	/* gsum: %10*/
	/*   %s.1 = phi i32 [ %9, %4 ], [ %s.02, %1 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if (((cur_state == LEGUP_F_gsum_BB__4_5) & (fsm_stall == 1'd0))) begin
		gsum_10_s1_reg <= gsum_10_s1;
	end
end
always @(*) begin
	/* gsum: %10*/
	/*   %11 = add nsw i32 %i.01, 1, !MSB !6, !LSB !3, !extendFrom !6*/
		gsum_10_11 = ({1'd0,gsum_1_i01_reg} + 32'd1);
end
always @(*) begin
	/* gsum: %10*/
	/*   %exitcond = icmp eq i32 %11, 1000, !MSB !3, !LSB !3, !extendFrom !3*/
		gsum_10_exitcond = (gsum_10_11 == 32'd1000);
end
always @(*) begin
	/* gsum: %12*/
	/*   %s.1.lcssa = phi i32 [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
		gsum_12_s1lcssa = gsum_10_s1_reg;
end
always @(posedge clk) begin
	/* gsum: %12*/
	/*   %s.1.lcssa = phi i32 [ %s.1, %10 ], !MSB !4, !LSB !3, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_gsum_BB__10_6) & (fsm_stall == 1'd0)) & (gsum_10_exitcond == 1'd1))) begin
		gsum_12_s1lcssa_reg <= gsum_12_s1lcssa;
	end
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
	legup_mult_1_unsigned_32_32_1_0_clken = legup_mult_gsum_4_5_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_dataa = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_5_out_actual = legup_mult_1_unsigned_32_32_1_0_result;
end
always @(*) begin
	legup_mult_gsum_4_5_out = legup_mult_gsum_4_5_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_5_en = ~(fsm_stall);
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
	legup_mult_1_unsigned_32_32_1_1_clken = legup_mult_gsum_4_6_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_dataa = gsum_4_5_reg;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_6_out_actual = legup_mult_1_unsigned_32_32_1_1_result;
end
always @(*) begin
	legup_mult_gsum_4_6_out = legup_mult_gsum_4_6_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_6_en = ~(fsm_stall);
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
	legup_mult_1_unsigned_32_32_1_2_clken = legup_mult_gsum_4_7_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_dataa = gsum_4_6_reg;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_7_out_actual = legup_mult_1_unsigned_32_32_1_2_result;
end
always @(*) begin
	legup_mult_gsum_4_7_out = legup_mult_gsum_4_7_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_7_en = ~(fsm_stall);
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
	legup_mult_1_unsigned_32_32_1_3_clken = legup_mult_gsum_4_8_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_dataa = gsum_4_7;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_3_datab = gsum_1_2_reg;
end
always @(*) begin
	legup_mult_gsum_4_8_out_actual = legup_mult_1_unsigned_32_32_1_3_result;
end
always @(*) begin
	legup_mult_gsum_4_8_out = legup_mult_gsum_4_8_out_actual[31:0];
end
always @(*) begin
	legup_mult_gsum_4_8_en = ~(fsm_stall);
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* gsum: %12*/
	/*   ret i32 %s.1.lcssa, !MSB !2, !LSB !3, !extendFrom !2*/
	if ((cur_state == LEGUP_F_gsum_BB__12_7)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		return_val <= 0;
	end
	/* gsum: %12*/
	/*   ret i32 %s.1.lcssa, !MSB !2, !LSB !3, !extendFrom !2*/
	if ((cur_state == LEGUP_F_gsum_BB__12_7)) begin
		return_val <= gsum_12_s1lcssa_reg;
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
