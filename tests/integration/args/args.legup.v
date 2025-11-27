//----------------------------------------------------------------------------
// LegUp High-Level Synthesis Tool Version 5.0 (http://legup.org)
// Copyright (c) 2009-23 University of Toronto. All Rights Reserved.
// For research and academic purposes only. Commercial use is prohibited.
// Please report bugs at: http://legup.org/bugs
// Please email questions to: legup@eecg.toronto.edu
// Date: Wed Jul 16 12:19:36 2025
// ----------------------------------------------------------------------------
`define MEMORY_CONTROLLER_ADDR_SIZE 32
`define MEMORY_CONTROLLER_DATA_SIZE 64
// Number of RAM elements: 0
`define MEMORY_CONTROLLER_TAG_SIZE 9
`timescale 1 ns / 1 ns
module test_args
(
	clk,
	clk2x,
	clk1x_follower,
	reset,
	memory_controller_waitrequest,
	start,
	input_a,
	input_b,
	input_c,
	finish,
	return_val
);

parameter  LEGUP_0 = 1'd0;
parameter  LEGUP_F_main_BB__0_1 = 1'd1;

input  clk;
input  clk2x;
input  clk1x_follower;
input  reset;
input  memory_controller_waitrequest;
input  start;
input  [31:0] input_a;
input  [31:0] input_b;
input  [31:0] input_c;
output reg  finish;
output reg [31:0] return_val;
reg  cur_state;
reg  next_state;
reg  fsm_stall;

// Local Rams

// End Local Rams

/* synthesis translate_on */
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
		next_state = LEGUP_F_main_BB__0_1;
LEGUP_F_main_BB__0_1:
		next_state = LEGUP_0;
default:
	next_state = cur_state;
endcase

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
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		finish <= 1'd0;
	end
	/* main: %0*/
	/*   ret i32 0, !MSB !3, !LSB !2, !extendFrom !3*/
	if ((cur_state == LEGUP_F_main_BB__0_1)) begin
		finish <= (fsm_stall == 1'd0);
	end
end
always @(posedge clk) begin
	if ((cur_state == LEGUP_0)) begin
		return_val <= 0;
	end
	/* main: %0*/
	/*   ret i32 0, !MSB !3, !LSB !2, !extendFrom !3*/
	if ((cur_state == LEGUP_F_main_BB__0_1)) begin
		return_val <= (input_a * 3) + input_b + input_c;
	end
end

endmodule

