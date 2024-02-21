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

// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output wire rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here
reg [1:0] state = 0;
reg [8:0] count = 0;    //434
reg [2:0] index = 0;
reg [7:0] Msg = 0;
reg [2:0] idx = 3'd7;
reg rx_data = 0;
reg rx_complete_r = 0;
reg status_r = 0;

initial begin
rx_msg = 0;
state <= 2'b00;
end

assign rx_complete = rx_complete_r;

always@(posedge clk_50M)begin
	case(state)
		2'b00: begin
			state <= 2'b01;
			Msg <= 0;
			rx_complete_r  <= 0;
		end
		2'b01:begin         //start
			Msg <= 0;
			rx_complete_r  <= 0;
			if ( (25 < count < 425) && rx == 0) status_r <= 1;
			if (count == 433) begin
				count <= 0;
				if(status_r == 1'b1) state <= 2'b10;
				else state <= 2'b00;
			end
			else count <= count + 1;
		end
		2'b10:begin       //read data
			if (count < 433) begin
				status_r <= 0;
				count <= count + 1;
				state <= 2'b10;
				if ( 25 < count < 425 ) rx_data <= rx;
			end
			else begin
				Msg[7 - index] <= rx_data;
				count <= 0;
				if (index < 7) begin
					index <= index + 1;
					state <= 2'b10;
				end
				else begin
					index <= 0;
					state <= 2'b11;
				end
			end
		end
		2'b11:begin
			if (count < 433) begin
				count = count + 1;
				state <= 2'b11;
			end
			else begin
				if (Msg != 8'h50 ) rx_msg <= Msg;
				rx_complete_r <= 1'b1;
				count <= 0;
				state <= 2'b01;
			end
		end
	endcase
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule 