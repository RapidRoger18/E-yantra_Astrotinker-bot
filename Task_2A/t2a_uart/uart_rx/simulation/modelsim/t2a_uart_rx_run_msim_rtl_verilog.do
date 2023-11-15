transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/sra-vjti/Downloads/uart-Eyantra23/t2a_uart/uart_rx {/home/sra-vjti/Downloads/uart-Eyantra23/t2a_uart/uart_rx/uart_rx.v}

vlog -vlog01compat -work work +incdir+/home/sra-vjti/Downloads/uart-Eyantra23/t2a_uart/uart_rx/simulation/modelsim {/home/sra-vjti/Downloads/uart-Eyantra23/t2a_uart/uart_rx/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 869000 ns
