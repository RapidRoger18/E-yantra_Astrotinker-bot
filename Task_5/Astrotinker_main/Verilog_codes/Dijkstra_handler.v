module Dijkstra_handler(
	input clk_3125KHz,                                       
	input EU_fault_flag,                            
	input CU_fault_flag,
	input RU_fault_flag,
	input pick_block_flag,
	input [1:0] block_location,
//	input block_picked,
	input switch_key,
	input [4:0] realtime_pos,                 // realtime node position of the bot  
	input [4:0] curr_node,
	
	output reg CPU_start,             
	output reg [4:0] start_point,        
	output reg [4:0] end_point,
	output reg ALL_DONE_FLAG = 0,            //switches on when the processing is done
	output reg [2:0]  fault_id = 0,						//SU1 = 1, SU2 = 2, SU3 = 3, SU4 = 4;
	output reg [1:0] fault_location = 0             //EU = 1, CU = 2, RU = 3 
);
parameter IDLE_STATE = 3'b000;				//states for diffrent stages 
parameter EU_FAULT = 3'b001;
parameter CU_FAULT = 3'b010;
parameter RU_FAULT = 3'b011;
parameter PICK_BLOCK = 3'b100;
parameter EU_RECTIFY = 3'b101;
parameter CU_RECTIFY = 3'b110;
parameter RU_RECTIFY = 3'b111;

reg [2:0] SWITCH_STATE = IDLE_STATE;
reg [3:0] PREV_SWITCH_STATE;
reg [1:0] counter_EU_fault = 0;					//required counters for substates
reg [1:0] counter_CU_fault = 0;
reg [1:0] counter_RU_fault = 0;
reg block_pick_counter = 0;
reg [1:0] counter_EU_rectify = 0;
reg [1:0] counter_CU_rectify = 0;
reg [1:0] counter_RU_rectify = 0;
reg check_flag = 0;
reg IDLE_state_counter = 0;

reg EU_rectify = 0;
reg CU_rectify = 0;
reg RU_rectify = 0;
reg [1:0] EU_fault_count = 0;
reg [1:0] CU_fault_count = 0;
reg [2:0] RU_fault_count = 0;

always@(posedge clk_3125KHz) begin
	if (EU_fault_flag) EU_fault_count <= EU_fault_count + 1;
	if (CU_fault_flag) CU_fault_count <= CU_fault_count + 1;
	if (RU_fault_flag) RU_fault_count <= RU_fault_count + 1;
	
	if (switch_key) begin
		case (SWITCH_STATE) 
			IDLE_STATE: begin											//idle state for begining and ending stages 
				if (!IDLE_state_counter) begin
					if (EU_rectify) begin
						EU_fault_count <= EU_fault_count - 1;
						EU_rectify <= 0;
					end
					if (CU_rectify) begin
						EU_fault_count <= EU_fault_count - 1;
						EU_rectify <= 0;
					end
					if (RU_rectify) begin
						EU_fault_count <= EU_fault_count - 1;
						EU_rectify <= 0;
					end
					IDLE_state_counter <= 1;
				end
				else begin
					if( EU_fault_count != 0 ) SWITCH_STATE <= EU_FAULT;
//					else if( CU_fault_count != 0 ) SWITCH_STATE <= CU_FAULT;
//					else if( RU_fault_count != 0 ) SWITCH_STATE <= RU_FAULT;
					else begin
						if(realtime_pos != 0) begin
							start_point <= realtime_pos;
							end_point <= 5'd0;
							CPU_start <= 1;
							check_flag <= 1;
							if ((realtime_pos == end_point) && check_flag) begin
								ALL_DONE_FLAG <= 1;
								check_flag <= 0;
							end
						end
					end
					IDLE_state_counter <= 0;
				end
			end
			EU_FAULT: begin										//fault identification step- bot traverses through multiple nodes of the perticular section
				fault_location <= 2'd1;
				if (realtime_pos == 5'd29 && curr_node == 5'd28) fault_id <= 3'd3;
				else if (realtime_pos == 5'd26 && curr_node == 5'd27) fault_id <= 3'd2;
				else if (realtime_pos == 5'd25 && curr_node == 5'd24) fault_id <= 3'd1;
				else fault_id <= 3'd0;
				
				case (counter_EU_fault)
					2'b00: begin
						CPU_start <= 1;
						start_point <= realtime_pos;
						end_point <= 5'd29;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							counter_EU_fault <= 2'b01;
							check_flag <= 0;
						end
					end
					2'b01: begin                        
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd27;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_EU_fault <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd24;
						check_flag <= 1;
						if ( (curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_EU_fault <= 2'b00;
//							PREV_SWITCH_STATE <= SWITCH_STATE;
							SWITCH_STATE <= PICK_BLOCK;                           //switches state once traversing and detection is completed
						end
					end
				endcase
			end
			CU_FAULT: begin
				fault_location <= 2'd2;
				if (realtime_pos == 5'd7 && curr_node == 5'd6) fault_id <= 3'd3;
				else if (realtime_pos == 5'd5 && curr_node == 5'd4) fault_id <= 3'd2;
				else if (realtime_pos == 5'd3 && curr_node == 5'd2) fault_id <= 3'd1;
				else fault_id <= 3'd0;
				case (counter_CU_fault)
					2'b00: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd7;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_fault <= 2'b01; 
						end
					end
					2'b01: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd5;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_fault <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd2;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_fault <= 2'b00;
//							PREV_SWITCH_STATE <= SWITCH_STATE;
							SWITCH_STATE <= PICK_BLOCK;
						end
					end
				endcase
			end
			RU_FAULT: begin
				fault_location <= 2'd3;
				if (realtime_pos == 5'd19 && curr_node == 5'd18) fault_id <= 3'd1;
				else if (realtime_pos == 5'd17 && curr_node == 5'd16) fault_id <= 3'd2;
				else if (realtime_pos == 5'd14 && curr_node == 5'd15) fault_id <= 3'd3;
				else if (realtime_pos == 5'd13 && curr_node == 5'd12) fault_id <= 3'd4;
				else fault_id <= 3'd0;
				case (counter_RU_fault)
					2'b00: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd19;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag )begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_RU_fault <= 2'b01; 
						end
					end
					2'b01: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd17;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_RU_fault <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd15;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							counter_RU_fault <= 2'b11;
							CPU_start <= 0;
							check_flag <= 0;
						end
					end
					2'b11 :begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd12;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
//							PREV_SWITCH_STATE <= SWITCH_STATE;
							SWITCH_STATE <= PICK_BLOCK;
							counter_RU_fault <= 2'b00;
						end
					end
				endcase
			end
			PICK_BLOCK: begin  																	//this state is responsible for planning the path to the 
				if ( pick_block_flag && !block_pick_counter ) begin 
					case ( block_location )
						2'd0: begin
							CPU_start <= 1;
							start_point <= curr_node;
							end_point <= 5'd22;
							check_flag <= 1;
							if((curr_node == end_point) && check_flag) begin
								CPU_start <= 0;
								check_flag <= 0;
								block_pick_counter <= 1'b1;
							end
						end
						2'd01: begin
							CPU_start <= 1;
							start_point <= curr_node;
							end_point <= 5'd10;
							check_flag <= 1;
							if((curr_node == end_point) && check_flag) begin
								CPU_start <= 0;
								check_flag <= 0;
								block_pick_counter <= 1'b1;
							end
						end
						2'd2: begin
							CPU_start <= 1;
							start_point <= curr_node;
							end_point <= 5'd23;
							check_flag <= 1;
							if((curr_node == end_point) && check_flag) begin
								CPU_start <= 0;
								check_flag <= 0;
								block_pick_counter <= 1'b1;
							end
						end
						2'd3: begin
							CPU_start <= 1;
							start_point <= curr_node;
							end_point <= 5'd11;
							check_flag <= 1;
							if((curr_node == end_point) && check_flag) begin
								CPU_start <= 0;
								check_flag <= 0;
								block_pick_counter <= 1'b1;
							end
						end
					endcase	
				end
				else if (block_pick_counter) begin
					SWITCH_STATE <= EU_RECTIFY;
//					if(PREV_SWITCH_STATE == EU_FAULT) SWITCH_STATE <= EU_RECTIFY;
//					else if(PREV_SWITCH_STATE == CU_FAULT)	SWITCH_STATE <= CU_RECTIFY;
//					else if(PREV_SWITCH_STATE == RU_FAULT) SWITCH_STATE <= RU_RECTIFY;
					block_pick_counter <= 1'b0;
				end
			end
			EU_RECTIFY: begin
				case (counter_EU_rectify)
					2'b00: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd29;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag ) begin 
							counter_EU_rectify <= 2'b01;
							CPU_start <= 0;
							check_flag <= 0;
						end	
					end
					2'b01: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd27;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_EU_rectify <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd24;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_EU_rectify <= 2'b00;
							SWITCH_STATE <= IDLE_STATE;
							EU_rectify <= 1;
						end
					end
				endcase
			end
			CU_RECTIFY: begin
				case (counter_CU_rectify)
					2'b00: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd7;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_rectify <= 2'b01;
						end	
					end
					2'b01: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd5;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_rectify <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd2;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_CU_rectify <= 2'b00;
							CU_rectify <= 1;
							SWITCH_STATE <= IDLE_STATE;
						end
					end
				endcase
			end
			RU_RECTIFY: begin
				case (counter_RU_rectify)
					2'b00: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd19;
						check_flag <= 1;
						if( (curr_node == end_point) && check_flag ) begin 
							CPU_start <= 0;
							check_flag <= 0;
							counter_RU_rectify <= 2'b01; 
						end
					end
					2'b01: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd17;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							CPU_start <= 0;
							check_flag <= 0;
							counter_RU_rectify <= 2'b10;
						end
					end
					2'b10: begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd15;
						check_flag <= 1;
						if ((curr_node == end_point) && check_flag ) begin
							counter_RU_rectify <= 2'b11;
							CPU_start <= 0;
							check_flag <= 0;
						end
					end
					2'b11 :begin
						CPU_start <= 1;
						start_point <= curr_node;
						end_point <= 5'd12;
						check_flag <= 1;
						if (curr_node == end_point ) begin
							counter_RU_rectify <= 2'b00;
							RU_rectify <= 1;
							SWITCH_STATE <= IDLE_STATE;
							CPU_start <= 0;
							check_flag <= 0;
						end
					end
				endcase
			end
		endcase
	end
end
endmodule 