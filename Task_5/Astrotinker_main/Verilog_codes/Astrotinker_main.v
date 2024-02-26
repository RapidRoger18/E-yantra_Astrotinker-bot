module Astrotinker_main(
	clk_50M,
	adc_dout,
	key0,
	key1,
	UV_echo,
	UV_trig,
	adc_cs_n,
	adc_din,
	led1_R1,
	led1_G1,
	led1_B1,
	led2_R2,
	led2_G2,
	led2_B2,
	led3_R3,
	led3_G3,
	led3_B3,
	motor_A1,
	motor_B1,
	motor_A2,
	motor_B2,
	adc_clk_3125Khz,
	fpga_LED,
	transmit_data,
	receive_data,
	EM_A1,
	EM_B1
);

input wire	clk_50M;
input wire	adc_dout;
input wire key0;
input wire key1;
input wire UV_echo;
input wire receive_data;
output wire UV_trig;
output wire	adc_cs_n;
output wire	adc_din;
output wire	led1_R1;
output wire	led1_G1;
output wire	led1_B1;
output wire	led2_R2;
output wire	led2_G2;
output wire	led2_B2;
output wire	led3_R3;
output wire	led3_G3;
output wire	led3_B3;
output wire	motor_A1;
output wire	motor_B1;
output wire	motor_A2;
output wire	motor_B2;
output wire	adc_clk_3125Khz;
output wire [7:0] fpga_LED;
output wire transmit_data;
output wire EM_A1;
output wire EM_B1;


wire EU_fault_flag, CU_fault_flag, RU_fault_flag;
wire EU_done_flag, CU_done_flag, RU_done_flag, run_complete;
wire pick_block_flag, block_picked;
wire [1:0] block_location;

wire CPU_reset, CPU_start;
wire [31:0] CPU_Ext_WriteData, CPU_Ext_DataAdr;
wire CPU_MemWrite_flag, CPU_stop_flag, CPU_Ext_MemWrite_flag;
wire [31:0] CPU_WriteData, CPU_DataAdr, CPU_ReadData;
wire [4:0] path_planned, CPU_dijkstra_SP, CPU_dijkstra_EP;

wire	[11:0] SYNTHESIZED_WIRE_1;
wire	[11:0] SYNTHESIZED_WIRE_2;
wire	[11:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[4:0] SYNTHESIZED_WIRE_11;
wire	[4:0] SYNTHESIZED_WIRE_13;
wire clk_95Hz;
wire node_flag;
wire fault_detect;
wire object_drop;
wire [4:0] now_position;
wire [4:0] curr_node;
wire [7:0] tx_data;
wire [7:0] rx_msg;
wire rx_complete;
wire data_send;
wire node_changed;
wire key_flag;
wire [2:0] fault_id;
wire [1:0] fault_location;

assign fpga_LED = now_position;

t2b_riscv_cpu b2v_inst0(
	.clk(adc_clk_3125Khz),
	.reset(CPU_reset),
   .Ext_MemWrite(CPU_Ext_MemWrite_flag),
   .Ext_WriteData(CPU_Ext_WriteData), 
	.Ext_DataAdr(CPU_Ext_DataAdr),
   .MemWrite(CPU_MemWrite_flag),
   .WriteData(CPU_WriteData), 
	.DataAdr(CPU_DataAdr), 
	.ReadData(CPU_ReadData)
);
CPU_driver b2v_inst1(
	.clk_3125KHz(adc_clk_3125Khz),
	.CPU_start(CPU_start),
	.CPU_MemWrite(CPU_MemWrite_flag),
	.CPU_WriteData(CPU_WriteData), 
	.CPU_DataAdr(CPU_DataAdr),
	.CPU_ReadData(CPU_ReadData),
	.CPU_reset(CPU_reset),
	.CPU_stop_flag(CPU_stop_flag),
	.path_planned(path_planned),
	.CPU_Ext_MemWrite(CPU_Ext_MemWrite_flag),
	.CPU_Ext_WriteData(CPU_Ext_WriteData), 
	.CPU_Ext_DataAdr(CPU_Ext_DataAdr),
	.SP(CPU_dijkstra_SP),
	.EP(CPU_dijkstra_EP)
);

ADC_Controller	b2v_inst2(
	.dout(adc_dout),
	.adc_sck(adc_clk_3125Khz),
	.adc_cs_n(adc_cs_n),
	.din(adc_din),
	.center_value(SYNTHESIZED_WIRE_2),
	.left_value(SYNTHESIZED_WIRE_1),
	.right_value(SYNTHESIZED_WIRE_3));

Line_Following	b2v_inst3(
	.switch_key(key_flag),
	.clk_3125KHz(adc_clk_3125Khz),
	.left(SYNTHESIZED_WIRE_1),
	.middle(SYNTHESIZED_WIRE_2),
	.right(SYNTHESIZED_WIRE_3),
	.m1_a(SYNTHESIZED_WIRE_5),
	.m1_b(SYNTHESIZED_WIRE_6),
	.m2_a(SYNTHESIZED_WIRE_8),
	.m2_b(SYNTHESIZED_WIRE_9),
	.dc1(SYNTHESIZED_WIRE_11),
	.dc2(SYNTHESIZED_WIRE_13),
	.node_flag(node_flag),
	.node_changed(node_changed)
);
frequency_scaling	b2v_inst4(
	.clk_50M(clk_50M),
	.clk_3125KHz(adc_clk_3125Khz)	
);
pwm_generator	b2v_inst5(
	.clk_3125KHz(adc_clk_3125Khz),
	.duty_cycle(SYNTHESIZED_WIRE_11),
	.clk_95Hz(clk_95Hz),
	.motor_a(SYNTHESIZED_WIRE_5),
	.motor_b(SYNTHESIZED_WIRE_6),
	.motor_A(motor_A1),
	.motor_B(motor_B1));


pwm_generator	b2v_inst6(
	.clk_3125KHz(adc_clk_3125Khz),
	.duty_cycle(SYNTHESIZED_WIRE_13),
	.motor_a(SYNTHESIZED_WIRE_8),
	.motor_b(SYNTHESIZED_WIRE_9),
	.motor_A(motor_A2),
	.motor_B(motor_B2));

Fault_detection b2v_inst7(
	.clk_50M(clk_50M),
	.switch_key(key_flag),
	.UV_echo(UV_echo),
	.UV_trig(UV_trig),
	.fault_detect(fault_detect),
	.fault_count(fault_count),
	.block_picked (block_picked),
	.object_drop(object_drop),
	.EM_a1(EM_A1),
	.EM_b1(EM_B1)
	);
	
LED_driver b2v_inst8(
	.clk_50M(clk_50M),
	.clk_3125KHz(adc_clk_3125Khz),
	.fault_detect(fault_detect),
	.node_flag(node_flag),
	.switch_key(key_flag),
	.object_drop(object_drop),
	.run_complete(run_complete),
	.EU_fault_flag (EU_fault_flag),
	.led1_R1(led1_R1),
	.led1_G1(led1_G1),
	.led1_B1(led1_B1),
	.led2_R2(led2_R2),
	.led2_G2(led2_G2),
	.led2_B2(led2_B2),
	.led3_R3(led3_R3),
	.led3_G3(led3_G3),
	.led3_B3(led3_B3)
);

uart_tx b2v_inst9(
	.clk_50M(clk_50M),
	.data_send(data_send),
	.data(tx_data),
	.tx(transmit_data)
);

uart_rx b2v_inst10(
	.clk_50M(clk_50M),
	.rx(receive_data),
	.rx_msg(rx_msg),
	.rx_complete(rx_complete)
);
path_mapping b2v_inst11(
	.clk_3125KHz(adc_clk_3125Khz),
	.node_flag(node_flag),
	.switch_key(key_flag),
	.turn_flag(turn_flag),
	.path_planned(path_planned),
	.path_input(CPU_stop_flag),
	.node_changed(node_changed),
	.realtime_pos(now_position),
	.curr_node(curr_node)
);

Dijkstra_handler b2v_inst12(
	.clk_3125KHz(adc_clk_3125Khz),
	.CPU_start(CPU_start),
	.switch_key(key_flag),
	.EU_fault_flag(EU_fault_flag),
	.CU_fault_flag(CU_fault_flag),
	.RU_fault_flag(RU_fault_flag),
	.pick_block_flag(pick_block_flag),
	.block_location(block_location),
//	.block_picked(block_picked),
	.realtime_pos(now_position),
	.start_point(CPU_dijkstra_SP),
	.end_point(CPU_dijkstra_EP),
	.curr_node(curr_node),
	.ALL_DONE_FLAG(run_complete),
	.fault_id(fault_id),
	.fault_location(fault_location)
);

msg_rx b2v_inst13(
	.clk_50M(clk_50M),
	.clk_3125KHz(adc_clk_3125Khz),
   .rx_msg(rx_msg),
	.key0(key0),
	.switch_key(key_flag),
	.rx_complete(rx_complete),
	.EU_fault_flag(EU_fault_flag), 
	.CU_fault_flag(CU_fault_flag),
	.RU_fault_flag(RU_fault_flag),
	.pick_block_flag(pick_block_flag),
	.block_location(block_location)
);

message_unit b2v_inst14(
	.clk_50M(clk_50M),
	.clk_3125KHz(adc_clk_3125Khz),
	.fault_location(fault_location),
   .fault_detect(fault_detect), 
	.switch_key(key_flag),
	.fault_id(fault_id),
	.block_picked(block_picked),
	.end_run_interrupt(run_complete),
	.block_location(block_location), 												
	.msg(tx_data),
	.node_flag(node_flag),
	.data_send(data_send)
);
endmodule 