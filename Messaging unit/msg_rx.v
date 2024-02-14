module msg_rx (
    input clk_50M,
    input [7:0] rx,
	 input rx_complete,
    //output reg [83:0] msg
    output reg CU_active,
    output reg EU_active,
    output reg RU_active,
    output reg EM_active,  // when em is on
    output reg EM_drop,   // when em is switched off with a load
    output reg fault_detect, // when a fault is detected by U.S.
    output reg [7:0] csu_block_id,
    output reg [7:0] esu_block_id,
    output reg [7:0] rsu_block_id
);
    
parameter delay = 4339 ;
reg [13:0] delay_count;
reg [7:0] msg_mem [11:0] ;
reg [1:0] state ;
reg [4:0] idx;

initial begin
    CU_active <= 0;
    fault_detect <= 0;
    EU_active <= 0;
    EM_active <= 0;
    RU_active <= 0;
    EM_drop <= 0;
    delay_count = 0 ;
    state = 0;
    //msg = 0;
    idx=0;

end

always @(posedge clk_50M) begin
if (rx_complete) begin
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
         //   msg <= {msg_mem[0],msg_mem[1],msg_mem[2],msg_mem[3],msg_mem[4],msg_mem[5],msg_mem[6],msg_mem[7],msg_mem[8],msg_mem[9],msg_mem[10],msg_mem[11]};
			if (msg_mem[4]== 8'h43  && msg_mem[5] == 8'h55 ) begin
                CU_active <= 1;
                fault_detect <= 1;
                csu_block_id <= 8'h31;

            end
            else if (msg_mem[4]== 8'h45  && msg_mem[5] == 8'h55) begin
                EU_active <= 1;
                EM_active <= 1;
                esu_block_id <= 8'h32;

                
            end
            else if (msg_mem[4]== 8'h52  && msg_mem[5] == 8'h55) begin
                RU_active <= 1;
                EM_drop <= 1;
                rsu_block_id <= 8'h33;
            end
			
            state <= 2'd0;
        end
        
    endcase
	 end
end

endmodule 