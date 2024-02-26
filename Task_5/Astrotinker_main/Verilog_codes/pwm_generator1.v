// AstroTinker Bot : Task 1A : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 3.125MHz Clock Frequency to 195.125KHz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : clk_3125KHz, duty_cycle
//Output : clk_195KHz, pwm_signal


module pwm_generator(
    input clk_3125KHz,
    input [4:0] duty_cycle,
	 input motor_a, motor_b,
	 output motor_A, motor_B,
    output reg clk_95Hz
);
reg pwm_signal;
initial begin
    clk_95Hz = 0; pwm_signal = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [8:0] counter=0;

always @(posedge clk_3125KHz) begin												//this is pwm clock of about 3 KHz
	if (!counter) clk_95Hz = ~clk_95Hz;											
	counter=counter+ 1'b1;
end

reg [4:0] counter_pwm=0;
always @(posedge clk_95Hz) begin												//generating PWM based on Duty cycles
	if(counter_pwm < duty_cycle) pwm_signal<=1'b1;
	else pwm_signal<=1'b0;
	counter_pwm = counter_pwm + 1'b1;
end

assign motor_A = (motor_a) ? pwm_signal : 0; 										// assigning PWM to motors
assign motor_B = (motor_b) ? pwm_signal : 0;

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule 