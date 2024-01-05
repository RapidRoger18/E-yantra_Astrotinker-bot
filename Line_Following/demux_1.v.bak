module demux_1 ( 
input  pwm_195,
input  m1a1, m1b1 ,
output reg A1 , B1
);
always@(*) begin
	case ({ m1a1 , m1b1})
		2'b00: begin
			A1 <= 1'b0;
			B1 <= 1'b0;
		end
		2'b01: begin 
			A1 <= 1'b0;
			B1 <= pwm_195;
		end
		2'b10 : begin 
			A1 <= pwm_195;
			B1 <= 1'b0;
		end
		2'b11: begin
			A1 <= 1'b0;
			B1 <= 1'b0;
		end
	endcase 
end
endmodule 

