transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t4b_Fault_detection {/home/atharvak/E-yantra23/t4b_Fault_detection/Fault_detection.v}

vlog -vlog01compat -work work +incdir+/home/atharvak/E-yantra23/t4b_Fault_detection/simulation/modelsim {/home/atharvak/E-yantra23/t4b_Fault_detection/simulation/modelsim/Fault_detection_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Fault_detection_tb

add wave *
view structure
view signals
run -all
