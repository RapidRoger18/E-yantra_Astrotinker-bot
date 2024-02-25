//module message_unit( 
//input clk_50M,
//input fault_detect, 											// when a fault is detected by U.S.
////input [1:0] fault_id,
//input block_picked,
//input end_run_interrupt,
//input [1:0] block_location,
//input EU_fault_flag, 												// in EU section
//input CU_fault_flag, 												// in CU section
//input RU_fault_flag, 												// in RU section
//output reg  [7:0] msg = 0,
//output reg data_send = 0
//
//);
//parameter B = 8'h42;
//parameter C = 8'h43;
//parameter D = 8'h44;
//parameter E = 8'h45;
//parameter F = 8'h46;
//parameter I = 8'h49;
//parameter M = 8'h4D;
//parameter N = 8'h4E;
//parameter P = 8'h50;
//parameter R = 8'h52;
//parameter S = 8'h53;
//parameter U = 8'h55;
//parameter N1 = 8'h31;
//parameter N2 = 8'h32;
//parameter N3 = 8'h33;
//parameter N4 = 8'h34;
//parameter DASH = 8'h2D;
//parameter HASH = 8'h23;
//
//parameter IDLE_state = 2'b00;
//parameter FAULT_state = 2'b01;
//parameter PICKUP_state = 2'b10;
//parameter DEPOSIT_state = 2'b11;
//
//reg [15:0] msg_delay =0;
//reg [7:0] msg_container [12:0];
//reg [1:0] STATE = 2'd0;
//reg [3:0] idx = 0; 
//reg msg_sent = 0;
////reg msg_stop_flag =0;
//reg[1:0] send_msg =0;
//reg [8:0] count =0;
//reg [1:0] fault_id = 2'd2;
//
//
//always@( posedge clk_50M ) begin
//
//if (count == 4339)begin
//count <= 0;
//send_msg <=1;
//end 
//
//else begin 
//send_msg<=0;
//count <= count+1;
//end 
//	if ( send_msg ==1)begin 
//	if ( end_run_interrupt ) begin
//		msg_container[0] <= E;
//		msg_container[1] <= N;
//		msg_container[2] <= D;
//		msg_container[3] <= DASH;
//		msg_container[4] <= HASH;
//		
//	end
//	else if ( fault_detect && !block_picked ) STATE <= FAULT_state;
//	else if ( block_picked && !fault_detect ) STATE <= PICKUP_state;
//	else if ( block_picked && fault_detect ) STATE <= DEPOSIT_state;
//	if ( msg_sent ) STATE <= IDLE_state;
//	
//
//	case (STATE)
//			IDLE_state: begin
//				msg_container[0] <= 8'h0;
//				msg_container[1] <= 8'h0;
//				msg_container[2] <= 8'h0;
//				msg_container[3] <= 8'h0;
//				msg_container[4] <= 8'h0;
//				msg_container[5] <= 8'h0;
//				msg_container[6] <= 8'h0;
//				msg_container[7] <= 8'h0;
//				msg_container[8] <= 8'h0;
//				msg_container[9] <= 8'h0;
//				msg_container[10] <= 8'h0;
//				msg_container[11] <= 8'h0;
//				msg_container[12] <= 8'h0;
//				msg_sent <= 0;
//			end
//			FAULT_state: begin
//				msg_container[0] <= F;
//				msg_container[1] <= I;
//				msg_container[2] <= M;
//				msg_container[3] <= DASH;
//				if (EU_fault_flag) msg_container[4] <= E;
//				else if (CU_fault_flag) msg_container[4] <= C;
//				else if (RU_fault_flag) msg_container[4] <= R;
//				msg_container[5] <= S;
//				msg_container[6] <= U;
//				if (fault_id == 2'd0) msg_container[7] <= N1; 
//				else if (fault_id == 2'd1) msg_container[7] <= N2;
//				else if (fault_id == 2'd2) msg_container[7] <= N3;
//				else if (fault_id == 2'd3) msg_container[7] <= N4;
//				msg_container[8] <= DASH;
//				msg_container[9] <= HASH;
//			  // msg_stop_flag <= 1;
//			end
//			PICKUP_state: begin
//				msg_container[0] <= B;
//				msg_container[1] <= P;
//				msg_container[2] <= M;
//				msg_container[3] <= DASH;
//				msg_container[4] <= S;
//				msg_container[5] <= U;
//				msg_container[6] <= DASH;
//				msg_container[7] <= B;
//				if (block_location == 0) msg_container[8] <= N1;
//				else if (block_location == 2'd1) msg_container[8] <= N2;
//				else if (block_location == 2'd2) msg_container[8] <= N3;
//				else if (block_location == 2'd3) msg_container[8] <= N4;
//				msg_container[9] <= DASH;
//				msg_container[10] <= HASH;
//			end
//			DEPOSIT_state: begin
//				msg_container[0] <= B;
//				msg_container[1] <= D;
//				msg_container[2] <= M;
//				msg_container[3] <= DASH;
//				if (EU_fault_flag) msg_container[4] <= E;
//				else if (CU_fault_flag) msg_container[4] <= C;
//				else if (RU_fault_flag) msg_container[4] <= R;
//				msg_container[5] <= S;
//				msg_container[6] <= U;
//				if (fault_id == 2'd0) msg_container[7] <= N1; 
//				else if (fault_id == 2'd1) msg_container[7] <= N2;
//				else if (fault_id == 2'd2) msg_container[7] <= N3;
//				else if (fault_id == 2'd3) msg_container[7] <= N4;
//				msg_container[8] <= DASH;
//				msg_container[9] <= B;
//				if (block_location == 0) msg_container[10] <= N1;
//				else if (block_location == 2'd1) msg_container[10] <= N2;
//				else if (block_location == 2'd2) msg_container[10] <= N3;
//				else if (block_location == 2'd3) msg_container[10] <= N4;
//				msg_container[11] <= DASH;
//				msg_container[12] <= HASH;
//			end
//		endcase
//	
//	if (msg_container[idx] != 8'h0 && !msg_sent) begin
//		if (msg_delay == 4339) begin
//			msg <= msg_container[idx];
//			data_send <= 1;
//			if(msg_container[idx] == HASH) begin
//				msg_sent <= 1;
//				idx <= 0;
//			end
//			else idx <= idx + 1;
//			msg_delay <= 0;
//		end
//		else begin 
//			msg_delay <= msg_delay + 1;
//		end
//	end 
//end 
//end
//endmodule  





// Code your design here
module message_unit
( 
input clk_50M,
//input led_1, // for eu
//input led_2, // for cu
//input led_3, // for ru
//input node_flag,
//input [4:0] node,
input stop_flag,
input [7:0] esu_block_id,
input [7:0] csu_block_id,
input [7:0] rsu_block_id,
input EM_active,  // when em is on
input EM_drop,   // when em is switched off with a load
input fault_detect, // when a fault is detected by U.S.
input EU_active, // in EU section
input CU_active, // in CU section
input RU_active, // in RU section
//output reg [7:0] msg_FIM, 
//output  reg [7:0] msg_FSM,
//output reg [7:0] msg_BDM,
output reg  [7:0] msg,
output reg data_send =0
//output reg [1:0] blue_light,
//output reg [1:0] green_light

);
reg [7:0] text_FIM[3:0]; // FIM-  
reg [7:0] text_BDM[3:0]; // BDM-
reg [7:0] text_BPM[3:0]; // BPM- 
reg [7:0] text_SUB[3:0]; // SU-B

reg [7:0] text_CSU[2:0];  // CSU 
reg [7:0] text_ESU[2:0];  //ESU
reg [7:0] text_RSU[2:0];  //RSU

reg [7:0] text_hash[2:0];  // 1-#


reg [7:0] text_1b[2:0];  // 1-B
reg [7:0] text_2b[2:0];  // 2-B
reg [7:0] text_3b[2:0];  //3-B
reg [7:0] text_4b[2:0];  //4-B

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

reg [31:0] msg_delay =0;

reg [2:0] increment_su1 =1;
reg [2:0] increment_su2 =1;
reg [2:0] increment_su3 =1;



reg [1:0]current_state ;
reg [1:0] state;

initial begin 
state <= 0;
text_FIM[0] <=  8'h46; // FIM-          
text_FIM[1] <=  8'h49;          
text_FIM[2] <=  8'h4D;          
text_FIM[3] <=  8'h2D;          

text_BDM[0] <= 8'h42;  //BDM-
text_BDM[1] <= 8'h44;
text_BDM[2] <= 8'h4D;
text_BDM[3] <= 8'h2D;

text_BPM[0] <= 8'h42;  //BPM
text_BPM[1] <= 8'h50;
text_BPM[2] <= 8'h4D;
text_BPM[3] <= 8'h2D;

text_CSU[0] <= 8'h43;
text_CSU[1] <= 8'h53;
text_CSU[2] <= 8'h55;
//blue_light <=0;
//green_light <=0;

text_ESU[0] <= 8'h45;
text_ESU[1] <= 8'h53;
text_ESU[2] <= 8'h55;

text_SUB[0] <= 8'h53; // SU-B
text_SUB[1] <= 8'h55;
text_SUB[2] <= 8'h2D;
text_SUB[3] <= 8'h42;

text_RSU[0] <= 8'h52;
text_RSU[1] <= 8'h53;
text_RSU[2] <= 8'h55;

text_hash[0] <= 8'h2D;  ///-#
text_hash[1] <= 8'h23;


end


  parameter IDLE_STATE = 2'b00;
  parameter EU_ACTIVE_STATE = 2'b01;
  parameter CU_ACTIVE_STATE = 2'b10;
  parameter RU_ACTIVE_STATE = 2'b11;
  
  
 always @(posedge clk_50M) begin 

 if ( EU_active  ) begin
 current_state <= EU_ACTIVE_STATE;
 end
 else if ( CU_active ) begin 
 current_state <= CU_ACTIVE_STATE;
 end
 else if ( RU_active ) begin 
 current_state <= RU_ACTIVE_STATE;
 end 
 
 else begin 
 current_state <= IDLE_STATE;
 end
 
 
 case(current_state)
 
 EU_ACTIVE_STATE: begin 

  if ( fault_detect) begin   // to send FIM message 
//   msg <= {text_FIM[index_fim],text_ESU[index_esu],node};	
	//blue_light <= 1;
	case(state) 

		2'b00: begin 

			  data_send <= 1;
					 if (msg_delay == 4339) begin
						
						msg <= text_FIM[index_fim];
						index_fim <= index_fim +1;    // delay of 10us
						//msg_delay <= 0;
							
							if (index_fim == 4) begin
							
								index_fim<=0;
								state<=2'b01;
								
							//	node_flag <= 0;
							end
							else msg_delay <= 0;
					  end 
					  
					  else begin
							msg_delay <= msg_delay + 1;
							state<=2'b0;
							
					  end
						
			end 
			
			2'b01: begin 
						
			 
				 
		  
					  if (msg_delay == 93750000) begin           // 10us delay
						 msg <= text_ESU[index_esu];
						 index_esu <= index_esu +1;
						 //msg_delay<=0;
						 
					       if  (index_esu == 3) begin
							
								index_esu <=0;
								state<=2'b10;
								//node_flag <= 0;
							end
							else msg_delay <= 0;
					  end
					  
						else begin
							msg_delay <= msg_delay + 1;
							state<=2'b01;
							
						end
					
		 end 
		 2'b10: begin
		 
			 
		 
					  if ( msg_delay == 4339) begin
						 msg <=  { increment_su1, text_hash[index_1]};
						  index_1 <= index_1+1;
						  msg_delay <= 0;
						  increment_su1 <= increment_su1 +1;
					  
		 
							if (index_1 == 2 ) begin
							
							
								index_1 <=0;
								state<=2'b11;
								data_send <=0;
							
								//node_flag <= 0;
							end
							//else msg_delay <= 0;

					  end	

						else begin
							msg_delay <= msg_delay + 1;
							state <= 2'b10;
						end
						
				end
				
		2'b11: begin
		
			
			state <= 2'b00;
		end 

				endcase 
		
		end 
		
else if ( EM_active ) begin 
	
	case(state) 

	2'b00: begin 

		
		
			if (msg_delay == 4339) begin
				msg <= text_BPM[index_bpm];
				index_bpm <= index_bpm +1;    // delay of 10us
				//msg_delay<=0;
			
	
					if (index_bpm == 4) begin
						
							index_bpm<=0;
							state<=2'b01;
						//	node_flag <= 0;
						end
					else msg_delay <= 0;
			end		
					else begin
						msg_delay <= msg_delay + 1;
						state <= 2'b00;
					end
					
		end 
		
		2'b01: begin 
					
		
		
	
			if (msg_delay == 4339) begin           // 10us delay
				msg <= text_SUB[index_su];
				index_su <= index_su +1;
				//msg_delay<=0;
			
	
					if  (index_su == 4) begin
						
						
							index_su <=0;
							state<=2'b10;
							//node_flag <= 0;
						end
					else msg_delay <= 0;

			end		
					else begin
						msg_delay <= msg_delay + 1;
						state <= 2'b01;
					end
					
		end 

	2'b10: begin
		
		
	
			if ( msg_delay == 4339) begin
				msg <= {esu_block_id, text_hash[index_1]} ;
				index_1 <= index_1+1;
				msg_delay<=0;
				
			
	
					if (index_1 == 2 ) begin
						

							index_1 <=0;
							state<=2'b11;
							//node_flag <= 0;
						end
					//else msg_delay <= 0;
			end		
					else begin
						msg_delay <= msg_delay + 1;
						state<=2'b10;
					end
			end
			
	2'b11: state<=2'b00;

	endcase 

end 
		
else if ( EM_drop ) begin 
	//blue_light <=0;
	//green_light <=1;
case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
			msg <= text_BDM[index_bdm];
            index_bdm <= index_bdm +1;    // delay of 10us
			//msg_delay <= 0;
           
  
  		         if (index_bdm == 4) begin
					
						index_bdm<=0;
						state <= 2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;

		  end

				else begin
					msg_delay <= msg_delay + 1;
					state <= 2'b00;
				end
				
	end 
	
	2'b01: begin 
				
           if (msg_delay == 4339) begin           // 10us delay
            msg <= text_ESU[index_su];
             index_su <= index_su +1;
			msg_delay<=0;
           
  
  		        if  (index_su == 3) begin
					
					
						index_su <=0;
						state<=2'b10;
						//node_flag <= 0;
					end
				//else msg_delay<=0;

		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b01;
				end
				
 end 

 2'b10: state<=2'b00;
 
endcase 
end 

end

 CU_ACTIVE_STATE : begin 
 
 
  if ( fault_detect) begin   // to send FIM message 
//   msg <= {text_FIM[index_fim],text_ESU[index_esu],node};	
	//blue_light <= 1;
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
			msg <= text_FIM[index_fim];
            index_fim <= index_fim +1;    // delay of 10us
			//msg_delay<=0;
          
  
  		         if (index_fim == 4) begin
					
						index_fim<=0;
						state<=2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;
		  end 

				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b00;
				end
				
	end 
	
	2'b01: begin 
				
  
           if (msg_delay == 4339) begin           // 10us delay
	 		 msg <= text_CSU[index_csu];
             index_csu <= index_csu +1;
			// msg_delay <= 0;
           
  
  		        if  (index_csu >= 4) begin
					
					
						index_csu <=0;
					    state<=2'b10;
						//node_flag <= 0;
					end
				else msg_delay <= 0;
		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b01;
				end
				
 end 
 2'b10: begin
 
           if ( msg_delay == 4339) begin
              msg <= text_hash[index_1];
              index_1 <= index_1+1;
			  msg_delay<=0;
			  increment_su2 <= increment_su2 +1;
           
 
  		         if (index_1 == 2 ) begin
					
					
						index_1 <=0;
						state <= 2'b11;
						//node_flag <= 0;
					end
		   end

				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b10;
				end
		end

 2'b11: state<=2'b00;

		endcase 
		
		end 
		
else if ( EM_active ) begin 
	
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
			msg <= text_BPM[index_bpm];
            index_bpm <= index_bpm +1;    // delay of 10us
			//msg_delay <= 0;

          
  
  		         if (index_bpm == 4) begin
					
						index_bpm<=0;
						state <= 2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;
		  end 	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b00;
				end
				
	end 
	
	2'b01: begin 
				
     
       
  
           if (msg_delay == 4339) begin           // 10us delay
             msg <= text_SUB[index_su];
             index_su <= index_su +1;
			// msg_delay <= 0;
           
  
  		        if  (index_su >= 4) begin
					
					
						index_su <=0;
						state<=2'b10;
						//node_flag <= 0;
					end
				else msg_delay<= 0;
		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b01;
				end
				
 end 
 2'b10: begin
    
    
 
           if ( msg_delay == 4339) begin
             msg <= {csu_block_id, text_hash[index_1]} ;
              index_1 <= index_1+1;
			  msg_delay <= 0;
           
 
  		         if (index_1 == 2 ) begin
					
					
						index_1 <=0;
						state<= 2'b11;
						//node_flag <= 0;
					end
		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b10;
				end
		end

	2'b11: state<=2'b00;

		endcase 
		end 
		
else if ( EM_drop ) begin 
	//blue_light <= 0;
	//green_light <= 1;
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
            index_bdm <= index_bdm +1;    // delay of 10us
			msg <= text_BDM[index_bdm];
			//msg_delay<=0;
  
  		         if (index_bdm == 4) begin
					
						index_bdm<=0;
						state<=2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;
		  end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b01;
				end
				
	end 
	
	2'b01: begin 
				
     
       
  
           if (msg_delay == 4339) begin           // 10us delay
            msg <= text_CSU[index_csu];
             index_csu <= index_csu +1;
	   		msg_delay<= 0 ;
           
  
  		        if  (index_csu == 3) begin
					
					
						index_csu <=0;
						state<= 2'b10;
						//node_flag <= 0;
					end
		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b01;
				end
 end 

	2'b10: state <= 2'b00;

endcase 
end 
end 

 RU_ACTIVE_STATE : begin 
 
  
  if ( fault_detect) begin   // to send FIM message 
//   msg <= {text_FIM[index_fim],text_ESU[index_esu],node};	
	//blue_light <= 1;
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
			msg <= text_FIM[index_fim];
            index_fim <= index_fim +1;    // delay of 10us
			//msg_delay <= 0;
          
  
  		         if (index_fim == 4) begin

						index_fim<=0;
						state<= 2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;

		  end	
				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b00;
					
				end
				
	end 
	
	2'b01: begin 
				
           if (msg_delay == 4339) begin           // 10us delay
             msg <= text_RSU[index_rsu]; 
             index_rsu <= index_rsu +1;
	         //msg_delay <= 0;
           
  
  		        if  (index_rsu == 3) begin
					
					
						index_rsu <=0;
						state<= 2'b10;
						//node_flag <= 0;
					end
				else msg_delay <= 0;
		   end 

				else begin
					msg_delay <= msg_delay + 1;
					state <= 2'b01;
				end
			
 end 
 2'b10: begin
 
   
    
 
           if ( msg_delay == 4339) begin
              msg <=  text_hash[index_1] ;
              index_1 <= index_1+1;
			  msg_delay<= 0 ;
			  increment_su3 <= increment_su3 +1;
 
  		         if (index_1 == 2 ) begin
					
					
						index_1 <=0;
						state <= 2'b11;
						//node_flag <= 0;
					end
		   end

				else begin
					msg_delay <= msg_delay + 1;
					state<=2'b10;
				end
		end

 2'b11: state <= 2'b00;

		endcase 
		
		end 
		
else if ( EM_active ) begin 
	
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
           msg <= text_BPM[index_bpm];
		    index_bpm <= index_bpm +1;    // delay of 10us
			//msg_delay <= 0;

           
  
  		         if (index_bpm == 4) begin
					
						index_bpm<=0;
						state <= 2'b01;
					//	node_flag <= 0;
					end
				else msg_delay<= 0;

		  end 	
				else begin
					msg_delay <= msg_delay + 1;
					state <= 2'b00;
				end
				
	end 
	
	2'b01: begin 
				
     
       
  
           if (msg_delay == 4339) begin           // 10us delay
            msg <= text_SUB[index_su];
             index_su <= index_su +1;
			//msg_delay<= 0;

           
  
  		        if  (index_su == 4) begin
					
					
						index_su <=0;
						state <= 2'b10;
						//node_flag <= 0;
					end
				else msg_delay<=0;

		   end	
				else begin
					msg_delay <= msg_delay + 1;
					state <= 2'b01;
				end
				
 end 

 2'b10: begin
   
    
 
           if ( msg_delay == 4339) begin
               msg <= {rsu_block_id, text_hash[index_1]} ;
              index_1 <= index_1+1;
			  msg_delay = 0;
           
 
  		         if (index_1 == 2 ) begin
					
					
						index_1 <=0;
						state <= 2'b11;
						//node_flag <= 0;
					end
		   end

				else begin
					msg_delay <= msg_delay + 1;
					state<= 2'b10;
				end
		end
		
2'b11: state <= 2'b00; 

		endcase 
		end 
		
else if ( EM_drop ) begin 
//blue_light <=0;
	//green_light <=1;
	case(state) 

2'b00: begin 

	
     
          if (msg_delay == 4339) begin
			msg <= text_BDM[index_bdm];
            index_bdm <= index_bdm +1;    // delay of 10us
			//msg_delay <= 0;

           
  
  		         if (index_bdm == 3) begin
					
						index_bdm<=0;
						state<= 2'b01;
					//	node_flag <= 0;
					end
				else msg_delay <= 0;

		  end	
				else begin
					msg_delay <= msg_delay + 1;
					state<= 2'b00;
				end
				
	end 
	
	2'b01: begin 
				
    
       
  
           if (msg_delay == 4339) begin           // 10us delay
             msg <= text_RSU[index_su];
             index_rsu <= index_rsu +1;
			 msg_delay <= 0;
           
  
  		        if  (index_rsu == 3) begin
					
					
						index_rsu <=0;
						state <= 2'b10;
						//node_flag <= 0;
					end
		   end 	
				else begin
					msg_delay <= msg_delay + 1;
					state <= 2'b01;
				end
				end
				
	2'b10: state <= 2'b00;
 endcase
 end
 
end 

 
			
endcase 
  
 end  
 
 //end 
 
 
endmodule 
 




