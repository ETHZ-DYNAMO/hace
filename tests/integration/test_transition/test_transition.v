


module test_resource_sharing
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
	parameter S3 = 2;
	parameter S4 = 2;
	parameter S5 = 2;


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
reg a, b, c, result_reg;
reg t1;
wire addition;

always @(posedge clk)
case(cur_state)
	S0: a <= arg_A;
	S1: b <= arg_B;
	S2: begin 
		c <= addition;
		t1 <= addition & 1;
	end
	S3: begin
		a <= c;
		b <= arg_C;
	end
	S4: result_reg <= addition;
endcase


assign addition = a + b;
assign result = result_reg;


endmodule
