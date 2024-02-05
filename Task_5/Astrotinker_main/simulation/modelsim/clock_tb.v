`timescale 1 ns/1 ns 
module tb_clock;
reg clk;
Astrotinker_main uut(.clk_50M(clk));
always begin
    clk <= 1; # 5; clk <= 0; # 5;
end
endmodule 