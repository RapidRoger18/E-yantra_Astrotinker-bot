module msg_rx (
    input clk_50M,
    input [7:0] rx_msg,
	 input rx_complete,
	 output reg EU_fault_flag = 0, 
	 output reg CU_fault_flag = 0,
	 output reg RU_fault_flag = 0,
	 output reg pick_block_flag = 0,
	 output reg switch_key,
	 output reg [1:0] block_location
); 
reg [7:0] msg_mem [11:0] ;
reg [1:0] state = 0;
reg [4:0] idx = 0;
reg [15:0] delay_count = 0;
initial begin
			msg_mem[0] <= 0;
			msg_mem[1] <= 0;
			msg_mem[2] <= 0;
			msg_mem[3] <= 0;
			msg_mem[4] <= 0;
			msg_mem[5] <= 0;
			msg_mem[6] <= 0;
			msg_mem[7] <= 0;
			msg_mem[8] <= 0;
			msg_mem[9] <= 0;
			msg_mem[10] <= 0;
			msg_mem[11] <= 0;
end
always @(posedge clk_50M) begin
    case (state)
		2'd0: begin
			if (rx_complete) state<=2'd1;
		end
      2'd1: begin
			if (delay_count == 4339) idx <= idx + 1 ;
			else delay_count <= delay_count + 1;
			msg_mem[idx] <= rx_msg;
         if (rx_msg == 8'h23) begin
				idx <= 0;
				state <= 2'd2;
         end
			else state <= 2'd0; 
      end
      2'd2: begin
			if ( msg_mem[0] == 8'h49 && msg_mem[1] == 8'h46 && msg_mem[2] == 8'h4D)  begin // IFM signal is detected 
				switch_key <= 1;
				if ( msg_mem[4] == 8'h45 ) EU_fault_flag <= 1; 
				else if ( msg_mem[4] == 8'h43) CU_fault_flag <= 1; 
				else if ( msg_mem[4] == 8'h52) RU_fault_flag <= 1;
			end //PBM-SU-Bn-#
			else if ( msg_mem[0] == 8'h50 && msg_mem[1] == 8'h42 && msg_mem[2]  == 8'h4D && msg_mem [4] == 8'h53 && msg_mem[5] == 8'h55 && msg_mem[7] == 8'h42) begin // PBM signal is detected 
				pick_block_flag <= 1;
				if ( msg_mem[8] == 8'h39 ) block_location <= 2'd0;
				else if (msg_mem[8] == 8'h40) block_location <= 2'd1;
				else if (msg_mem[8] == 8'h41) block_location <= 2'd2;
				else if (msg_mem[8] == 8'h42) block_location <= 2'd3;
			end
			state <= 2'd3;
		end
		2'd3: begin
			msg_mem[0] <= 0;
			msg_mem[1] <= 0;
			msg_mem[2] <= 0;
			msg_mem[3] <= 0;
			msg_mem[4] <= 0;
			msg_mem[5] <= 0;
			msg_mem[6] <= 0;
			msg_mem[7] <= 0;
			msg_mem[8] <= 0;
			msg_mem[9] <= 0;
			msg_mem[10] <= 0;
			msg_mem[11] <= 0;
			state <= 2'd0;
		end
	endcase
end
endmodule 