// Code your testbench here
// or browse Examples
module tb_msg;
reg clk_50M;
//reg led_1; // for eu
//reg led_2; // for cu
//reg led_3; // for ru
//reg node_flag;
reg esu_block_id;
reg csu_block_id;
reg rsu_block_id;
reg EM_active;  // when em is on
reg EM_drop;   // when em is switched off with a load
reg fault_detect; // when a fault is detected by U.S.
reg EU_active; // in EU section
reg CU_active; // in CU section
reg RU_active; // in RU section
wire [7:0] msg;
wire [1:0] blue_light;
wire [1:0] green_light;
  
  message_unit msg1 ( .EM_active(EM_active),
                .EM_drop(EM_drop),.fault_detect(fault_detect),.EU_active(EU_active),.CU_active(CU_active),
                .RU_active(RU_active),.msg(msg),.clk_50M(clk_50M) , .blue_light(blue_light) , .green_light(green_light) , .esu_block_id(esu_block_id) ,
					.rsu_block_id(rsu_block_id) );

initial clk_50M = 0;
always #10 clk_50M = ~clk_50M;

initial begin
	// led_1=1;
    //led_2=0;
    //led_3=0;
    //node_flag=0;
	 esu_block_id = 1;
	 csu_block_id = 0;
	 rsu_block_id = 0;
    EM_active=0;
    EM_drop=0;
    fault_detect=1;
    EU_active=1;
    CU_active=0;
    RU_active=0;
	 $stop;
//	 #50;
//	 //node_flag=1;
//	 led_1 = 0;
//	 led_2=1;
//	 led_3 =0;
//	 esu_block_id =0;
//	 csu_block_id =2;
//	 rsu_block_id =0;
//    EM_active=1;
//    EM_drop=0;
//    fault_detect=0;
//    EU_active=0;
//    CU_active=1;
//    RU_active=0;
//	 #50;
//	// node_flag=1;
//	 led_1=0;
//    led_2=0;
//    led_3=1;
//	  esu_block_id =0;
//	 csu_block_id =0;
//	 rsu_block_id =1;
//    EM_active=0;
//    EM_drop=0;
//    fault_detect=1;
//    EU_active=0;
//    CU_active=1;
//    RU_active=1;
//	 #50;
//	 // node_flag=0;
//	  led_1=1;
//    led_2=0;
//    led_3=0;
//	  esu_block_id =3;
//	 csu_block_id =0;
//	 rsu_block_id =0;
//    EM_active=1;
//    EM_drop=0;
//    fault_detect=0;
//    EU_active=1;
//    CU_active=0;
//    RU_active=0;
//	 #50;
//	 $stop;
	 
end

endmodule