//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Sat Oct  5 08:59:42 2024
// ----------------------------------------------------------------------------
`define MEMORY_CONTROLLER_ADDR_SIZE 32
`define MEMORY_CONTROLLER_DATA_SIZE 64
// Number of RAM elements: 7
`define MEMORY_CONTROLLER_TAG_SIZE 9
`timescale 1 ns / 1 ns
module kernel_3mm
(
	clk,
	clk2x,
	clk1x_follower,
	reset,
	memory_controller_waitrequest,
	start,
	finish,
	arg_A,
	arg_B,
	arg_C,
	arg_D,
	arg_E,
	arg_F,
	arg_G,
	main_0_E_write_enable_a,
	main_0_E_in_a,
	main_0_E_byteena_a,
	main_0_E_enable_a,
	main_0_E_address_a,
	main_0_E_out_a,
	main_0_E_write_enable_b,
	main_0_E_in_b,
	main_0_E_byteena_b,
	main_0_E_enable_b,
	main_0_E_address_b,
	main_0_E_out_b,
	main_0_A_write_enable_a,
	main_0_A_in_a,
	main_0_A_byteena_a,
	main_0_A_enable_a,
	main_0_A_address_a,
	main_0_A_out_a,
	main_0_A_write_enable_b,
	main_0_A_in_b,
	main_0_A_byteena_b,
	main_0_A_enable_b,
	main_0_A_address_b,
	main_0_A_out_b,
	main_0_B_write_enable_a,
	main_0_B_in_a,
	main_0_B_byteena_a,
	main_0_B_enable_a,
	main_0_B_address_a,
	main_0_B_out_a,
	main_0_B_write_enable_b,
	main_0_B_in_b,
	main_0_B_byteena_b,
	main_0_B_enable_b,
	main_0_B_address_b,
	main_0_B_out_b,
	main_0_F_write_enable_a,
	main_0_F_in_a,
	main_0_F_byteena_a,
	main_0_F_enable_a,
	main_0_F_address_a,
	main_0_F_out_a,
	main_0_F_write_enable_b,
	main_0_F_in_b,
	main_0_F_byteena_b,
	main_0_F_enable_b,
	main_0_F_address_b,
	main_0_F_out_b,
	main_0_C_write_enable_a,
	main_0_C_in_a,
	main_0_C_byteena_a,
	main_0_C_enable_a,
	main_0_C_address_a,
	main_0_C_out_a,
	main_0_C_write_enable_b,
	main_0_C_in_b,
	main_0_C_byteena_b,
	main_0_C_enable_b,
	main_0_C_address_b,
	main_0_C_out_b,
	main_0_D_write_enable_a,
	main_0_D_in_a,
	main_0_D_byteena_a,
	main_0_D_enable_a,
	main_0_D_address_a,
	main_0_D_out_a,
	main_0_D_write_enable_b,
	main_0_D_in_b,
	main_0_D_byteena_b,
	main_0_D_enable_b,
	main_0_D_address_b,
	main_0_D_out_b,
	main_0_G_write_enable_a,
	main_0_G_in_a,
	main_0_G_byteena_a,
	main_0_G_enable_a,
	main_0_G_address_a,
	main_0_G_out_a,
	main_0_G_write_enable_b,
	main_0_G_in_b,
	main_0_G_byteena_b,
	main_0_G_enable_b,
	main_0_G_address_b,
	main_0_G_out_b
);

parameter [4:0] LEGUP_0 = 5'd0;
parameter [4:0] LEGUP_F_kernel_3mm_BB__1_1 = 5'd1;
parameter [4:0] LEGUP_F_kernel_3mm_BB__3_2 = 5'd2;
parameter [4:0] LEGUP_F_kernel_3mm_BB__3_3 = 5'd3;
parameter [4:0] LEGUP_F_kernel_3mm_BB__6_4 = 5'd4;
parameter [4:0] LEGUP_F_kernel_3mm_BB__6_5 = 5'd5;
parameter [4:0] LEGUP_F_kernel_3mm_BB__6_6 = 5'd6;
parameter [4:0] LEGUP_F_kernel_3mm_BB__15_7 = 5'd7;
parameter [4:0] LEGUP_F_kernel_3mm_BB__15_8 = 5'd8;
parameter [4:0] LEGUP_F_kernel_3mm_BB__17_9 = 5'd9;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheader1preheaderpreheader_10 = 5'd10;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheader1preheader_11 = 5'd11;
parameter [4:0] LEGUP_F_kernel_3mm_BB__20_12 = 5'd12;
parameter [4:0] LEGUP_F_kernel_3mm_BB__20_13 = 5'd13;
parameter [4:0] LEGUP_F_kernel_3mm_BB__23_14 = 5'd14;
parameter [4:0] LEGUP_F_kernel_3mm_BB__23_15 = 5'd15;
parameter [4:0] LEGUP_F_kernel_3mm_BB__23_16 = 5'd16;
parameter [4:0] LEGUP_F_kernel_3mm_BB__32_17 = 5'd17;
parameter [4:0] LEGUP_F_kernel_3mm_BB__32_18 = 5'd18;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheader1_19 = 5'd19;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheaderpreheaderpreheader_20 = 5'd20;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheaderpreheader_21 = 5'd21;
parameter [4:0] LEGUP_F_kernel_3mm_BB__36_22 = 5'd22;
parameter [4:0] LEGUP_F_kernel_3mm_BB__36_23 = 5'd23;
parameter [4:0] LEGUP_F_kernel_3mm_BB__39_24 = 5'd24;
parameter [4:0] LEGUP_F_kernel_3mm_BB__39_25 = 5'd25;
parameter [4:0] LEGUP_F_kernel_3mm_BB__39_26 = 5'd26;
parameter [4:0] LEGUP_F_kernel_3mm_BB__48_27 = 5'd27;
parameter [4:0] LEGUP_F_kernel_3mm_BB__48_28 = 5'd28;
parameter [4:0] LEGUP_F_kernel_3mm_BB_preheader_29 = 5'd29;
parameter [4:0] LEGUP_F_kernel_3mm_BB__51_30 = 5'd30;

input  clk;
input  clk2x;
input  clk1x_follower;
input  reset;
input  memory_controller_waitrequest;
input  start;
output reg  finish;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_A;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_B;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_C;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_D;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_E;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_F;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_G;
output reg  main_0_E_write_enable_a;
output reg [31:0] main_0_E_in_a;
output  main_0_E_byteena_a;
output reg  main_0_E_enable_a;
output reg [5:0] main_0_E_address_a;
input [31:0] main_0_E_out_a;
output  main_0_E_write_enable_b;
output [31:0] main_0_E_in_b;
output  main_0_E_byteena_b;
output  main_0_E_enable_b;
output [5:0] main_0_E_address_b;
input [31:0] main_0_E_out_b;
output  main_0_A_write_enable_a;
output [31:0] main_0_A_in_a;
output  main_0_A_byteena_a;
output reg  main_0_A_enable_a;
output reg [5:0] main_0_A_address_a;
input [31:0] main_0_A_out_a;
output  main_0_A_write_enable_b;
output [31:0] main_0_A_in_b;
output  main_0_A_byteena_b;
output  main_0_A_enable_b;
output [5:0] main_0_A_address_b;
input [31:0] main_0_A_out_b;
output  main_0_B_write_enable_a;
output [31:0] main_0_B_in_a;
output  main_0_B_byteena_a;
output reg  main_0_B_enable_a;
output reg [5:0] main_0_B_address_a;
input [31:0] main_0_B_out_a;
output  main_0_B_write_enable_b;
output [31:0] main_0_B_in_b;
output  main_0_B_byteena_b;
output  main_0_B_enable_b;
output [5:0] main_0_B_address_b;
input [31:0] main_0_B_out_b;
output reg  main_0_F_write_enable_a;
output reg [31:0] main_0_F_in_a;
output  main_0_F_byteena_a;
output reg  main_0_F_enable_a;
output reg [5:0] main_0_F_address_a;
input [31:0] main_0_F_out_a;
output  main_0_F_write_enable_b;
output [31:0] main_0_F_in_b;
output  main_0_F_byteena_b;
output  main_0_F_enable_b;
output [5:0] main_0_F_address_b;
input [31:0] main_0_F_out_b;
output  main_0_C_write_enable_a;
output [31:0] main_0_C_in_a;
output  main_0_C_byteena_a;
output reg  main_0_C_enable_a;
output reg [5:0] main_0_C_address_a;
input [31:0] main_0_C_out_a;
output  main_0_C_write_enable_b;
output [31:0] main_0_C_in_b;
output  main_0_C_byteena_b;
output  main_0_C_enable_b;
output [5:0] main_0_C_address_b;
input [31:0] main_0_C_out_b;
output  main_0_D_write_enable_a;
output [31:0] main_0_D_in_a;
output  main_0_D_byteena_a;
output reg  main_0_D_enable_a;
output reg [5:0] main_0_D_address_a;
input [31:0] main_0_D_out_a;
output  main_0_D_write_enable_b;
output [31:0] main_0_D_in_b;
output  main_0_D_byteena_b;
output  main_0_D_enable_b;
output [5:0] main_0_D_address_b;
input [31:0] main_0_D_out_b;
output reg  main_0_G_write_enable_a;
output reg [31:0] main_0_G_in_a;
output  main_0_G_byteena_a;
output reg  main_0_G_enable_a;
output reg [5:0] main_0_G_address_a;
input [31:0] main_0_G_out_a;
output  main_0_G_write_enable_b;
output [31:0] main_0_G_in_b;
output  main_0_G_byteena_b;
output  main_0_G_enable_b;
output [5:0] main_0_G_address_b;
input [31:0] main_0_G_out_b;
reg [4:0] cur_state;
reg [4:0] next_state;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_A_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_B_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_C_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_D_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_E_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_F_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_G_reg;
reg  fsm_stall;
reg [3:0] kernel_3mm_1_i013;
reg [3:0] kernel_3mm_1_i013_reg;
reg [7:0] kernel_3mm_1_2;
reg [7:0] kernel_3mm_1_2_reg;
reg [31:0] kernel_3mm_3_j012;
reg [31:0] kernel_3mm_3_j012_reg;
reg [31:0] kernel_3mm_3_4;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_3_scevgep24;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_3_scevgep24_reg;
reg [31:0] kernel_3mm_3_5;
reg [31:0] kernel_3mm_6_tmp011;
reg [31:0] kernel_3mm_6_tmp011_reg;
reg [31:0] kernel_3mm_6_k010;
reg [31:0] kernel_3mm_6_k010_reg;
reg [31:0] kernel_3mm_6_7;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_6_scevgep21;
reg [31:0] kernel_3mm_6_8;
reg [31:0] kernel_3mm_6_9;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_6_scevgep20;
reg [31:0] kernel_3mm_6_10;
reg [31:0] kernel_3mm_6_11;
reg [31:0] kernel_3mm_6_12;
reg [31:0] kernel_3mm_6_13;
reg [31:0] kernel_3mm_6_14;
reg [31:0] kernel_3mm_6_14_reg;
reg  kernel_3mm_6_exitcond27;
reg  kernel_3mm_6_exitcond27_reg;
reg [31:0] kernel_3mm_15_lcssa2;
reg [31:0] kernel_3mm_15_lcssa2_reg;
reg [31:0] kernel_3mm_15_16;
reg [31:0] kernel_3mm_15_16_reg;
reg  kernel_3mm_15_exitcond30;
reg  kernel_3mm_15_exitcond30_reg;
reg [4:0] kernel_3mm_17_18;
reg  kernel_3mm_17_exitcond33;
reg [3:0] kernel_3mm_preheader1preheader_i19;
reg [3:0] kernel_3mm_preheader1preheader_i19_reg;
reg [7:0] kernel_3mm_preheader1preheader_19;
reg [7:0] kernel_3mm_preheader1preheader_19_reg;
reg [31:0] kernel_3mm_20_j18;
reg [31:0] kernel_3mm_20_j18_reg;
reg [31:0] kernel_3mm_20_21;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_20_scevgep15;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_20_scevgep15_reg;
reg [31:0] kernel_3mm_20_22;
reg [31:0] kernel_3mm_23_tmp107;
reg [31:0] kernel_3mm_23_tmp107_reg;
reg [31:0] kernel_3mm_23_k16;
reg [31:0] kernel_3mm_23_k16_reg;
reg [31:0] kernel_3mm_23_24;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_23_scevgep12;
reg [31:0] kernel_3mm_23_25;
reg [31:0] kernel_3mm_23_26;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_23_scevgep11;
reg [31:0] kernel_3mm_23_27;
reg [31:0] kernel_3mm_23_28;
reg [31:0] kernel_3mm_23_29;
reg [31:0] kernel_3mm_23_29_reg;
reg [31:0] kernel_3mm_23_30;
reg [31:0] kernel_3mm_23_30_reg;
reg [31:0] kernel_3mm_23_31;
reg [31:0] kernel_3mm_23_31_reg;
reg  kernel_3mm_23_exitcond15;
reg  kernel_3mm_23_exitcond15_reg;
reg [31:0] kernel_3mm_32_lcssa1;
reg [31:0] kernel_3mm_32_lcssa1_reg;
reg [31:0] kernel_3mm_32_33;
reg [31:0] kernel_3mm_32_33_reg;
reg  kernel_3mm_32_exitcond18;
reg  kernel_3mm_32_exitcond18_reg;
reg [4:0] kernel_3mm_preheader1_34;
reg  kernel_3mm_preheader1_exitcond23;
reg [3:0] kernel_3mm_preheaderpreheader_i25;
reg [3:0] kernel_3mm_preheaderpreheader_i25_reg;
reg [7:0] kernel_3mm_preheaderpreheader_35;
reg [7:0] kernel_3mm_preheaderpreheader_35_reg;
reg [31:0] kernel_3mm_36_j24;
reg [31:0] kernel_3mm_36_j24_reg;
reg [31:0] kernel_3mm_36_37;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_36_scevgep6;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_36_scevgep6_reg;
reg [31:0] kernel_3mm_36_38;
reg [31:0] kernel_3mm_39_tmp203;
reg [31:0] kernel_3mm_39_tmp203_reg;
reg [31:0] kernel_3mm_39_k22;
reg [31:0] kernel_3mm_39_k22_reg;
reg [31:0] kernel_3mm_39_40;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_39_scevgep4;
reg [31:0] kernel_3mm_39_41;
reg [31:0] kernel_3mm_39_42;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] kernel_3mm_39_scevgep;
reg [31:0] kernel_3mm_39_43;
reg [31:0] kernel_3mm_39_44;
reg [31:0] kernel_3mm_39_45;
reg [31:0] kernel_3mm_39_46;
reg [31:0] kernel_3mm_39_47;
reg [31:0] kernel_3mm_39_47_reg;
reg  kernel_3mm_39_exitcond4;
reg  kernel_3mm_39_exitcond4_reg;
reg [31:0] kernel_3mm_48_lcssa;
reg [31:0] kernel_3mm_48_lcssa_reg;
reg [31:0] kernel_3mm_48_49;
reg [31:0] kernel_3mm_48_49_reg;
reg  kernel_3mm_48_exitcond8;
reg  kernel_3mm_48_exitcond8_reg;
reg [4:0] kernel_3mm_preheader_50;
reg  kernel_3mm_preheader_exitcond;
reg  legup_mult_1_unsigned_32_32_1_0_clock;
reg  legup_mult_1_unsigned_32_32_1_0_aclr;
reg  legup_mult_1_unsigned_32_32_1_0_sum;
reg  legup_mult_1_unsigned_32_32_1_0_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_0_result;
reg [63:0] legup_mult_kernel_3mm_6_12_out_actual;
reg [31:0] legup_mult_kernel_3mm_6_12_out;
reg  legup_mult_kernel_3mm_6_12_en;
reg  legup_mult_1_unsigned_32_32_1_1_clock;
reg  legup_mult_1_unsigned_32_32_1_1_aclr;
reg  legup_mult_1_unsigned_32_32_1_1_sum;
reg  legup_mult_1_unsigned_32_32_1_1_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_1_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_1_result;
reg [63:0] legup_mult_kernel_3mm_23_29_out_actual;
reg [31:0] legup_mult_kernel_3mm_23_29_out;
reg  legup_mult_kernel_3mm_23_29_en;
reg  legup_mult_1_unsigned_32_32_1_2_clock;
reg  legup_mult_1_unsigned_32_32_1_2_aclr;
reg  legup_mult_1_unsigned_32_32_1_2_sum;
reg  legup_mult_1_unsigned_32_32_1_2_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_2_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_2_result;
reg [63:0] legup_mult_kernel_3mm_39_45_out_actual;
reg [31:0] legup_mult_kernel_3mm_39_45_out;
reg  legup_mult_kernel_3mm_39_45_en;

/*   %12 = mul nsw i32 %10, %11, !MSB !5, !LSB !2, !extendFrom !5*/
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


/*   %29 = mul nsw i32 %27, %28, !MSB !5, !LSB !2, !extendFrom !5*/
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


/*   %45 = mul nsw i32 %43, %44, !MSB !5, !LSB !2, !extendFrom !5*/
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
		next_state = LEGUP_F_kernel_3mm_BB__1_1;
LEGUP_F_kernel_3mm_BB__15_7:
		next_state = LEGUP_F_kernel_3mm_BB__15_8;
LEGUP_F_kernel_3mm_BB__15_8:
	if ((fsm_stall == 1'd0) && (kernel_3mm_15_exitcond30_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB__17_9;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_15_exitcond30_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__3_2;
LEGUP_F_kernel_3mm_BB__17_9:
	if ((fsm_stall == 1'd0) && (kernel_3mm_17_exitcond33 == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB_preheader1preheaderpreheader_10;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_17_exitcond33 == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__1_1;
LEGUP_F_kernel_3mm_BB__1_1:
		next_state = LEGUP_F_kernel_3mm_BB__3_2;
LEGUP_F_kernel_3mm_BB__20_12:
		next_state = LEGUP_F_kernel_3mm_BB__20_13;
LEGUP_F_kernel_3mm_BB__20_13:
		next_state = LEGUP_F_kernel_3mm_BB__23_14;
LEGUP_F_kernel_3mm_BB__23_14:
		next_state = LEGUP_F_kernel_3mm_BB__23_15;
LEGUP_F_kernel_3mm_BB__23_15:
		next_state = LEGUP_F_kernel_3mm_BB__23_16;
LEGUP_F_kernel_3mm_BB__23_16:
	if ((fsm_stall == 1'd0) && (kernel_3mm_23_exitcond15_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB__32_17;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_23_exitcond15_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__23_14;
LEGUP_F_kernel_3mm_BB__32_17:
		next_state = LEGUP_F_kernel_3mm_BB__32_18;
LEGUP_F_kernel_3mm_BB__32_18:
	if ((fsm_stall == 1'd0) && (kernel_3mm_32_exitcond18_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB_preheader1_19;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_32_exitcond18_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__20_12;
LEGUP_F_kernel_3mm_BB__36_22:
		next_state = LEGUP_F_kernel_3mm_BB__36_23;
LEGUP_F_kernel_3mm_BB__36_23:
		next_state = LEGUP_F_kernel_3mm_BB__39_24;
LEGUP_F_kernel_3mm_BB__39_24:
		next_state = LEGUP_F_kernel_3mm_BB__39_25;
LEGUP_F_kernel_3mm_BB__39_25:
		next_state = LEGUP_F_kernel_3mm_BB__39_26;
LEGUP_F_kernel_3mm_BB__39_26:
	if ((fsm_stall == 1'd0) && (kernel_3mm_39_exitcond4_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB__48_27;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_39_exitcond4_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__39_24;
LEGUP_F_kernel_3mm_BB__3_2:
		next_state = LEGUP_F_kernel_3mm_BB__3_3;
LEGUP_F_kernel_3mm_BB__3_3:
		next_state = LEGUP_F_kernel_3mm_BB__6_4;
LEGUP_F_kernel_3mm_BB__48_27:
		next_state = LEGUP_F_kernel_3mm_BB__48_28;
LEGUP_F_kernel_3mm_BB__48_28:
	if ((fsm_stall == 1'd0) && (kernel_3mm_48_exitcond8_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB_preheader_29;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_48_exitcond8_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__36_22;
LEGUP_F_kernel_3mm_BB__51_30:
		next_state = LEGUP_0;
LEGUP_F_kernel_3mm_BB__6_4:
		next_state = LEGUP_F_kernel_3mm_BB__6_5;
LEGUP_F_kernel_3mm_BB__6_5:
		next_state = LEGUP_F_kernel_3mm_BB__6_6;
LEGUP_F_kernel_3mm_BB__6_6:
	if ((fsm_stall == 1'd0) && (kernel_3mm_6_exitcond27_reg == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB__15_7;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_6_exitcond27_reg == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB__6_4;
LEGUP_F_kernel_3mm_BB_preheader1_19:
	if ((fsm_stall == 1'd0) && (kernel_3mm_preheader1_exitcond23 == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB_preheaderpreheaderpreheader_20;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_preheader1_exitcond23 == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB_preheader1preheader_11;
LEGUP_F_kernel_3mm_BB_preheader1preheader_11:
		next_state = LEGUP_F_kernel_3mm_BB__20_12;
LEGUP_F_kernel_3mm_BB_preheader1preheaderpreheader_10:
		next_state = LEGUP_F_kernel_3mm_BB_preheader1preheader_11;
LEGUP_F_kernel_3mm_BB_preheader_29:
	if ((fsm_stall == 1'd0) && (kernel_3mm_preheader_exitcond == 1'd1))
		next_state = LEGUP_F_kernel_3mm_BB__51_30;
	else if ((fsm_stall == 1'd0) && (kernel_3mm_preheader_exitcond == 1'd0))
		next_state = LEGUP_F_kernel_3mm_BB_preheaderpreheader_21;
LEGUP_F_kernel_3mm_BB_preheaderpreheader_21:
		next_state = LEGUP_F_kernel_3mm_BB__36_22;
LEGUP_F_kernel_3mm_BB_preheaderpreheaderpreheader_20:
		next_state = LEGUP_F_kernel_3mm_BB_preheaderpreheader_21;
default:
	next_state = cur_state;
endcase

end
always @(posedge clk) begin
	if (start) begin
		arg_A_reg <= arg_A;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_B_reg <= arg_B;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_C_reg <= arg_C;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_D_reg <= arg_D;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_E_reg <= arg_E;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_F_reg <= arg_F;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_G_reg <= arg_G;
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
	/* kernel_3mm: %1*/
	/*   %i.013 = phi i32 [ 0, %0 ], [ %18, %17 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		kernel_3mm_1_i013 = 32'd0;
	end
	/* kernel_3mm: %1*/
	/*   %i.013 = phi i32 [ 0, %0 ], [ %18, %17 ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__17_9) & (fsm_stall == 1'd0)) & (kernel_3mm_17_exitcond33 == 1'd0))) */ begin
		kernel_3mm_1_i013 = kernel_3mm_17_18;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %1*/
	/*   %i.013 = phi i32 [ 0, %0 ], [ %18, %17 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		kernel_3mm_1_i013_reg <= kernel_3mm_1_i013;
	end
	/* kernel_3mm: %1*/
	/*   %i.013 = phi i32 [ 0, %0 ], [ %18, %17 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__17_9) & (fsm_stall == 1'd0)) & (kernel_3mm_17_exitcond33 == 1'd0))) begin
		kernel_3mm_1_i013_reg <= kernel_3mm_1_i013;
	end
end
always @(*) begin
	/* kernel_3mm: %1*/
	/*   %2 = mul i32 %i.013, 8, !MSB !4, !LSB !3, !extendFrom !4*/
		kernel_3mm_1_2 = ({4'd0,kernel_3mm_1_i013_reg} * 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %1*/
	/*   %2 = mul i32 %i.013, 8, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__1_1)) begin
		kernel_3mm_1_2_reg <= kernel_3mm_1_2;
	end
end
always @(*) begin
	/* kernel_3mm: %3*/
	/*   %j.012 = phi i32 [ 0, %1 ], [ %16, %15 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__1_1) & (fsm_stall == 1'd0))) begin
		kernel_3mm_3_j012 = 32'd0;
	end
	/* kernel_3mm: %3*/
	/*   %j.012 = phi i32 [ 0, %1 ], [ %16, %15 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__15_8) & (fsm_stall == 1'd0)) & (kernel_3mm_15_exitcond30_reg == 1'd0))) */ begin
		kernel_3mm_3_j012 = kernel_3mm_15_16_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %3*/
	/*   %j.012 = phi i32 [ 0, %1 ], [ %16, %15 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__1_1) & (fsm_stall == 1'd0))) begin
		kernel_3mm_3_j012_reg <= kernel_3mm_3_j012;
	end
	/* kernel_3mm: %3*/
	/*   %j.012 = phi i32 [ 0, %1 ], [ %16, %15 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__15_8) & (fsm_stall == 1'd0)) & (kernel_3mm_15_exitcond30_reg == 1'd0))) begin
		kernel_3mm_3_j012_reg <= kernel_3mm_3_j012;
	end
end
always @(*) begin
	/* kernel_3mm: %3*/
	/*   %4 = add i32 %2, %j.012, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_3_4 = ({24'd0,kernel_3mm_1_2_reg} + kernel_3mm_3_j012_reg);
end
always @(*) begin
	/* kernel_3mm: %3*/
	/*   %scevgep24 = getelementptr i32* %E, i32 %4, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_3_scevgep24 = (arg_E_reg + (4 * kernel_3mm_3_4));
end
always @(posedge clk) begin
	/* kernel_3mm: %3*/
	/*   %scevgep24 = getelementptr i32* %E, i32 %4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__3_2)) begin
		kernel_3mm_3_scevgep24_reg <= kernel_3mm_3_scevgep24;
	end
end
always @(*) begin
	/* kernel_3mm: %3*/
	/*   %5 = load i32* %scevgep24, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_3_5 = main_0_E_out_a;
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %tmp.011 = phi i32 [ %5, %3 ], [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__3_3) & (fsm_stall == 1'd0))) begin
		kernel_3mm_6_tmp011 = kernel_3mm_3_5;
	end
	/* kernel_3mm: %6*/
	/*   %tmp.011 = phi i32 [ %5, %3 ], [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__6_6) & (fsm_stall == 1'd0)) & (kernel_3mm_6_exitcond27_reg == 1'd0))) */ begin
		kernel_3mm_6_tmp011 = kernel_3mm_6_13;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %6*/
	/*   %tmp.011 = phi i32 [ %5, %3 ], [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__3_3) & (fsm_stall == 1'd0))) begin
		kernel_3mm_6_tmp011_reg <= kernel_3mm_6_tmp011;
	end
	/* kernel_3mm: %6*/
	/*   %tmp.011 = phi i32 [ %5, %3 ], [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__6_6) & (fsm_stall == 1'd0)) & (kernel_3mm_6_exitcond27_reg == 1'd0))) begin
		kernel_3mm_6_tmp011_reg <= kernel_3mm_6_tmp011;
	end
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %k.010 = phi i32 [ 0, %3 ], [ %14, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__3_3) & (fsm_stall == 1'd0))) begin
		kernel_3mm_6_k010 = 32'd0;
	end
	/* kernel_3mm: %6*/
	/*   %k.010 = phi i32 [ 0, %3 ], [ %14, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__6_6) & (fsm_stall == 1'd0)) & (kernel_3mm_6_exitcond27_reg == 1'd0))) */ begin
		kernel_3mm_6_k010 = kernel_3mm_6_14_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %6*/
	/*   %k.010 = phi i32 [ 0, %3 ], [ %14, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__3_3) & (fsm_stall == 1'd0))) begin
		kernel_3mm_6_k010_reg <= kernel_3mm_6_k010;
	end
	/* kernel_3mm: %6*/
	/*   %k.010 = phi i32 [ 0, %3 ], [ %14, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__6_6) & (fsm_stall == 1'd0)) & (kernel_3mm_6_exitcond27_reg == 1'd0))) begin
		kernel_3mm_6_k010_reg <= kernel_3mm_6_k010;
	end
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %7 = add i32 %2, %k.010, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_7 = ({24'd0,kernel_3mm_1_2_reg} + kernel_3mm_6_k010_reg);
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %scevgep21 = getelementptr i32* %A, i32 %7, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_6_scevgep21 = (arg_A_reg + (4 * kernel_3mm_6_7));
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %8 = mul i32 %k.010, 8, !MSB !5, !LSB !3, !extendFrom !5*/
		kernel_3mm_6_8 = (kernel_3mm_6_k010_reg * 32'd8);
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %9 = add i32 %j.012, %8, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_9 = (kernel_3mm_3_j012_reg + kernel_3mm_6_8);
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %scevgep20 = getelementptr i32* %B, i32 %9, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_6_scevgep20 = (arg_B_reg + (4 * kernel_3mm_6_9));
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %10 = load i32* %scevgep21, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_10 = main_0_A_out_a;
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %11 = load i32* %scevgep20, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_11 = main_0_B_out_a;
end
always @(*) begin
	kernel_3mm_6_12 = legup_mult_kernel_3mm_6_12_out;
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %13 = add nsw i32 %tmp.011, %12, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_13 = (kernel_3mm_6_tmp011_reg + kernel_3mm_6_12);
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %14 = add nsw i32 %k.010, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_6_14 = (kernel_3mm_6_k010_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %6*/
	/*   %14 = add nsw i32 %k.010, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		kernel_3mm_6_14_reg <= kernel_3mm_6_14;
	end
end
always @(*) begin
	/* kernel_3mm: %6*/
	/*   %exitcond27 = icmp eq i32 %14, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_6_exitcond27 = (kernel_3mm_6_14 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %6*/
	/*   %exitcond27 = icmp eq i32 %14, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		kernel_3mm_6_exitcond27_reg <= kernel_3mm_6_exitcond27;
	end
end
always @(*) begin
	/* kernel_3mm: %15*/
	/*   %.lcssa2 = phi i32 [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_15_lcssa2 = kernel_3mm_6_13;
end
always @(posedge clk) begin
	/* kernel_3mm: %15*/
	/*   %.lcssa2 = phi i32 [ %13, %6 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__6_6) & (fsm_stall == 1'd0)) & (kernel_3mm_6_exitcond27_reg == 1'd1))) begin
		kernel_3mm_15_lcssa2_reg <= kernel_3mm_15_lcssa2;
	end
end
always @(*) begin
	/* kernel_3mm: %15*/
	/*   %16 = add nsw i32 %j.012, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_15_16 = (kernel_3mm_3_j012_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %15*/
	/*   %16 = add nsw i32 %j.012, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		kernel_3mm_15_16_reg <= kernel_3mm_15_16;
	end
end
always @(*) begin
	/* kernel_3mm: %15*/
	/*   %exitcond30 = icmp eq i32 %16, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_15_exitcond30 = (kernel_3mm_15_16 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %15*/
	/*   %exitcond30 = icmp eq i32 %16, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		kernel_3mm_15_exitcond30_reg <= kernel_3mm_15_exitcond30;
	end
end
always @(*) begin
	/* kernel_3mm: %17*/
	/*   %18 = add nsw i32 %i.013, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		kernel_3mm_17_18 = ({1'd0,kernel_3mm_1_i013_reg} + 32'd1);
end
always @(*) begin
	/* kernel_3mm: %17*/
	/*   %exitcond33 = icmp eq i32 %18, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_17_exitcond33 = (kernel_3mm_17_18 == 32'd8);
end
always @(*) begin
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %i.19 = phi i32 [ %34, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheader1preheaderpreheader_10) & (fsm_stall == 1'd0))) begin
		kernel_3mm_preheader1preheader_i19 = 32'd0;
	end
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %i.19 = phi i32 [ %34, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB_preheader1_19) & (fsm_stall == 1'd0)) & (kernel_3mm_preheader1_exitcond23 == 1'd0))) */ begin
		kernel_3mm_preheader1preheader_i19 = kernel_3mm_preheader1_34;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %i.19 = phi i32 [ %34, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheader1preheaderpreheader_10) & (fsm_stall == 1'd0))) begin
		kernel_3mm_preheader1preheader_i19_reg <= kernel_3mm_preheader1preheader_i19;
	end
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %i.19 = phi i32 [ %34, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB_preheader1_19) & (fsm_stall == 1'd0)) & (kernel_3mm_preheader1_exitcond23 == 1'd0))) begin
		kernel_3mm_preheader1preheader_i19_reg <= kernel_3mm_preheader1preheader_i19;
	end
end
always @(*) begin
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %19 = mul i32 %i.19, 8, !MSB !4, !LSB !3, !extendFrom !4*/
		kernel_3mm_preheader1preheader_19 = ({4'd0,kernel_3mm_preheader1preheader_i19_reg} * 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %.preheader1.preheader*/
	/*   %19 = mul i32 %i.19, 8, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB_preheader1preheader_11)) begin
		kernel_3mm_preheader1preheader_19_reg <= kernel_3mm_preheader1preheader_19;
	end
end
always @(*) begin
	/* kernel_3mm: %20*/
	/*   %j.18 = phi i32 [ 0, %.preheader1.preheader ], [ %33, %32 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheader1preheader_11) & (fsm_stall == 1'd0))) begin
		kernel_3mm_20_j18 = 32'd0;
	end
	/* kernel_3mm: %20*/
	/*   %j.18 = phi i32 [ 0, %.preheader1.preheader ], [ %33, %32 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__32_18) & (fsm_stall == 1'd0)) & (kernel_3mm_32_exitcond18_reg == 1'd0))) */ begin
		kernel_3mm_20_j18 = kernel_3mm_32_33_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %20*/
	/*   %j.18 = phi i32 [ 0, %.preheader1.preheader ], [ %33, %32 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheader1preheader_11) & (fsm_stall == 1'd0))) begin
		kernel_3mm_20_j18_reg <= kernel_3mm_20_j18;
	end
	/* kernel_3mm: %20*/
	/*   %j.18 = phi i32 [ 0, %.preheader1.preheader ], [ %33, %32 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__32_18) & (fsm_stall == 1'd0)) & (kernel_3mm_32_exitcond18_reg == 1'd0))) begin
		kernel_3mm_20_j18_reg <= kernel_3mm_20_j18;
	end
end
always @(*) begin
	/* kernel_3mm: %20*/
	/*   %21 = add i32 %19, %j.18, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_20_21 = ({24'd0,kernel_3mm_preheader1preheader_19_reg} + kernel_3mm_20_j18_reg);
end
always @(*) begin
	/* kernel_3mm: %20*/
	/*   %scevgep15 = getelementptr i32* %F, i32 %21, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_20_scevgep15 = (arg_F_reg + (4 * kernel_3mm_20_21));
end
always @(posedge clk) begin
	/* kernel_3mm: %20*/
	/*   %scevgep15 = getelementptr i32* %F, i32 %21, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__20_12)) begin
		kernel_3mm_20_scevgep15_reg <= kernel_3mm_20_scevgep15;
	end
end
always @(*) begin
	/* kernel_3mm: %20*/
	/*   %22 = load i32* %scevgep15, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_20_22 = main_0_F_out_a;
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %tmp1.07 = phi i32 [ %22, %20 ], [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__20_13) & (fsm_stall == 1'd0))) begin
		kernel_3mm_23_tmp107 = kernel_3mm_20_22;
	end
	/* kernel_3mm: %23*/
	/*   %tmp1.07 = phi i32 [ %22, %20 ], [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__23_16) & (fsm_stall == 1'd0)) & (kernel_3mm_23_exitcond15_reg == 1'd0))) */ begin
		kernel_3mm_23_tmp107 = kernel_3mm_23_30_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %tmp1.07 = phi i32 [ %22, %20 ], [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__20_13) & (fsm_stall == 1'd0))) begin
		kernel_3mm_23_tmp107_reg <= kernel_3mm_23_tmp107;
	end
	/* kernel_3mm: %23*/
	/*   %tmp1.07 = phi i32 [ %22, %20 ], [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__23_16) & (fsm_stall == 1'd0)) & (kernel_3mm_23_exitcond15_reg == 1'd0))) begin
		kernel_3mm_23_tmp107_reg <= kernel_3mm_23_tmp107;
	end
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %k.16 = phi i32 [ 0, %20 ], [ %31, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__20_13) & (fsm_stall == 1'd0))) begin
		kernel_3mm_23_k16 = 32'd0;
	end
	/* kernel_3mm: %23*/
	/*   %k.16 = phi i32 [ 0, %20 ], [ %31, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__23_16) & (fsm_stall == 1'd0)) & (kernel_3mm_23_exitcond15_reg == 1'd0))) */ begin
		kernel_3mm_23_k16 = kernel_3mm_23_31_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %k.16 = phi i32 [ 0, %20 ], [ %31, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__20_13) & (fsm_stall == 1'd0))) begin
		kernel_3mm_23_k16_reg <= kernel_3mm_23_k16;
	end
	/* kernel_3mm: %23*/
	/*   %k.16 = phi i32 [ 0, %20 ], [ %31, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__23_16) & (fsm_stall == 1'd0)) & (kernel_3mm_23_exitcond15_reg == 1'd0))) begin
		kernel_3mm_23_k16_reg <= kernel_3mm_23_k16;
	end
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %24 = add i32 %19, %k.16, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_24 = ({24'd0,kernel_3mm_preheader1preheader_19_reg} + kernel_3mm_23_k16_reg);
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %scevgep12 = getelementptr i32* %C, i32 %24, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_23_scevgep12 = (arg_C_reg + (4 * kernel_3mm_23_24));
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %25 = mul i32 %k.16, 8, !MSB !5, !LSB !3, !extendFrom !5*/
		kernel_3mm_23_25 = (kernel_3mm_23_k16_reg * 32'd8);
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %26 = add i32 %j.18, %25, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_26 = (kernel_3mm_20_j18_reg + kernel_3mm_23_25);
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %scevgep11 = getelementptr i32* %D, i32 %26, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_23_scevgep11 = (arg_D_reg + (4 * kernel_3mm_23_26));
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %27 = load i32* %scevgep12, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_27 = main_0_C_out_a;
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %28 = load i32* %scevgep11, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_28 = main_0_D_out_a;
end
always @(*) begin
	kernel_3mm_23_29 = legup_mult_kernel_3mm_23_29_out;
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %29 = mul nsw i32 %27, %28, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_16)) begin
		kernel_3mm_23_29_reg <= kernel_3mm_23_29;
	end
	/* kernel_3mm: %23*/
	/*   %29 = mul nsw i32 %27, %28, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_16)) begin
		kernel_3mm_23_29_reg <= kernel_3mm_23_29;
	end
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %30 = add nsw i32 %tmp1.07, %29, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_30 = (kernel_3mm_23_tmp107_reg + kernel_3mm_23_29_reg);
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %30 = add nsw i32 %tmp1.07, %29, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		kernel_3mm_23_30_reg <= kernel_3mm_23_30;
	end
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %31 = add nsw i32 %k.16, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_23_31 = (kernel_3mm_23_k16_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %31 = add nsw i32 %k.16, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		kernel_3mm_23_31_reg <= kernel_3mm_23_31;
	end
end
always @(*) begin
	/* kernel_3mm: %23*/
	/*   %exitcond15 = icmp eq i32 %31, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_23_exitcond15 = (kernel_3mm_23_31 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %23*/
	/*   %exitcond15 = icmp eq i32 %31, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		kernel_3mm_23_exitcond15_reg <= kernel_3mm_23_exitcond15;
	end
end
always @(*) begin
	/* kernel_3mm: %32*/
	/*   %.lcssa1 = phi i32 [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_32_lcssa1 = kernel_3mm_23_30_reg;
end
always @(posedge clk) begin
	/* kernel_3mm: %32*/
	/*   %.lcssa1 = phi i32 [ %30, %23 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__23_16) & (fsm_stall == 1'd0)) & (kernel_3mm_23_exitcond15_reg == 1'd1))) begin
		kernel_3mm_32_lcssa1_reg <= kernel_3mm_32_lcssa1;
	end
end
always @(*) begin
	/* kernel_3mm: %32*/
	/*   %33 = add nsw i32 %j.18, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_32_33 = (kernel_3mm_20_j18_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %32*/
	/*   %33 = add nsw i32 %j.18, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		kernel_3mm_32_33_reg <= kernel_3mm_32_33;
	end
end
always @(*) begin
	/* kernel_3mm: %32*/
	/*   %exitcond18 = icmp eq i32 %33, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_32_exitcond18 = (kernel_3mm_32_33 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %32*/
	/*   %exitcond18 = icmp eq i32 %33, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		kernel_3mm_32_exitcond18_reg <= kernel_3mm_32_exitcond18;
	end
end
always @(*) begin
	/* kernel_3mm: %.preheader1*/
	/*   %34 = add nsw i32 %i.19, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		kernel_3mm_preheader1_34 = ({1'd0,kernel_3mm_preheader1preheader_i19_reg} + 32'd1);
end
always @(*) begin
	/* kernel_3mm: %.preheader1*/
	/*   %exitcond23 = icmp eq i32 %34, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_preheader1_exitcond23 = (kernel_3mm_preheader1_34 == 32'd8);
end
always @(*) begin
	/* kernel_3mm: %.preheader.preheader*/
	/*   %i.25 = phi i32 [ %50, %.preheader ], [ 0, %.preheader.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheaderpreheaderpreheader_20) & (fsm_stall == 1'd0))) begin
		kernel_3mm_preheaderpreheader_i25 = 32'd0;
	end
	/* kernel_3mm: %.preheader.preheader*/
	/*   %i.25 = phi i32 [ %50, %.preheader ], [ 0, %.preheader.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB_preheader_29) & (fsm_stall == 1'd0)) & (kernel_3mm_preheader_exitcond == 1'd0))) */ begin
		kernel_3mm_preheaderpreheader_i25 = kernel_3mm_preheader_50;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %.preheader.preheader*/
	/*   %i.25 = phi i32 [ %50, %.preheader ], [ 0, %.preheader.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheaderpreheaderpreheader_20) & (fsm_stall == 1'd0))) begin
		kernel_3mm_preheaderpreheader_i25_reg <= kernel_3mm_preheaderpreheader_i25;
	end
	/* kernel_3mm: %.preheader.preheader*/
	/*   %i.25 = phi i32 [ %50, %.preheader ], [ 0, %.preheader.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB_preheader_29) & (fsm_stall == 1'd0)) & (kernel_3mm_preheader_exitcond == 1'd0))) begin
		kernel_3mm_preheaderpreheader_i25_reg <= kernel_3mm_preheaderpreheader_i25;
	end
end
always @(*) begin
	/* kernel_3mm: %.preheader.preheader*/
	/*   %35 = mul i32 %i.25, 8, !MSB !4, !LSB !3, !extendFrom !4*/
		kernel_3mm_preheaderpreheader_35 = ({4'd0,kernel_3mm_preheaderpreheader_i25_reg} * 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %.preheader.preheader*/
	/*   %35 = mul i32 %i.25, 8, !MSB !4, !LSB !3, !extendFrom !4*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB_preheaderpreheader_21)) begin
		kernel_3mm_preheaderpreheader_35_reg <= kernel_3mm_preheaderpreheader_35;
	end
end
always @(*) begin
	/* kernel_3mm: %36*/
	/*   %j.24 = phi i32 [ 0, %.preheader.preheader ], [ %49, %48 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheaderpreheader_21) & (fsm_stall == 1'd0))) begin
		kernel_3mm_36_j24 = 32'd0;
	end
	/* kernel_3mm: %36*/
	/*   %j.24 = phi i32 [ 0, %.preheader.preheader ], [ %49, %48 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__48_28) & (fsm_stall == 1'd0)) & (kernel_3mm_48_exitcond8_reg == 1'd0))) */ begin
		kernel_3mm_36_j24 = kernel_3mm_48_49_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %36*/
	/*   %j.24 = phi i32 [ 0, %.preheader.preheader ], [ %49, %48 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB_preheaderpreheader_21) & (fsm_stall == 1'd0))) begin
		kernel_3mm_36_j24_reg <= kernel_3mm_36_j24;
	end
	/* kernel_3mm: %36*/
	/*   %j.24 = phi i32 [ 0, %.preheader.preheader ], [ %49, %48 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__48_28) & (fsm_stall == 1'd0)) & (kernel_3mm_48_exitcond8_reg == 1'd0))) begin
		kernel_3mm_36_j24_reg <= kernel_3mm_36_j24;
	end
end
always @(*) begin
	/* kernel_3mm: %36*/
	/*   %37 = add i32 %35, %j.24, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_36_37 = ({24'd0,kernel_3mm_preheaderpreheader_35_reg} + kernel_3mm_36_j24_reg);
end
always @(*) begin
	/* kernel_3mm: %36*/
	/*   %scevgep6 = getelementptr i32* %G, i32 %37, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_36_scevgep6 = (arg_G_reg + (4 * kernel_3mm_36_37));
end
always @(posedge clk) begin
	/* kernel_3mm: %36*/
	/*   %scevgep6 = getelementptr i32* %G, i32 %37, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__36_22)) begin
		kernel_3mm_36_scevgep6_reg <= kernel_3mm_36_scevgep6;
	end
end
always @(*) begin
	/* kernel_3mm: %36*/
	/*   %38 = load i32* %scevgep6, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_36_38 = main_0_G_out_a;
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %tmp2.03 = phi i32 [ %38, %36 ], [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__36_23) & (fsm_stall == 1'd0))) begin
		kernel_3mm_39_tmp203 = kernel_3mm_36_38;
	end
	/* kernel_3mm: %39*/
	/*   %tmp2.03 = phi i32 [ %38, %36 ], [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__39_26) & (fsm_stall == 1'd0)) & (kernel_3mm_39_exitcond4_reg == 1'd0))) */ begin
		kernel_3mm_39_tmp203 = kernel_3mm_39_46;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %39*/
	/*   %tmp2.03 = phi i32 [ %38, %36 ], [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__36_23) & (fsm_stall == 1'd0))) begin
		kernel_3mm_39_tmp203_reg <= kernel_3mm_39_tmp203;
	end
	/* kernel_3mm: %39*/
	/*   %tmp2.03 = phi i32 [ %38, %36 ], [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__39_26) & (fsm_stall == 1'd0)) & (kernel_3mm_39_exitcond4_reg == 1'd0))) begin
		kernel_3mm_39_tmp203_reg <= kernel_3mm_39_tmp203;
	end
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %k.22 = phi i32 [ 0, %36 ], [ %47, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__36_23) & (fsm_stall == 1'd0))) begin
		kernel_3mm_39_k22 = 32'd0;
	end
	/* kernel_3mm: %39*/
	/*   %k.22 = phi i32 [ 0, %36 ], [ %47, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	else /* if ((((cur_state == LEGUP_F_kernel_3mm_BB__39_26) & (fsm_stall == 1'd0)) & (kernel_3mm_39_exitcond4_reg == 1'd0))) */ begin
		kernel_3mm_39_k22 = kernel_3mm_39_47_reg;
	end
end
always @(posedge clk) begin
	/* kernel_3mm: %39*/
	/*   %k.22 = phi i32 [ 0, %36 ], [ %47, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if (((cur_state == LEGUP_F_kernel_3mm_BB__36_23) & (fsm_stall == 1'd0))) begin
		kernel_3mm_39_k22_reg <= kernel_3mm_39_k22;
	end
	/* kernel_3mm: %39*/
	/*   %k.22 = phi i32 [ 0, %36 ], [ %47, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__39_26) & (fsm_stall == 1'd0)) & (kernel_3mm_39_exitcond4_reg == 1'd0))) begin
		kernel_3mm_39_k22_reg <= kernel_3mm_39_k22;
	end
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %40 = add i32 %35, %k.22, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_40 = ({24'd0,kernel_3mm_preheaderpreheader_35_reg} + kernel_3mm_39_k22_reg);
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %scevgep4 = getelementptr i32* %E, i32 %40, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_39_scevgep4 = (arg_E_reg + (4 * kernel_3mm_39_40));
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %41 = mul i32 %k.22, 8, !MSB !5, !LSB !3, !extendFrom !5*/
		kernel_3mm_39_41 = (kernel_3mm_39_k22_reg * 32'd8);
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %42 = add i32 %j.24, %41, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_42 = (kernel_3mm_36_j24_reg + kernel_3mm_39_41);
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %scevgep = getelementptr i32* %F, i32 %42, !MSB !1, !LSB !2, !extendFrom !1*/
		kernel_3mm_39_scevgep = (arg_F_reg + (4 * kernel_3mm_39_42));
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %43 = load i32* %scevgep4, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_43 = main_0_E_out_a;
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %44 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_44 = main_0_F_out_a;
end
always @(*) begin
	kernel_3mm_39_45 = legup_mult_kernel_3mm_39_45_out;
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %46 = add nsw i32 %tmp2.03, %45, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_46 = (kernel_3mm_39_tmp203_reg + kernel_3mm_39_45);
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %47 = add nsw i32 %k.22, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_39_47 = (kernel_3mm_39_k22_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %39*/
	/*   %47 = add nsw i32 %k.22, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		kernel_3mm_39_47_reg <= kernel_3mm_39_47;
	end
end
always @(*) begin
	/* kernel_3mm: %39*/
	/*   %exitcond4 = icmp eq i32 %47, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_39_exitcond4 = (kernel_3mm_39_47 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %39*/
	/*   %exitcond4 = icmp eq i32 %47, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		kernel_3mm_39_exitcond4_reg <= kernel_3mm_39_exitcond4;
	end
end
always @(*) begin
	/* kernel_3mm: %48*/
	/*   %.lcssa = phi i32 [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_48_lcssa = kernel_3mm_39_46;
end
always @(posedge clk) begin
	/* kernel_3mm: %48*/
	/*   %.lcssa = phi i32 [ %46, %39 ], !MSB !5, !LSB !2, !extendFrom !5*/
	if ((((cur_state == LEGUP_F_kernel_3mm_BB__39_26) & (fsm_stall == 1'd0)) & (kernel_3mm_39_exitcond4_reg == 1'd1))) begin
		kernel_3mm_48_lcssa_reg <= kernel_3mm_48_lcssa;
	end
end
always @(*) begin
	/* kernel_3mm: %48*/
	/*   %49 = add nsw i32 %j.24, 1, !MSB !5, !LSB !2, !extendFrom !5*/
		kernel_3mm_48_49 = (kernel_3mm_36_j24_reg + 32'd1);
end
always @(posedge clk) begin
	/* kernel_3mm: %48*/
	/*   %49 = add nsw i32 %j.24, 1, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		kernel_3mm_48_49_reg <= kernel_3mm_48_49;
	end
end
always @(*) begin
	/* kernel_3mm: %48*/
	/*   %exitcond8 = icmp eq i32 %49, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_48_exitcond8 = (kernel_3mm_48_49 == 32'd8);
end
always @(posedge clk) begin
	/* kernel_3mm: %48*/
	/*   %exitcond8 = icmp eq i32 %49, 8, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		kernel_3mm_48_exitcond8_reg <= kernel_3mm_48_exitcond8;
	end
end
always @(*) begin
	/* kernel_3mm: %.preheader*/
	/*   %50 = add nsw i32 %i.25, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		kernel_3mm_preheader_50 = ({1'd0,kernel_3mm_preheaderpreheader_i25_reg} + 32'd1);
end
always @(*) begin
	/* kernel_3mm: %.preheader*/
	/*   %exitcond = icmp eq i32 %50, 8, !MSB !2, !LSB !2, !extendFrom !2*/
		kernel_3mm_preheader_exitcond = (kernel_3mm_preheader_50 == 32'd8);
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
	legup_mult_1_unsigned_32_32_1_0_clken = legup_mult_kernel_3mm_6_12_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_dataa = kernel_3mm_6_10;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_datab = kernel_3mm_6_11;
end
always @(*) begin
	legup_mult_kernel_3mm_6_12_out_actual = legup_mult_1_unsigned_32_32_1_0_result;
end
always @(*) begin
	legup_mult_kernel_3mm_6_12_out = legup_mult_kernel_3mm_6_12_out_actual[31:0];
end
always @(*) begin
	legup_mult_kernel_3mm_6_12_en = ~(fsm_stall);
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
	legup_mult_1_unsigned_32_32_1_1_clken = legup_mult_kernel_3mm_23_29_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_dataa = kernel_3mm_23_27;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_1_datab = kernel_3mm_23_28;
end
always @(*) begin
	legup_mult_kernel_3mm_23_29_out_actual = legup_mult_1_unsigned_32_32_1_1_result;
end
always @(*) begin
	legup_mult_kernel_3mm_23_29_out = legup_mult_kernel_3mm_23_29_out_actual[31:0];
end
always @(*) begin
	legup_mult_kernel_3mm_23_29_en = ~(fsm_stall);
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
	legup_mult_1_unsigned_32_32_1_2_clken = legup_mult_kernel_3mm_39_45_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_dataa = kernel_3mm_39_43;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_2_datab = kernel_3mm_39_44;
end
always @(*) begin
	legup_mult_kernel_3mm_39_45_out_actual = legup_mult_1_unsigned_32_32_1_2_result;
end
always @(*) begin
	legup_mult_kernel_3mm_39_45_out = legup_mult_kernel_3mm_39_45_out_actual[31:0];
end
always @(*) begin
	legup_mult_kernel_3mm_39_45_en = ~(fsm_stall);
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* kernel_3mm: %51*/
	/*   ret void, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__51_30)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
always @(*) begin
	main_0_E_write_enable_a = 1'd0;
	/* kernel_3mm: %15*/
	/*   store i32 %.lcssa2, i32* %scevgep24, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		main_0_E_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_E_in_a = 0;
	/* kernel_3mm: %15*/
	/*   store i32 %.lcssa2, i32* %scevgep24, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		main_0_E_in_a = kernel_3mm_15_lcssa2_reg;
	end
end
assign main_0_E_byteena_a = 1'd1;
always @(*) begin
	main_0_E_enable_a = 1'd0;
	/* kernel_3mm: %3*/
	/*   %5 = load i32* %scevgep24, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__3_2)) begin
		main_0_E_enable_a = 1'd1;
	end
	/* kernel_3mm: %15*/
	/*   store i32 %.lcssa2, i32* %scevgep24, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		main_0_E_enable_a = 1'd1;
	end
	/* kernel_3mm: %39*/
	/*   %43 = load i32* %scevgep4, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		main_0_E_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_E_address_a = 6'd0;
	/* kernel_3mm: %3*/
	/*   %5 = load i32* %scevgep24, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__3_2)) begin
		main_0_E_address_a = (kernel_3mm_3_scevgep24 >>> 3'd2);
	end
	/* kernel_3mm: %15*/
	/*   store i32 %.lcssa2, i32* %scevgep24, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__15_7)) begin
		main_0_E_address_a = (kernel_3mm_3_scevgep24_reg >>> 3'd2);
	end
	/* kernel_3mm: %39*/
	/*   %43 = load i32* %scevgep4, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		main_0_E_address_a = (kernel_3mm_39_scevgep4 >>> 3'd2);
	end
end
assign main_0_E_write_enable_b = 1'd0;
assign main_0_E_in_b = 0;
assign main_0_E_byteena_b = 1'd1;
assign main_0_E_enable_b = 1'd0;
assign main_0_E_address_b = 6'd0;
assign main_0_A_write_enable_a = 1'd0;
assign main_0_A_in_a = 0;
assign main_0_A_byteena_a = 1'd1;
always @(*) begin
	main_0_A_enable_a = 1'd0;
	/* kernel_3mm: %6*/
	/*   %10 = load i32* %scevgep21, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		main_0_A_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_A_address_a = 6'd0;
	/* kernel_3mm: %6*/
	/*   %10 = load i32* %scevgep21, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		main_0_A_address_a = (kernel_3mm_6_scevgep21 >>> 3'd2);
	end
end
assign main_0_A_write_enable_b = 1'd0;
assign main_0_A_in_b = 0;
assign main_0_A_byteena_b = 1'd1;
assign main_0_A_enable_b = 1'd0;
assign main_0_A_address_b = 6'd0;
assign main_0_B_write_enable_a = 1'd0;
assign main_0_B_in_a = 0;
assign main_0_B_byteena_a = 1'd1;
always @(*) begin
	main_0_B_enable_a = 1'd0;
	/* kernel_3mm: %6*/
	/*   %11 = load i32* %scevgep20, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		main_0_B_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_B_address_a = 6'd0;
	/* kernel_3mm: %6*/
	/*   %11 = load i32* %scevgep20, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__6_4)) begin
		main_0_B_address_a = (kernel_3mm_6_scevgep20 >>> 3'd2);
	end
end
assign main_0_B_write_enable_b = 1'd0;
assign main_0_B_in_b = 0;
assign main_0_B_byteena_b = 1'd1;
assign main_0_B_enable_b = 1'd0;
assign main_0_B_address_b = 6'd0;
always @(*) begin
	main_0_F_write_enable_a = 1'd0;
	/* kernel_3mm: %32*/
	/*   store i32 %.lcssa1, i32* %scevgep15, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		main_0_F_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_F_in_a = 0;
	/* kernel_3mm: %32*/
	/*   store i32 %.lcssa1, i32* %scevgep15, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		main_0_F_in_a = kernel_3mm_32_lcssa1_reg;
	end
end
assign main_0_F_byteena_a = 1'd1;
always @(*) begin
	main_0_F_enable_a = 1'd0;
	/* kernel_3mm: %20*/
	/*   %22 = load i32* %scevgep15, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__20_12)) begin
		main_0_F_enable_a = 1'd1;
	end
	/* kernel_3mm: %32*/
	/*   store i32 %.lcssa1, i32* %scevgep15, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		main_0_F_enable_a = 1'd1;
	end
	/* kernel_3mm: %39*/
	/*   %44 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		main_0_F_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_F_address_a = 6'd0;
	/* kernel_3mm: %20*/
	/*   %22 = load i32* %scevgep15, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__20_12)) begin
		main_0_F_address_a = (kernel_3mm_20_scevgep15 >>> 3'd2);
	end
	/* kernel_3mm: %32*/
	/*   store i32 %.lcssa1, i32* %scevgep15, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__32_17)) begin
		main_0_F_address_a = (kernel_3mm_20_scevgep15_reg >>> 3'd2);
	end
	/* kernel_3mm: %39*/
	/*   %44 = load i32* %scevgep, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__39_24)) begin
		main_0_F_address_a = (kernel_3mm_39_scevgep >>> 3'd2);
	end
end
assign main_0_F_write_enable_b = 1'd0;
assign main_0_F_in_b = 0;
assign main_0_F_byteena_b = 1'd1;
assign main_0_F_enable_b = 1'd0;
assign main_0_F_address_b = 6'd0;
assign main_0_C_write_enable_a = 1'd0;
assign main_0_C_in_a = 0;
assign main_0_C_byteena_a = 1'd1;
always @(*) begin
	main_0_C_enable_a = 1'd0;
	/* kernel_3mm: %23*/
	/*   %27 = load i32* %scevgep12, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		main_0_C_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_C_address_a = 6'd0;
	/* kernel_3mm: %23*/
	/*   %27 = load i32* %scevgep12, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		main_0_C_address_a = (kernel_3mm_23_scevgep12 >>> 3'd2);
	end
end
assign main_0_C_write_enable_b = 1'd0;
assign main_0_C_in_b = 0;
assign main_0_C_byteena_b = 1'd1;
assign main_0_C_enable_b = 1'd0;
assign main_0_C_address_b = 6'd0;
assign main_0_D_write_enable_a = 1'd0;
assign main_0_D_in_a = 0;
assign main_0_D_byteena_a = 1'd1;
always @(*) begin
	main_0_D_enable_a = 1'd0;
	/* kernel_3mm: %23*/
	/*   %28 = load i32* %scevgep11, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		main_0_D_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_D_address_a = 6'd0;
	/* kernel_3mm: %23*/
	/*   %28 = load i32* %scevgep11, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__23_14)) begin
		main_0_D_address_a = (kernel_3mm_23_scevgep11 >>> 3'd2);
	end
end
assign main_0_D_write_enable_b = 1'd0;
assign main_0_D_in_b = 0;
assign main_0_D_byteena_b = 1'd1;
assign main_0_D_enable_b = 1'd0;
assign main_0_D_address_b = 6'd0;
always @(*) begin
	main_0_G_write_enable_a = 1'd0;
	/* kernel_3mm: %48*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		main_0_G_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_G_in_a = 0;
	/* kernel_3mm: %48*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		main_0_G_in_a = kernel_3mm_48_lcssa_reg;
	end
end
assign main_0_G_byteena_a = 1'd1;
always @(*) begin
	main_0_G_enable_a = 1'd0;
	/* kernel_3mm: %36*/
	/*   %38 = load i32* %scevgep6, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__36_22)) begin
		main_0_G_enable_a = 1'd1;
	end
	/* kernel_3mm: %48*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		main_0_G_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_G_address_a = 6'd0;
	/* kernel_3mm: %36*/
	/*   %38 = load i32* %scevgep6, align 4, !MSB !5, !LSB !2, !extendFrom !5*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__36_22)) begin
		main_0_G_address_a = (kernel_3mm_36_scevgep6 >>> 3'd2);
	end
	/* kernel_3mm: %48*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_kernel_3mm_BB__48_27)) begin
		main_0_G_address_a = (kernel_3mm_36_scevgep6_reg >>> 3'd2);
	end
end
assign main_0_G_write_enable_b = 1'd0;
assign main_0_G_in_b = 0;
assign main_0_G_byteena_b = 1'd1;
assign main_0_G_enable_b = 1'd0;
assign main_0_G_address_b = 6'd0;

endmodule
