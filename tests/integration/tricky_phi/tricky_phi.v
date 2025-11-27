



module tricky_phi
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


reg cur_state;
always @(posedge clk)
if(reset)
	cur_state <= S0;
else case(cur_state)
	S0: if(start) cur_state <= S1;
	S1: cur_state <= S2;
	S2: if(arg_B) cur_state <= S3; else cur_state <= S4;
	S3: cur_state <= S4;
	S4: if(arg_A) cur_state <= S5; else cur_state <= S2;
	S5: cur_state <= S0;
endcase


reg result_reg;

reg phi;
wire continuous_phi_user;

always @(*)
	continuous_phi_user <= phi;

always @(posedge clk)
case(cur_state)
	S0: begin phi <= arg_B; result_reg <= 0; end
	S3: result_reg <= continuous_phi_user + 1;
	S4: phi <= arg_C;
	default: begin end
endcase
assign result = result_reg;

endmodule
