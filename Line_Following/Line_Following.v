module Line_Following(
		input clk_3125KHz,
		input key,
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		input 	[1:0]  turn_flag,
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output reg [3:0]dc1,
		output reg [3:0]dc2,
		output reg node_flag=0,
		output reg [7:0] node = 0,
		output reg [7:0] fpga_LED,
		output reg switch_on = 0
		);
reg [3:0] dutycyc_left, dutycyc_right;
reg [31:0] count;
always @(posedge clk_3125KHz) begin
	if(!key)begin
		switch_on <= 1;
	end
	if(switch_on) begin	
		
		// Turn conditions on node
		if (left>12'd1000 && middle>12'd1000 && right>12'd1000) begin

			case(turn_flag)

			0: begin                             //straight turn
								m1_a<=1;
								m1_b<=0;
								m2_a<=1;
								m2_b<=0;
								dutycyc_left<=4'd8;
								dutycyc_right<=4'd8;
								node_flag <= 0;
			
			end

			1: begin                             //right turn
								m1_a<=1;
								m1_b<=0;
								m2_a<=0;
								m2_b<=1;
								dutycyc_left<=4'd10;
								dutycyc_right<=4'd5;
			end
			
			2: begin								// U turn
								m1_a<=1;
								m1_b<=0;
								m2_a<=0;
								m2_b<=1;
								dutycyc_left<=4'd8;
								dutycyc_right<=4'd8;
			end

			3: begin								// left turn
								m1_a<=0; 
								m1_b<=1;
								m2_a<=1;
								m2_b<=0;
								dutycyc_left<=4'd5;
								dutycyc_right<=4'd10;
			end

			endcase

		end

		// Normal line follow algo for adjusting on a straight line
		 else if ( right > 1000  && left < 200) begin      
							m1_a<=1;
							m1_b<=0;
							m2_a<=0;	
							m2_b<=1;
							dutycyc_left<=4'd9;
							dutycyc_right<=4'd3;
							//node_flag<=0;
		end
		else if ( left > 1000 && right < 200) begin
							m1_a<=0; // *
							m1_b<=1;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left<=4'd3;
							dutycyc_right<=4'd9;
						//	node_flag<=0;
		end
		else if (left < 200 && middle > 1000  && right < 200 ) begin
							m1_a<=1;
							m1_b<=0;
							m2_a<=1;
							m2_b<=0;
							dutycyc_left<=4'd8;
							dutycyc_right<=4'd8;
							node_flag <= 0;
		end

		dc1<=dutycyc_left;
		dc2<=dutycyc_right;

		// Doubt whether this should be removed or not so left untouched
		if (node_flag) begin
			count <= count + 1;
		end
		if (!node_flag && count != 0 ) begin
			count <= 0;
			node <= node + 1;
		end
		fpga_LED <= node;
	end

	else begin
		m1_a<=0;
		m1_b<=0;
		m2_a<=0;
		m2_b<=0;
		dutycyc_left<=4'd0;
		dutycyc_right<=4'd0;
	end

end

endmodule  


		