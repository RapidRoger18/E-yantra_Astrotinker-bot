transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/uart_tx.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/uart_rx.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/t2b_riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/registerfile.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/pwm_generator1.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/pc.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/path_1.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/Line_Following.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/LED_driver.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/frequency_scaling.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/Fault_detection.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/decoder.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/data_mem.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/control_unit.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/alu.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/adc_controller.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/Astrotinker_main.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/CPU_driver.v}
vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes {/home/atharvak/E-yantra23/Astrotinker_main/Verilog_codes/instr_mem.v}

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/Astrotinker_main/simulation/modelsim {/home/atharvak/E-yantra23/Astrotinker_main/simulation/modelsim/clock_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_clock

add wave *
view structure
view signals
run -all
