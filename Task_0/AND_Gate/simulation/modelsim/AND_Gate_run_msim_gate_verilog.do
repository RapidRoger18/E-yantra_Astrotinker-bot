transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {AND_Gate.vo}

vlog -vlog01compat -work work +incdir+/home/saish_k/Eyantra/Task\ 0/AND_Gate {/home/saish_k/Eyantra/Task 0/AND_Gate/AND_gate_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  AND_Gate_tb

add wave *
view structure
view signals
run -all
