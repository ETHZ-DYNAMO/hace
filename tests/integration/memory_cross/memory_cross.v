
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
	memory_out_a,
	cond_A,
	cond_B
);

	input wire start;
	input wire cond_A;
	input wire cond_B;
	output memory_write_enable_a;
	output [31:0] memory_in_a;
	output memory_byteena_a;
	output memory_enable_a;
	output [31:0] memory_address_a;
	input [31:0] memory_out_a;

	parameter S0 = 0;
	parameter S1_A = 1;
	parameter S1_B = 2;
	parameter S2_A = 3;
	parameter S2_B = 4;
	parameter S3 = 5;

reg [2:0] cur_state;
always @(posedge clk)
if(reset)
	cur_state <= S0;
else case(cur_state)
	S0: if(start) begin if(cond_A) cur_state <= S1_A; else cur_state <= S1_B; end
	S1_A: if(cond_B) cur_state <= S2_B; else cur_state <= S2_A;
	S1_B: if(cond_B) cur_state <= S2_A; else cur_state <= S2_B;
	S2_A: cur_state <= S3;
	S2_B: cur_state <= S3;
	S3: cur_state <= S0;
endcase


always @(posedge clk)
case(cur_state)
	S1_A:      memory_enable_a <= 1;
	S1_B:      memory_enable_a <= 1;
	S2_A:      memory_enable_a <= 1;
	S2_B:      memory_enable_a <= 1;
	default: memory_enable_a <= 0;
endcase

always @(posedge clk)
case(cur_state)
	S1_A:      memory_address_a <= 1;
	S1_B:      memory_address_a <= 1;
	S2_A:      memory_address_a <= 2;
	S2_B:      memory_address_a <= 2;
	default: memory_address_a <= 0;
endcase

always @(posedge clk)
case(cur_state)
	S2_A:      memory_write_enable_a <= 1;
	S2_B:      memory_write_enable_a <= 1;
	default: memory_write_enable_a <= 0;
endcase
reg val;
always @(*)
case(cur_state)
	S2_A: val <= memory_out_a;
	S2_B: val <= memory_out_a;
	S3: memory_in_a <= val;
	default: memory_in_a <= 0;
endcase
	
endmodule
