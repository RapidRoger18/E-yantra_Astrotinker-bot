module Line_Following(
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
		output  reg led1_R1,
		output  reg led1_G1,
		output  reg led1_B1,
		output  reg led2_R2,
		output  reg led2_G2,
		output  reg led2_B2,
		output  reg led3_R3,
		output  reg led3_G3,
		output  reg led3_B3,
		output reg [3:0]dc1,
		output reg [3:0]dc2
		);
		
reg [3:0]node=0;
always @(*) begin
	if (node!=5) begin
			if ( left<12'd100 & middle>12'd100 & right<12'd100) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=1;
						m2_b<=0;
						dc1<=4'd11;
						dc2<=4'd11;
			end
			else if ( left<12'd100 & middle>12'd100 & right>12'd100) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;
						m2_b<=1;
						dc1<=4'd7;
						dc2<=4'd3;
			end
			else if ( left>12'd100 & middle<12'd100 & right<12'd100) begin
						m1_a<=0;
						m1_b<=0;
						m2_a<=1;
						m2_b<=0;
						dc1<=4'd7;
						dc2<=4'd3;
			end
	end
	else begin
			m1_a<=1;
			m1_b<=0;
			m2_a<=1;
			m2_b<=0;
			dc1<=4'd11;
			dc2<=4'd11;
	end
		{led1_R1,led2_R2,led3_R3} <= 2'b0;
	   {led1_B1,led2_B2,led3_B3} <= 3'b0;
		{led1_G1,led2_G2,led3_G3} <= 3'b111;
	if (left>12'd100 & middle>12'd100 & right>12'd100) begin
					m1_a<=1;
					m1_b<=0;
					m2_a<=0;
					m2_b<=1;
					dc1<=4'd7;
					dc2<=4'd3;
					node<=node+1;
					{led1_R1,led2_R2,led3_R3} <= 2'b0;
				   {led1_B1,led2_B2,led3_B3} <= 3'b0;
					{led1_G1,led2_G2,led3_G3} <= 3'b0;
	end
end
endmodule 
		
