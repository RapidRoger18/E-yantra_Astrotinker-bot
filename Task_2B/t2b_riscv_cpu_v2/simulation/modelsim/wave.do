onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset
add wave -noupdate /tb/Ext_MemWrite
add wave -noupdate /tb/Ext_WriteData
add wave -noupdate /tb/Ext_DataAdr
add wave -noupdate /tb/WriteData
add wave -noupdate /tb/DataAdr
add wave -noupdate /tb/ReadData
add wave -noupdate /tb/MemWrite
add wave -noupdate /tb/SP
add wave -noupdate /tb/EP
add wave -noupdate /tb/error_count
add wave -noupdate /tb/i
add wave -noupdate /tb/fw
add wave -noupdate /tb/fd
add wave -noupdate /tb/num_values
add wave -noupdate /tb/value
add wave -noupdate -radix hexadecimal -childformat {{{/tb/uut/Instr[31]} -radix hexadecimal} {{/tb/uut/Instr[30]} -radix hexadecimal} {{/tb/uut/Instr[29]} -radix hexadecimal} {{/tb/uut/Instr[28]} -radix hexadecimal} {{/tb/uut/Instr[27]} -radix hexadecimal} {{/tb/uut/Instr[26]} -radix hexadecimal} {{/tb/uut/Instr[25]} -radix hexadecimal} {{/tb/uut/Instr[24]} -radix hexadecimal} {{/tb/uut/Instr[23]} -radix hexadecimal} {{/tb/uut/Instr[22]} -radix hexadecimal} {{/tb/uut/Instr[21]} -radix hexadecimal} {{/tb/uut/Instr[20]} -radix hexadecimal} {{/tb/uut/Instr[19]} -radix hexadecimal} {{/tb/uut/Instr[18]} -radix hexadecimal} {{/tb/uut/Instr[17]} -radix hexadecimal} {{/tb/uut/Instr[16]} -radix hexadecimal} {{/tb/uut/Instr[15]} -radix hexadecimal} {{/tb/uut/Instr[14]} -radix hexadecimal} {{/tb/uut/Instr[13]} -radix hexadecimal} {{/tb/uut/Instr[12]} -radix hexadecimal} {{/tb/uut/Instr[11]} -radix hexadecimal} {{/tb/uut/Instr[10]} -radix hexadecimal} {{/tb/uut/Instr[9]} -radix hexadecimal} {{/tb/uut/Instr[8]} -radix hexadecimal} {{/tb/uut/Instr[7]} -radix hexadecimal} {{/tb/uut/Instr[6]} -radix hexadecimal} {{/tb/uut/Instr[5]} -radix hexadecimal} {{/tb/uut/Instr[4]} -radix hexadecimal} {{/tb/uut/Instr[3]} -radix hexadecimal} {{/tb/uut/Instr[2]} -radix hexadecimal} {{/tb/uut/Instr[1]} -radix hexadecimal} {{/tb/uut/Instr[0]} -radix hexadecimal}} -subitemconfig {{/tb/uut/Instr[31]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[30]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[29]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[28]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[27]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[26]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[25]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[24]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[23]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[22]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[21]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[20]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[19]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[18]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[17]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[16]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[15]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[14]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[13]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[12]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[11]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[10]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[9]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[8]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[7]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[6]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[5]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[4]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[3]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[2]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[1]} {-height 17 -radix hexadecimal} {/tb/uut/Instr[0]} {-height 17 -radix hexadecimal}} /tb/uut/Instr
add wave -noupdate -radix hexadecimal /tb/uut/PC
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/rf/rd_addr1
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/rf/rd_addr2
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/rf/rd_data1
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/rf/rd_data2
add wave -noupdate -radix hexadecimal /tb/uut/dmem/wr_addr
add wave -noupdate -radix unsigned /tb/uut/rvsingle/dp/rf/wr_addr
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/rf/wr_data
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/alu/alu_out
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/WriteData
add wave -noupdate -radix decimal /tb/uut/rvsingle/dp/ext/immext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199747 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {303616 ps}
