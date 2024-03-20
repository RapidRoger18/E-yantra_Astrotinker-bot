module Line_Following(
		input clk_3125KHz,
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		input 	[1:0]  turn_flag,
		input end_path,
		input switch_key,
		input EU_FAULT_FLAG,
		input [4:0] realtime_pos,
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output reg [4:0]dc1,
		output reg [4:0]dc2,
		output reg node_flag=0,
		output reg node_changed = 0
		);
reg [4:0] dutycyc_left, dutycyc_right;
reg [31:0] count;
reg [10:0] node_delay;
reg is_str,is_left,is_right,all_white = 0;
reg [1:0] node_count;
reg [1:0] nc;


always @(posedge clk_3125KHz) begin
	if(switch_key) begin																		// generating flags for required conditions 
		if (left>12'd1000 && middle>12'd1000 && right>12'd1000) 	node_flag<=1;
		else if ( right > 1000  && left < 400)	is_right<=1;
		else if ( left > 1000 && right < 400) 	is_left<=1;
		else if ( left < 12'd400 && middle < 12'd400 && right < 12'd400) all_white<=1;
		else if ( left < 12'd400 && middle > 12'd1000 && right < 12'd400) begin 
			is_str <= 1;
			node_flag<=0;
			all_white<=0;
		end
		if (node_changed) node_changed<=0;
		if (node_flag) begin																	// duty cycles and motor direction based on the turn flag on the nodes
								case(turn_flag)
										0: begin
												if ( realtime_pos == 5'd29 ) begin	
																m1_a<=1;
																m1_b<=0;
																m2_a<=1;
																m2_b<=0; 
																dutycyc_left<=5'd3;
																dutycyc_right<=5'd26;
//																nc<=nc+1;
												end
												else if (realtime_pos == 5'd24 ) begin
														m1_a<=1;
														m1_b<=0;
														m2_a<=1;
														m2_b<=0;
														dutycyc_left<=5'd3;
														dutycyc_right<=5'd22;
												end
												else if (realtime_pos == 5'd2 ) begin
														m1_a<=1;
														m1_b<=0;
														m2_a<=1;
														m2_b<=0;
														dutycyc_left<=5'd26;
														dutycyc_right<=5'd3;
												end
												else  begin
														m1_a<=1;
														m1_b<=0;
														m2_a<=1;
														m2_b<=0;
														dutycyc_left<=5'd18;
														dutycyc_right<=5'd18;
												end
										end
										1: begin
													case(realtime_pos) 	
														5'd21 : begin
																	m1_a<=1;
																	m1_b<=0;
																	m2_a<=1;
																	m2_b<=0;
																	dutycyc_left<=5'd18;
																	dutycyc_right<=5'd1;
															end
														5'd29 : begin
																	m1_a<=1;
																	m1_b<=0;
																	m2_a<=1;
																	m2_b<=0;
																	dutycyc_left<=5'd18;
																	dutycyc_right<=5'd2;
																end		
														default : begin
																	m1_a<=1;
																	m1_b<=0;
																	m2_a<=0;
																	m2_b<=1;
																	dutycyc_left<=5'd18;
																	dutycyc_right<=5'd1;
															end
													endcase
										end
										2: begin
													if(all_white) begin
															m1_a<=1;
															m1_b<=0;
															m2_a<=0;
															m2_b<=1;
															dutycyc_left<=5'd16;
															dutycyc_right<=5'd20;
													end
													else if ( realtime_pos == 5'd25 ) begin
															m1_a<=1;
															m1_b<=0;
															m2_a<=1;
															m2_b<=0;
															dutycyc_left<=5'd15;
															dutycyc_right<=5'd17;
															all_white<=0;
													end
													else begin
															m1_a<=1;
															m1_b<=0;
															m2_a<=1;
															m2_b<=0;
															dutycyc_left<=5'd10;
															dutycyc_right<=5'd10;
													end
										end
										3: begin
												case ( realtime_pos) 
														5'd20 : begin
																	if(node_count==0) begin
																			m1_a<=0; 
																			m1_b<=1;
																			m2_a<=1;
																			m2_b<=0;
																			dutycyc_left<=5'd14;
																			dutycyc_right<=5'd30;
																			node_count<=1;
																	end
																end
														5'd28 : begin 	
																	m1_a<=1;
																	m1_b<=0;
																	m2_a<=1;
																	m2_b<=0;
																	dutycyc_left<= 5'd7;
																	dutycyc_right<= 5'd21;
																end
														default : begin
																	 	m1_a<=1;
																		m1_b<=0;
																		m2_a<=1;
																		m2_b<=0;
																		dutycyc_left<=5'd2;
																		dutycyc_right<=5'd18;
																end
											endcase
								end
								endcase
		end
		// Line follow algo
		else if (is_right) begin      											//right condition - when bot is slightly to the right of the actual path
							m1_a<=1;
							m1_b<=0;
							m2_a<=0;	
							m2_b<=1;
							dutycyc_left<=5'd22;
							dutycyc_right<=5'd10;
							is_right<=0;
//							node_flag<=0;
		end
		else if (is_left) begin												//left condition - when bot is slightly to the left of the actual path
							m1_a<=0; // *
							m1_b<=1;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left<=5'd10;	
							dutycyc_right<=5'd22;
							is_left<=0;
//							node_flag<=0;
		end
		else if (is_str) begin												//stright condition - when bot is on the actual path
							m1_a<=1;
							m1_b<=0;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left <= 5'd20;
							dutycyc_right<= 5'd20;
							node_delay <=0;
							is_left<=0;
							is_right<=0;
							is_str<=0;
							all_white<=0;
							node_flag<=0;
		end
		dc1<=dutycyc_left;
		dc2<=dutycyc_right;
		if (node_flag) begin
			count <= count + 1;
		end
		if (!node_flag && count != 0 ) begin										// node_changed flag is send when the bot leaves a node
			count <= 0;
			node_changed <= 1;
		end
	end
end
endmodule  


		