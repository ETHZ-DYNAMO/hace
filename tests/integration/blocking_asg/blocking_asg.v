module test_blocking_asg
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


always @(posedge clk)
if(reset)
	cur_state <= S0;
else case(cur_state)
	S0: if(start) cur_state <= S1;
	S1: cur_state <= S2;
	S2: cur_state <= S0;
endcase
reg cur_state;
reg result_reg;


reg a_blocking, b_blocking;
reg a_nonblocking, b_nonblocking;

always @(posedge clk)
case(cur_state)
	S1: begin 
		a_blocking = arg_A;
		b_blocking = a_blocking;
		a_nonblocking <= arg_A;
		b_nonblocking <= a_nonblocking;
	end
	S2: result_reg <= b_nonblocking == b_blocking;
	default: begin
		a_nonblocking <= arg_B;
		a_blocking     = arg_B;
	end
endcase


assign result = result_reg;


endmodule
