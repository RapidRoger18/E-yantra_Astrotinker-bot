//// Copyright (C) 2020  Intel Corporation. All rights reserved.
//// Your use of Intel Corporation's design tools, logic functions 
//// and other software and tools, and any partner logic 
//// functions, and any output files from any of the foregoing 
//// (including device programming or simulation files), and any 
//// associated documentation or information are expressly subject 
//// to the terms and conditions of the Intel Program License 
//// Subscription Agreement, the Intel Quartus Prime License Agreement,
//// the Intel FPGA IP License Agreement, or other applicable license
//// agreement, including, without limitation, that your use is for
//// the sole purpose of programming logic devices manufactured by
//// Intel and sold by Intel or its authorized distributors.  Please
//// refer to the applicable agreement for further details, at
//// https://fpgasoftware.intel.com/eula.
//
//// PROGRAM		"Quartus Prime"
//// VERSION		"Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"
//// CREATED		"Sat Dec 30 12:17:12 2023"
//
//module  main_module(
//	input	clk_50M,
//	input	dout,
//	input key,
//	input UV_echo,
//	output UV_trig,
//	output adc_cs_n,
//	output din,
//	output led1_R1,
//	output led1_G1,
//	output led1_B1,
//	output led2_R2,
//	output led2_G2,
//	output led2_B2,
//	output led3_R3,
//	output led3_G3,
//	output led3_B3,
//	output A1,
//	output B1,
//	output A2,
//	output B2,
//	output clk_3125Khz,
//	output [7:0] fpga_LED,
//	output transmit_data,
//	output receive_data
//);
//
//
////input wire	clk_50M;
////input wire	dout;
////input wire key;
////input wire UV_echo;
////output wire UV_trig;
////output wire	adc_cs_n;
////output wire	din;
////output wire	led1_R1;
////output wire	led1_G1;
////output wire	led1_B1;
////output wire	led2_R2;
////output wire	led2_G2;
////output wire	led2_B2;
////output wire	led3_R3;
////output wire	led3_G3;
////output wire	led3_B3;
////output wire	A1;
////output wire	B1;
////output wire	A2;
////output wire	B2;
////output wire	clk_3125Khz;
////output wire [7:0] fpga_LED;
////output wire transmit_data;
////output wire receive_data;
//
//
//wire	SYNTHESIZED_WIRE_14;
//wire	[11:0] SYNTHESIZED_WIRE_1;
//wire	[11:0] SYNTHESIZED_WIRE_2;
//wire	[11:0] SYNTHESIZED_WIRE_3;
//wire	SYNTHESIZED_WIRE_4;
//wire	SYNTHESIZED_WIRE_5;
//wire	SYNTHESIZED_WIRE_6;
//wire	SYNTHESIZED_WIRE_7;
//wire	SYNTHESIZED_WIRE_8;
//wire	SYNTHESIZED_WIRE_9;
//wire	[3:0] SYNTHESIZED_WIRE_11;
//wire	[3:0] SYNTHESIZED_WIRE_13;
//wire clk_95Hz;
//wire node_flag;
//wire turn_flag;
//wire [7:0] node;
//wire fault_detect;
//wire key_flag;
//wire [7:0] tx_data;
//assign	clk_3125Khz = SYNTHESIZED_WIRE_14;
//wire [7:0] rx_msg;
//wire rx_complete;
//
//ADC_Controller	b2v_inst(
//	.dout(dout),
//	.adc_sck(SYNTHESIZED_WIRE_14),
//	.adc_cs_n(adc_cs_n),
//	.din(din),
//	.center_value(SYNTHESIZED_WIRE_2),
//	.left_value(SYNTHESIZED_WIRE_1),
//	.right_value(SYNTHESIZED_WIRE_3));
//
//Line_Following	b2v_inst2(
//	.key(key),
//	.switch_on(key_flag),
//	.clk_3125KHz(SYNTHESIZED_WIRE_14),
//	.left(SYNTHESIZED_WIRE_1),
//	.middle(SYNTHESIZED_WIRE_2),
//	.right(SYNTHESIZED_WIRE_3),
//	.m1_a(SYNTHESIZED_WIRE_5),
//	.m1_b(SYNTHESIZED_WIRE_6),
//	.m2_a(SYNTHESIZED_WIRE_8),
//	.m2_b(SYNTHESIZED_WIRE_9),
//	.dc1(SYNTHESIZED_WIRE_11),
//	.dc2(SYNTHESIZED_WIRE_13),
//	.node_flag(node_flag),
//	.node(node),
//	.fpga_LED(fpga_LED));
//
//
////demux	b2v_inst3(
////	.pwm_195(SYNTHESIZED_WIRE_4),
////	.m1a1(SYNTHESIZED_WIRE_5),
////	.m1b1(SYNTHESIZED_WIRE_6),
////	.A1(A1),
////	.B1(B1));
////
////
////demux	b2v_inst4(
////	.pwm_195(SYNTHESIZED_WIRE_7),
////	.m1a1(SYNTHESIZED_WIRE_8),
////	.m1b1(SYNTHESIZED_WIRE_9),
////	.A1(A2),
////	.B1(B2));
//
//
//frequency_scaling	b2v_inst5(
//	.clk_50M(clk_50M),
//	.clk_3125KHz(SYNTHESIZED_WIRE_14));
//
//
//pwm_generator	b2v_inst6(
//	.clk_3125KHz(SYNTHESIZED_WIRE_14),
//	.duty_cycle(SYNTHESIZED_WIRE_11),
//	.clk_95Hz(clk_95Hz),
//	.motor_a(SYNTHESIZED_WIRE_5),
//	.motor_b(SYNTHESIZED_WIRE_6),
//	.motor_A(A1),
//	.motor_B(B1));
//
//
//pwm_generator	b2v_inst7(
//	.clk_3125KHz(SYNTHESIZED_WIRE_14),
//	.duty_cycle(SYNTHESIZED_WIRE_13),
//	.motor_a(SYNTHESIZED_WIRE_8),
//	.motor_b(SYNTHESIZED_WIRE_9),
//	.motor_A(A2),
//	.motor_B(B2));
//
//Fault_detection b2v_inst8(
//	.key_flag(key_flag),
//	.clk_50M(clk_50M),
//	.UV_echo(UV_echo),
//	.UV_trig(UV_trig),
//	.fault_detect(fault_detect),
//	.msg(tx_data)
//	);
//	
//LED_driver b2v_inst9(
//	.clk_95Hz(clk_95Hz),
//	.fault_detect(fault_detect),
//	.node_flag(node_flag),
//	.node(node),
//	.led1_R1(led1_R1),
//	.led1_G1(led1_G1),
//	.led1_B1(led1_B1),
//	.led2_R2(led2_R2),
//	.led2_G2(led2_G2),
//	.led2_B2(led2_B2),
//	.led3_R3(led3_R3),
//	.led3_G3(led3_G3),
//	.led3_B3(led3_B3)
//);
//
//uart_tx b2v_inst10(
//	.clk_50M(clk_50M),
//	.data(tx_data),
//	.tx(transmit_data)
//);
//
//uart_rx b2v_inst11(
//	.clk_50M(clk_50M),
//	.rx(receive_data),
//	.rx_msg(rx_msg),
//	.rx_complete(rx_complete));
//
//path b2v_inst12(
//	.clk_50M(clk_50M),
//	.node_flag(node_flag),
//	.turn_flag(turn_flag)
//	);
//	
//endmodule 