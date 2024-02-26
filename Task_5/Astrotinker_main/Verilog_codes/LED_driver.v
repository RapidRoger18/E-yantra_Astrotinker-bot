module LED_driver(
	input clk_3125KHz,
	input clk_50M,
	input fault_detect,
	input block_picked,
	input node_flag,
	input switch_key,
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
reg fault_detect_flag = 0;
reg object_drop_flag = 0; 
reg [31:0] counter = 0;
reg switch = 0;
reg EU_state = 0;
reg CU_state = 0;
reg RU_state = 0;
reg counter_flag = 0;
reg run_complete_flag = 0;

always@ (posedge clk_3125KHz) begin
	if (counter == 3125000) begin
		switch <= ~switch;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

always@(posedge clk_50M)begin
	if (EU_fault_flag) EU_state <= 1;
	if (CU_fault_flag) CU_state <= 1;
	if (RU_fault_flag) RU_state <= 1;
	if (switch_key) begin
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
		if (EU_state) begin 
			if (fault_detect) fault_detect_flag <= 1;
			if (object_drop) object_drop_flag <= 1;
			
			if (object_drop_flag) { led1_R1, led1_G1, led1_B1 } <= 3'b010; 
			else if (fault_detect_flag) { led1_R1, led1_G1, led1_B1 } <= 3'b001;
			else { led1_R1, led1_G1, led1_B1 } <= 3'b100;
		end
	end
end
endmodule 