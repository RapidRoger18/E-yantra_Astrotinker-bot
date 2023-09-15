module full_adder (
input a,b,cin,
output sum, c_out);

assign sum = a^b^cin;
assign c_out = (((a^b)&cin) | (a&b)) ;

endmodule 