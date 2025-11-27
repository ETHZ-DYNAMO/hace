/*
int test(arg_A, arg_B, arg_C)
{
	int a;
	if(arg_C)  a = 1;
	else       a = 2;

	int c = shared_adder(a, arg_A);

	return shared_adder(c, arg_B);
}

*/


module test
(
	clk,
	reset,
	start,
	arg_A,
	arg_B,
	arg_C,
	result
);
input wire start;
input wire arg_A;
input wire arg_B;
input wire arg_C;
output wire result;
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
	S0: if(start) if(arg_C) cur_state <= S1; else cur_state <= S2;
	S1: cur_state <= S3;
	S2: cur_state <= S3;
	S3: cur_state <= S4;
	S4: cur_state <= S5;
	S5: cur_state <= S0;
endcase

reg cur_state;
reg a, b, c, result_reg;
wire addition;

always @(posedge clk)
case(cur_state)
	S0: b <= arg_A;
	S1: a <= 1;
	S2: a <= 2;
	S3: begin
		c <= addition;
	end
	S4: begin
		a <= c;
		b <= arg_B;
	end
	S5: result_reg <= addition;
endcase


assign addition = a + b;
assign result = result_reg;


endmodule
