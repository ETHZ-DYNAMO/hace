

module encoding_dense_1(
	start,
	clk,
	reset,
	arg_A,
	result
);
input start, clk, reset;
input [31:0] arg_A;
output [31:0] result;

parameter S1 = 0;
parameter S2 = 1;
parameter S3 = 2;
parameter S4 = 3;

reg [1:0]cur_state;
always @(posedge clk)
if(reset)
	cur_state <= S1;
else case(cur_state)
	S1: if(start) begin
		if(arg_A != 0) cur_state <= S2;
		else      cur_state <= S3;
	end
	S2: begin
			cur_state <= S4;
			result <= 32'hdeadbeef;
	end
	S3: begin
			cur_state <= S4;
			result <= 32'hfafafafa;
	end
	S4: cur_state <= S1;
endcase

endmodule
