// AstroTinker Bot : Task 2A : UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/
// This module samples Data at the centre of its Baud rate 
// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state = 0;
reg [8:0] counter = 0;    //434
reg [2:0] bit_count = 0 ;
always@(posedge clk_50M) begin
	case(state)
	IDLE: begin
		if (rx == 0) begin
			rx_complete <= 0;
			state <= START;
		end
	end
	START: begin
		if( rx == 0 && counter == 9'd217) begin
			state <= DATA;
			counter <= 0;
			bit_count <= 0;
			rx_msg <= 0;
		end 
		else counter <= counter + 1;
	end
	DATA: begin
		if(counter == 9'd433) begin
			state <= DATA;
			rx_msg <= {rx, rx_msg[7:1]};
			bit_count <= bit_count + 1;
			counter <= 0;
			if(bit_count == 3'd7) begin
			state <= STOP;
			bit_count <= 0;
			rx_complete <= 0;
			end
		end 
		else begin
			counter <= counter + 1;
		end
	end
	STOP: begin
		if(counter == 9'd433) begin
			rx_complete <= 1;
			state <= IDLE;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	endcase
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule 