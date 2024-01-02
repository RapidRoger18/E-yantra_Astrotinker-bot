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
parameter Kp = 1;
parameter Kd = 2;
parameter Ki = 1;

reg read_left, read_center,read_right ;
reg [3:0]error;
reg node_flag = 0;
reg [3:0] dutycyc_left, dutycyc_right;
reg [3:0]prev_error = 0;
reg [3:0]proportional;
reg [3:0]derivative;
reg [3:0]integral= 0;
reg [3:0] correction ;
always @(*) begin

		//{led1_R1,led2_R2,led3_R3} <= 2'b0;
	   //{led1_B1,led2_B2,led3_B3} <= 3'b0;
		//{led1_G1,led2_G2,led3_G3} <= 3'b111;
//		dutycyc_left<=4'd8;
//		dutycyc_right<=4'd8;
	if (left>12'd1200 && middle>12'd1200 && right>12'd1200 && !node_flag) begin
					m1_a<=1;
					m1_b<=0;
					m2_a<=0;
					m2_b<=1;
					dutycyc_left<=4'd10;
					dutycyc_right<=4'd2;
//					//{led1_R1,led2_R2,led3_R3} <= 2'b0;
//				   //{led1_B1,led2_B2,led3_B3} <= 3'b111;
//					//{led1_G1,led2_G2,led3_G3} <= 3'b0;
					node <= node + 1;
					node_flag <= 1;  
	end
	else if ( left > 1200 && right < 700) begin
						m1_a<=0; // *
						m1_b<=1;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd3;
						dutycyc_right<=4'd10;
						node_flag <= 0;
	end
	else if ( right > 1200 && left < 700) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;	
						m2_b<=1;
						dutycyc_left<=4'd9;
						dutycyc_right<=4'd3;
						node_flag <= 0;
	end
	
	else if (left < 700 && middle > 1200  && right < 700 ) begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd7;
						dutycyc_right<=4'd7;
						node_flag <= 0;
	end					
	else if (left<700 && middle < 700 && right < 700 )begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;	
						m2_b<=1;
						dutycyc_left<=4'd8;
						dutycyc_right<=4'd2;
	end

//	if(!node_flag) begin
		 if (left<700) read_left<=0;
		 else read_left<=1;

		 if (middle>1200) read_center<=1;
		 else read_center<=0;

		  if (right<700) read_right<=0;
		 else read_right<=1;

		 error <= (4*read_right+0*read_center-4*read_left)/(read_right+read_center+read_center); //weighted sum - 1/ sum
		 proportional<= Kp * error;
		 derivative <= Kd * (error-prev_error);
		 integral <= integral + (Ki*error);

		 correction<=proportional+derivative+integral;
		 dc1<=dutycyc_left+correction;
		 dc2<=dutycyc_right-correction;	

		 prev_error<=error;
//	end
end
endmodule 
		
