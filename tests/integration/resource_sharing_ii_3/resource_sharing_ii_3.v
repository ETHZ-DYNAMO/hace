


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
input wire [31:0] arg_A;
input wire [31:0] arg_B;
input wire [31:0] arg_C;
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
	S0: if(start) cur_state <= S1;
	S1: cur_state <= S2;
	S2: cur_state <= S3;
	S3: cur_state <= S4;
	S4: cur_state <= S5;
	S5: cur_state <= S0;
endcase

reg cur_state;
reg [31:0] a, b, c, result_reg, inter_reg;
wire addition;

wire [31:0] input_1_a, input_1_b;
wire [31:0] input_2_a, input_2_b;
assign input_1_a = arg_A;
assign input_1_b = arg_B;
assign input_2_a = arg_C;
assign input_2_b = arg_A;

// (A + B) + (C + A)

always @(posedge clk)
case(cur_state)
	S0: begin a <= input_1_a; b <= input_1_b; end
	S1: begin a <= input_2_a; b <= input_2_b; end
	S2: begin end
	S3: inter_reg <= addition;
	S4: begin result_reg <= addition + inter_reg; end
endcase


assign addition = a + b;
assign result = result_reg;


endmodule
