module CPU_driver(
	input clk_3125KHz,
	input CPU_MemWrite,
	input CPU_start,
	input [4:0] SP, EP,
	input [31:0] CPU_WriteData, CPU_DataAdr, CPU_ReadData,
	output reg CPU_reset,
	output reg CPU_Ext_MemWrite,
	output reg [4:0] path_planned,
	output reg CPU_stop_flag = 0,
	output reg [31:0] CPU_Ext_WriteData, CPU_Ext_DataAdr
);
reg start_mem = 0;
reg [1:0] state = 0;
reg [3:0] index = 0;
reg [3:0] idx = 0;
reg [4:0] path_planned_array [15:0] ;
reg CPU_start_state = 0;
reg [3:0] CPU_state_counter = 0;
reg CPU_state_flag = 0;
reg CPU_stop = 0; 
reg read_state = 0;
always @(posedge clk_3125KHz) begin
	if ( CPU_start && !CPU_state_flag) begin
		if( CPU_state_counter == 8 ) begin
			CPU_state_counter <= 0;
			CPU_start_state <= 0;
			CPU_state_flag <= 1;
		end
		else begin
			CPU_state_counter <= CPU_state_counter + 1;
			CPU_start_state <= 1;
		end
	end
	else if( !CPU_start ) CPU_state_flag <= 0;
	if ( CPU_start_state ) begin
		CPU_reset <= 1;
		case (state)
			2'b00: begin                   // write START_POINT in the memory address 02000000
				if (!start_mem) begin
					CPU_Ext_MemWrite <= 1; CPU_Ext_WriteData <= SP; CPU_Ext_DataAdr <= 32'h02000000;
					start_mem <= 1;
				end
				else begin
					CPU_Ext_MemWrite <= 0; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h0;
					start_mem <= 0;
					state <= 2'b01;
				end
			end
			2'b01: begin						// write END_POINT in the memory address 02000004
				if (!start_mem) begin
					CPU_Ext_MemWrite <= 1; CPU_Ext_WriteData <= EP; CPU_Ext_DataAdr <= 32'h02000004;
					start_mem <= 1;
				end
				else begin
					CPU_Ext_MemWrite <= 0; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h0;
					start_mem <= 0;
					state <= 2'b10;
				end
			end
			2'b10: begin						// write NODE_POINT as 00 in the memory address 02000008
				if (!start_mem) begin
					CPU_Ext_MemWrite <= 1; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h02000008;
					start_mem <= 1;
				end
				else begin
					CPU_Ext_MemWrite <= 0; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h0;
					start_mem <= 0;
					state <= 2'b11;
				end
			end
			2'b11: begin					// write CPU_DONE as 00 in the memory address 0200000c
				if (!start_mem) begin
					CPU_Ext_MemWrite <= 1; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h0200000c;
					start_mem <= 1;
				end
				else begin
					CPU_Ext_MemWrite <= 0; CPU_Ext_WriteData <= 00; CPU_Ext_DataAdr <= 32'h0;
					start_mem <= 0;
					state <= 2'b00;
					CPU_reset <= 0;
					read_state <= 1;
				end
			end
		endcase
		// External Memory Access Disabled
//		CPU_Ext_MemWrite <= 0; CPU_Ext_WriteData <= 0; CPU_Ext_DataAdr <= 0;
	end
	if(CPU_MemWrite && !CPU_reset && read_state) begin
        if (CPU_DataAdr === 32'h02000008) begin
            path_planned_array [index] <= CPU_WriteData;
				index <= index + 1;
        end
        if (CPU_DataAdr === 32'h0200000c & CPU_WriteData === 32'h1) begin
				CPU_stop <= 1;
				read_state <= 0;
				index <= 0;
        end
    end
	 if (CPU_stop) begin
		if (path_planned_array[idx] == EP) begin
			path_planned <= path_planned_array [idx];
			idx <= 0;
			CPU_stop <= 0;
		end
		else begin
			CPU_stop_flag <= 1;
			path_planned <= path_planned_array [idx];
			idx <= idx + 1;
		end
	end
	else CPU_stop_flag <= 0;
end
endmodule 