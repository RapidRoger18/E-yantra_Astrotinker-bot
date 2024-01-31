module msg_rx (
    input clk_50M,
    input [7:0] rx,
    output reg [83:0] msg,
	 output reg [1:0]EU_active, 
	 output reg [1:0]CU_active,
	 output reg [1:0]RU_active,
	 output  reg [4:0] esu_block_id,
	 output  reg [4:0] csu_block_id,
	 output  reg [4:0] rsu_block_id
	 
);
 
parameter delay = 4339 ;
reg [13:0] delay_count;
reg [7:0] msg_mem [11:0] ;
reg [1:0] state ;
reg [4:0] idx;
 
initial begin
 
    delay_count <= 0 ;
    state <= 0;
    msg <= 0;
    idx<=0;
 
end
 
always @(posedge clk_50M) begin
    case (state)
        0: begin
            state<=2'd1;
        end
 
        1: begin
            if (delay_count==delay) begin
                msg_mem[idx] <= rx;
                idx <= idx + 1 ;
                delay_count <= 0;
                if (idx == 12) begin
                    idx <= 0;
                    state <= 2'd2;
 
                end
            end
 
            else begin
                delay_count <= delay_count + 1;
                state <= 2'd1;
            end
 
        end
 
        2: begin
		   if ( msg_mem[0] <= 8'h49 && msg_mem[1] <= 8'h46 && msg_mem[2] <= 8'h4D)  begin 
			// IFM signal is detected 
			if ( msg_mem[3] <= 8'h45 ) begin 
			EU_active <= 1;
			CU_active <= 0;
			RU_active <= 0;
			end 
			else if ( msg_mem[3] <= 8'h43) begin 
			EU_active <= 0;
			CU_active <= 1;
			RU_active <= 0;
			end 
			else if ( msg_mem[3] <= 8'h52) begin 
			EU_active <= 0;
			CU_active <= 0;
			RU_active <= 1;
			end 
			end 
			
			else if ( msg_mem[0] <= 8'h50 && msg_mem[1] <= 8'h42 && msg_mem[2]  <= 8'h4D ) begin 
			// PBM signal is detected 
			 if ( msg_mem [3] <= 8'h53 && msg_mem[4] <= 8'h55) begin
			 if ( msg_mem[5] <= 8'h39 && EU_active <= 1) begin 
			 esu_block_id <=1;
			 csu_block_id <=0;
			 rsu_block_id <=0;
			 end 
			 else if (msg_mem[5] <= 8'h40 && EU_active <= 1) begin 
			  esu_block_id <=2;
			 csu_block_id <=0;
			 rsu_block_id <=0;
			 end 
			  else if (msg_mem[5] <= 8'h41 && EU_active <= 1) begin 
			  esu_block_id <=3;
			 csu_block_id <=0;
			 rsu_block_id <=0;
			 end 
			  else if (msg_mem[5] <= 8'h42 && EU_active <= 1) begin 
			  esu_block_id <=4;
			 csu_block_id <=0;
			 rsu_block_id <=0;
			 end 
			 
			 else if ( msg_mem[5] <= 8'h39 && CU_active <= 1) begin 
			 esu_block_id <=0;
			 csu_block_id <=1;
			 rsu_block_id <=0;
			 end 
			 else if (msg_mem[5] <= 8'h40 && CU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=2;
			 rsu_block_id <=0;
			 end 
			  else if (msg_mem[5] <= 8'h41 && CU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=3;
			 rsu_block_id <=0;
			 end 
			  else if (msg_mem[5] <= 8'h42 && CU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=4;
			 rsu_block_id <=0;
			 end 
			 
			  
			 else if ( msg_mem[5] <= 8'h39 && RU_active <= 1) begin 
			 esu_block_id <=0;
			 csu_block_id <=0;
			 rsu_block_id <=1;
			 end 
			 else if (msg_mem[5] <= 8'h40 && RU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=0;
			 rsu_block_id <=2;
			 end 
			  else if (msg_mem[5] <= 8'h41 && RU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=0;
			 rsu_block_id <=3;
			 end 
			  else if (msg_mem[5] <= 8'h42 && RU_active <= 1) begin 
			  esu_block_id <=0;
			 csu_block_id <=0;
			 rsu_block_id <=4;
			 end 
			 end end 
			 
			 
			 
			 
			 
			 
			
			
			
         //   msg <= {msg_mem[0],msg_mem[1],msg_mem[2],msg_mem[3],msg_mem[4],msg_mem[5],msg_mem[6],msg_mem[7],msg_mem[8],msg_mem[9],msg_mem[10],msg_mem[11]};
 
 
            state <= 2'd0;
        end
 
    endcase
end
 
endmodule