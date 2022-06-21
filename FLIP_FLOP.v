module FF_PC(clk , en , rst , pc , pc_out );
input clk , rst , en;
input [31:0] pc ; 
output reg[31:0] pc_out ; 
initial begin
            pc_out <= 32'b0;
        end
always @(posedge clk )
begin 
  if(rst ==0 )
     begin
     if (en==1)  pc_out<=pc;
     end
  else 
begin
pc_out <= 0;
 end
end
endmodule 
module FP_T ( clk, en, rst, pc   , a,a_32    , bht , pattern
                              , pc_out, a_out,a_32_out , bht_out, pattern_out);
input clk , rst, en;
input [31:0]a,a_32,pc;
input [1:0] bht;
input [7:0] pattern;
output reg [7:0] pattern_out;
output reg[1:0] bht_out;
output reg[31:0]a_out,a_32_out , pc_out ;
//output reg br_inst_detect_out;
always @(posedge clk )
if(rst ==0) begin
   if (en==1) begin 
   pc_out <= pc; bht_out <= bht; pattern_out <=pattern; a_32_out<=a_32;
   a_out<= a ;  //br_inst_detect_out <= br_inst_detect ; pc_next_out <= pc_next;
   end end
else begin pc_out <=0; a_out<=0;  bht_out <= 0; pattern_out <=pattern; a_32_out<=0;end
endmodule
module FP_PC_IF ( clk, en, rst, pc   , a    ,a_32, bht  
                              , pc_out, a_out ,a_32_out, bht_out);
input clk , rst, en;
input [31:0]a,a_32,pc;
input [1:0] bht;
//input [7:0] pattern;
//output reg [7:0] pattern_out;
output reg[1:0] bht_out;
output reg[31:0]a_out ,a_32_out, pc_out ;
//output reg br_inst_detect_out;
always @(posedge clk )
if(rst ==0) begin
   if (en==1) begin 
   pc_out <= pc; bht_out <= bht; //pattern_out <=pattern;
a_32_out<=a_32;a_out<= a ;  //br_inst_detect_out <= br_inst_detect ; pc_next_out <= pc_next;
   end end
else begin pc_out <=0; a_out<=0;  bht_out <= 0;a_32_out<=0;  //pattern_out <=pattern;
end
endmodule

/*
module FP_IF_ID( clk ,en ,rst, a,a_32,pc,rs1,rs2,rd, imm,Regwrite,ALUsrc, Memtoreg, Memread, Memwrite,Branch,ALUop, Nb,rs1_a,rs2_a,bht,pattern,
a_out,a_32_out,pc_out,rs1_out,rs2_out,rd_out,imm_out,Regwrite_out,ALUsrc_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out,ALUop_out,Nb_out,rs1_addr,rs2_addr, bht_out,pattern_out );
input clk ,en , rst;
input [31:0]pc,imm,rs1,rs2 ,a,a_32;
input Regwrite,ALUsrc, Memtoreg, Memread, Memwrite,Branch;
input [10:0]ALUop; 
input [4:0]rd,rs1_a,rs2_a;
input [2:0] Nb;
input [1:0] bht;
input [7:0] pattern;
output reg [7:0]pattern_out;
output reg [2:0] Nb_out;
output reg [ 4:0] rs1_addr , rs2_addr;
output reg[4:0] rd_out;
output reg[31:0] imm_out,rs1_out,rs2_out,pc_out,a_out,a_32_out;
output reg[1:0] bht_out;
output reg Regwrite_out,ALUsrc_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out;
output reg[10:0]ALUop_out ;
always @(posedge clk )
if(rst ==0 )
begin if (en==1) begin 
rs1_addr<=rs1_a; 
rs2_addr<=rs2_a;
pc_out <= pc;  imm_out<=imm;
Regwrite_out<=Regwrite;  ALUsrc_out<=ALUsrc;
 Memtoreg_out<=Memtoreg; Memread_out<=Memread;a_out<=a;
Memwrite_out<=Memwrite;a_32_out<=a_32;
Branch_out<=Branch; ALUop_out<=ALUop;pattern_out <=pattern;
rs1_out <= rs1; rs2_out<=rs2;  rd_out<=rd; Nb_out<=Nb; bht_out<=bht ; 
end end
else begin
rs1_addr<=0;
rs2_addr<=0;
pc_out <= 0;a_32_out<=0;
 imm_out<=0; Regwrite_out<=0;pattern_out <=pattern;
ALUsrc_out<=0;  Memtoreg_out<=0;a_out <=0;
 Memread_out<=0;   Memwrite_out<=0;
Branch_out<=0; ALUop_out<=0;
rs1_out <= 0; rs2_out<=0;Nb_out<=0; bht_out<=0 ; 
rd_out<=0;  end
endmodule */
module FP_ID_EX( clk ,en ,rst, a,a_32,pc,rs1,rs2,rd, imm,ALUsrc,Regwrite,Memtoreg, Memread, Memwrite,Branch,ALUop, Nb,rs1_a,rs2_a,bht, pattern,
a_out,a_32_out,pc_out,rs1_out,rs2_out,rd_out,imm_out,ALUsrc_out,Regwrite_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out,ALUop_out,Nb_out,rs1_addr,rs2_addr, bht_out ,pattern_out);
input clk ,en , rst;
input [31:0]pc,imm,rs1,rs2 ,a,a_32;
input ALUsrc,Regwrite, Memtoreg, Memread, Memwrite,Branch;
input [10:0]ALUop; 
input [4:0]rd,rs1_a,rs2_a;
input [2:0] Nb;
input [1:0] bht;
input [7:0] pattern;
output reg [7:0]pattern_out;
output reg [2:0] Nb_out;
output reg [ 4:0] rs1_addr , rs2_addr,rd_out;
output reg[31:0] imm_out,rs1_out,rs2_out,pc_out,a_out,a_32_out;
output reg[1:0] bht_out;
output reg ALUsrc_out,Regwrite_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out;
output reg[10:0]ALUop_out ;
always @(posedge clk )
if(rst ==0 )
begin if (en==1) begin 
rs1_addr<=rs1_a; 
rs2_addr<=rs2_a;
pc_out <= pc;  imm_out<=imm;a_32_out<=a_32;
Regwrite_out<=Regwrite;  pattern_out<=pattern;
 Memtoreg_out<=Memtoreg; Memread_out<=Memread;a_out<=a;
Memwrite_out<=Memwrite;
Branch_out<=Branch; ALUop_out<=ALUop;ALUsrc_out<=ALUsrc;
rs1_out <= rs1; rs2_out<=rs2;  rd_out<=rd; Nb_out<=Nb; bht_out<=bht ;  
end end
else begin
rs1_addr<=0;
rs2_addr<=0; pattern_out <=pattern;
pc_out <= 0;ALUsrc_out<=0;imm_out<=0;a_32_out<=0; 
Regwrite_out<=0;  Memtoreg_out<=0;a_out <=0;
 Memread_out<=0;   Memwrite_out<=0;
Branch_out<=0; ALUop_out<=0;
rs1_out <= 0; rs2_out<=0;Nb_out<=0; bht_out<=0 ; 
rd_out<=0;  end
endmodule 
module FP_EX_MEM( clk ,en,rst, pc ,ALU_result,zero,rs2,rd,Regwrite, Memtoreg, Memread, Memwrite,Branch,Nb,
pc_out,ALU_result_out,zero_out,rs2_out,rd_out,Regwrite_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out,Nb_out  );
input clk,en,rst,zero ;
input [31:0]pc,ALU_result,rs2;
input Regwrite, Memtoreg, Memread, Memwrite,Branch;
input [4:0]rd;
input [2:0]Nb;
output reg[2:0] Nb_out;
output reg[4:0] rd_out;
output reg[31:0] rs2_out,ALU_result_out,pc_out;
output reg Regwrite_out, Memtoreg_out, Memread_out, Memwrite_out,Branch_out;
output reg zero_out;
always @(posedge clk )
if(rst ==0 )
begin
if (en==1)
begin 
pc_out <= pc;
Regwrite_out<=Regwrite; Memtoreg_out<=Memtoreg;
 Memread_out<=Memread; Memwrite_out<=Memwrite;
Branch_out<=Branch; rs2_out<=rs2;
rd_out<=rd; zero_out<=zero;
ALU_result_out<=ALU_result;
Nb_out<= Nb;
end end
else begin
pc_out <= 0;
Regwrite_out<=0;
 Memtoreg_out<=0; Memread_out<=0;
 Memwrite_out<=0; Branch_out<=0;
zero_out <= 0; rs2_out<=0;
rd_out<=0;
ALU_result_out<=0;
Nb_out<=0;
 end
endmodule 
module FP_MEM_WB ( clk ,en,rst,pc,rd,ALU_result,Regwrite, Memtoreg,rd_data,PCsrc,delay1,
pc_out,rd_out,ALU_result_out,Regwrite_out ,Memtoreg_out,rd_data_out  ,PCsrc_out,delay2 );
input clk,en,rst ;
input [31:0]pc,ALU_result,rd_data;
input Regwrite, Memtoreg, PCsrc,delay1;
input [4:0]rd;
output reg[31:0]pc_out,ALU_result_out,rd_data_out;
output reg[4:0]rd_out;
output reg Regwrite_out,Memtoreg_out,PCsrc_out,delay2;
always @(posedge clk )
if(rst ==0 )
begin
if (en==1)
begin 
delay2<=delay1;
PCsrc_out<=PCsrc;
rd_data_out<=rd_data;
pc_out<=pc;rd_out<=rd;
ALU_result_out<=ALU_result;
Regwrite_out<=Regwrite;
 Memtoreg_out<=Memtoreg;
end end
else  begin
PCsrc_out<=0; delay2<=0;
pc_out<=0; rd_data_out<=0;
ALU_result_out<=0; Regwrite_out<=0;
 Memtoreg_out<=0; rd_out<=0;
 end
endmodule
module FF(clk, rd,rd_out);
input clk ;
input [4:0] rd;
output reg [4:0]rd_out;


always @(posedge clk )

rd_out<=rd;
endmodule