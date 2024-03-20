module Dijkstra_test(
	clk_50M,
	realtime_pos,
	EU_fault_flag,
	pick_block_B1
);
input wire clk_50M;
input wire[4:0] realtime_pos;
input wire EU_fault_flag;
input wire pick_block_B1;
//wire run_complete;
wire CPU_reset, CPU_start;
wire [31:0] CPU_Ext_WriteData, CPU_Ext_DataAdr;
wire CPU_MemWrite_flag, CPU_stop_flag, CPU_Ext_MemWrite_flag;
wire [31:0] CPU_WriteData, CPU_DataAdr, CPU_ReadData;
wire [4:0] path_planned, CPU_dijkstra_SP, CPU_dijkstra_EP ;

t2b_riscv_cpu b2v_inst0(
	.clk(clk_50M),
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
	.clk_50M(clk_50M),
	.CPU_start(CPU_start),
	.CPU_MemWrite(CPU_MemWrite_flag),
	.CPU_WriteData(CPU_WriteData), 
	.CPU_DataAdr(CPU_DataAdr),
	.CPU_ReadData(CPU_ReadData),
	.CPU_reset(CPU_reset),
	.CPU_stop(CPU_stop_flag),
	.path_planned(path_planned),
	.CPU_Ext_MemWrite(CPU_Ext_MemWrite_flag),
	.CPU_Ext_WriteData(CPU_Ext_WriteData), 
	.CPU_Ext_DataAdr(CPU_Ext_DataAdr),
	.SP(CPU_dijkstra_SP),
	.EP(CPU_dijkstra_EP)
);

path_mapping b2v_inst11(
	.clk_50M(clk_50M),
//	.node_flag(node_flag),
//	.turn_flag(turn_flag),
	.path_planned(path_planned),
	.path_input(CPU_stop_flag),
	.node_changed(node_changed),
	.realtime_pos(now_position)
);

Dijkstra_handler b2v_inst12(
	.clk_50M(clk_50M),
	.CPU_start(CPU_start),
	.EU_fault_flag(EU_fault_flag),
//	.CU_fault_flag(CU_fault_flag),
//	.RU_fault_flag(RU_fault_flag),
	.pick_block_B1(pick_block_B1),
//	.pick_block_B2(pick_block_B2),
//	.block_picked(block_picked),
	.realtime_pos(realtime_pos),
	.start_point(CPU_dijkstra_SP),
	.end_point(CPU_dijkstra_EP)
//	.ALL_DONE_FLAG(run_complete)
);
endmodule 