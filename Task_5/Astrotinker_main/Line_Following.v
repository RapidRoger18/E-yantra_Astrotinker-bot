
module Line_Following(
		input clk_3125KHz,
		input key,
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		input 	[1:0]  turn_flag,
		input end_path,
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output reg [4:0]dc1,
		output reg [4:0]dc2,
		output reg node_flag=0,
		output reg node_changed = 0,
		output reg switch_on = 0
		);
reg [4:0] dutycyc_left, dutycyc_right;
reg [31:0] count;
reg [9:0] node_delay;
reg is_str,is_left,is_right,all_white = 0;

always @(posedge clk_3125KHz) begin
	if(key)begin
		switch_on <= 1;
	end
	if(switch_on) begin	
		if (left>12'd1000 && middle>12'd1000 && right>12'd1000) 	node_flag<=1;
		else if ( right > 1000  && left < 200)	is_right<=1;
		else if ( left > 1000 && right < 200) 	is_left<=1;
		else if ( left < 12'd200 && middle < 12'd200 && right < 12'd200) all_white<=1;
		else if ( left < 12'd200 && middle > 12'd1000 && right < 12'd200) begin 
			is_str <= 1;
			node_flag<=0;
		end
		
		if (node_flag) begin
								case(turn_flag)
										0: begin
												m1_a<=1;
												m1_b<=0;
												m2_a<=1;
												m2_b<=0; 
												dutycyc_left<=5'd16;
												dutycyc_right<=5'd16;
										end
										1: begin
												m1_a<=1;
												m1_b<=0;
												m2_a<=0;
												m2_b<=1;
												dutycyc_left<=5'd18;
												dutycyc_right<=5'd1;
										end
										2: begin
												m1_a<=1;
												m1_b<=0;
												m2_a<=0;
												m2_b<=1;
												dutycyc_left<=5'd12;
												dutycyc_right<=5'd22;
										end
										3: begin
												m1_a<=0; 
												m1_b<=1;
												m2_a<=1;
												m2_b<=0;
												dutycyc_left<=5'd1;
												dutycyc_right<=5'd18;
										end
								endcase
		end
		// Line follow algo
		else if (is_right) begin      
							m1_a<=1;
							m1_b<=0;
							m2_a<=0;	
							m2_b<=1;
							dutycyc_left<=5'd20;
							dutycyc_right<=5'd10;
							is_right<=0;
							node_flag<=0;
		end
		else if (is_left) begin
							m1_a<=0; // *
							m1_b<=1;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left<=5'd10;
							dutycyc_right<=5'd20;
							is_left<=0;
							node_flag<=0;
		end
		else if (is_str) begin
							m1_a<=1;
							m1_b<=0;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left <= 5'd16;
							dutycyc_right<= 5'd16;
							node_delay <=0;
							is_str<=0;
							is_left<=0;
							is_right<=0;
							node_flag<=0;
		end
		dc1<=dutycyc_left;
		dc2<=dutycyc_right;
		if (node_flag) begin
			count <= count + 1;
		end
		if (!node_flag && count != 0 ) begin
			count <= 0;
			node_changed <= 1;
		end
	end
	else if (end_path) begin
		m1_a<=0;
		m1_b<=0;
		m2_a<=0;
		m2_b<=0;
		dutycyc_left<=5'd0;
		dutycyc_right<=5'd0;
	end
	
end

endmodule  


		