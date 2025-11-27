
module test_resource_sharing
(
	clk,
	reset,
	start,
	memory_write_enable_a,
	memory_in_a,
	memory_byteena_a,
	memory_enable_a,
	memory_address_a,
	memory_out_a
);

	input wire start;
	output memory_write_enable_a;
	output [31:0] memory_in_a;
	output memory_byteena_a;
	output memory_enable_a;
	output [31:0] memory_address_a;
	input [31:0] memory_out_a;

	parameter S0 = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;

reg [2:0] cur_state;
always @(posedge clk)
if(reset)
	cur_state <= S0;
else case(cur_state)
	S0: if(start) cur_state <= S1;
	S1: cur_state <= S2;
	S2: cur_state <= S3;
	S3: cur_state <= S0;
endcase


always @(posedge clk)
case(cur_state)
	S1:      memory_enable_a <= 1;
	S2:      memory_enable_a <= 1;
	default: memory_enable_a <= 0;
endcase

always @(posedge clk)
case(cur_state)
	S1:      memory_address_a <= 1;
	S2:      memory_address_a <= 2;
	default: memory_address_a <= 0;
endcase

always @(posedge clk)
case(cur_state)
	S2:      memory_write_enable_a <= 1;
	default: memory_write_enable_a <= 0;
endcase

always @(*)
case(cur_state)
	S2: memory_in_a <= memory_out_a;
	default: memory_in_a <= 0;
endcase
	
endmodule
