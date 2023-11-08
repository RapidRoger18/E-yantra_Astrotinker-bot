
module alu(

input [31:0] rs1,
input [31:0] rs2,
input [31:0] imm,
input [36:0] instructions,

output reg [31:0] ALUoutput
);

	initial begin
		ALUoutput = 0;
	end	
	 
	always@(*) begin
	
    case(instructions) 
		   37'h1 : ALUoutput <= rs1 + rs2;                                       //add
           37'h2 : ALUoutput <= rs1 - rs2;                                       //sub
           37'h4 : ALUoutput <= rs1 ^ rs2;                                       //xor
           37'h8 : ALUoutput <= rs1 | rs2;                                       //or
           37'h10 : ALUoutput <= rs1 & rs2;                                      //and
           37'h20 : ALUoutput <= rs1 << rs2;                                     //sll
           37'h40 : ALUoutput <= rs1 >> rs2;                                     //srl
           37'h80 : ALUoutput <= rs1 > rs2;                                      //sra 
           37'h100 : ALUoutput <= (rs1 > rs2)?1:0;                               //slt
           37'h200 : ALUoutput <= (rs1 > rs2)?1:0;                               //sltu
           37'h400 : ALUoutput <= (rs1 + imm);                                   //addi
           37'h800 : ALUoutput <= (rs1 ^ imm);                                   //xori
           37'h1000 : ALUoutput <= (rs1 | imm);                                  //ori
           37'h2000 : ALUoutput <= (rs1 & imm);                                  //andi
           37'h4000 : ALUoutput <= (rs1 << imm[4:0]);                            //slli
           37'h8000 : ALUoutput <= (rs1 >> imm[4:0]);                            //srli
           37'h10000 : ALUoutput <= (rs1 > imm[4:0]);                            //srai
           37'h20000 : ALUoutput <= (rs1 < imm)?1:0;                             //slti
           37'h40000 : ALUoutput <= (rs1 < imm)?1:0;                             //sltiu 
          
           default : ALUoutput<= 0;
        
		
	endcase  
end	
endmodule 