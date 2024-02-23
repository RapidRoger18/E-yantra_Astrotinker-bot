module LED_driver(
	input clk_3125KHz,
	input fault_detect,
	input block_picked,
	input node_flag,
	input object_drop,
	input run_complete,
	input EU_fault_flag,
	input CU_fault_flag,
	input RU_fault_flag,
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
reg run_complete_flag = 0;
always@ (posedge clk_3125KHz) begin
	if (counter == 3125000) begin
		switch <= ~switch;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

always@(*)begin
	if (run_complete) run_complete_flag <= 0;
	if (run_complete_flag) begin
		if (switch) begin
			{led1_R1,led2_R2,led3_R3} <= 3'b0;
			{led1_B1,led2_B2,led3_B3} <= 3'b0;
			{led1_G1,led2_G2,led3_G3} <= 3'b111;
		end
		else begin
			{led1_R1,led2_R2,led3_R3} <= 3'b0;
			{led1_B1,led2_B2,led3_B3} <= 3'b0;
			{led1_G1,led2_G2,led3_G3} <= 3'b000;
		end
	end
	if (EU_fault_flag) begin
		if (glow_flag == 2'b00) 
			glow_flag <= 2'b01;
		
		if (object_drop)
			glow_flag <= 2'b11;
		else if (fault_detect)
			glow_flag <= 2'b10;		
		
		case (glow_flag)
			2'b00: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b01: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b100;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b10: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b100;
				{led1_G1,led2_G2,led3_G3} <= 3'b0;
			end
			2'b11: begin
				{led1_R1,led2_R2,led3_R3} <= 3'b0;
				{led1_B1,led2_B2,led3_B3} <= 3'b0;
				{led1_G1,led2_G2,led3_G3} <= 3'b100;
			end
		endcase
	end

end
endmodule 