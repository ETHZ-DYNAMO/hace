//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Thu Sep 19 13:20:47 2024
// ----------------------------------------------------------------------------
`define MEMORY_CONTROLLER_ADDR_SIZE 32
`define MEMORY_CONTROLLER_DATA_SIZE 64
// Number of RAM elements: 3
`define MEMORY_CONTROLLER_TAG_SIZE 9
`timescale 1 ns / 1 ns
module covariance
(
	clk,
	clk2x,
	clk1x_follower,
	reset,
	memory_controller_waitrequest,
	start,
	finish,
	arg_data,
	arg_symmat,
	arg_mean,
	main_0_data_write_enable_a,
	main_0_data_in_a,
	main_0_data_byteena_a,
	main_0_data_enable_a,
	main_0_data_address_a,
	main_0_data_out_a,
	main_0_data_write_enable_b,
	main_0_data_in_b,
	main_0_data_byteena_b,
	main_0_data_enable_b,
	main_0_data_address_b,
	main_0_data_out_b,
	main_0_mean_write_enable_a,
	main_0_mean_in_a,
	main_0_mean_byteena_a,
	main_0_mean_enable_a,
	main_0_mean_address_a,
	main_0_mean_out_a,
	main_0_mean_write_enable_b,
	main_0_mean_in_b,
	main_0_mean_byteena_b,
	main_0_mean_enable_b,
	main_0_mean_address_b,
	main_0_mean_out_b,
	main_0_symmat_write_enable_a,
	main_0_symmat_in_a,
	main_0_symmat_byteena_a,
	main_0_symmat_enable_a,
	main_0_symmat_address_a,
	main_0_symmat_out_a,
	main_0_symmat_write_enable_b,
	main_0_symmat_in_b,
	main_0_symmat_byteena_b,
	main_0_symmat_enable_b,
	main_0_symmat_address_b,
	main_0_symmat_out_b
);

parameter [5:0] LEGUP_0 = 6'd0;
parameter [5:0] LEGUP_F_covariance_BB__1_1 = 6'd1;
parameter [5:0] LEGUP_F_covariance_BB__2_2 = 6'd2;
parameter [5:0] LEGUP_F_covariance_BB__2_3 = 6'd3;
parameter [5:0] LEGUP_F_covariance_BB__2_4 = 6'd4;
parameter [5:0] LEGUP_F_covariance_BB__8_5 = 6'd5;
parameter [5:0] LEGUP_F_covariance_BB__8_6 = 6'd6;
parameter [5:0] LEGUP_F_covariance_BB__8_7 = 6'd7;
parameter [5:0] LEGUP_F_covariance_BB__8_8 = 6'd8;
parameter [5:0] LEGUP_F_covariance_BB__8_9 = 6'd9;
parameter [5:0] LEGUP_F_covariance_BB__8_10 = 6'd10;
parameter [5:0] LEGUP_F_covariance_BB__8_11 = 6'd11;
parameter [5:0] LEGUP_F_covariance_BB__8_12 = 6'd12;
parameter [5:0] LEGUP_F_covariance_BB__8_13 = 6'd13;
parameter [5:0] LEGUP_F_covariance_BB__8_14 = 6'd14;
parameter [5:0] LEGUP_F_covariance_BB__8_15 = 6'd15;
parameter [5:0] LEGUP_F_covariance_BB__8_16 = 6'd16;
parameter [5:0] LEGUP_F_covariance_BB__8_17 = 6'd17;
parameter [5:0] LEGUP_F_covariance_BB__8_18 = 6'd18;
parameter [5:0] LEGUP_F_covariance_BB__8_19 = 6'd19;
parameter [5:0] LEGUP_F_covariance_BB__8_20 = 6'd20;
parameter [5:0] LEGUP_F_covariance_BB__8_21 = 6'd21;
parameter [5:0] LEGUP_F_covariance_BB__8_22 = 6'd22;
parameter [5:0] LEGUP_F_covariance_BB__8_23 = 6'd23;
parameter [5:0] LEGUP_F_covariance_BB__8_24 = 6'd24;
parameter [5:0] LEGUP_F_covariance_BB__8_25 = 6'd25;
parameter [5:0] LEGUP_F_covariance_BB__8_26 = 6'd26;
parameter [5:0] LEGUP_F_covariance_BB__8_27 = 6'd27;
parameter [5:0] LEGUP_F_covariance_BB__8_28 = 6'd28;
parameter [5:0] LEGUP_F_covariance_BB__8_29 = 6'd29;
parameter [5:0] LEGUP_F_covariance_BB__8_30 = 6'd30;
parameter [5:0] LEGUP_F_covariance_BB__8_31 = 6'd31;
parameter [5:0] LEGUP_F_covariance_BB__8_32 = 6'd32;
parameter [5:0] LEGUP_F_covariance_BB__8_33 = 6'd33;
parameter [5:0] LEGUP_F_covariance_BB__8_34 = 6'd34;
parameter [5:0] LEGUP_F_covariance_BB__8_35 = 6'd35;
parameter [5:0] LEGUP_F_covariance_BB__8_36 = 6'd36;
parameter [5:0] LEGUP_F_covariance_BB__8_37 = 6'd37;
parameter [5:0] LEGUP_F_covariance_BB__8_38 = 6'd38;
parameter [5:0] LEGUP_F_covariance_BB_preheader1preheaderpreheader_39 = 6'd39;
parameter [5:0] LEGUP_F_covariance_BB_preheader1preheader_40 = 6'd40;
parameter [5:0] LEGUP_F_covariance_BB__12_41 = 6'd41;
parameter [5:0] LEGUP_F_covariance_BB__12_42 = 6'd42;
parameter [5:0] LEGUP_F_covariance_BB__12_43 = 6'd43;
parameter [5:0] LEGUP_F_covariance_BB__12_44 = 6'd44;
parameter [5:0] LEGUP_F_covariance_BB_preheader1_45 = 6'd45;
parameter [5:0] LEGUP_F_covariance_BB_preheaderpreheaderpreheader_46 = 6'd46;
parameter [5:0] LEGUP_F_covariance_BB_preheaderpreheader_47 = 6'd47;
parameter [5:0] LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48 = 6'd48;
parameter [5:0] LEGUP_F_covariance_BB_lrphpreheader_49 = 6'd49;
parameter [5:0] LEGUP_F_covariance_BB_lrphpreheader_50 = 6'd50;
parameter [5:0] LEGUP_F_covariance_BB_lrph_51 = 6'd51;
parameter [5:0] LEGUP_F_covariance_BB_lrph_52 = 6'd52;
parameter [5:0] LEGUP_F_covariance_BB__25_53 = 6'd53;
parameter [5:0] LEGUP_F_covariance_BB__25_54 = 6'd54;
parameter [5:0] LEGUP_F_covariance_BB__25_55 = 6'd55;
parameter [5:0] LEGUP_F_covariance_BB__25_56 = 6'd56;
parameter [5:0] LEGUP_F_covariance_BB__35_57 = 6'd57;
parameter [5:0] LEGUP_F_covariance_BB__35_58 = 6'd58;
parameter [5:0] LEGUP_F_covariance_BB__35_59 = 6'd59;
parameter [5:0] LEGUP_F_covariance_BB_preheader_60 = 6'd60;
parameter [5:0] LEGUP_F_covariance_BB__38_61 = 6'd61;

input  clk;
input  clk2x;
input  clk1x_follower;
input  reset;
input  memory_controller_waitrequest;
input  start;
output reg  finish;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_data;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_symmat;
input [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_mean;
output reg  main_0_data_write_enable_a;
output reg [31:0] main_0_data_in_a;
output  main_0_data_byteena_a;
output reg  main_0_data_enable_a;
output reg [9:0] main_0_data_address_a;
input [31:0] main_0_data_out_a;
output  main_0_data_write_enable_b;
output [31:0] main_0_data_in_b;
output  main_0_data_byteena_b;
output reg  main_0_data_enable_b;
output reg [9:0] main_0_data_address_b;
input [31:0] main_0_data_out_b;
output reg  main_0_mean_write_enable_a;
output reg [31:0] main_0_mean_in_a;
output  main_0_mean_byteena_a;
output reg  main_0_mean_enable_a;
output reg [4:0] main_0_mean_address_a;
input [31:0] main_0_mean_out_a;
output  main_0_mean_write_enable_b;
output [31:0] main_0_mean_in_b;
output  main_0_mean_byteena_b;
output  main_0_mean_enable_b;
output [4:0] main_0_mean_address_b;
input [31:0] main_0_mean_out_b;
output reg  main_0_symmat_write_enable_a;
output reg [31:0] main_0_symmat_in_a;
output  main_0_symmat_byteena_a;
output reg  main_0_symmat_enable_a;
output reg [9:0] main_0_symmat_address_a;
input [31:0] main_0_symmat_out_a;
output  main_0_symmat_write_enable_b;
output [31:0] main_0_symmat_in_b;
output  main_0_symmat_byteena_b;
output  main_0_symmat_enable_b;
output [9:0] main_0_symmat_address_b;
input [31:0] main_0_symmat_out_b;
reg [5:0] cur_state;
reg [5:0] next_state;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_data_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_symmat_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] arg_mean_reg;
reg  fsm_stall;
reg [5:0] covariance_1_j011;
reg [5:0] covariance_1_j011_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_1_scevgep16;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_1_scevgep16_reg;
reg [31:0] covariance_2_x010;
reg [31:0] covariance_2_x010_reg;
reg [31:0] covariance_2_i09;
reg [31:0] covariance_2_i09_reg;
reg [31:0] covariance_2_3;
reg [31:0] covariance_2_4;
reg [31:0] covariance_2_4_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_2_scevgep13;
reg [31:0] covariance_2_5;
reg [31:0] covariance_2_6;
reg [31:0] covariance_2_7;
reg [31:0] covariance_2_7_reg;
reg  covariance_2_exitcond18;
reg  covariance_2_exitcond18_reg;
reg [31:0] covariance_8_lcssa1;
reg [31:0] covariance_8_lcssa1_reg;
reg [26:0] covariance_8_9;
reg [6:0] covariance_8_10;
reg [6:0] covariance_8_10_reg;
reg  covariance_8_exitcond20;
reg  covariance_8_exitcond20_reg;
reg [5:0] covariance_preheader1preheader_i18;
reg [5:0] covariance_preheader1preheader_i18_reg;
reg [11:0] covariance_preheader1preheader_11;
reg [11:0] covariance_preheader1preheader_11_reg;
reg [31:0] covariance_12_j17;
reg [31:0] covariance_12_j17_reg;
reg [31:0] covariance_12_13;
reg [31:0] covariance_12_13_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_12_scevgep8;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_12_scevgep8_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_12_scevgep9;
reg [31:0] covariance_12_14;
reg [31:0] covariance_12_14_reg;
reg [31:0] covariance_12_15;
reg [31:0] covariance_12_16;
reg [31:0] covariance_12_17;
reg [31:0] covariance_12_17_reg;
reg  covariance_12_exitcond;
reg  covariance_12_exitcond_reg;
reg [6:0] covariance_preheader1_18;
reg  covariance_preheader1_exitcond16;
reg [31:0] covariance_preheaderpreheader_j106;
reg [31:0] covariance_preheaderpreheader_j106_reg;
reg  covariance_preheaderpreheader_exitcond294;
reg [31:0] covariance_preheaderpreheaderbackedge_j106be;
reg [31:0] covariance_preheaderpreheaderbackedge_j106be_reg;
reg [31:0] covariance_lrphpreheader_19;
reg [31:0] covariance_lrphpreheader_19_reg;
reg [31:0] covariance_lrphpreheader_20;
reg [31:0] covariance_lrphpreheader_20_reg;
reg [31:0] covariance_lrph_indvar;
reg [31:0] covariance_lrph_indvar_reg;
reg [31:0] covariance_lrph_21;
reg [31:0] covariance_lrph_21_reg;
reg [31:0] covariance_lrph_22;
reg [31:0] covariance_lrph_22_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_lrph_scevgep6;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_lrph_scevgep6_reg;
reg [31:0] covariance_lrph_23;
reg [31:0] covariance_lrph_24;
reg [31:0] covariance_lrph_24_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_lrph_scevgep5;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_lrph_scevgep5_reg;
reg [31:0] covariance_25_x103;
reg [31:0] covariance_25_x103_reg;
reg [31:0] covariance_25_i22;
reg [31:0] covariance_25_i22_reg;
reg [31:0] covariance_25_26;
reg [31:0] covariance_25_27;
reg [31:0] covariance_25_27_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_25_scevgep;
reg [31:0] covariance_25_28;
reg [31:0] covariance_25_29;
reg [31:0] covariance_25_29_reg;
reg [`MEMORY_CONTROLLER_ADDR_SIZE-1:0] covariance_25_scevgep3;
reg [31:0] covariance_25_30;
reg [31:0] covariance_25_31;
reg [31:0] covariance_25_32;
reg [31:0] covariance_25_33;
reg [31:0] covariance_25_34;
reg [31:0] covariance_25_34_reg;
reg  covariance_25_exitcond3;
reg  covariance_25_exitcond3_reg;
reg [31:0] covariance_35_lcssa;
reg [31:0] covariance_35_lcssa_reg;
reg [31:0] covariance_35_36;
reg [31:0] covariance_35_36_reg;
reg  covariance_35_exitcond8;
reg  covariance_35_exitcond8_reg;
reg [31:0] covariance_preheader_37;
reg  covariance_preheader_exitcond30;
reg [31:0] covariance_signed_divide_32_0_op0;
reg [6:0] covariance_signed_divide_32_0_op1;
reg  covariance_signed_divide_32_0_inst_clock;
reg  covariance_signed_divide_32_0_inst_aclr;
reg  covariance_signed_divide_32_0_inst_clken;
reg [31:0] covariance_signed_divide_32_0_inst_numer;
reg [6:0] covariance_signed_divide_32_0_inst_denom;
wire [31:0] covariance_signed_divide_32_0_inst_quotient;
wire [6:0] covariance_signed_divide_32_0_inst_remain;
reg [31:0] divide_covariance_8_9_temp_out;
reg  divide_covariance_8_9_en;
reg [26:0] divide_covariance_8_9_out;
reg [26:0] covariance_signed_divide_32_0;
reg  legup_mult_covariance_lrphpreheader_20_en;
reg [31:0] covariance_lrphpreheader_20_stage0_reg;
reg  legup_mult_1_unsigned_32_32_1_0_clock;
reg  legup_mult_1_unsigned_32_32_1_0_aclr;
reg  legup_mult_1_unsigned_32_32_1_0_sum;
reg  legup_mult_1_unsigned_32_32_1_0_clken;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_dataa;
reg [31:0] legup_mult_1_unsigned_32_32_1_0_datab;
wire [63:0] legup_mult_1_unsigned_32_32_1_0_result;
reg [63:0] legup_mult_covariance_25_32_out_actual;
reg [31:0] legup_mult_covariance_25_32_out;
reg  legup_mult_covariance_25_32_en;

/*   %9 = sdiv i32 %.lcssa1, 32, !MSB !4, !LSB !2, !extendFrom !5*/
lpm_divide covariance_signed_divide_32_0_inst (
	.clock (covariance_signed_divide_32_0_inst_clock),
	.aclr (covariance_signed_divide_32_0_inst_aclr),
	.clken (covariance_signed_divide_32_0_inst_clken),
	.numer (covariance_signed_divide_32_0_inst_numer),
	.denom (covariance_signed_divide_32_0_inst_denom),
	.quotient (covariance_signed_divide_32_0_inst_quotient),
	.remain (covariance_signed_divide_32_0_inst_remain)
);

defparam
	covariance_signed_divide_32_0_inst.lpm_widthn = 32,
	covariance_signed_divide_32_0_inst.lpm_widthd = 7,
	covariance_signed_divide_32_0_inst.lpm_drepresentation = "SIGNED",
	covariance_signed_divide_32_0_inst.lpm_nrepresentation = "SIGNED",
	covariance_signed_divide_32_0_inst.lpm_hint = "LPM_REMAINDERPOSITIVE=FALSE",
	covariance_signed_divide_32_0_inst.lpm_pipeline = 32;

/*   %32 = mul nsw i32 %30, %31, !MSB !4, !LSB !2, !extendFrom !4*/
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
		next_state = LEGUP_F_covariance_BB__1_1;
LEGUP_F_covariance_BB__12_41:
		next_state = LEGUP_F_covariance_BB__12_42;
LEGUP_F_covariance_BB__12_42:
		next_state = LEGUP_F_covariance_BB__12_43;
LEGUP_F_covariance_BB__12_43:
		next_state = LEGUP_F_covariance_BB__12_44;
LEGUP_F_covariance_BB__12_44:
	if ((fsm_stall == 1'd0) && (covariance_12_exitcond_reg == 1'd1))
		next_state = LEGUP_F_covariance_BB_preheader1_45;
	else if ((fsm_stall == 1'd0) && (covariance_12_exitcond_reg == 1'd0))
		next_state = LEGUP_F_covariance_BB__12_41;
LEGUP_F_covariance_BB__1_1:
		next_state = LEGUP_F_covariance_BB__2_2;
LEGUP_F_covariance_BB__25_53:
		next_state = LEGUP_F_covariance_BB__25_54;
LEGUP_F_covariance_BB__25_54:
		next_state = LEGUP_F_covariance_BB__25_55;
LEGUP_F_covariance_BB__25_55:
		next_state = LEGUP_F_covariance_BB__25_56;
LEGUP_F_covariance_BB__25_56:
	if ((fsm_stall == 1'd0) && (covariance_25_exitcond3_reg == 1'd1))
		next_state = LEGUP_F_covariance_BB__35_57;
	else if ((fsm_stall == 1'd0) && (covariance_25_exitcond3_reg == 1'd0))
		next_state = LEGUP_F_covariance_BB__25_53;
LEGUP_F_covariance_BB__2_2:
		next_state = LEGUP_F_covariance_BB__2_3;
LEGUP_F_covariance_BB__2_3:
		next_state = LEGUP_F_covariance_BB__2_4;
LEGUP_F_covariance_BB__2_4:
	if ((fsm_stall == 1'd0) && (covariance_2_exitcond18_reg == 1'd1))
		next_state = LEGUP_F_covariance_BB__8_5;
	else if ((fsm_stall == 1'd0) && (covariance_2_exitcond18_reg == 1'd0))
		next_state = LEGUP_F_covariance_BB__2_2;
LEGUP_F_covariance_BB__35_57:
		next_state = LEGUP_F_covariance_BB__35_58;
LEGUP_F_covariance_BB__35_58:
		next_state = LEGUP_F_covariance_BB__35_59;
LEGUP_F_covariance_BB__35_59:
	if ((fsm_stall == 1'd0) && (covariance_35_exitcond8_reg == 1'd1))
		next_state = LEGUP_F_covariance_BB_preheader_60;
	else if ((fsm_stall == 1'd0) && (covariance_35_exitcond8_reg == 1'd0))
		next_state = LEGUP_F_covariance_BB_lrph_51;
LEGUP_F_covariance_BB__38_61:
		next_state = LEGUP_0;
LEGUP_F_covariance_BB__8_10:
		next_state = LEGUP_F_covariance_BB__8_11;
LEGUP_F_covariance_BB__8_11:
		next_state = LEGUP_F_covariance_BB__8_12;
LEGUP_F_covariance_BB__8_12:
		next_state = LEGUP_F_covariance_BB__8_13;
LEGUP_F_covariance_BB__8_13:
		next_state = LEGUP_F_covariance_BB__8_14;
LEGUP_F_covariance_BB__8_14:
		next_state = LEGUP_F_covariance_BB__8_15;
LEGUP_F_covariance_BB__8_15:
		next_state = LEGUP_F_covariance_BB__8_16;
LEGUP_F_covariance_BB__8_16:
		next_state = LEGUP_F_covariance_BB__8_17;
LEGUP_F_covariance_BB__8_17:
		next_state = LEGUP_F_covariance_BB__8_18;
LEGUP_F_covariance_BB__8_18:
		next_state = LEGUP_F_covariance_BB__8_19;
LEGUP_F_covariance_BB__8_19:
		next_state = LEGUP_F_covariance_BB__8_20;
LEGUP_F_covariance_BB__8_20:
		next_state = LEGUP_F_covariance_BB__8_21;
LEGUP_F_covariance_BB__8_21:
		next_state = LEGUP_F_covariance_BB__8_22;
LEGUP_F_covariance_BB__8_22:
		next_state = LEGUP_F_covariance_BB__8_23;
LEGUP_F_covariance_BB__8_23:
		next_state = LEGUP_F_covariance_BB__8_24;
LEGUP_F_covariance_BB__8_24:
		next_state = LEGUP_F_covariance_BB__8_25;
LEGUP_F_covariance_BB__8_25:
		next_state = LEGUP_F_covariance_BB__8_26;
LEGUP_F_covariance_BB__8_26:
		next_state = LEGUP_F_covariance_BB__8_27;
LEGUP_F_covariance_BB__8_27:
		next_state = LEGUP_F_covariance_BB__8_28;
LEGUP_F_covariance_BB__8_28:
		next_state = LEGUP_F_covariance_BB__8_29;
LEGUP_F_covariance_BB__8_29:
		next_state = LEGUP_F_covariance_BB__8_30;
LEGUP_F_covariance_BB__8_30:
		next_state = LEGUP_F_covariance_BB__8_31;
LEGUP_F_covariance_BB__8_31:
		next_state = LEGUP_F_covariance_BB__8_32;
LEGUP_F_covariance_BB__8_32:
		next_state = LEGUP_F_covariance_BB__8_33;
LEGUP_F_covariance_BB__8_33:
		next_state = LEGUP_F_covariance_BB__8_34;
LEGUP_F_covariance_BB__8_34:
		next_state = LEGUP_F_covariance_BB__8_35;
LEGUP_F_covariance_BB__8_35:
		next_state = LEGUP_F_covariance_BB__8_36;
LEGUP_F_covariance_BB__8_36:
		next_state = LEGUP_F_covariance_BB__8_37;
LEGUP_F_covariance_BB__8_37:
		next_state = LEGUP_F_covariance_BB__8_38;
LEGUP_F_covariance_BB__8_38:
	if ((fsm_stall == 1'd0) && (covariance_8_exitcond20_reg == 1'd1))
		next_state = LEGUP_F_covariance_BB_preheader1preheaderpreheader_39;
	else if ((fsm_stall == 1'd0) && (covariance_8_exitcond20_reg == 1'd0))
		next_state = LEGUP_F_covariance_BB__1_1;
LEGUP_F_covariance_BB__8_5:
		next_state = LEGUP_F_covariance_BB__8_6;
LEGUP_F_covariance_BB__8_6:
		next_state = LEGUP_F_covariance_BB__8_7;
LEGUP_F_covariance_BB__8_7:
		next_state = LEGUP_F_covariance_BB__8_8;
LEGUP_F_covariance_BB__8_8:
		next_state = LEGUP_F_covariance_BB__8_9;
LEGUP_F_covariance_BB__8_9:
		next_state = LEGUP_F_covariance_BB__8_10;
LEGUP_F_covariance_BB_lrph_51:
		next_state = LEGUP_F_covariance_BB_lrph_52;
LEGUP_F_covariance_BB_lrph_52:
		next_state = LEGUP_F_covariance_BB__25_53;
LEGUP_F_covariance_BB_lrphpreheader_49:
		next_state = LEGUP_F_covariance_BB_lrphpreheader_50;
LEGUP_F_covariance_BB_lrphpreheader_50:
		next_state = LEGUP_F_covariance_BB_lrph_51;
LEGUP_F_covariance_BB_preheader1_45:
	if ((fsm_stall == 1'd0) && (covariance_preheader1_exitcond16 == 1'd1))
		next_state = LEGUP_F_covariance_BB_preheaderpreheaderpreheader_46;
	else if ((fsm_stall == 1'd0) && (covariance_preheader1_exitcond16 == 1'd0))
		next_state = LEGUP_F_covariance_BB_preheader1preheader_40;
LEGUP_F_covariance_BB_preheader1preheader_40:
		next_state = LEGUP_F_covariance_BB__12_41;
LEGUP_F_covariance_BB_preheader1preheaderpreheader_39:
		next_state = LEGUP_F_covariance_BB_preheader1preheader_40;
LEGUP_F_covariance_BB_preheader_60:
	if ((fsm_stall == 1'd0) && (covariance_preheader_exitcond30 == 1'd1))
		next_state = LEGUP_F_covariance_BB__38_61;
	else if ((fsm_stall == 1'd0) && (covariance_preheader_exitcond30 == 1'd0))
		next_state = LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48;
LEGUP_F_covariance_BB_preheaderpreheader_47:
	if ((fsm_stall == 1'd0) && (covariance_preheaderpreheader_exitcond294 == 1'd1))
		next_state = LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48;
	else if ((fsm_stall == 1'd0) && (covariance_preheaderpreheader_exitcond294 == 1'd0))
		next_state = LEGUP_F_covariance_BB_lrphpreheader_49;
LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48:
		next_state = LEGUP_F_covariance_BB_preheaderpreheader_47;
LEGUP_F_covariance_BB_preheaderpreheaderpreheader_46:
		next_state = LEGUP_F_covariance_BB_preheaderpreheader_47;
default:
	next_state = cur_state;
endcase

end
always @(posedge clk) begin
	if (start) begin
		arg_data_reg <= arg_data;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_symmat_reg <= arg_symmat;
	end
end
always @(posedge clk) begin
	if (start) begin
		arg_mean_reg <= arg_mean;
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
	/* covariance: %1*/
	/*   %j.011 = phi i32 [ 0, %0 ], [ %10, %8 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		covariance_1_j011 = 32'd0;
	end
	/* covariance: %1*/
	/*   %j.011 = phi i32 [ 0, %0 ], [ %10, %8 ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__8_38) & (fsm_stall == 1'd0)) & (covariance_8_exitcond20_reg == 1'd0))) */ begin
		covariance_1_j011 = covariance_8_10_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %1*/
	/*   %j.011 = phi i32 [ 0, %0 ], [ %10, %8 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_0) & (fsm_stall == 1'd0)) & (start == 1'd1))) begin
		covariance_1_j011_reg <= covariance_1_j011;
	end
	/* covariance: %1*/
	/*   %j.011 = phi i32 [ 0, %0 ], [ %10, %8 ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_covariance_BB__8_38) & (fsm_stall == 1'd0)) & (covariance_8_exitcond20_reg == 1'd0))) begin
		covariance_1_j011_reg <= covariance_1_j011;
	end
end
always @(*) begin
	/* covariance: %1*/
	/*   %scevgep16 = getelementptr i32* %mean, i32 %j.011, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_1_scevgep16 = (arg_mean_reg + (4 * {26'd0,covariance_1_j011_reg}));
end
always @(posedge clk) begin
	/* covariance: %1*/
	/*   %scevgep16 = getelementptr i32* %mean, i32 %j.011, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__1_1)) begin
		covariance_1_scevgep16_reg <= covariance_1_scevgep16;
	end
end
always @(*) begin
	/* covariance: %2*/
	/*   %x.010 = phi i32 [ 0, %1 ], [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB__1_1) & (fsm_stall == 1'd0))) begin
		covariance_2_x010 = 32'd0;
	end
	/* covariance: %2*/
	/*   %x.010 = phi i32 [ 0, %1 ], [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__2_4) & (fsm_stall == 1'd0)) & (covariance_2_exitcond18_reg == 1'd0))) */ begin
		covariance_2_x010 = covariance_2_6;
	end
end
always @(posedge clk) begin
	/* covariance: %2*/
	/*   %x.010 = phi i32 [ 0, %1 ], [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB__1_1) & (fsm_stall == 1'd0))) begin
		covariance_2_x010_reg <= covariance_2_x010;
	end
	/* covariance: %2*/
	/*   %x.010 = phi i32 [ 0, %1 ], [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__2_4) & (fsm_stall == 1'd0)) & (covariance_2_exitcond18_reg == 1'd0))) begin
		covariance_2_x010_reg <= covariance_2_x010;
	end
end
always @(*) begin
	/* covariance: %2*/
	/*   %i.09 = phi i32 [ 0, %1 ], [ %7, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB__1_1) & (fsm_stall == 1'd0))) begin
		covariance_2_i09 = 32'd0;
	end
	/* covariance: %2*/
	/*   %i.09 = phi i32 [ 0, %1 ], [ %7, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__2_4) & (fsm_stall == 1'd0)) & (covariance_2_exitcond18_reg == 1'd0))) */ begin
		covariance_2_i09 = covariance_2_7_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %2*/
	/*   %i.09 = phi i32 [ 0, %1 ], [ %7, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB__1_1) & (fsm_stall == 1'd0))) begin
		covariance_2_i09_reg <= covariance_2_i09;
	end
	/* covariance: %2*/
	/*   %i.09 = phi i32 [ 0, %1 ], [ %7, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__2_4) & (fsm_stall == 1'd0)) & (covariance_2_exitcond18_reg == 1'd0))) begin
		covariance_2_i09_reg <= covariance_2_i09;
	end
end
always @(*) begin
	/* covariance: %2*/
	/*   %3 = mul i32 %i.09, 32, !MSB !4, !LSB !3, !extendFrom !4*/
		covariance_2_3 = (covariance_2_i09_reg * 32'd32);
end
always @(*) begin
	/* covariance: %2*/
	/*   %4 = add i32 %j.011, %3, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_2_4 = ({26'd0,covariance_1_j011_reg} + covariance_2_3);
end
always @(posedge clk) begin
	/* covariance: %2*/
	/*   %4 = add i32 %j.011, %3, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__2_2)) begin
		covariance_2_4_reg <= covariance_2_4;
	end
end
always @(*) begin
	/* covariance: %2*/
	/*   %scevgep13 = getelementptr i32* %data, i32 %4, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_2_scevgep13 = (arg_data_reg + (4 * covariance_2_4_reg));
end
always @(*) begin
	/* covariance: %2*/
	/*   %5 = load i32* %scevgep13, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_2_5 = main_0_data_out_a;
end
always @(*) begin
	/* covariance: %2*/
	/*   %6 = add nsw i32 %x.010, %5, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_2_6 = (covariance_2_x010_reg + covariance_2_5);
end
always @(*) begin
	/* covariance: %2*/
	/*   %7 = add nsw i32 %i.09, 1, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_2_7 = (covariance_2_i09_reg + 32'd1);
end
always @(posedge clk) begin
	/* covariance: %2*/
	/*   %7 = add nsw i32 %i.09, 1, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__2_2)) begin
		covariance_2_7_reg <= covariance_2_7;
	end
end
always @(*) begin
	/* covariance: %2*/
	/*   %exitcond18 = icmp eq i32 %7, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_2_exitcond18 = (covariance_2_7 == 32'd32);
end
always @(posedge clk) begin
	/* covariance: %2*/
	/*   %exitcond18 = icmp eq i32 %7, 32, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_covariance_BB__2_2)) begin
		covariance_2_exitcond18_reg <= covariance_2_exitcond18;
	end
end
always @(*) begin
	/* covariance: %8*/
	/*   %.lcssa1 = phi i32 [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_8_lcssa1 = covariance_2_6;
end
always @(posedge clk) begin
	/* covariance: %8*/
	/*   %.lcssa1 = phi i32 [ %6, %2 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__2_4) & (fsm_stall == 1'd0)) & (covariance_2_exitcond18_reg == 1'd1))) begin
		covariance_8_lcssa1_reg <= covariance_8_lcssa1;
	end
end
always @(*) begin
	covariance_8_9 = covariance_signed_divide_32_0;
end
always @(*) begin
	/* covariance: %8*/
	/*   %10 = add nsw i32 %j.011, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		covariance_8_10 = ({1'd0,covariance_1_j011_reg} + 32'd1);
end
always @(posedge clk) begin
	/* covariance: %8*/
	/*   %10 = add nsw i32 %j.011, 1, !MSB !6, !LSB !2, !extendFrom !6*/
	if ((cur_state == LEGUP_F_covariance_BB__8_5)) begin
		covariance_8_10_reg <= covariance_8_10;
	end
end
always @(*) begin
	/* covariance: %8*/
	/*   %exitcond20 = icmp eq i32 %10, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_8_exitcond20 = (covariance_8_10 == 32'd32);
end
always @(posedge clk) begin
	/* covariance: %8*/
	/*   %exitcond20 = icmp eq i32 %10, 32, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_covariance_BB__8_5)) begin
		covariance_8_exitcond20_reg <= covariance_8_exitcond20;
	end
end
always @(*) begin
	/* covariance: %.preheader1.preheader*/
	/*   %i.18 = phi i32 [ %18, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_covariance_BB_preheader1preheaderpreheader_39) & (fsm_stall == 1'd0))) begin
		covariance_preheader1preheader_i18 = 32'd0;
	end
	/* covariance: %.preheader1.preheader*/
	/*   %i.18 = phi i32 [ %18, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB_preheader1_45) & (fsm_stall == 1'd0)) & (covariance_preheader1_exitcond16 == 1'd0))) */ begin
		covariance_preheader1preheader_i18 = covariance_preheader1_18;
	end
end
always @(posedge clk) begin
	/* covariance: %.preheader1.preheader*/
	/*   %i.18 = phi i32 [ %18, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if (((cur_state == LEGUP_F_covariance_BB_preheader1preheaderpreheader_39) & (fsm_stall == 1'd0))) begin
		covariance_preheader1preheader_i18_reg <= covariance_preheader1preheader_i18;
	end
	/* covariance: %.preheader1.preheader*/
	/*   %i.18 = phi i32 [ %18, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ], !MSB !3, !LSB !2, !extendFrom !3*/
	if ((((cur_state == LEGUP_F_covariance_BB_preheader1_45) & (fsm_stall == 1'd0)) & (covariance_preheader1_exitcond16 == 1'd0))) begin
		covariance_preheader1preheader_i18_reg <= covariance_preheader1preheader_i18;
	end
end
always @(*) begin
	/* covariance: %.preheader1.preheader*/
	/*   %11 = mul i32 %i.18, 32, !MSB !7, !LSB !3, !extendFrom !7*/
		covariance_preheader1preheader_11 = ({6'd0,covariance_preheader1preheader_i18_reg} * 32'd32);
end
always @(posedge clk) begin
	/* covariance: %.preheader1.preheader*/
	/*   %11 = mul i32 %i.18, 32, !MSB !7, !LSB !3, !extendFrom !7*/
	if ((cur_state == LEGUP_F_covariance_BB_preheader1preheader_40)) begin
		covariance_preheader1preheader_11_reg <= covariance_preheader1preheader_11;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %j.17 = phi i32 [ 0, %.preheader1.preheader ], [ %17, %12 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_preheader1preheader_40) & (fsm_stall == 1'd0))) begin
		covariance_12_j17 = 32'd0;
	end
	/* covariance: %12*/
	/*   %j.17 = phi i32 [ 0, %.preheader1.preheader ], [ %17, %12 ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__12_44) & (fsm_stall == 1'd0)) & (covariance_12_exitcond_reg == 1'd0))) */ begin
		covariance_12_j17 = covariance_12_17_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %j.17 = phi i32 [ 0, %.preheader1.preheader ], [ %17, %12 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_preheader1preheader_40) & (fsm_stall == 1'd0))) begin
		covariance_12_j17_reg <= covariance_12_j17;
	end
	/* covariance: %12*/
	/*   %j.17 = phi i32 [ 0, %.preheader1.preheader ], [ %17, %12 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__12_44) & (fsm_stall == 1'd0)) & (covariance_12_exitcond_reg == 1'd0))) begin
		covariance_12_j17_reg <= covariance_12_j17;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %13 = add i32 %11, %j.17, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_12_13 = ({20'd0,covariance_preheader1preheader_11_reg} + covariance_12_j17_reg);
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %13 = add i32 %11, %j.17, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_41)) begin
		covariance_12_13_reg <= covariance_12_13;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %scevgep8 = getelementptr i32* %data, i32 %13, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_12_scevgep8 = (arg_data_reg + (4 * covariance_12_13_reg));
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %scevgep8 = getelementptr i32* %data, i32 %13, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__12_42)) begin
		covariance_12_scevgep8_reg <= covariance_12_scevgep8;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %scevgep9 = getelementptr i32* %mean, i32 %j.17, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_12_scevgep9 = (arg_mean_reg + (4 * covariance_12_j17_reg));
end
always @(*) begin
	/* covariance: %12*/
	/*   %14 = load i32* %scevgep9, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_12_14 = main_0_mean_out_a;
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %14 = load i32* %scevgep9, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_42)) begin
		covariance_12_14_reg <= covariance_12_14;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %15 = load i32* %scevgep8, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_12_15 = main_0_data_out_a;
end
always @(*) begin
	/* covariance: %12*/
	/*   %16 = sub nsw i32 %15, %14, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_12_16 = (covariance_12_15 - covariance_12_14_reg);
end
always @(*) begin
	/* covariance: %12*/
	/*   %17 = add nsw i32 %j.17, 1, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_12_17 = (covariance_12_j17_reg + 32'd1);
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %17 = add nsw i32 %j.17, 1, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_41)) begin
		covariance_12_17_reg <= covariance_12_17;
	end
end
always @(*) begin
	/* covariance: %12*/
	/*   %exitcond = icmp eq i32 %17, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_12_exitcond = (covariance_12_17 == 32'd32);
end
always @(posedge clk) begin
	/* covariance: %12*/
	/*   %exitcond = icmp eq i32 %17, 32, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_covariance_BB__12_41)) begin
		covariance_12_exitcond_reg <= covariance_12_exitcond;
	end
end
always @(*) begin
	/* covariance: %.preheader1*/
	/*   %18 = add nsw i32 %i.18, 1, !MSB !6, !LSB !2, !extendFrom !6*/
		covariance_preheader1_18 = ({1'd0,covariance_preheader1preheader_i18_reg} + 32'd1);
end
always @(*) begin
	/* covariance: %.preheader1*/
	/*   %exitcond16 = icmp eq i32 %18, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_preheader1_exitcond16 = (covariance_preheader1_18 == 32'd32);
end
always @(*) begin
	/* covariance: %.preheader.preheader*/
	/*   %j1.06 = phi i32 [ 0, %.preheader.preheader.preheader ], [ %j1.06.be, %.preheader.preheader.backedge ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_preheaderpreheaderpreheader_46) & (fsm_stall == 1'd0))) begin
		covariance_preheaderpreheader_j106 = 32'd0;
	end
	/* covariance: %.preheader.preheader*/
	/*   %j1.06 = phi i32 [ 0, %.preheader.preheader.preheader ], [ %j1.06.be, %.preheader.preheader.backedge ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if (((cur_state == LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48) & (fsm_stall == 1'd0))) */ begin
		covariance_preheaderpreheader_j106 = covariance_preheaderpreheaderbackedge_j106be_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %.preheader.preheader*/
	/*   %j1.06 = phi i32 [ 0, %.preheader.preheader.preheader ], [ %j1.06.be, %.preheader.preheader.backedge ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_preheaderpreheaderpreheader_46) & (fsm_stall == 1'd0))) begin
		covariance_preheaderpreheader_j106_reg <= covariance_preheaderpreheader_j106;
	end
	/* covariance: %.preheader.preheader*/
	/*   %j1.06 = phi i32 [ 0, %.preheader.preheader.preheader ], [ %j1.06.be, %.preheader.preheader.backedge ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_preheaderpreheaderbackedge_48) & (fsm_stall == 1'd0))) begin
		covariance_preheaderpreheader_j106_reg <= covariance_preheaderpreheader_j106;
	end
end
always @(*) begin
	/* covariance: %.preheader.preheader*/
	/*   %exitcond294 = icmp eq i32 %j1.06, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_preheaderpreheader_exitcond294 = (covariance_preheaderpreheader_j106_reg == 32'd32);
end
always @(*) begin
	/* covariance: %.preheader.preheader.backedge*/
	/*   %j1.06.be = phi i32 [ %37, %.preheader ], [ 33, %.preheader.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB_preheaderpreheader_47) & (fsm_stall == 1'd0)) & (covariance_preheaderpreheader_exitcond294 == 1'd1))) begin
		covariance_preheaderpreheaderbackedge_j106be = 32'd33;
	end
	/* covariance: %.preheader.preheader.backedge*/
	/*   %j1.06.be = phi i32 [ %37, %.preheader ], [ 33, %.preheader.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB_preheader_60) & (fsm_stall == 1'd0)) & (covariance_preheader_exitcond30 == 1'd0))) */ begin
		covariance_preheaderpreheaderbackedge_j106be = covariance_preheader_37;
	end
end
always @(posedge clk) begin
	/* covariance: %.preheader.preheader.backedge*/
	/*   %j1.06.be = phi i32 [ %37, %.preheader ], [ 33, %.preheader.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB_preheaderpreheader_47) & (fsm_stall == 1'd0)) & (covariance_preheaderpreheader_exitcond294 == 1'd1))) begin
		covariance_preheaderpreheaderbackedge_j106be_reg <= covariance_preheaderpreheaderbackedge_j106be;
	end
	/* covariance: %.preheader.preheader.backedge*/
	/*   %j1.06.be = phi i32 [ %37, %.preheader ], [ 33, %.preheader.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB_preheader_60) & (fsm_stall == 1'd0)) & (covariance_preheader_exitcond30 == 1'd0))) begin
		covariance_preheaderpreheaderbackedge_j106be_reg <= covariance_preheaderpreheaderbackedge_j106be;
	end
end
always @(*) begin
	/* covariance: %.lr.ph.preheader*/
	/*   %19 = sub i32 32, %j1.06, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_lrphpreheader_19 = (32'd32 - covariance_preheaderpreheader_j106_reg);
end
always @(posedge clk) begin
	/* covariance: %.lr.ph.preheader*/
	/*   %19 = sub i32 32, %j1.06, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrphpreheader_49)) begin
		covariance_lrphpreheader_19_reg <= covariance_lrphpreheader_19;
	end
end
always @(*) begin
	covariance_lrphpreheader_20 = covariance_lrphpreheader_20_stage0_reg;
end
always @(posedge clk) begin
	/* covariance: %.lr.ph.preheader*/
	/*   %20 = mul i32 %j1.06, 33, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrphpreheader_50)) begin
		covariance_lrphpreheader_20_reg <= covariance_lrphpreheader_20;
	end
	/* covariance: %.lr.ph.preheader*/
	/*   %20 = mul i32 %j1.06, 33, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrphpreheader_50)) begin
		covariance_lrphpreheader_20_reg <= covariance_lrphpreheader_20;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %indvar = phi i32 [ %36, %35 ], [ 0, %.lr.ph.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrphpreheader_50) & (fsm_stall == 1'd0))) begin
		covariance_lrph_indvar = 32'd0;
	end
	/* covariance: %.lr.ph*/
	/*   %indvar = phi i32 [ %36, %35 ], [ 0, %.lr.ph.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__35_59) & (fsm_stall == 1'd0)) & (covariance_35_exitcond8_reg == 1'd0))) */ begin
		covariance_lrph_indvar = covariance_35_36_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %indvar = phi i32 [ %36, %35 ], [ 0, %.lr.ph.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrphpreheader_50) & (fsm_stall == 1'd0))) begin
		covariance_lrph_indvar_reg <= covariance_lrph_indvar;
	end
	/* covariance: %.lr.ph*/
	/*   %indvar = phi i32 [ %36, %35 ], [ 0, %.lr.ph.preheader ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__35_59) & (fsm_stall == 1'd0)) & (covariance_35_exitcond8_reg == 1'd0))) begin
		covariance_lrph_indvar_reg <= covariance_lrph_indvar;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %21 = add i32 %j1.06, %indvar, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_lrph_21 = (covariance_preheaderpreheader_j106_reg + covariance_lrph_indvar_reg);
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %21 = add i32 %j1.06, %indvar, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrph_51)) begin
		covariance_lrph_21_reg <= covariance_lrph_21;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %22 = add i32 %20, %indvar, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_lrph_22 = (covariance_lrphpreheader_20_reg + covariance_lrph_indvar_reg);
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %22 = add i32 %20, %indvar, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrph_51)) begin
		covariance_lrph_22_reg <= covariance_lrph_22;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %scevgep6 = getelementptr i32* %symmat, i32 %22, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_lrph_scevgep6 = (arg_symmat_reg + (4 * covariance_lrph_22_reg));
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %scevgep6 = getelementptr i32* %symmat, i32 %22, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB_lrph_52)) begin
		covariance_lrph_scevgep6_reg <= covariance_lrph_scevgep6;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %23 = mul i32 %indvar, 32, !MSB !4, !LSB !3, !extendFrom !4*/
		covariance_lrph_23 = (covariance_lrph_indvar_reg * 32'd32);
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %24 = add i32 %20, %23, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_lrph_24 = (covariance_lrphpreheader_20_reg + covariance_lrph_23);
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %24 = add i32 %20, %23, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB_lrph_51)) begin
		covariance_lrph_24_reg <= covariance_lrph_24;
	end
end
always @(*) begin
	/* covariance: %.lr.ph*/
	/*   %scevgep5 = getelementptr i32* %symmat, i32 %24, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_lrph_scevgep5 = (arg_symmat_reg + (4 * covariance_lrph_24_reg));
end
always @(posedge clk) begin
	/* covariance: %.lr.ph*/
	/*   %scevgep5 = getelementptr i32* %symmat, i32 %24, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB_lrph_52)) begin
		covariance_lrph_scevgep5_reg <= covariance_lrph_scevgep5;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %x1.03 = phi i32 [ 0, %.lr.ph ], [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrph_52) & (fsm_stall == 1'd0))) begin
		covariance_25_x103 = 32'd0;
	end
	/* covariance: %25*/
	/*   %x1.03 = phi i32 [ 0, %.lr.ph ], [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__25_56) & (fsm_stall == 1'd0)) & (covariance_25_exitcond3_reg == 1'd0))) */ begin
		covariance_25_x103 = covariance_25_33;
	end
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %x1.03 = phi i32 [ 0, %.lr.ph ], [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrph_52) & (fsm_stall == 1'd0))) begin
		covariance_25_x103_reg <= covariance_25_x103;
	end
	/* covariance: %25*/
	/*   %x1.03 = phi i32 [ 0, %.lr.ph ], [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__25_56) & (fsm_stall == 1'd0)) & (covariance_25_exitcond3_reg == 1'd0))) begin
		covariance_25_x103_reg <= covariance_25_x103;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %i.22 = phi i32 [ 0, %.lr.ph ], [ %34, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrph_52) & (fsm_stall == 1'd0))) begin
		covariance_25_i22 = 32'd0;
	end
	/* covariance: %25*/
	/*   %i.22 = phi i32 [ 0, %.lr.ph ], [ %34, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	else /* if ((((cur_state == LEGUP_F_covariance_BB__25_56) & (fsm_stall == 1'd0)) & (covariance_25_exitcond3_reg == 1'd0))) */ begin
		covariance_25_i22 = covariance_25_34_reg;
	end
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %i.22 = phi i32 [ 0, %.lr.ph ], [ %34, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if (((cur_state == LEGUP_F_covariance_BB_lrph_52) & (fsm_stall == 1'd0))) begin
		covariance_25_i22_reg <= covariance_25_i22;
	end
	/* covariance: %25*/
	/*   %i.22 = phi i32 [ 0, %.lr.ph ], [ %34, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__25_56) & (fsm_stall == 1'd0)) & (covariance_25_exitcond3_reg == 1'd0))) begin
		covariance_25_i22_reg <= covariance_25_i22;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %26 = mul i32 %i.22, 32, !MSB !4, !LSB !3, !extendFrom !4*/
		covariance_25_26 = (covariance_25_i22_reg * 32'd32);
end
always @(*) begin
	/* covariance: %25*/
	/*   %27 = add i32 %21, %26, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_27 = (covariance_lrph_21_reg + covariance_25_26);
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %27 = add i32 %21, %26, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_53)) begin
		covariance_25_27_reg <= covariance_25_27;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %scevgep = getelementptr i32* %data, i32 %27, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_25_scevgep = (arg_data_reg + (4 * covariance_25_27_reg));
end
always @(*) begin
	/* covariance: %25*/
	/*   %28 = mul i32 %i.22, 32, !MSB !4, !LSB !3, !extendFrom !4*/
		covariance_25_28 = (covariance_25_i22_reg * 32'd32);
end
always @(*) begin
	/* covariance: %25*/
	/*   %29 = add i32 %j1.06, %28, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_29 = (covariance_preheaderpreheader_j106_reg + covariance_25_28);
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %29 = add i32 %j1.06, %28, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_53)) begin
		covariance_25_29_reg <= covariance_25_29;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %scevgep3 = getelementptr i32* %data, i32 %29, !MSB !1, !LSB !2, !extendFrom !1*/
		covariance_25_scevgep3 = (arg_data_reg + (4 * covariance_25_29_reg));
end
always @(*) begin
	/* covariance: %25*/
	/*   %30 = load i32* %scevgep3, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_30 = main_0_data_out_a;
end
always @(*) begin
	/* covariance: %25*/
	/*   %31 = load i32* %scevgep, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_31 = main_0_data_out_b;
end
always @(*) begin
	covariance_25_32 = legup_mult_covariance_25_32_out;
end
always @(*) begin
	/* covariance: %25*/
	/*   %33 = add nsw i32 %x1.03, %32, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_33 = (covariance_25_x103_reg + covariance_25_32);
end
always @(*) begin
	/* covariance: %25*/
	/*   %34 = add nsw i32 %i.22, 1, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_25_34 = (covariance_25_i22_reg + 32'd1);
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %34 = add nsw i32 %i.22, 1, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_53)) begin
		covariance_25_34_reg <= covariance_25_34;
	end
end
always @(*) begin
	/* covariance: %25*/
	/*   %exitcond3 = icmp eq i32 %34, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_25_exitcond3 = (covariance_25_34 == 32'd32);
end
always @(posedge clk) begin
	/* covariance: %25*/
	/*   %exitcond3 = icmp eq i32 %34, 32, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_covariance_BB__25_53)) begin
		covariance_25_exitcond3_reg <= covariance_25_exitcond3;
	end
end
always @(*) begin
	/* covariance: %35*/
	/*   %.lcssa = phi i32 [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_35_lcssa = covariance_25_33;
end
always @(posedge clk) begin
	/* covariance: %35*/
	/*   %.lcssa = phi i32 [ %33, %25 ], !MSB !4, !LSB !2, !extendFrom !4*/
	if ((((cur_state == LEGUP_F_covariance_BB__25_56) & (fsm_stall == 1'd0)) & (covariance_25_exitcond3_reg == 1'd1))) begin
		covariance_35_lcssa_reg <= covariance_35_lcssa;
	end
end
always @(*) begin
	/* covariance: %35*/
	/*   %36 = add i32 %indvar, 1, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_35_36 = (covariance_lrph_indvar_reg + 32'd1);
end
always @(posedge clk) begin
	/* covariance: %35*/
	/*   %36 = add i32 %indvar, 1, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		covariance_35_36_reg <= covariance_35_36;
	end
end
always @(*) begin
	/* covariance: %35*/
	/*   %exitcond8 = icmp eq i32 %36, %19, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_35_exitcond8 = (covariance_35_36 == covariance_lrphpreheader_19_reg);
end
always @(posedge clk) begin
	/* covariance: %35*/
	/*   %exitcond8 = icmp eq i32 %36, %19, !MSB !2, !LSB !2, !extendFrom !2*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		covariance_35_exitcond8_reg <= covariance_35_exitcond8;
	end
end
always @(*) begin
	/* covariance: %.preheader*/
	/*   %37 = add nsw i32 %j1.06, 1, !MSB !4, !LSB !2, !extendFrom !4*/
		covariance_preheader_37 = (covariance_preheaderpreheader_j106_reg + 32'd1);
end
always @(*) begin
	/* covariance: %.preheader*/
	/*   %exitcond30 = icmp eq i32 %37, 32, !MSB !2, !LSB !2, !extendFrom !2*/
		covariance_preheader_exitcond30 = (covariance_preheader_37 == 32'd32);
end
always @(*) begin
	/* covariance: %8*/
	/*   %9 = sdiv i32 %.lcssa1, 32, !MSB !4, !LSB !2, !extendFrom !5*/
		covariance_signed_divide_32_0_op0 = covariance_8_lcssa1_reg;
end
always @(*) begin
	/* covariance: %8*/
	/*   %9 = sdiv i32 %.lcssa1, 32, !MSB !4, !LSB !2, !extendFrom !5*/
if (reset) begin covariance_signed_divide_32_0_op1 = 0; end
		covariance_signed_divide_32_0_op1 = 32'd32;
end
always @(*) begin
	covariance_signed_divide_32_0_inst_clock = clk;
end
always @(*) begin
	covariance_signed_divide_32_0_inst_aclr = reset;
end
always @(*) begin
	covariance_signed_divide_32_0_inst_clken = divide_covariance_8_9_en;
end
always @(*) begin
	covariance_signed_divide_32_0_inst_numer = covariance_signed_divide_32_0_op0;
end
always @(*) begin
	covariance_signed_divide_32_0_inst_denom = covariance_signed_divide_32_0_op1;
end
always @(*) begin
	divide_covariance_8_9_temp_out = covariance_signed_divide_32_0_inst_quotient;
end
always @(*) begin
	divide_covariance_8_9_en = ~(fsm_stall);
end
always @(*) begin
	divide_covariance_8_9_out = divide_covariance_8_9_temp_out;
end
always @(*) begin
	covariance_signed_divide_32_0 = divide_covariance_8_9_out;
end
always @(*) begin
	legup_mult_covariance_lrphpreheader_20_en = ~(fsm_stall);
end
always @(posedge clk) begin
	/* covariance: %.lr.ph.preheader*/
	/*   %20 = mul i32 %j1.06, 33, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((legup_mult_covariance_lrphpreheader_20_en == 1'd1)) begin
		covariance_lrphpreheader_20_stage0_reg <= (covariance_preheaderpreheader_j106_reg * 32'd33);
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
	legup_mult_1_unsigned_32_32_1_0_clken = legup_mult_covariance_25_32_en;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_dataa = covariance_25_30;
end
always @(*) begin
	legup_mult_1_unsigned_32_32_1_0_datab = covariance_25_31;
end
always @(*) begin
	legup_mult_covariance_25_32_out_actual = legup_mult_1_unsigned_32_32_1_0_result;
end
always @(*) begin
	legup_mult_covariance_25_32_out = legup_mult_covariance_25_32_out_actual[31:0];
end
always @(*) begin
	legup_mult_covariance_25_32_en = ~(fsm_stall);
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* covariance: %38*/
	/*   ret void, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__38_61)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
always @(*) begin
	main_0_data_write_enable_a = 1'd0;
	/* covariance: %12*/
	/*   store i32 %16, i32* %scevgep8, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__12_43)) begin
		main_0_data_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_data_in_a = 0;
	/* covariance: %12*/
	/*   store i32 %16, i32* %scevgep8, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__12_43)) begin
		main_0_data_in_a = covariance_12_16;
	end
end
assign main_0_data_byteena_a = 1'd1;
always @(*) begin
	main_0_data_enable_a = 1'd0;
	/* covariance: %2*/
	/*   %5 = load i32* %scevgep13, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__2_3)) begin
		main_0_data_enable_a = 1'd1;
	end
	/* covariance: %12*/
	/*   %15 = load i32* %scevgep8, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_42)) begin
		main_0_data_enable_a = 1'd1;
	end
	/* covariance: %12*/
	/*   store i32 %16, i32* %scevgep8, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__12_43)) begin
		main_0_data_enable_a = 1'd1;
	end
	/* covariance: %25*/
	/*   %30 = load i32* %scevgep3, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_54)) begin
		main_0_data_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_data_address_a = 10'd0;
	/* covariance: %2*/
	/*   %5 = load i32* %scevgep13, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__2_3)) begin
		main_0_data_address_a = (covariance_2_scevgep13 >>> 3'd2);
	end
	/* covariance: %12*/
	/*   %15 = load i32* %scevgep8, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_42)) begin
		main_0_data_address_a = (covariance_12_scevgep8 >>> 3'd2);
	end
	/* covariance: %12*/
	/*   store i32 %16, i32* %scevgep8, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__12_43)) begin
		main_0_data_address_a = (covariance_12_scevgep8_reg >>> 3'd2);
	end
	/* covariance: %25*/
	/*   %30 = load i32* %scevgep3, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_54)) begin
		main_0_data_address_a = (covariance_25_scevgep3 >>> 3'd2);
	end
end
assign main_0_data_write_enable_b = 1'd0;
assign main_0_data_in_b = 0;
assign main_0_data_byteena_b = 1'd1;
always @(*) begin
	main_0_data_enable_b = 1'd0;
	/* covariance: %25*/
	/*   %31 = load i32* %scevgep, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_54)) begin
		main_0_data_enable_b = 1'd1;
	end
end
always @(*) begin
	main_0_data_address_b = 10'd0;
	/* covariance: %25*/
	/*   %31 = load i32* %scevgep, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__25_54)) begin
		main_0_data_address_b = (covariance_25_scevgep >>> 3'd2);
	end
end
always @(*) begin
	main_0_mean_write_enable_a = 1'd0;
	/* covariance: %8*/
	/*   store i32 %9, i32* %scevgep16, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__8_37)) begin
		main_0_mean_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_mean_in_a = 0;
	/* covariance: %8*/
	/*   store i32 %9, i32* %scevgep16, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__8_37)) begin
		main_0_mean_in_a = {{5{covariance_8_9[26]}},covariance_8_9};
	end
end
assign main_0_mean_byteena_a = 1'd1;
always @(*) begin
	main_0_mean_enable_a = 1'd0;
	/* covariance: %8*/
	/*   store i32 %9, i32* %scevgep16, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__8_37)) begin
		main_0_mean_enable_a = 1'd1;
	end
	/* covariance: %12*/
	/*   %14 = load i32* %scevgep9, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_41)) begin
		main_0_mean_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_mean_address_a = 5'd0;
	/* covariance: %8*/
	/*   store i32 %9, i32* %scevgep16, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__8_37)) begin
		main_0_mean_address_a = (covariance_1_scevgep16_reg >>> 3'd2);
	end
	/* covariance: %12*/
	/*   %14 = load i32* %scevgep9, align 4, !MSB !4, !LSB !2, !extendFrom !4*/
	if ((cur_state == LEGUP_F_covariance_BB__12_41)) begin
		main_0_mean_address_a = (covariance_12_scevgep9 >>> 3'd2);
	end
end
assign main_0_mean_write_enable_b = 1'd0;
assign main_0_mean_in_b = 0;
assign main_0_mean_byteena_b = 1'd1;
assign main_0_mean_enable_b = 1'd0;
assign main_0_mean_address_b = 5'd0;
always @(*) begin
	main_0_symmat_write_enable_a = 1'd0;
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		main_0_symmat_write_enable_a = 1'd1;
	end
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep5, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_58)) begin
		main_0_symmat_write_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_symmat_in_a = 0;
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		main_0_symmat_in_a = covariance_35_lcssa_reg;
	end
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep5, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_58)) begin
		main_0_symmat_in_a = covariance_35_lcssa_reg;
	end
end
assign main_0_symmat_byteena_a = 1'd1;
always @(*) begin
	main_0_symmat_enable_a = 1'd0;
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		main_0_symmat_enable_a = 1'd1;
	end
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep5, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_58)) begin
		main_0_symmat_enable_a = 1'd1;
	end
end
always @(*) begin
	main_0_symmat_address_a = 10'd0;
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep6, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_57)) begin
		main_0_symmat_address_a = (covariance_lrph_scevgep6_reg >>> 3'd2);
	end
	/* covariance: %35*/
	/*   store i32 %.lcssa, i32* %scevgep5, align 4, !MSB !1, !LSB !2, !extendFrom !1*/
	if ((cur_state == LEGUP_F_covariance_BB__35_58)) begin
		main_0_symmat_address_a = (covariance_lrph_scevgep5_reg >>> 3'd2);
	end
end
assign main_0_symmat_write_enable_b = 1'd0;
assign main_0_symmat_in_b = 0;
assign main_0_symmat_byteena_b = 1'd1;
assign main_0_symmat_enable_b = 1'd0;
assign main_0_symmat_address_b = 10'd0;

endmodule
