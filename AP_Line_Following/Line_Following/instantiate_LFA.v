module instantiate_LFA (
input clk_50M ,
output adc_cs_n,
output din,
input dout ,
output A1,B1,A2,B2,
output clk_3125KHz,
output led1_R1,led1_G1,led1_B1,led2_R2,led2_G2,led2_B2,led3_R3,led3_G3,led3_B3
);

wire pwm_gen1_dc;
wire clk_195KHz1;
wire pwm_gen2_dc;
wire clk_195KHz2;
wire [11:0]adc_left_lsa;
wire [11:0]adc_right_lsa;
wire [11:0]adc_centre_lsa;
wire [3:0] pwm_signal_op1;
wire [3:0] pwm_signal_op2;
wire d1a1,d1b1 , d2a2,d2b2;
 
 frequency_scaling uut (
 .clk_50M(clk_50M),
 .clk_3125KHz(clk_3125KHz)
 );
 
 pwm_generator1 dut (
 .clk_3125KHz(clk_3125KHz),
 .duty_cycle(pwm_gen1_dc),
 .clk_195KHz(clk_195KHz1),
 .pwm_signal(pwm_signal_op1)
 );
 
 pwm_generator2 vut (
 .clk_3125KHz(freq_scaling_pwm),
 .duty_cycle(pwm_gen2_dc),
 .clk_195KHz(clk_195KHz2) ,
 .pwm_signal(pwm_signal_op2)
 );
 
 ADC_Controller mut (
 .adc_sck(clk_3125KHz),
 .dout(dout),
 .left_value(adc_left_lsa),
 .right_value(adc_right_lsa),
 .center_value(adc_centre_lsa),
 .adc_cs_n(adc_cs_n),
 .din(din)
 );
 
 demux_1 nut (
 .pwm_195(pwm_signal_op1),
 .m1a1(d1a1),
 .m1b1(d1b1),
 .A1(A1),
 .B1(B1)
 );
 
  demux_2 kut (
 .pwm_195(pwm_signal_op2),
 .m2a2(d2a2),
 .m2b2(d2b2),
 .A2(A2),
 .B2(B2)
 );

 
 Line_Following aut (   
 .left(adc_left_lsa),
 .middle(adc_centre_lsa),
 .right(adc_right_lsa),
 .m1_a(d1a1),
 .m1_b(d1b1),
 .m2_a(d2a2),
 .m2_b(d2b2),
 .dc1(pwm_gen1_dc),
 .dc2(pwm_gen2_dc),
 .led1_R1(led1_R1),
 .led1_G1(led1_G1),
 .led1_B1(led1_B1),
 .led2_R2(led2_R2),
 .led2_G2(led2_G2),
 .led2_B2(led2_B2),
 .led3_R3(led3_R3),
 .led3_G3(led3_G3),
 .led3_B3(led3_B3)
);
 
 endmodule
 