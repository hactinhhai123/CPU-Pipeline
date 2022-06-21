
module controlunit(in, Regwrite, ALUsrc, Memtoreg, Memread,Memwrite, Branch );
  input [6:0]in;
//output reg Cen,Ben,Aen,Jen,Jsel; //Aen = 1: chon PC thay vi rs1 vao ALU, Jen = 1: chon rs1 thay vi PC vao PC nhay
  output reg Regwrite, ALUsrc, Memtoreg, Memread,Memwrite, Branch; 
always @(*)
if((in==7'b0110111)|(in==7'b0010111)|(in==7'b1100111)|(in==7'b1101111)|(in==7'b1100011)|(in==7'b0000011)|(in==7'b0100011)|(in==7'b0010011)|(in==7'b0110011))
begin 
 //Cen = (~in[6])&(~in[5])&(in[4])&(~in[3])&(in[2])&(in[1])&(in[0]);  //jalr
  //if (in==7'b0010111) Cen = 1'b1; else Cen = 1'b0;
//Ben = (in==7'b0110111)?1'b1:1'b0;  // lui
 //Aen = ((in==7'b1100111)|(in==7'b0010111)|(in==7'b1101111))?1'b1:1'b0; // jalr auipc jal
 //Jen = ((in==7'b1100111)|(in==7'b1101111))?1'b1:1'b0;  // jalr  jal
 //Jsel= ((in==7'b1101111)|(in==7'b1100111)|(in==7'b0010111))?1'b1:1'b0;  //|(in==7'b0010011)
 Branch = (in[6]) & (in[5]) & (~in[4]) & ((~in[3])&(~in[2]) | (in[3])&(in[2]) | (~in[3])&(in[2]))|(in==7'b0010111);  // các l?nh B va jal jalr 
 Memwrite = (~in[6]) & (in[5]) & (~in[4]);
 Memread = (~in[6]) & (~in[5]) & (~in[4]);
 Memtoreg =(~in[6]) & (~in[5]) & (~in[4])?1'd1:1'd0;
 //Memtoreg = ((in[6]) & (in[5]) & (~in[4]) & (in[2]))?1'd1:(((~in[6]) & (~in[5]) & (~in[4]))?1'd1:1'd0);
 ALUsrc = (~in[6]) & ((~in[5]) | (~in[4]) | ((in[4]) & (~in[3]) & (in[2])))|(in==7'b1100111)|(in==7'b1101111);
 Regwrite = (~in[6]) & ((~in[5]) | (in[4])) | (((~in[6]) & (in[4]) & (~in[3]) | (in[6]) & (in[5]) & (~in[4])) & (in[2]));
end
else //|(in==7'b1100111)
begin 
//Aen = 0;
 //Jen = 0;
 Branch = 0;
 Memwrite =0;
 Memread = 0;
 Memtoreg = 0;
 ALUsrc = 0;
 Regwrite=0;
//Jsel=0;
end 
endmodule

module t_controlunit ;
reg [6:0]in;
wire Ben, Aen,Jen; //Aen = 1: chon PC thay vi rs1 vao ALU, Jen = 1: chon rs1 thay vi PC vao PC nhay
wire Regwrite, ALUsrc, Memtoreg, Memread,Memwrite, Branch; 
parameter time_out = 100;
controlunit u1(in, Regwrite, ALUsrc, Memtoreg, Memread,Memwrite, Branch  ,Ben,Aen,Jen);
//initial $monitor($time," opcode %h ,Regwrite %d, ALUsrc %d, Memtoreg %d, Memread %d, Memwrite %d, Branch %d " ,opcode,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch );

initial
begin 
#5 in=  7'b0100011;
#20 in = 7'bxxxxxx;
/*#20 in= 32'd16;
#20 in= -20;*/
#300 $finish;
 end
endmodule
