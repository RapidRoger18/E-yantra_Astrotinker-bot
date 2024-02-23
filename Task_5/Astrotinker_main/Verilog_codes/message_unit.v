module message_unit( 
input clk_50M,
input fault_detect, 											// when a fault is detected by U.S.
input [2:0] fault_id,
input block_picked,
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
parameter F = 8'h46;
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

reg [15:0] msg_delay =0;
reg [7:0] msg_container [12:0];
reg [1:0] STATE = 2'd0;
reg [3:0] idx = 0; 
reg msg_sent = 0;
reg EU_fault_flag = 0;
reg CU_fault_flag = 0;
reg RU_fault_flag = 0;

always@( clk_50M ) begin
	
	if( fault_location == 2'd1 ) EU_fault_flag <= 1;
	if( fault_location == 2'd2 ) CU_fault_flag <= 1;
	if( fault_location == 2'd3 ) RU_fault_flag <= 1;
	else begin
		EU_fault_flag <= 0;
		CU_fault_flag <= 0;
		RU_fault_flag <= 0;
	end
	
	if ( end_run_interrupt ) begin
		msg_container[0] <= E;
		msg_container[1] <= N;
		msg_container[2] <= D;
		msg_container[3] <= DASH;
		msg_container[4] <= HASH;
	end
	else if ( fault_detect && !block_picked ) STATE <= FAULT_state;
	else if ( block_picked && !fault_detect ) STATE <= PICKUP_state;
	else if ( block_picked && fault_detect ) STATE <= DEPOSIT_state;
	else STATE <= IDLE_state;
	if ( msg_sent ) STATE <= IDLE_state;

	case (STATE)
			IDLE_state: begin
				msg_container[0] <= 8'h0;
				msg_container[1] <= 8'h0;
				msg_container[2] <= 8'h0;
				msg_container[3] <= 8'h0;
				msg_container[4] <= 8'h0;
				msg_container[5] <= 8'h0;
				msg_container[6] <= 8'h0;
				msg_container[7] <= 8'h0;
				msg_container[8] <= 8'h0;
				msg_container[9] <= 8'h0;
				msg_container[10] <= 8'h0;
				msg_container[11] <= 8'h0;
				msg_container[12] <= 8'h0;
				msg_sent <= 0;
			end
			FAULT_state: begin
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
			end
			PICKUP_state: begin
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
			end
			DEPOSIT_state: begin
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
			end
		endcase
	
	if (msg_container[idx] != 8'h0 && !msg_sent) begin
		if (msg_delay == 4339) begin
			msg <= msg_container[idx];
			data_send <= 0;
			if(msg_container[idx] == HASH) begin
				msg_sent <= 1;
				idx <= 0;
			end
			else idx <= idx + 1;
			msg_delay <= 0;
		end
		else begin 
			msg_delay <= msg_delay + 1;
		end
	end 
end
endmodule  