module uart_self_inst (
 clk_50M,
 rx,
 tx,
 led_R1,
 led_B1,
 led_G1
 );
 
 input wire clk_50M;
 input wire rx;
 input wire tx;
 output wire led_R1;
 output wire led_B1;
 output wire led_G1;
 wire SYNTHESIZED_WIRE_1;

// wire SYTHESIZED_WIRE_2;
// wire SYNTHESIZED_WIRE_3;
// wire SYNTHESIZED_WIRE_4;
 
uart_tx uut (
.clk_50M(clk_50M),
.tx(tx),
.data(SYNTHESIZED_WIRE_1));

uart_rx dut (
.clk_50M(clk_50M),
.rx(rx),
.rx_msg(SYNTHESIZED_WIRE_1),
.rx_complete(rx_complete),
.led_R1(led_R1),
.led_B1(led_B1),
.led_G1(led_G1));

endmodule 