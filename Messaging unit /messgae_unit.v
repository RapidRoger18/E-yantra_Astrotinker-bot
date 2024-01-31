// Code your design here
module message_unit
( 
input clk_50M,
//input led_1, // for eu
//input led_2, // for cu
//input led_3, // for ru
//input node_flag,
//input [4:0] node,
input [3:0] esu_block_id,
input [3:0] csu_block_id,
input [3:0] rsu_block_id,
input EM_active,  // when em is on
input EM_drop,   // when em is switched off with a load
input fault_detect, // when a fault is detected by U.S.
input EU_active, // in EU section
input CU_active, // in CU section
input RU_active, // in RU section
//output reg [7:0] msg_FIM, 
//output  reg [7:0] msg_FSM,
//output reg [7:0] msg_BDM,
output reg  [20:0] msg,
output reg [1:0] blue_light,
output reg [1:0] green_light

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

reg [15:0] msg_delay =0;

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
blue_light <=0;
green_light <=0;

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

 if ( EU_active ) begin
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
	blue_light <= 1;
	case(state) 

		2'b00: begin 

			  
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
						
			 
				 
		  
					  if (msg_delay == 4339) begin           // 10us delay
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
						 msg <= {increment_su1 , text_hash[index_1]} ;
						  index_1 <= index_1+1;
						  msg_delay <= 0;
						  increment_su1 <= increment_su1 +1;
					  
		 
							if (index_1 == 2 ) begin
							
							
								index_1 <=0;
								state<=2'b11;
							
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
	blue_light <=0;
	green_light <=1;
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
	blue_light <= 1;
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
              msg <= {increment_su2 , text_hash[index_1]} ;
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
	blue_light <= 0;
	
	green_light <= 1;
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
	blue_light <= 1;
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
              msg <= {increment_su3 , text_hash[index_1]} ;
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
blue_light <=0;
	green_light <=1;
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
 



