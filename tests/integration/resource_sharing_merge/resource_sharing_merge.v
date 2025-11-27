


module resource_sharing_merge
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
	S0: begin a <= 1; b <= 0; end
	S1: begin a <= arg_C; b <= arg_B; end
	S2: begin a <= arg_A; b <= 1;     end
	S3: begin result_reg <= addition; end
	S4: result_reg <= addition;
endcase


assign addition = a + b;
always @(*)
case(cur_state)
	S5: result = result_reg;
endcase


endmodule
