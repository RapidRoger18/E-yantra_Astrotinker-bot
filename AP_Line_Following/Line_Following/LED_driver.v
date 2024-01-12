module LED_driver(
	input clk_3125KHz,
	input fault_detect,
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
	output reg led3_B3
);
initial begin
	{led1_R1,led2_R2,led3_R3} <= 3'b0;
	{led1_B1,led2_B2,led3_B3} <= 3'b0;
	{led1_G1,led2_G2,led3_G3} <= 3'b0;
end
reg [1:0] glow_flag = 2'b0;
reg [31:0] counter = 0;
reg switch = 0;
always@ (posedge clk_3125KHz) begin
	if (counter == 3125) begin
		switch <= ~switch;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

always@(*)begin
	if (fault_detect)
			glow_flag <= 2'b10;
	else if (node_flag) begin
		if (node >= 11)
				glow_flag <= (switch) ? 2'b11 : 2'b00; 
		else 
				glow_flag <= 2'b00;
	end
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