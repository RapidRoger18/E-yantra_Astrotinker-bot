module demux_2 ( 
input  pwm_195,
input m2a2, m2b2 ,
output reg A2 , B2
);
always@(*) begin
	case ({ m2a2 , m2b2})
		2'b00: begin
			A2 <= 1'b0;
			B2 <= 1'b0;
		end
		2'b01: begin 
			A2 <= 1'b0;
			B2 <= pwm_195;	
		end
		2'b10 : begin 
			A2 <= pwm_195;
			B2 <= 1'b0;
		end
		2'b11: begin
			A2 <= 1'b0;
			B2 <= 1'b0;
		end
	endcase 
end
endmodule 


