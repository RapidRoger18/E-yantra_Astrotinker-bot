module Fault_detection(
	input clk_50M,
	input switch_key,
	input UV_echo,															//UV sensor recieve
	output reg UV_trig,													//UV sensor send
	output reg fault_detect = 0,									
	output reg EM_a1,
	output reg EM_b1,
	output reg block_picked = 0,
	output reg fault_count,
	output reg object_drop = 0
	);
	reg state1 = 0;														//UV sensor FSM driver
	reg [1:0] flag = 0;															//activate if Fault is detected
	reg [15:0] counter = 0;												//10us UV sensor trigger pulse counter
	reg [15:0] time_counter = 0;										//measuring pulse width of UV recieved data
	reg [15:0] prev_time_counter = 0;								//comparison for fault detection

always@(posedge clk_50M)begin
	if (switch_key) begin	
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
							fault_detect <= 1;
					end
					else if(prev_time_counter < 10000 && prev_time_counter > 8000) begin
							block_picked <= 1;
					end
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
//		if (fault_detect ) fault_detect <= 0;
		
		if (block_picked && fault_detect) begin
			EM_a1 <= 1;
			EM_b1 <= 0;
			object_drop <= 1;
			block_picked <= 0;
		end
	end	
end
endmodule 