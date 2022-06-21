
module ALU(a,b,ALUop,zero,c);
input [31:0] a;
input [31:0] b;
input [10:0]ALUop;
output reg [31:0] c;
output  reg zero;
assign e=~(a+1);
assign d=~(b+1);
always @(* ) begin begin
if ((ALUop[6:0]==7'b0110111)|(ALUop[6:0]==7'b0010111)) //LUI,AUIPC
    //Aop <= 4'b0010; //SLL
    begin c=a+b ; end
  else if ((ALUop[6:0]==7'b1101111)|(ALUop[6:0]==7'b1100111)|(ALUop[6:0]==7'b0000011)|(ALUop[6:0]==7'b0100011)) // JAL JALR LB SB
   // Aop <= 4'b0000; //ADD
   c<= a+b;
  else begin
   case (ALUop[10:7])
4'b0000: begin c<= a+b ; end // ADD 
4'b1000: begin c<= a-b ; end  // SUB
4'b0001: begin c=a<<b ; end         // SLL
4'b0010:          //SLT
c<= ($signed(a)< $signed(b))?1:0;
4'b0011: begin c<=(a>=b)?1:0;  end       //SLTU  
4'b0100: begin c[31:0] <= a[31:0] ^ b[31:0] ;  end    // XOR
4'b0101: begin c<=a>>b;  end               //SRL
4'b1101: begin  c <= a>>>b ; end     // SRA
4'b0110: begin c <= a |b ;  end       // OR
4'b0111: begin c <= a &b ;  end       //AND*/
default begin c <=0 ; end
endcase end
case (ALUop[9:0])
10'b0001100011: zero <= (a==b)?1:0; //BEQ
10'b0011100011: zero <= (a==b)?0:1; //BNE
10'b1001100011: zero <= ($signed(a)< $signed(b))?1:0; //BLT
10'b1011100011: zero <= ($signed(a)> $signed(b))?1:0; //BGE
10'b1101100011: zero <= (a<b)?1:0; //BLTU
10'b1111100011: zero <= (a>b)?1:0; //BGEU
default: zero <=1;
endcase 
end end
endmodule

module t_ALU ;
reg [31:0]a;
reg [31:0]b;
reg [10:0] ALUop; 
wire [31:0]c;
wire zero;
parameter time_out = 100;
ALU U1(a,b,ALUop,zero,c); 
initial $monitor($time," a %h ,b %h ,ALUop %b ,zero  %d, c %h" , a , b,ALUop,zero , c);
/*initial begin
	clk = 0;
end
always #5 clk = ~clk;*/
initial
begin 
#5 a = 32'd10;
b = 32'd1;
ALUop = 11'b01110010011;
#20 a = 32'd2;
b = 32'd5;
ALUop = 11'b00000010011;
#20 a = 32'd0;
b = 32'd1;
ALUop = 11'b00000110011;
/*#20 a = 32'Hf000000f;
b = 32'd100;
ALUop = 4'b0011;32'b000000000000_00000_111_00011_;
assign imem[32'd24]=32'b000000000001_00011_000_00001_;
assign imem[32'd36]=32'b000000000011_00001_000_00010_;

#20 a = -20;
b = -10;
ALUop = 4'b1000;*/
#300 $finish;
 end
endmodule
