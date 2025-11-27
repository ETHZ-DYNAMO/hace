

module encoding_dense_2(
	start,
	clk,
	reset,
	arg_A,
	result
);
input start, clk, reset;
input [31:0] arg_A;
output [31:0] result;

reg [1:0]cur_state;
always @(posedge clk)
if(reset)
	cur_state <= 1;
else case(cur_state)
	1: if(start) begin
		if(arg_A != 0) cur_state <= 2;
		else      cur_state <= 3;
	end
	2: begin
			cur_state <= 4;
			result <= 32'hdeadbeef;
	end
	3: begin
			cur_state <= 4;
			result <= 32'hfafafafa;
	end
	4: cur_state <= 1;
endcase

endmodule
