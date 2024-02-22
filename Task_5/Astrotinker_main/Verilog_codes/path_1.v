module path_mapping(
		input node_flag,
		input clk_3125KHz,
		input path_input,
		input CPU_start,
		input [4:0] path_planned,
		input node_changed,
		input switch_key,
		output  [1:0] turn_flag,
		output  [4:0] realtime_pos 
//		output [4:0] SP,EP
);
reg [1:0] STATE = 0;
reg [1:0] curr_dir=0;
reg [1:0] next_dir=0;
reg [19:0] node_rel [29:0];
reg [4:0] path_planned_array [15:0];
reg [4:0] j=0,k=0;
reg [4:0] curr_node,next_node;
reg [19:0] temp;
reg [3:0] idx = 0;
reg [1:0] turn;
reg [1:0] diff;
reg [4:0] pos;


 initial begin
        //              N     E    S    W
        node_rel[0] = {5'd1,5'dx,5'dx,5'dx};
        node_rel[1] = {5'dx,5'd29,5'd0,5'd2};
        node_rel[2] = {5'd8,5'd1,5'd3,5'dx}; 
        node_rel[3] = {5'd2,5'd28,5'dx,5'd4};       
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
        node_rel[24] = {5'dx,5'd25,5'dx,5'd20};		// ??recheck after test
        node_rel[25] = {5'd24,5'dx,5'd26,5'dx};
        node_rel[26] = {5'd27,5'd25,5'dx,5'd28};
        node_rel[27] = {5'dx,5'dx,5'd26,5'dx};
        node_rel[28] = {5'd29,5'd26,5'dx,5'd3};
        node_rel[29] = {5'd20,5'dx,5'd28,5'd1};

		path_planned_array[0] <= 5'd0;
		path_planned_array[1] <= 5'd1;
		path_planned_array[2] <= 5'd29;
		path_planned_array[3] <= 5'd20;
		path_planned_array[4] <= 5'd21;
		path_planned_array[5] <= 5'd22;
		path_planned_array[6] <= 5'd21;
		path_planned_array[7] <= 5'd20;
		path_planned_array[8] <= 5'd29;
		path_planned_array[9] <= 5'd28;
		path_planned_array[10] <= 5'd26;
		path_planned_array[11] <= 5'd25;
		path_planned_array[12] <= 5'd24;
		path_planned_array[13] <= 5'd20;
		path_planned_array[14] <= 5'd29;
		path_planned_array[15] <= 5'd1;
		
end 

always @(posedge clk_3125KHz) begin
//		if (path_input) begin
//			path_planned_array[idx] <= path_planned;
//			idx <= idx + 1;`
//		end
//		else begin
			idx <= 0;
			temp<=node_rel[curr_node];
			if (node_flag) begin
				pos <= curr_node;
			end
			
			if (node_changed) begin
				curr_node<=path_planned_array[j];
				next_node<=path_planned_array[j+1];
				k<=0;
				STATE <= 2'b01;
				curr_dir<= next_dir;
			end
			case(STATE)
				2'b00:begin
				end
				2'b01: begin
					if ( {temp[k+4],temp[k+3],temp[k+2],temp[k+1],temp[k]}==next_node ) begin
						case(k) 
							5'd0  : next_dir <= 3; 									  
							5'd5  : next_dir <= 2;                              
							5'd10 : next_dir <= 1;                             
							5'd15 : next_dir <= 0;                             
						endcase
						STATE <= 2'b10;
					end
					else k <= k + 5;
				end
				2'b10:begin 
					if(next_dir > curr_dir) begin
							case (next_dir - curr_dir)
								2'd0: turn <= 2'd0;                   //redundant
								2'd1: turn <= 2'd1;
								2'd2: turn <= 2'd2;
								2'd3: turn <= 2'd3;
							endcase
					end
					else begin
						case (curr_dir - next_dir)
							2'd0: turn <= 2'd0;
							2'd1: turn <= 2'd3;
							2'd2: turn <= 2'd2;
							2'd3: turn <= 2'b1;
						endcase 
					end
					STATE <= 1'b0;
					j <= j + 1;
				end
			endcase
end
assign turn_flag=turn;
assign realtime_pos=pos;
endmodule 