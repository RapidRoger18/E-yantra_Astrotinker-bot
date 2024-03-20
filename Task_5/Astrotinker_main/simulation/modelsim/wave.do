onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_clock/clk
add wave -noupdate -radix unsigned /tb_clock/realtime_pos
add wave -noupdate /tb_clock/EU_fault_flag
add wave -noupdate /tb_clock/pick_block_B1
add wave -noupdate /tb_clock/uut/clk_50M
add wave -noupdate -radix unsigned /tb_clock/uut/realtime_pos
add wave -noupdate /tb_clock/uut/EU_fault_flag
add wave -noupdate /tb_clock/uut/pick_block_B1
add wave -noupdate /tb_clock/uut/run_complete
add wave -noupdate /tb_clock/uut/CPU_reset
add wave -noupdate /tb_clock/uut/CPU_start
add wave -noupdate /tb_clock/uut/CPU_Ext_WriteData
add wave -noupdate /tb_clock/uut/CPU_Ext_DataAdr
add wave -noupdate /tb_clock/uut/CPU_MemWrite_flag
add wave -noupdate /tb_clock/uut/CPU_stop_flag
add wave -noupdate /tb_clock/uut/CPU_Ext_MemWrite_flag
add wave -noupdate /tb_clock/uut/CPU_WriteData
add wave -noupdate /tb_clock/uut/CPU_DataAdr
add wave -noupdate /tb_clock/uut/CPU_ReadData
add wave -noupdate -radix unsigned -childformat {{{/tb_clock/uut/path_planned[4]} -radix unsigned} {{/tb_clock/uut/path_planned[3]} -radix unsigned} {{/tb_clock/uut/path_planned[2]} -radix unsigned} {{/tb_clock/uut/path_planned[1]} -radix unsigned} {{/tb_clock/uut/path_planned[0]} -radix unsigned}} -subitemconfig {{/tb_clock/uut/path_planned[4]} {-radix unsigned} {/tb_clock/uut/path_planned[3]} {-radix unsigned} {/tb_clock/uut/path_planned[2]} {-radix unsigned} {/tb_clock/uut/path_planned[1]} {-radix unsigned} {/tb_clock/uut/path_planned[0]} {-radix unsigned}} /tb_clock/uut/path_planned
add wave -noupdate -radix unsigned /tb_clock/uut/CPU_dijkstra_SP
add wave -noupdate -radix unsigned /tb_clock/uut/CPU_dijkstra_EP
add wave -noupdate /tb_clock/uut/b2v_inst1/path_planned_array
add wave -noupdate /tb_clock/uut/b2v_inst12/SWITCH_STATE
add wave -noupdate /tb_clock/uut/b2v_inst12/counter_EU_fault
add wave -noupdate /tb_clock/uut/b2v_inst12/counter_EU_rectify
add wave -noupdate /tb_clock/uut/b2v_inst12/block_pick_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42007290057 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 271
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
WaveRestoreZoom {7432306677 ps} {22296920053 ps}
