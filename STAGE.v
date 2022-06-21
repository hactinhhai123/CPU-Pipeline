module PC(  pc_pc, pc_ex, br_infact_ex ,br_inst_detect_ex, , bht_ex,
            pattern_old_ex, pattern_new_ex, pred_pc_ex,
            pred_pc_pc, bht_pc, pc_next_2, a_32, br_inst_detect_pc);
input [31:0] pc_pc ,pc_ex,pred_pc_ex;
input [1:0] bht_ex;
input [7:0] pattern_old_ex, pattern_new_ex;
input  br_inst_detect_ex,br_infact_ex;
output [31:0]pc_next_2,pred_pc_pc,a_32;
output br_inst_detect_pc;
output [1:0] bht_pc;
//---------------------------------------------------------------------------------
wire [31:0]a_32_out,a_32, pc_ex,pc_pc,pc_next,pc_next_1,pc_next_2,pred_pc_pc, pred_pc_ex;
wire [6:0] opcode;
wire [7:0] pattern_old_ex, pattern_new_ex;
wire [1:0] bht_pc,bht_ex ;
wire [19:0] tag_val;
wire signal_1,signal_2,signal_3,br_infact_ex,br_inst_detect_ex,br_inst_detect_pc;
//---------------------------------------------------------------------------------
IMEM a2( pc_pc, a_32_out);
assign pc_next = (a_32_out[1:0]==2'b11)?pc_pc+4:pc_pc+2;
decoder a3(a_32_out,a_32);
assign opcode = a_32[6:0];
br_inst_detect a7(opcode,br_inst_detect_pc);
BHT a1(br_inst_detect_pc, br_inst_detect_ex, pc_pc, pc_ex, bht_ex, pattern_old_ex, pattern_new_ex,
     bht_pc);
BTB btt2(br_inst_detect_pc, br_inst_detect_ex, pc_pc, pc_ex, pred_pc_ex, pattern_old_ex, pattern_new_ex,
      tag_val, pred_pc_pc);
    assign signal_1 = (pc_pc[31:12] == tag_val) ? 1'b1 : 1'b0;
    assign signal_2 = bht_pc[1];
    and(signal_3,signal_1,signal_2);
    assign pc_next_1 = signal_3 ? pred_pc_pc : pc_next;
    assign pc_next_2 = br_infact_ex ? pred_pc_ex : pc_next_1;
    endmodule
//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
module t_IF;
reg [31:0]pc;
wire [31:0]a_32;
wire [15:0]a_16;
wire [31:0]pc_next;
parameter time_out = 100;
IF a1(  pc ,a_32,a_16,pc_next);
initial begin
	#10 pc = 4;
        #10 pc = 8;
        #10 pc = 12 ;
        #10 pc = 16;
        #10 pc = 20;
        #10 pc = 10;
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
module IF( a,clk,
imm,ALUsrc, Memtoreg, Memread, Memwrite,Branch,ALUop,Regwrite,Nb);
input [31:0]a;
input clk;
output [10:0]ALUop;
output [31:0]imm;
output Regwrite,ALUsrc, Memtoreg, Memread, Memwrite, Branch;//Cen, Ben,Aen,Jen,Jsel;
output [2:0]Nb;
//--------------------------------------------------------------------------------------
wire Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch ;
wire   [2:0]Nb;
//--------------------------------------------------------------------------------------
assign ALUop = {a[30],a[14:12],a[6:0]};
imm a3(a ,imm);
assign Nb = a[14:12];
controlunit u1(a[6:0],Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch);
endmodule 
////////////////////////////////////////////////////////////////////////////////////////
module t_ID;
reg [31:0]a;
reg clk;
wire [10:0]ALUop;
wire [31:0] imm;
wire Regwrite,ALUsrc, Memtoreg, Memread, Memwrite, Branch,Aen,Jen;
wire   [2:0]Nb;
parameter time_out = 100;
ID u1( a,clk,imm,ALUsrc, Memtoreg, Memread, Memwrite,Branch,ALUop,Regwrite,Aen,Jen,Nb);
initial begin
	clk = 0;
end
always #5 clk = ~clk;
initial begin
	
        #10 
           a= 32'b000000000000_00000_101_00011_0010011;
        #10 
           a= 32'b000000000001_00011_000_00010_0100011;
end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

module EX(pc , ALUop , rs1  , rs2,
zero , ALU_result , pc_out   );
input [31:0]pc;
input [10:0]ALUop;
input [31:0]rs1,rs2;
output [31:0] pc_out;
output zero;
output [31:0]ALU_result;
//-----------------------------------------------------------------------------------
wire [31:0]mux_alu;
//------------------------------------------------------------------------------
ALU a9(rs1,rs2,ALUop,zero,ALU_result);

endmodule
module t_EX;
reg [31:0]pc;
reg [10:0]ALUop;
reg [31:0]rs1,rs2,imm;
reg  ALUsrc  ;
wire [31:0] pc_out;
wire zero;
wire [31:0]ALU_result;
wire [31:0] rs2_out;
parameter time_out = 100;
EX u1(pc , ALUop , rs1 , rs2 , imm,ALUsrc,zero , ALU_result ,rs2_out, pc_out   );
initial begin
	#10 pc = 1; 
           ALUop = 11'b00000010011;
           rs1 = 32'd0;//rs2 = 32'd2;
imm = 32'd1;
           ALUsrc = 1;
      /* #10 pc = 2; 
           ALUop = 0001;
           rs1 = 32'd1;rs2 = 32'd2;imm = 32'd5;
           ALUsrc = 1;
       #10 pc = 3; 
           ALUop = 1000;
           rs1 = 32'd111;rs2 = 32'd20;imm = 32'd5;
           ALUsrc = 0;*/
end
endmodule
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
module MEM( clk, Memwrite, Memread, rs2, Nb,
rd_data );
input [31:0]rs2;
input clk,Memread,Memwrite;
input [2:0] Nb;
output [31:0] rd_data;
//-----------------------------------------------------------------------------------
wire [31:0]a;
wire [31:0]mux_alu;
wire [3:0]ALUop;
//-----------------------------------------------------------------------------------

data_mem a10(clk, Nb, Memwrite, Memread, ALU_result, rs2, rd_data);
endmodule
/////////////////////////////////////////////////////////////////////////////////
module t_MEM;
reg [31:0]rs2;
reg zero,Branch,clk,Memread,Memwrite;
reg [2:0] Nb;
wire [31:0] rd_data;
parameter time_out = 100;
 MEM u1( clk, ALU_result, Memwrite, Memread, rs2, Nb,
rd_data );
initial begin
	clk = 0;
end
always #5 clk = ~clk;
initial begin
	#10 Nb=0; Memread=0; Memwrite=1; 
           rs2 = 32'd2;
end

endmodule
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
module WB(rd_data,Memtoreg ,ALU_result,wr_data);
input [31:0]rd_data;
input [31:0]ALU_result;
input Memtoreg;
output wr_data;
MUX u1(rd_data,ALU_result,Memtoreg,wr_data);
endmodule 

