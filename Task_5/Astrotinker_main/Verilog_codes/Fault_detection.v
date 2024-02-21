module Fault_detection(
	input clk_50M,
	input UV_echo,															//UV sensor recieve
	output reg UV_trig,													//UV sensor send
	output reg fault_detect = 0,
	//output reg [7:0] msg,													//msg to bluetooth device
	output reg EM_a1,
	output reg EM_b1,
	output reg block_picked,
	output reg fault_count,
	output reg object_drop
	);
//	reg [7:0] msg_contain [9:0];										//msg ram container to store msg
	reg state1 = 0;														//UV sensor FSM driver
//	reg [3:0] index = 0;													//indexing for msg
//	reg msg_state = 0;													//msg sending FSM driver
//	reg [15:0] msg_delay = 0;											//width of each msg/delay between changing of two chars
	reg [1:0] flag = 0;															//activate if Fault is detected
	reg [15:0] counter = 0;												//10us UV sensor trigger pulse counter
	reg [15:0] time_counter = 0;										//measuring pulse width of UV recieved data
	reg [15:0] prev_time_counter = 0;								//comparison for fault detection
initial begin
//	msg <= 0;
//	msg_contain [0] <= 8'h46;												//F
//	msg_contain [1] <= 8'h49;                                   //I
//	msg_contain [2] <= 8'h4D;                                   //M
//	msg_contain [3] <= 8'h2D;												//-
//	msg_contain [4] <= 8'h43;												//C
//	msg_contain [5] <= 8'h53;												//S
//	msg_contain [6] <= 8'h55;												//U
//	msg_contain [7] <= 8'h31;												//1
//	msg_contain [8] <= 8'h2D;												//-
//	msg_contain [9] <= 8'h23;												//#
end
always@(posedge clk_50M)begin
	fault_detect <= 0;
//	if (key_flag) begin	
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
					if (prev_time_counter < 19000 && prev_time_counter > 17000) begin   
							if (block_picked) begin
								object_drop <= 1;
								block_picked <= 0;
							end
							else fault_detect <= 1;
					end
					else if(prev_time_counter < 10000 && prev_time_counter > 8000) begin
							block_picked <= 1;
					end
					else object_drop <= 0;
					prev_time_counter <= time_counter;
					time_counter <= 0;
					state1 <= 1'b0;
				end
				else if (UV_echo) begin
					time_counter <= time_counter + 1;
					state1 <= 1'b1;
				end
			end
		endcase
//		if (msg_state) begin
//				msg <= msg_contain[index];																								//data is sent in ASCII code every 10us {subjected to change}
//				if (msg_delay == 4339) begin
//					index <= index + 1;
//					msg_delay <= 0;
//					if (index >= 10) msg_state <= 0;
//				end
//				else begin
//					msg_delay <= msg_delay + 1;
//				end
//				msg_state <= 1'b1;
//		end
		if(block_picked) begin
			EM_a1 <= 1;
			EM_b1 <= 0;
		end
		else begin
			EM_a1 <= 0;
			EM_b1 <= 0;
		end
//	end	
end
endmodule 