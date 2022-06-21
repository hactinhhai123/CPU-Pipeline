/*
module data_mem(clk,Nb, mem_wr , mem_rd , addr1 ,wr_data , rd_data);
input [31:0]addr1;
input [2:0] Nb;
input mem_wr , mem_rd,clk ; 
input [31:0] wr_data;
output reg[31:0]rd_data ;
reg [31:0] rd_data1;
reg [7:0]mem[100000:0];
reg [31:0]b,c,d;
reg [31:0]addr;

integer i;
initial begin
for (i=0;i<100;i=i+1)
mem[i]=0;
  rd_data <= 32'b0;
end
assign addr = {addr1[29:0],2'b00};
always @(* ) 
begin 
  if (mem_rd ==1)begin
               b<={mem[addr + 32'd3],mem[addr + 32'd2],mem[addr + 32'd1],mem[addr + 32'd0]};
                case (Nb)
       3'b010 :   rd_data<=b;   // lw
       3'b000 :   rd_data<={24'd0,b[7:0]};   // lb
       3'b001 :   rd_data<={16'd0,b[15:0]};   // lh
       3'b100 :   rd_data<={{24{b[7]}},b[7:0]};   // lbu
       3'b101 :   rd_data<={{16{b[15]}},b[15:0]};   // lhu
       default: rd_data<=32'd0;
                endcase
                 end 
  else if (mem_wr ==1) begin 
             c<= { 24'd0,wr_data[7:0]};
             d<= { 16'd0,wr_data[15:0]};
                case(Nb)
3'b000 :   //mem[addr]<= c ; // sb
           begin
           mem[addr + 32'd0] <=c[7:0];
           mem[addr + 32'd1] <=c[15:8];
           mem[addr + 32'd2] <=c[23:16];
           mem[addr + 32'd3] <=c[31:24];
           end
3'b001 :   //mem[addr]<= d  ; // sh
           begin
           mem[addr + 32'd0] <=d[7:0];
           mem[addr + 32'd1] <=d[15:8];
           mem[addr + 32'd2] <=d[23:16];
           mem[addr + 32'd3] <=d[31:24];
           end
default: //3'b010 :   //mem[addr]<=wr_data ;   // sw
           begin
           mem[addr + 32'd0] <=wr_data[7:0];
           mem[addr + 32'd1] <=wr_data[15:8];
           mem[addr + 32'd2] <=wr_data[23:16];
           mem[addr + 32'd3] <=wr_data[31:24];
           end

                endcase
              end 
end
endmodule*/
module data_mem(clk,Nb, mem_wr , mem_rd , addr ,wr_data , rd_data);
input [31:0]addr;
input [2:0] Nb;
input mem_wr , mem_rd,clk ; 
input [31:0] wr_data;
output reg[31:0]rd_data ;

reg [31:0]mem[100:0];
reg [31:0]b,c,d;
integer i;
initial begin
for (i=0;i<100;i=i+1)
mem[i]=0;
  rd_data <= 32'b0;
end
always @(* ) 
begin 
if (mem_wr ==1) begin 
             c<= { 24'd0,wr_data[7:0]};
             d<= { 16'd0,wr_data[15:0]};
                case(Nb)
3'b000 :   mem[addr]<= c ; // sb
3'b001 :   mem[addr]<= d  ; // sh
3'b010 :   mem[addr]<=wr_data ;   // sw
                endcase
              end 
  
  else if (mem_rd ==1)begin
               b<=mem[addr];
                case (Nb)
       3'b010 :   rd_data<=b;   // lw
       3'b000 :   rd_data<={24'd0,b[7:0]};   // lb
       3'b001 :   rd_data<={16'd0,b[15:0]};   // lh
       3'b100 :   rd_data<={{24{b[7]}},b[7:0]};   // lbu
       3'b101 :   rd_data<={{16{b[15]}},b[15:0]};   // lhu
       
                endcase
                 end 
end
endmodule
module t_data_mem;
reg [31:0]addr;
reg clk , mem_wr , mem_rd;
reg [2:0] Nb;
reg [31:0]wr_data;
wire [31:0]rd_data;
parameter time_out = 100;
data_mem U1(clk,Nb, mem_wr , mem_rd , addr ,wr_data , rd_data); 
initial $monitor($time," mem_wr %d  ,mem_rd %d , addr  %h,wr_data %d , rd_data %d" , mem_wr , mem_rd , addr ,wr_data , rd_data);
initial begin
	clk = 0;
end
always #5 clk = ~clk;
initial
begin 
#5 mem_wr = 1;  mem_rd = 0; 
addr = 32'd10; Nb= 3'b001;
wr_data=32'd1010120;
#20 mem_wr = 0;  mem_rd = 0; 
addr = 32'd0;
wr_data=32'd1010120;
#20 mem_wr = 1;  mem_rd = 0; 
addr = 32'd14; Nb= 3'b000;
wr_data=32'd1010120;
#20 mem_wr = 0;  mem_rd = 1; 
addr = 32'd14;Nb= 3'b000;
wr_data=32'd120;
#300 $finish;
 end
endmodule
