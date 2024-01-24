module path_mapping(
		input node_flag,
		input clk_50M,
		input path_input,
		input [4:0] path_planned,
		output reg [1:0] turn_flag,
		output reg [4:0] SP, EP,
		output reg CPU_start
);

reg [7:0] curr_dir=0,prev_dir=0;
reg [19:0] node_rel [29:0];
reg [4:0] path_planned_array [15:0];
reg [4:0] j=0,k=0,d=0;
reg [4:0] curr_node,next_node;
reg [19:0] temp;
reg [1:0] diff;
reg [3:0] idx = 0;

 initial begin
        //              N     E    S    W
        node_rel[0] = {5'd1,5'dx,5'dx,5'dx};
        node_rel[1] = {5'dx,5'd29,5'd0,5'd2};
        node_rel[2] = {5'd8,5'd1,5'd3,5'dx}; 
        node_rel[3] = {5'd2,5'd28,5'dx,5'd4};       //?
        node_rel[4] = {5'd5,5'd3,5'dx,5'd6};
        node_rel[5] = {5'dx,5'dx,5'd4,5'dx};
        node_rel[6] = {5'd7,5'dx,5'd4,5'dx};
        node_rel[7] = {5'dx,5'd8,5'd6,5'dx};
        node_rel[8] = {5'd12,5'd9,5'd2,5'd7};
        node_rel[9] = {5'd11,5'dx,5'd10,5'd8};
        node_rel[10] = {5'd9,5'dx,5'dx,5'dx};
        node_rel[11] = {5'dx,5'dx,5'd9,5'dx};
        node_rel[12] = {5'dx,5'd19,5'd8,5'd13};
        node_rel[13] = {5'd14,5'dx,5'd12,5'dx};
        node_rel[14] = {5'dx,5'd16,5'd15,5'd13};
        node_rel[15] = {5'd14,5'dx,5'dx,5'dx};
        node_rel[16] = {5'dx,5'd18,5'd17,5'd14};
        node_rel[17] = {5'd16,5'dx,5'dx,5'dx};
        node_rel[18] = {5'd16,5'dx,5'd19,5'dx};
        node_rel[19] = {5'dx,5'd18,5'd20,5'd12};
        node_rel[20] = {5'd19,5'd24,5'd29,5'd21};
        node_rel[21] = {5'd23,5'd20,5'd22,5'dx};
        node_rel[22] = {5'd21,5'dx,5'dx,5'dx};
        node_rel[23] = {5'dx,5'dx,5'd21,5'dx};
        node_rel[24] = {5'dx,5'dx,5'd25,5'd20};
        node_rel[25] = {5'd24,5'dx,5'd26,5'dx};
        node_rel[26] = {5'd27,5'd25,5'dx,5'd28};
        node_rel[27] = {5'dx,5'dx,5'd26,5'dx};
        node_rel[28] = {5'd29,5'd26,5'dx,5'd3};
        node_rel[29] = {5'd20,5'dx,5'd28,5'd1};
end 

always @(posedge clk_50M) begin
		SP <= 0;
		EP <= 20;
		CPU_start <= 1;
		if (path_input) begin
			path_planned_array[idx] <= path_planned;
			idx <= idx + 1;
		end
		else begin
			idx <= 0;
			temp<=node_rel[j];
			curr_node<=path_planned_array[j];
			if (node_flag) begin
					
					next_node<=path_planned_array[j+1];
					if ({temp[k+4],temp[k+3],temp[k+2],temp[k+1],temp[k]}==next_node) begin
							case(k+4) 
									5'd4  : curr_dir[d]<=3; 									  
									5'd9  : curr_dir[d]<=2;                              
									5'd14 : curr_dir[d]<=1;                             
									5'd19 : curr_dir[d]<=0;                             
							endcase
							if (d!=0) prev_dir<=curr_dir[d-1];
							else prev_dir<=2'dx;
							d<=d+1;
							if(prev_dir>curr_dir) begin
									diff<= prev_dir - curr_dir;
									case (diff) 
											0 : turn_flag<=0;
											1 : turn_flag<=3; 
											2 : turn_flag<=2;
									endcase
							end
							else begin
									diff<=curr_dir - prev_dir;
									case (diff) 
											0 : turn_flag<=0;
											1 : turn_flag<=1;
											2 : turn_flag<=2;	
									endcase
							end
					end
					else k<=k+5;
					j<=j+1;
			end
		end
end
endmodule 