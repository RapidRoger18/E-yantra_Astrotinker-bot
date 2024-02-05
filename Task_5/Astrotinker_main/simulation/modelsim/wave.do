onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_clock/clk
add wave -noupdate /tb_clock/uut/b2v_inst3/clk_50M
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_MemWrite
add wave -noupdate -radix decimal /tb_clock/uut/b2v_inst3/CPU_WriteData
add wave -noupdate -radix hexadecimal /tb_clock/uut/b2v_inst3/CPU_DataAdr
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_ReadData
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_reset
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_Ext_MemWrite
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_Ext_WriteData
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_Ext_DataAdr
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_start
add wave -noupdate /tb_clock/uut/b2v_inst3/CPU_stop
add wave -noupdate /tb_clock/uut/b2v_inst3/start_mem
add wave -noupdate /tb_clock/uut/b2v_inst3/state
add wave -noupdate /tb_clock/uut/b2v_inst3/index
add wave -noupdate /tb_clock/uut/b2v_inst3/SP
add wave -noupdate /tb_clock/uut/b2v_inst3/EP
add wave -noupdate /tb_clock/uut/b2v_inst3/path_planned
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87247 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 348
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1051760 ps}
