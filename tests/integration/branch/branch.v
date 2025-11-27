


module branch
(
	clk,
	reset,
	start,
	arg_A,
	arg_B,
	arg_C,
	result
);
input wire [31:0] start, arg_A, arg_B, arg_C;
output wire [31:0] result;
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
	S0: if(start) if(arg_A == 0) cur_state <= S1; else cur_state <= S2;
	S1: cur_state <= S3;
	S2: cur_state <= S3;
	S3: cur_state <= S4;
	S4: cur_state <= S5;
	S5: cur_state <= S0;
endcase

reg cur_state;
reg [31:0] a, b, c, result_reg;
wire [31:0] addition;

always @(posedge clk)
case(cur_state)
	S0: result_reg <= 1;
	S1: result_reg <= arg_B;
	S2: result_reg <= arg_C;
endcase

assign result = result_reg;


endmodule
