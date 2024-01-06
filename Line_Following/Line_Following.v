module Line_Following(
		input clk_3125KHz, 
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output reg [3:0]dc1,
		output reg [3:0]dc2,
		output reg node_flag=0,
		output reg [7:0] node = 0,
		output reg [7:0] fpga_LED
		);

reg [3:0] dutycyc_left, dutycyc_right;
reg [31:0] count;
always @(posedge clk_3125KHz) begin
	if (left>12'd1000 && middle>12'd1000 && right>12'd1000) begin
					if (node != 5) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;
						m2_b<=1;
						dutycyc_left<=4'd9;
						dutycyc_right<=4'd5;
					end
					node_flag <= 1; 				
	end
	else if ( right > 1000 && left < 200) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;	
						m2_b<=1;
						dutycyc_left<=4'd7;
						dutycyc_right<=4'd3;
						//node_flag<=0;
	end
	else if ( left > 1000 && right < 200) begin
						m1_a<=0; // *
						m1_b<=1;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd3;
						dutycyc_right<=4'd7;
					//	node_flag<=0;
	end
	else if (left < 200 && middle > 900  && right < 200 ) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd5;
						dutycyc_right<=4'd5;
						node_flag <= 0;
	end					
		 dc1<=dutycyc_left;
		 dc2<=dutycyc_right;
	if (node_flag) begin
		count <= count + 1;
	end
	if (!node_flag && count != 0 ) begin
		count <= 0;
		node <= node + 1;
	end
	fpga_LED <= node;
end
endmodule 


		