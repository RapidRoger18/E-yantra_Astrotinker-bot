module message_unit
( 
//input clk_50M;
input led_1; // for eu
input led_2; // for cu
input led_3; // for ru
input node_flag ;
input EM_active;  // when em is on
input EM_drop;   // when em is switched off with a load
input fault_detect; // when a fault is detected by U.S.
input EU_active; // in EU section
input CU_active; // in CU section
input RU_active; // in RU section
output msg_FIM; 
output msg_FSM;
output msg_BDM;
output msg_BPM;

);

reg [7:0] text_FIM-[3:0]; // FIM-  
reg [7:0] text_BDM-[3:0]; // BDM-
reg [7:0] text_BPM-[3:0]; // BPM- 
reg [7:0] text_SU-B[3:0]; // SU-B

reg [7:0] text_CSU[2:0];  // CSU 
reg [7:0] text_ESU[2:0];  //ESU
reg [7:0] text_RSU[2:0];  //RSU

reg [7:0] text_1-#[2:0];  // 1-#
reg [7:0] text_2-#[2:0];  // 2-#
reg [7:0] text_3-#[2:0];  //3-#
reg [7:0] text_4-#[2:0];  //4-#

reg [7:0] text_1-B[2:0];  // 1-B
reg [7:0] text_2-B[2:0];  // 2-B
reg [7:0] text_3-B[2:0];  //3-B
reg [7:0] text_4-B[2:0];  //4-B

reg EU_flag =0;  
reg CU_flag =0;
reg RU_flag =0;

reg [3:0] index_fim =0;  
reg [3:0] index_bdm =0;
reg [3:0] index_bpm =0;
reg [3:0] index_csu =0;
reg [3:0] index_esu =0;
reg [3:0] index_rsu =0;
reg [3:0] index_1 =0;
reg [3:0] index_su =0;
reg [3:0] index_2 =0;
reg [3:0] index_3 =0;
reg [3:0] index_4 =0;
reg [3:0] index_1b =0;
reg [3:0] index_2b =0;
reg [3:0] index_3b =0;
reg [3:0] index_4b =0;

reg [15:0] msg_delay =0;



reg current_state [1:0];

initial begin 

text_FIM-[0] <=  8'h46;          
text_FIM-[1] <=  8'h49;          
text_FIM-[3] <=  8'h4D;          
text_FIM-[4] <=  8'h2D;          

text_BDM-[0] <= 8'h42;
text_BDM-[1] <= 8'h44;
text_BDM-[2] <= 8'h4D;
text_BDM-[3] <= 8'h2D;

text_BPM-[0] <= 8'h42;
text_BPM-[1] <= 8'h50;
text_BPM-[2] <= 8'h4D;
text_BPM-[3] <= 8'h2D;

text_CSU[0] <= 8'h43;
text_CSU[1] <= 8'h53;
text_CSU[2] <= 8'h55;

text_ESU[0] <= 8'h45;
text_ESU[1] <= 8'h53;
text_ESU[2] <= 8'h55;

text_SU-B[0] <= 8'h53;
text_SU-B[1] <= 8'h55;
text_SU-B[2] <= 8'h2D;
text_SU-B[3] <= 8'h42;

text_RSU[0] <= 8'h52;
text_RSU[1] <= 8'h53;
text_RSU[2] <= 8'h55;

text_1-#[0] <= 8'h31;
text_1-#[1] <= 8'h2D;
text_1-#[2] <= 8'h23;

text_2-#[0] <= 8'h32;
text_2-#[1] <= 8'h2D;
text_2-#[2] <= 8'h23;

text_3-#[0] <= 8'h33;
text_3-#[1] <= 8'h2D;
text_3-#[2] <= 8'h23;


text_4-#[0] <= 8'h34;
text_4-#[1] <= 8'h2D;
text_4-#[2] <= 8'h23;

text_1-B[0] <= 8'h31;
text_1-B[0] <= 8'h2D;
text_1-B[0] <= 8'h42;

text_2-B[0] <= 8'h32;
text_2-B[0] <= 8'h2D;
text_2-B[0] <= 8'h42;

text_3-B[0] <= 8'h33;
text_3-B[0] <= 8'h2D;
text_3-B[0] <= 8'h42;

text_4-B[0] <= 8'h34;
text_4-B[0] <= 8'h2D;
text_4-B[0] <= 8'h42;



end


  parameter IDLE_STATE = 2'b00;
  parameter EU_ACTIVE_STATE = 2'b01;
  parameter CU_ACTIVE_STATE = 2'b10;
  parameter RU_ACTIVE_STATE = 2'b11;
  
  
 always @( posedge EU_active or CU_active or RU_active ) begin 

 if ( EU_active && led_1) begin
 current_state <= EU_ACTIVE_STATE;
 end
 else if ( CU_active && led_2) begin 
 current_state <= CU_ACTIVE_STATE;
 end
 else if ( RU_active && led_3) begin 
 current_state <= RU_ACTIVE_STATE;
 end 
 
 else begin 
 current_state <= IDLE_STATE;
 end
 
 
 case (current_state) 
 
 EU_ACTIVE_STATE: begin 

  if ( fault_detect) begin   // to send FIM message 
  msg_FIM <= text_FIM-[index_fim];
  msg_FIM <= text_ESU[index_esu];
  end 
  if ( node_flag) begin   // to decide nth ESU
  msg_FIM <= text_1-#[index_1];
  end
   if (msg_delay == 4339) begin
  index_fim <= index_fim +1;    // delay of 10us
  index_esu <= index_esu +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_fim >= 4 && index_esu >= 4 && index_1 >= 4) begin
					
						index_fim<=0;
						index_esu <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 else if ( EM_active) begin   // to send BPM message
 msg_BPM <= text_BPM-[index_bpm];
 msg_BPM <= text_SU-B[index_su];   
 end
 if(node_flag) begin                   // tbd the logic to msg the nth Block picked 
 msg_BPM <= text_1-#[index_1];
 end
 
  if (msg_delay == 4339) begin           // 10us delay
  index_bpm <= index_bpm +1;
  index_su <= index_su +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_bpm >= 4 && index_su >= 4 && index_1 >= 4) begin
					
						index_bpm<=0;
						index_su <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 else if ( EM_DROP) begin           // to send BDM message 
 msg_BDM <= text_BDM-[index_bdm];
 msg_BDM <= text_ESU[index_esu];
 end
 if ( node_flag)                        // tbd the logic to msg the nth Block picked &  nth SU
 msg_BDM <= text_1-B[index_1b];
 msg_BDM <= text_1-#[index_1];
 end 
 if ( msg_delay == 4339) begin
 index_bdm <= index_bdm+1;
 index_esu <= index_esu+1;
 index_1b <= index_1b+1;
 index_1 <= index_1+1;
 end
 
  		if (index_bdm >= 4 && index_esu >= 4 && index_1 >= 4 && index_1b >= 4) begin
					
						index_bdm<=0;
						index_esu <=0;
						index_1 <=0;
						index_1b <= 0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 
 CU_ACTIVE_STATE : begin 
 
  
   if ( fault_detect) begin 
  msg_FIM <= text_FIM-[index_fim];
  msg_FIM <= text_CSU[index_esu];
  end 
  if ( node_flag) begin 
  msg_FIM <= text_1-#[index_1];
  end
   if (msg_delay == 4339) begin
  index_fim <= index_fim +1;
  index_esu <= index_esu +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_fim >= 4 && index_esu >= 4 && index_1 >= 4) begin
					
						index_fim<=0;
						index_esu <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 else if ( EM_active) begin 
 msg_BPM <= text_BPM-[index_bpm];
 msg_BPM <= text_SU-B[index_su];   // tbd the logic to msg the nth Block picked 
 if(node_flag) begin 
 msg_BPM <= text_1-#[index_1];
 end
 
  if (msg_delay == 4339) begin
  index_bpm <= index_bpm +1;
  index_su <= index_su +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_bpm >= 4 && index_su >= 4 && index_1 >= 4) begin
					
						index_bpm<=0;
						index_su <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
  else if ( EM_DROP) begin           // to send BDM message 
 msg_BDM <= text_BDM-[index_bdm];
 msg_BDM <= text_CSU[index_csu];
 end
 if ( node_flag)                        // tbd the logic to msg the nth Block picked &  nth SU
 msg_BDM <= text_1-B[index_1b];
 msg_BDM <= text_1-#[index_1];
 end 
 if ( msg_delay == 4339) begin
 index_bdm <= index_bdm+1;
 index_csu <= index_csu+1;
 index_1b <= index_1b+1;
 index_1 <= index_1+1;
 end
 
  		if (index_bdm >= 4 && index_csu >= 4 && index_1 >= 4 && index_1b >= 4) begin
					
						index_bdm<=0;
						index_csu <=0;
						index_1 <=0;
						index_1b <= 0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 
 
 
 RU_ACTIVE_STATE : begin 
 
 
  
   if ( fault_detect) begin 
  msg_FIM <= text_FIM-[index_fim];
  msg_FIM <= text_RSU[index_esu];
  end 
  if ( node_flag) begin 
  msg_FIM <= text_1-#[index_1];
  end
   if (msg_delay == 4339) begin
  index_fim <= index_fim +1;
  index_esu <= index_esu +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_fim >= 4 && index_esu >= 4 && index_1 >= 4) begin
					
						index_fim<=0;
						index_esu <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 else if ( EM_active) begin 
 msg_BPM <= text_BPM-[index_bpm];
 msg_BPM <= text_SU-B[index_su];   // tbd the logic to msg the nth Block picked 
 if(node_flag) begin 
 msg_BPM <= text_1-#[index_1];
 end
 
  if (msg_delay == 4339) begin
  index_bpm <= index_bpm +1;
  index_su <= index_su +1;
  index_1 <= index_1 + 1;
  end 
  
  		if (index_bpm >= 4 && index_csu >= 4 && index_1 >= 4) begin
					
						index_bpm<=0;
						index_su <=0;
						index_1 <=0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
  else if ( EM_DROP) begin           // to send BDM message 
 msg_BDM <= text_BDM-[index_bdm];
 msg_BDM <= text_RSU[index_rsu];
 end
 if ( node_flag)                        // tbd the logic to msg the nth Block picked &  nth SU
 msg_BDM <= text_1-B[index_1b];
 msg_BDM <= text_1-#[index_1];
 end 
 if ( msg_delay == 4339) begin
 index_bdm <= index_bdm+1;
 index_rsu <= index_rsu+1;
 index_1b <= index_1b+1;
 index_1 <= index_1+1;
 end
 
  		if (index_bdm >= 4 && index_rsu >= 4 && index_1 >= 4 && index_1b >= 4) begin
					
						index_bdm<=0;
						index_rsu <=0;
						index_1 <=0;
						index_1b <= 0;
						node_flag <= 0;
					end
				end
				else begin
					msg_delay <= msg_delay + 1;
					
				end
		end
 end
 
 
 endcase 
 endmodule 
 


