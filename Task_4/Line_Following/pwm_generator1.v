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
    input [3:0] duty_cycle,
    output reg clk_95Hz, pwm_signal
);

initial begin
    clk_95Hz = 0; pwm_signal = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [13:0] counter=0;

always @(posedge clk_3125KHz) begin
if (!counter) clk_95Hz = ~clk_95Hz;
counter=counter+ 1'b1;
end

reg [3:0] counter_pwm=0;
always @(posedge clk_95Hz) begin
if(counter_pwm < duty_cycle) pwm_signal<=1'b1;
else pwm_signal<=1'b0;
counter_pwm = counter_pwm + 1'b1;
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule 