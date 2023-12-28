`timescale 1 ns/1 ns
module Fault_detection_tb();
	reg clk_50M;
	reg UV_echo;
	wire UV_trig;												
	wire led1_R1;													
	wire led1_G1;
	wire led1_B1;
	wire led2_R2;
	wire led2_G2;
	wire led2_B2;
	wire led3_R3;	
	wire led3_G3;
	wire led3_B3;
	wire [7:0] msg;		

	Fault_detection Fault_detection1( clk_50M, UV_echo, UV_trig, led1_R1, led1_G1, led1_B1, led2_R2, led2_G2, led2_B2, led3_R3, led3_G3, led3_B3, msg );
	initial begin
		clk_50M = 0;
		UV_echo = 0;
	
		#2000000
		UV_echo <= 1;
		#100000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#200000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#200000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#100000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#300000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#300000
		UV_echo <= 0;
		#100000
		UV_echo <= 1;
		#300000
		UV_echo <= 0;
	end
	
	always begin
		clk_50M = ~clk_50M; #10;
	end
endmodule 