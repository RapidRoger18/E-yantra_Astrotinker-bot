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
// CREATED		"Wed Nov  8 14:38:04 2023"

module riscv_cpu(
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	Mem_WrAddr,
	Mem_WrData,
	ReadData
	
);


input wire	clk;
input wire	reset;
input wire	[31:0] Instr;
input wire	[31:0] ReadData;
output wire	MemWrite;
output wire	[31:0] Mem_WrAddr;
output wire	[31:0] Mem_WrData;
output wire	[31:0] PC;

wire	SYNTHESIZED_WIRE_0;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_20;
wire	[36:0] SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_21;
wire	[31:0] SYNTHESIZED_WIRE_22;
wire	[31:0] SYNTHESIZED_WIRE_6;
wire	[6:0] SYNTHESIZED_WIRE_8;
wire	[36:0] SYNTHESIZED_WIRE_9;
wire	[31:0] SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	[31:0] SYNTHESIZED_WIRE_16;
wire	[31:0] SYNTHESIZED_WIRE_17;
wire	[4:0] SYNTHESIZED_WIRE_18;
wire	[4:0] SYNTHESIZED_WIRE_19;

assign	PC = SYNTHESIZED_WIRE_10;




PC	b2v_inst(
	.clk(clk),
	.reset(reset),
	.j_signal(SYNTHESIZED_WIRE_0),
	.jump(SYNTHESIZED_WIRE_1),
	.out(SYNTHESIZED_WIRE_10));


alu	b2v_inst1(
	.imm(SYNTHESIZED_WIRE_20),
	.instructions(SYNTHESIZED_WIRE_3),
	.rs1(SYNTHESIZED_WIRE_21),
	.rs2(SYNTHESIZED_WIRE_22),
	.ALUoutput(SYNTHESIZED_WIRE_6));


control_unit	b2v_inst2(
	.clk(clk),
	.rst(reset),
	.ALUoutput(SYNTHESIZED_WIRE_6),
	.imm(SYNTHESIZED_WIRE_20),
	.mem_read(ReadData),
	.opcode(SYNTHESIZED_WIRE_8),
	.out_signal(SYNTHESIZED_WIRE_9),
	.pc_input(SYNTHESIZED_WIRE_10),
	.rs1_input(SYNTHESIZED_WIRE_21),
	.rs2_input(SYNTHESIZED_WIRE_22),
	.j_signal(SYNTHESIZED_WIRE_0),
	.wr_en_rf(SYNTHESIZED_WIRE_15),
	.wr_en(MemWrite),
	.addr(Mem_WrAddr),
	.final_output(SYNTHESIZED_WIRE_17),
	.instructions(SYNTHESIZED_WIRE_3),
	.jump(SYNTHESIZED_WIRE_1),
	.mem_write(Mem_WrData));


decoder	b2v_inst3(
	.instr(Instr),
	.rs1_valid(SYNTHESIZED_WIRE_13),
	.rs2_valid(SYNTHESIZED_WIRE_14),
	.imm(SYNTHESIZED_WIRE_20),
	.opcode(SYNTHESIZED_WIRE_8),
	.out_signal(SYNTHESIZED_WIRE_9),
	.rd(SYNTHESIZED_WIRE_16),
	.rs1(SYNTHESIZED_WIRE_18),
	.rs2(SYNTHESIZED_WIRE_19));


registerfile	b2v_inst4(
	.clk(clk),
	.rs1_valid(SYNTHESIZED_WIRE_13),
	.rs2_valid(SYNTHESIZED_WIRE_14),
	.wr_en(SYNTHESIZED_WIRE_15),
	.rd(SYNTHESIZED_WIRE_16),
	.result(SYNTHESIZED_WIRE_17),
	.rs1(SYNTHESIZED_WIRE_18),
	.rs2(SYNTHESIZED_WIRE_19),
	.rs1_value(SYNTHESIZED_WIRE_21),
	.rs2_value(SYNTHESIZED_WIRE_22));


endmodule
