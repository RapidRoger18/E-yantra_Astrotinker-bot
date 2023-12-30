// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"
// CREATED		"Sat Dec 30 12:17:12 2023"

module line_follower(
	clk_50M,
	dout,
	adc_cs_n,
	din,
	led1_R1,
	led1_G1,
	led1_B1,
	led2_R2,
	led2_G2,
	led2_B2,
	led3_R3,
	led3_G3,
	led3_B3,
	A1,
	B1,
	A2,
	B2,
	clk_3125Khz
);


input wire	clk_50M;
input wire	dout;
output wire	adc_cs_n;
output wire	din;
output wire	led1_R1;
output wire	led1_G1;
output wire	led1_B1;
output wire	led2_R2;
output wire	led2_G2;
output wire	led2_B2;
output wire	led3_R3;
output wire	led3_G3;
output wire	led3_B3;
output wire	A1;
output wire	B1;
output wire	A2;
output wire	B2;
output wire	clk_3125Khz;

wire	SYNTHESIZED_WIRE_14;
wire	[11:0] SYNTHESIZED_WIRE_1;
wire	[11:0] SYNTHESIZED_WIRE_2;
wire	[11:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[3:0] SYNTHESIZED_WIRE_11;
wire	[3:0] SYNTHESIZED_WIRE_13;

assign	clk_3125Khz = SYNTHESIZED_WIRE_14;




ADC_Controller	b2v_inst(
	.dout(dout),
	.adc_sck(SYNTHESIZED_WIRE_14),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.center_value(SYNTHESIZED_WIRE_2),
	.left_value(SYNTHESIZED_WIRE_1),
	.right_value(SYNTHESIZED_WIRE_3));


Line_Following	b2v_inst2(
	.left(SYNTHESIZED_WIRE_1),
	.middle(SYNTHESIZED_WIRE_2),
	.right(SYNTHESIZED_WIRE_3),
	.m1_a(SYNTHESIZED_WIRE_5),
	.m1_b(SYNTHESIZED_WIRE_6),
	.m2_a(SYNTHESIZED_WIRE_8),
	.m2_b(SYNTHESIZED_WIRE_9),
	.led1_R1(led1_R1),
	.led1_G1(led1_G1),
	.led1_B1(led1_B1),
	.led2_R2(led2_R2),
	.led2_G2(led2_G2),
	.led2_B2(led2_B2),
	.led3_R3(led3_R3),
	.led3_G3(led3_G3),
	.led3_B3(led3_B3),
	.dc1(SYNTHESIZED_WIRE_11),
	.dc2(SYNTHESIZED_WIRE_13));


demux_1	b2v_inst3(
	.pwm_195(SYNTHESIZED_WIRE_4),
	.m1a1(SYNTHESIZED_WIRE_5),
	.m1b1(SYNTHESIZED_WIRE_6),
	.A1(A1),
	.B1(B1));


demux_2	b2v_inst4(
	.pwm_195(SYNTHESIZED_WIRE_7),
	.m2a2(SYNTHESIZED_WIRE_8),
	.m2b2(SYNTHESIZED_WIRE_9),
	.A2(A2),
	.B2(B2));


frequency_scaling	b2v_inst5(
	.clk_50M(clk_50M),
	.clk_3125KHz(SYNTHESIZED_WIRE_14));


pwm_generator1	b2v_inst6(
	.clk_3125KHz(SYNTHESIZED_WIRE_14),
	.duty_cycle(SYNTHESIZED_WIRE_11),
	
	.pwm_signal(SYNTHESIZED_WIRE_4));


pwm_generator2	b2v_inst7(
	.clk_3125KHz(SYNTHESIZED_WIRE_14),
	.duty_cycle(SYNTHESIZED_WIRE_13),
	
	.pwm_signal(SYNTHESIZED_WIRE_7));


endmodule
