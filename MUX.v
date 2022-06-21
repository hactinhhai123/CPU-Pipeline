module MUX(a , b ,c , s);
input [31:0]a;
input [31:0]b;
input s;
output [31:0]c ;
//assign c= (s==1)?a:b; 
assign c= (s==0)?a:b;
endmodule
module MUX3(a,b,c,s,out);
input [31:0]a,b,c;
input [1:0]s;
output reg[31:0]out; 

always @(*)
case (s)
2'b00: out<=a;
2'b01: out<=b;
2'b10: out<=c;
//2'b11: out<=d;
default out<=a;
endcase 
endmodule

module PC_4 ( PC,PCN);
input [31:0] PC;
output [31:0] PCN ;

assign PCN=PC + 4;


		
endmodule 
