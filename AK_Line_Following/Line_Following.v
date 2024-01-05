module Line_Following(
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output reg [3:0]dc1,
		output reg [3:0]dc2,
		output reg nodes,
		output reg node_flag=0
		);
		
reg [3:0] dutycyc_left, dutycyc_right;

always @(*) begin
	if (left>12'd1000 && middle>12'd1000 && right>12'd1000 && !node_flag) begin
					m1_a<=1;
					m1_b<=0;
					m2_a<=0;
					m2_b<=1;
					dutycyc_left<=4'd8;
					dutycyc_right<=4'd3;			
					node_flag <= 1;
					nodes <= nodes + 1;
	end
	else if ( right > 500 && left < 200) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;	
						m2_b<=1;
						dutycyc_left<=4'd8;
						dutycyc_right<=4'd3;
	end
	else if ( left > 500 && right < 200) begin
						m1_a<=0; // *
						m1_b<=1;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd3;
						dutycyc_right<=4'd8;
	end
	else if (left < 200 && middle > 500  && right < 200 ) begin
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
end
endmodule 

		
