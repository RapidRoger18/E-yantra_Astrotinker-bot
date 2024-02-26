module message_unit( 
input clk_50M,
input clk_3125KHz,
input fault_detect, 											// when a fault is detected by U.S.
input [2:0] fault_id,
input block_picked,
input switch_key,
input node_flag,
input end_run_interrupt,
input [1:0] block_location,
input [1:0] fault_location,
output reg  [7:0] msg = 0,
output reg data_send = 0
);
parameter B = 8'h42;
parameter C = 8'h43;
parameter D = 8'h44;
parameter E = 8'h45;
parameter F = 8'h46;														// ascii codes for characters
parameter I = 8'h49;
parameter M = 8'h4D;
parameter N = 8'h4E;
parameter P = 8'h50;
parameter R = 8'h52;
parameter S = 8'h53;
parameter U = 8'h55;
parameter N1 = 8'h31;
parameter N2 = 8'h32;
parameter N3 = 8'h33;
parameter N4 = 8'h34;
parameter DASH = 8'h2D;
parameter HASH = 8'h23;

parameter IDLE_state = 2'b00;
parameter FAULT_state = 2'b01;
parameter PICKUP_state = 2'b10;
parameter DEPOSIT_state = 2'b11;

reg [15:0] msg_delay = 0;
reg [7:0] msg_container [12:0];
reg [1:0] STATE = 2'd0;
reg [3:0] idx = 0; 
reg msg_send = 0;
reg next_fault_flag =0;
reg EU_fault_flag = 0;
reg CU_fault_flag = 0;								//necessary flags for each units
reg RU_fault_flag = 0;
reg next_pickup_flag = 0;
reg next_deposit_flag = 0;
reg [3:0] count = 0;
initial begin
	msg_container[0] = 8'h0;
	msg_container[1] = 8'h0;
	msg_container[2] = 8'h0;
	msg_container[3] = 8'h0;
	msg_container[4] = 8'h0;
	msg_container[5] = 8'h0;
	msg_container[6] = 8'h0;
	msg_container[7] = 8'h0;
	msg_container[8] = 8'h0;
	msg_container[9] = 8'h0;
	msg_container[10] = 8'h0;
	msg_container[11] = 8'h0;
	msg_container[12] = 8'h0;
end
always@( posedge clk_50M ) begin
	if (switch_key) begin
		if( node_flag == 1) begin 
			next_fault_flag <= 0;
			next_pickup_flag <= 0;
			next_deposit_flag <= 0;
		end
		
		if( fault_location == 2'd1 ) EU_fault_flag <= 1;
		else if( fault_location == 2'd2 ) CU_fault_flag <= 1;
		else if( fault_location == 2'd3 ) RU_fault_flag <= 1;
		else begin
			EU_fault_flag <= 0;
			CU_fault_flag <= 0;
			RU_fault_flag <= 0;
		end
		
		if ( end_run_interrupt ) begin							//end message at the end of the run
			msg_container[0] <= E;
			msg_container[1] <= N;
			msg_container[2] <= D;
			msg_container[3] <= DASH;
			msg_container[4] <= HASH;
			msg_send <= 1;
		end
		if ( fault_detect && !block_picked && !next_fault_flag) STATE <= FAULT_state;	//fault state conditions 
		else if ( block_picked && !fault_detect && !next_pickup_flag) STATE <= PICKUP_state;	// pickup state conditions
		else if ( block_picked && fault_detect && !next_deposit_flag ) STATE <= DEPOSIT_state;	//deposit state conditions
//		else STATE <= IDLE_state;

		case (STATE)  //here complete message is stored in msg container
				IDLE_state: begin
					count <= 0;
				end
				FAULT_state: begin										//FIM-XSUn-# msg vased on incoming flags
					msg_container[0] <= F;
					msg_container[1] <= I;
					msg_container[2] <= M;
					msg_container[3] <= DASH;
					if (EU_fault_flag) msg_container[4] <= E;
					else if (CU_fault_flag) msg_container[4] <= C;
					else if (RU_fault_flag) msg_container[4] <= R;
					msg_container[5] <= S;
					msg_container[6] <= U;
					if (fault_id == 3'd1) msg_container[7] <= N1; 
					else if (fault_id == 3'd2) msg_container[7] <= N2;
					else if (fault_id == 3'd3) msg_container[7] <= N3;
					else if (fault_id == 3'd4) msg_container[7] <= N4;
					msg_container[8] <= DASH;
					msg_container[9] <= HASH;
					next_fault_flag <= 1;
					msg_send <= 1;
					data_send <= 1;
					STATE <= IDLE_state;
				end
				PICKUP_state: begin								//BPM-SU-Bn-#
					msg_container[0] <= B;
					msg_container[1] <= P;
					msg_container[2] <= M;
					msg_container[3] <= DASH;
					msg_container[4] <= S;
					msg_container[5] <= U;
					msg_container[6] <= DASH;
					msg_container[7] <= B;
					if (block_location == 0) msg_container[8] <= N1;
					else if (block_location == 2'd1) msg_container[8] <= N2;
					else if (block_location == 2'd2) msg_container[8] <= N3;
					else if (block_location == 2'd3) msg_container[8] <= N4;
					msg_container[9] <= DASH;
					msg_container[10] <= HASH;
					msg_send <= 1;
					next_pickup_flag <= 1;
					STATE <= IDLE_state;
				end
				DEPOSIT_state: begin                         //BDM-XSUn-#
					msg_container[0] <= B;
					msg_container[1] <= D;
					msg_container[2] <= M;
					msg_container[3] <= DASH;
					if (EU_fault_flag) msg_container[4] <= E;
					else if (CU_fault_flag) msg_container[4] <= C;
					else if (RU_fault_flag) msg_container[4] <= R;
					msg_container[5] <= S;
					msg_container[6] <= U;
					if (fault_id == 3'd1) msg_container[7] <= N1; 
					else if (fault_id == 3'd2) msg_container[7] <= N2;
					else if (fault_id == 3'd3) msg_container[7] <= N3;
					else if (fault_id == 3'd4) msg_container[7] <= N4;
					msg_container[8] <= DASH;
					msg_container[9] <= B;
					if (block_location == 0) msg_container[10] <= N1;
					else if (block_location == 2'd1) msg_container[10] <= N2;
					else if (block_location == 2'd2) msg_container[10] <= N3;
					else if (block_location == 2'd3) msg_container[10] <= N4;
					msg_container[11] <= DASH;
					msg_container[12] <= HASH;
					msg_send <= 1;
					next_deposit_flag <= 1;
					STATE <= IDLE_state;
				end
			endcase
		
		if ( msg_send ) begin                                     //msg is send serially after respective time counters to UART TX
			msg <= msg_container[idx];
			if (msg_delay == 4339) begin
				msg_delay <= 0;
				idx <= idx + 1;
				if(msg_container[idx] == HASH) begin
					msg_send <= 0;
					idx <= 0;
					data_send <= 0; 
				end
			end
			else msg_delay <= msg_delay + 1;
		end 	
	end
end
endmodule  