transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t1c_pulse_gen_detect {/home/atharvak/E-yantra23/t1c_pulse_gen_detect/t1c_pulse_gen_detect.v}

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t1c_pulse_gen_detect/simulation/modelsim {/home/atharvak/E-yantra23/t1c_pulse_gen_detect/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 8 ms
