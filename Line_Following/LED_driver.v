module LED_driver(
	input node_flag,
	input [7:0] node,
	output reg led1_R1,													//LED handling pins
	output reg led1_G1,
	output reg led1_B1,
	output reg led2_R2,
	output reg led2_G2,
	output reg led2_B2,
	output reg led3_R3,
	output reg led3_G3,
	output reg led3_B3,
);
reg [1:0] glow_flag;
	always@(*)begin
		case (glow_flag)
			2'b00: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b01: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b111;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b10: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b111;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b11: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b111;
			end
		endcase
	end
endmodule 