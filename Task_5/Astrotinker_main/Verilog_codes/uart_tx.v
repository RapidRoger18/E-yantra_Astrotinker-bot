// AstroTinker Bot : Task 2A : UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_50M - 50 MHz clock
        data    - 8-bit data line to transmit
Output: tx      - UART Transmission Line
*/

// module declaration
module uart_tx(
    input  clk_50M,
	 input data_send,
    input  [7:0] data,
    output reg tx
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
initial begin
	 tx = 0;
end

////////// Add your code here ///////////////////
reg [1:0] state = 0;
reg [2:0] index=0;
reg [8:0] count=0; //434

always@(posedge clk_50M) begin 

	case (state) 
		2'd0: begin 						// IDLE state
			index<=4'd0;
			if (data_send) state<=2'd1;
			count<=9'b0;
			tx <=1;
			end 
		2'd1: begin 							//START state 
			tx<=0;
			if(count<=432) begin
				count<=count+1;
				state<=2'd1;
				end
			else begin
				count<=9'b0;
				state<=2'd2;
				end
			end
		2'd2: begin 						// DATA state 
			tx<=data[index];
			if(count<=432) begin
				count<=count+1;
				state<=2'd2;
				end
			else begin	
				count<=9'b0;
				if(index<3'd7) begin
					index<=index+1;
					state<=2'd2;
					end
				else begin
					index<=3'b0;
					state<=2'd3;
					end
				end
			end
		2'd3: begin 					//STOP state
			tx<=1;
			if(count<=432) begin
				count<=count+1;
				state<=2'd3;
				end
			else state<=2'd0;
		end
		default: state<=0;
	endcase
			

end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule