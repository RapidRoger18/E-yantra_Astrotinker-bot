`timescale 1 ns/1 ns 
module tb_clock;
reg clk = 0;
reg [4:0] realtime_pos;
reg EU_fault_flag;
reg pick_block_B1;
Dijkstra_test uut(.clk_50M(clk),.realtime_pos(realtime_pos),.EU_fault_flag(EU_fault_flag),.pick_block_B1(pick_block_B1));
always begin
    clk <= 1; # 5; clk <= 0; # 5;
end
initial begin
	#100;
	realtime_pos <= 0;
	EU_fault_flag <= 1; #10; EU_fault_flag <= 0;
	#6000000;realtime_pos <= 5'd29;
	#6000000;realtime_pos <= 5'd27;
	#6000000;realtime_pos <= 5'd24;
	pick_block_B1 <= 1;
	#6000000;realtime_pos <= 5'd22;
	#6000000;realtime_pos <= 5'd21;
	#6000000;realtime_pos <= 5'd23;
	pick_block_B1 <= 0;
	#6000000;realtime_pos <= 5'd29;
	#6000000;realtime_pos <= 5'd27;
	#6000000;realtime_pos <= 5'd24;
	#6000000;realtime_pos <= 5'd0;

end
endmodule 