

module truncation_signed(
	clk,
	reset,
	start,
	a,
	res
);
input clk, reset, start;
input signed [31:0] a;
output signed [7:0] b;

reg cur_state;
parameter S0 = 0;
parameter S1 = 1;

reg signed [7:0] out_b;
assign b = out_b;

always @(posedge clk)
if(reset)
	cur_state = S0;
else case(cur_state)
	S0: if(start) cur_state <= S1;
	S1: begin
		out_b <= a[7:0];
		cur_state <= S0;
	end
endcase
endmodule
