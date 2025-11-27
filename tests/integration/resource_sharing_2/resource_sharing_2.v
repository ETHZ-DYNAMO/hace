


module test_resource_sharing
(
	clk,
	reset,
	start,
	arg_A,
	arg_B,
	arg_C,
	result,
	result_2
);
input wire start;
input wire arg_A;
input wire arg_B;
input wire arg_C;
output wire result;
output wire result_2;
	parameter S0 = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;
	parameter S4 = 4;
	parameter S5 = 5;


always @(posedge clk)
if(reset)
	cur_state <= S0;
else case(cur_state)
	S0: if(start) cur_state <= S1;
	S1: cur_state <= S2;
	S2: cur_state <= S3;
	S3: cur_state <= S4;
	S4: cur_state <= S5;
	S5: cur_state <= S0;
endcase

reg cur_state;
reg a, b, c, result_reg, result_2_reg;
wire addition;

always @(posedge clk)
case(cur_state)
	S0: a <= arg_A;
	S1: b <= arg_B;
	S2: begin 
		c <= addition;
		result_2_reg <= addition;
	end
	S3: begin
		a <= c;
		b <= arg_C;
	end
	S4: result_reg <= addition;
endcase


assign addition = a + b;
assign result = result_reg;
assign result_2 = result_2_reg;


endmodule
