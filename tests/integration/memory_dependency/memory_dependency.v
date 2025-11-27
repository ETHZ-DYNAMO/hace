
module memory_dependency
(
	clk,
	reset,
	start,
	value,
	return,
	memory_write_enable_a,
	memory_in_a,
	memory_byteena_a,
	memory_enable_a,
	memory_address_a,
	memory_out_a
);
	input [31:0] value;
	output reg [31:0] return;
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
	S1: begin
		memory_in_a <= value;
		memory_enable_a <= 1;
		memory_address_a <= 0;
		memory_write_enable_a <= 1;
	end
	S2: begin
		memory_in_a <= 0;
		memory_enable_a <= 1;
		memory_address_a <= 0;
		memory_write_enable_a <= 0;
	end
	S3: begin
		return <= memory_out_a;
	end
	default: begin
		memory_in_a <= 0;
		memory_enable_a <= 0;
		memory_write_enable_a <= 0;
		memory_address_a <= 0;
	end
endcase

endmodule
