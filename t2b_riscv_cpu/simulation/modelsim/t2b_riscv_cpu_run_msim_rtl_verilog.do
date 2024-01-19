transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes {/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes/pc.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes {/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes/decoder.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes {/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes {/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes/alu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes {/home/atharvak/E-yantra23/t2b_riscv_cpu/verilog_codes/registerfile.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu {/home/atharvak/E-yantra23/t2b_riscv_cpu/data_mem.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu {/home/atharvak/E-yantra23/t2b_riscv_cpu/riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu {/home/atharvak/E-yantra23/t2b_riscv_cpu/t2b_riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu {/home/atharvak/E-yantra23/t2b_riscv_cpu/instr_mem.v}

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t2b_riscv_cpu/simulation/modelsim {/home/atharvak/E-yantra23/t2b_riscv_cpu/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 5 ms
