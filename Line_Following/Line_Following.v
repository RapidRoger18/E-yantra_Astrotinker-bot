


module Line_Following(
		input   [11:0] left,		// LFA left sensor
		input   [11:0] middle,		// LFA middle sensor
		input   [11:0] right,		// LFA right sensor 
		output  reg m1_a,
		output  reg m1_b,
		output  reg m2_a,
		output  reg m2_b,
//		output  reg led1_R1,
//		output  reg led1_G1,
//		output  reg led1_B1,
//		output  reg led2_R2,
//		output  reg led2_G2,
//		output  reg led2_B2,
//		output  reg led3_R3,
//		output  reg led3_G3,
//		output  reg led3_B3,
		output reg [3:0]dc1,
		output reg [3:0]dc2,
		output reg node_flag=0
		);
		
integer nodes;	
reg read_left, read_center,read_right ;
//reg [3:0]error;
//reg node_flag = 0;
reg [3:0] dutycyc_left, dutycyc_right;
//reg [3:0]prev_error = 0;
//reg [3:0]proportional;
//reg [3:0]derivative;
//reg [3:0]integral= 0;
//reg [3:0] correction ;
reg[4:0] delay=0;

always@(*) begin 

st<= (left<12'd200 && middle>12'd500 && right<12'd200)? 1:0;
lt<=(left<12'd200 && right>12'd500)? 1:0;
rt<=(left>12'd500 && right<12'd200)? 1:0;

case ({lt,st,rt}):
000: begin 
				if (delay==5'b11111) begin
					m1_a<=1;
					m1_b<=0;
					m2_a<=0;
					m2_b<=1;
					dutycyc_left<=4'd8;
					dutycyc_right<=4'd3;			
					node_flag <= 1;
					nodes <= nodes + 1;
					delay<=delay<=delay+1'b1;delay+1'b1;
					end
				else delay<=delay+1'b1;

end
010:begin
						m1_a<=1;
						m1_b<=0;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd8;
						dutycyc_right<=4'd8;
						node_flag <= 0;

end 

100: begin
						m1_a<=0; // *
						m1_b<=1;
						m2_a<=1;
						m2_b<=0;
						dutycyc_left<=4'd5;
						dutycyc_right<=4'd7;


end

001: begin 
						m1_a<=1;
						m1_b<=0;
						m2_a<=0;	
						m2_b<=1;
						dutycyc_left<=4'd5;
						dutycyc_right<=4'd7;
						//node_flag <= 0;

end 
endcase

end
endmodule 