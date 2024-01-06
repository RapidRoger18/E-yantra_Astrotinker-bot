module Fault_detection(
	input clk_50M,
	input UV_echo,															//UV sensor recieve
	input node_flag,
	output reg UV_trig,													//UV sensor send
	output reg led1_R1,													//LED handling pins
	output reg led1_G1,
	output reg led1_B1,
	output reg led2_R2,
	output reg led2_G2,
	output reg led2_B2,
	output reg led3_R3,
	output reg led3_G3,
	output reg led3_B3,
	output reg [7:0] msg													//msg to bluetooth device
);
	reg [7:0] msg_contain [9:0];										//msg ram container to store msg
	reg state1 = 0;														//UV sensor FSM driver
	reg [3:0] index = 0;													//indexing for msg
	reg msg_state = 0;													//msg sending FSM driver
	reg [15:0] msg_delay = 0;											//width of each msg/delay between changing of two chars
	reg flag = 0;															//activate if Fault is detected
	reg [15:0] counter = 0;												//10us UV sensor trigger pulse counter
	reg [15:0] time_counter = 0;										//measuring pulse width of UV recieved data
	reg [15:0] prev_time_counter = 0;								//comparison for fault detection
	
initial begin
	UV_trig <= 0;												
	led1_R1 <= 0;													
	led1_G1 <= 0;
	led1_B1 <= 0;
	led2_R2 <= 0;
	led2_G2 <= 0;
	led2_B2 <= 0;	
	led3_R3 <= 0;
	led3_G3 <= 0;
	led3_B3 <= 0;
	msg <= 0;
	msg_contain [0] <= 8'h46;												//F
	msg_contain [1] <= 8'h49;                                   //I
	msg_contain [2] <= 8'h4D;                                   //M
	msg_contain [3] <= 8'h2D;												//-
	msg_contain [4] <= 8'h43;												//C
	msg_contain [5] <= 8'h53;												//S
	msg_contain [6] <= 8'h55;												//U
	msg_contain [7] <= 8'h31;												//1
	msg_contain [8] <= 8'h2D;												//-
	msg_contain [9] <= 8'h23;												//#
end
always@(posedge clk_50M)begin
	case(state1)																				//UV sensor driver FSM
		1'b0:begin
			if (counter == 500) begin 														//10us signal for UV sensor
				state1 <= 1'b1;
				counter <= 0;
				UV_trig <= 1'b0;
			end
			else begin
				UV_trig <= 1'b1;
				counter <= counter + 1;
				state1 <= 1'b0;
			end
		end
		1'b1:begin																				//if previous recorded time is lesser than current a fault is detected
			if (UV_echo == 0 && time_counter != 0) begin								//or end of box is detected that is verified by the flag
				state1 <= 1'b0;																//fine tuning can be done for precision and denying errors in UV readings 
				if (prev_time_counter < 16500 && prev_time_counter != 0) begin
					if(flag)begin 																//first fault is detected flag is 1
						flag <= 0;																//end of box flag id 0
					end																			//the pickup box condition yet to be evaluated is still
					else begin
						msg_state <=1'b1;														//initiate msg FSM
						flag <= 1;																//turn all the LEDs blue
					{led1_R1,led2_R2,led3_R3} <= 2'b000;
				   {led1_B1,led2_B2,led3_B3} <= 3'b111;
					{led1_G1,led2_G2,led3_G3} <= 3'b000;
					end
				end
				prev_time_counter <= time_counter;
				time_counter <= 0;
			end
			else if (UV_echo) begin
				time_counter <= time_counter + 1;
				state1 <= 1'b1;
			end
		end
	endcase
	
	case(msg_state)
		1'b00: begin																		//this ensures that the FSM can only be initiated externally
			msg_state <= 0;
		end
		1'b01: begin																		//data is sent in ASCII code every 10us {subjected to change}
			if (msg_delay == 500) begin
				index <= index + 1;
				msg_delay <= 0;
				if (index >= 10) msg_state <= 0;
			end
			else begin
				msg <= msg_contain[index];
				msg_delay <= msg_delay + 1;
			end
			msg_state <= 1'b1;
		end
	endcase 
	if (node_flag)	begin
					{led1_R1,led2_R2,led3_R3} <= 2'b0;
				   {led1_B1,led2_B2,led3_B3} <= 3'b0;
					{led1_G1,led2_G2,led3_G3} <= 3'b0;
	end
end
endmodule 