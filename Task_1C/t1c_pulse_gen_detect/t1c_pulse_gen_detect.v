// AstroTinker Bot : Task 1C : Pulse Generator and Detector
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to design a module which will generate a 10us pulse and detect incoming pulse signal.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

// t1c_pulse_gen_detect
//Inputs : clk_50M, reset, echo_rx
//Output : trigger, distance, pulses, state

// module declaration
module t1c_pulse_gen_detect (
    input clk_50M, reset, echo_rx,
    output reg trigger, out,
    output reg [21:0] pulses,
    output reg [1:0] state
);

initial begin
    trigger = 0; out = 0; pulses = 0; state = 0;
end


//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [7:0] warmup_counter=8'd50; //50
reg [21:0]width_counter;
reg [8:0] trigger_counter=9'd501;
reg [15:0] loop_counter=16'd49998;



always@(posedge clk_50M) begin

if (reset==1) begin
	//trigger<=1;
	out=0;
	pulses<=0;
	width_counter <= 1	;
	state<=2'b00;
	warmup_counter=9'd50;
	trigger_counter=9'd501;
	
	loop_counter<=16'd49998;
end 
else begin
if (warmup_counter == 0) warmup_counter=9'd50	;
if (trigger_counter == 0) trigger_counter=9'd501; 																		//500 counter or 10 us loop/delay
if (loop_counter == 0) loop_counter<=16'd49998; 																		//50000 counter or 1 ms loop/delay


case(state)
	2'b0: begin
		warmup_counter=warmup_counter - 1'b1;																				//warm up
		if (warmup_counter == 0) begin 
				state<= 2'b01;
			end
			
	end 
	2'b01: begin																													//trigger
		trigger<=1;
		trigger_counter = trigger_counter - 1'b1;
		if(trigger_counter == 0) begin
			trigger<=0;
			state<= 2'b10;
	   end
	end
	2'b10:begin																														//read pulse
		if ( loop_counter == 0 ) begin
			state<=2'b11;
		end
		else begin
			if(echo_rx==1) begin
				pulses<=pulses+1;
				width_counter<=width_counter+1'b1;
			end
			loop_counter<=loop_counter-1'b1;
		end	
	end
	2'b11:begin																														//final output
		if (width_counter >= 32'd29409) out=1; 																					//That binary is pulse width or the given time 588200 ns
		state<=2'b0;
	end
endcase
end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule