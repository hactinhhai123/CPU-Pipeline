module Main2(clk,
            pc_imm,pred_pc_pc,pc_pc_next, pc_pc, pc_if, a_ex, pc_ex, pc_mem, pc_wb, a,rd_data_mem , PCsrc,      
            Regwrite_wb, ALUsrc_ex, Memtoreg_wb, Memread_mem, Memwrite_mem, Branch_ex, signal_cache,
            wr_data,ALU_result_wb,ALU_result_ex2,ALU_result_mem,rs1_data_ex,rs2_data_ex,imm,data_a_pc_ex,data_b_imm_ex,
            rd_wb,rs1_ex,rs2_ex,Aforward_sel,Bforward_sel,Nb_mem,zero_ex,ALUop_ex,bht_if,bht_old_ex,bht_new_ex,tag_val,pattern_ex, pattern_ex_new,br_inst_detect_ex,
            signal_1,br_inst_detect_pc,miss_ex);
input clk;
output [31:0] pc_imm,pred_pc_pc,pc_pc_next, pc_pc, pc_if, a_ex, pc_ex, pc_mem, pc_wb, a,rd_data_mem ;
output [31:0] wr_data,ALU_result_mem,ALU_result_wb,ALU_result_ex2,rs1_data_ex,rs2_data_ex,imm,data_a_pc_ex,data_b_imm_ex;
output [4:0] rd_wb,rs1_ex,rs2_ex;
output [2:0] Nb_mem;
output [1:0] bht_if,bht_old_ex,bht_new_ex,Aforward_sel,Bforward_sel;
output [10:0]ALUop_ex;
output [19:0] tag_val;
output [7:0] pattern_ex, pattern_ex_new;
output br_inst_detect_pc,miss_ex,PCsrc, Regwrite_wb, ALUsrc_ex, Memtoreg_wb, Memread_mem, Memwrite_mem, Branch_ex,zero_ex,br_inst_detect_ex,signal_1,signal_cache;
///////////////////////////////////////////////////////////////////////////////////////////
reg         PCsrc,k;
reg         en_pc, en_if,en_id,en_ex, en_mem,en_wb, rst_pc, rst_if,rst_id, rst_ex, rst_mem,en_t,rst_t,rst_wb;      
wire        en_pc1, en_if1,en_id1, en_ex1, en_mem1, rst_pc1, rst_if1,rst_id1,  rst_ex1, rst_mem1;
reg  [31:0] pc_4, pc_imm,pc_pc_next;
reg  [31:0] rs1_data_id, rs2_data_id;
wire [31:0] rs1_data_ex, rs2_data_ex;
wire [31:0]  pc_next,pc_pc_next1,pc_next_1,pc_next_2,pred_pc_pc, pc, pc_pc, pc_if, pc_id, pc_ex, pc_mem, pc_wb,pc_pc_pred,pred_new_pc_ex, pred_pc_ex;
wire [31:0]  a, a_id,a_32_t,a_32_if,a_32_id,a_32_ex,a_32_out,a_32,a_if , a_ex, data_a_pc_id, data_b_imm_id ,  imm,imm_ex, data_a_if, data_b_if,data_b_ex, data_a_ex ;
wire [31:0] ALU_result_ex_imm ,ALU_result_imm,ALU_result_ex,ALU_result_ex1,ALU_result_ex2,ALU_result_mem,ALU_result_wb,rd_data;
wire [31:0] wr_data,rs1_data_ex2,rd_data_mem,rd_data_wb,imm_out,Mux3_out1,Mux3_out2, rs2_data_mem, rs2_data_ex2,Mux3_out1_ex,Mux3_out2_ex;
wire        Regwrite,     ALUsrc,    Memtoreg,    Memread,    Memwrite,    Branch,zero,signal_1,signal_2,signal_3,br_inst_detect_pc;
//wire        Regwrite_id,  ALUsrc_id, Memtoreg_id, Memread_id, Memwrite_id, Branch_id,br_inst_detect_id;
wire        Regwrite_ex,  ALUsrc_ex, Memtoreg_ex, Memread_ex, Memwrite_ex, Branch_ex,zero_ex,br_inst_detect_ex,miss_ex;
wire        Regwrite_mem, Memtoreg_mem, Memread_mem, Memwrite_mem, Branch_mem,zero_mem;
wire        Regwrite_wb , Memtoreg_wb, PCsrc1, PCsrc2,PCsrc3,delay1,delay2;
wire [2:0]  Nb,Nb_id, Nb_ex, Nb_mem;
wire [1:0]  Aforward_sel, Bforward_sel, bht_old_ex , bht_new_ex,bht_pc, bht_id, bht_if;
wire [10:0] ALUop,ALUop_id, ALUop_ex; 
wire [4:0]  rs1_ex, rd_id,rd_ex, rs2_ex,rd_wb,rd_mem,rd_wb2;
wire [7:0]  pattern_ex, pattern_ex_new;
wire [6:0]  opcode;
wire [19:0] tag_val;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
initial begin
        PCsrc<=0;en_wb<=1; en_pc<=1; en_if<=1; en_id<=1; en_ex<=1; en_mem<=1; en_t<=1;
        rst_pc<=0 ;rst_wb<=0;rst_if<=0;rst_id<=0;rst_t<=0;rst_ex<=0;rst_mem<=0;
// pc_pc_next<=0;
PCsrc=0; 
      end
//////////////////////////////////////////////////////////////////////////////////////////
FF_PC    FF_PC           (clk, en_pc, rst_pc,pc_pc_next,
                                           pc_pc);                       
IMEM a2( pc_pc, a_32_out);
decoder a3(a_32_out,a);
assign pc_next = (a_32_out[1:0]==2'b11)?pc_pc+4:pc_pc+2;
assign opcode = a[6:0];
br_inst_detect a7(a[6:0],br_inst_detect_pc);
BHT a321(br_inst_detect_pc, br_inst_detect_ex, pc_pc, pc_ex, bht_new_ex, pattern_ex, pattern_ex_new,
     bht_pc);
BTB btt2(br_inst_detect_pc, br_inst_detect_ex, pc_pc, pc_ex, pc_imm, pattern_ex, pattern_ex_new,
      tag_val, pred_pc_pc);
    assign signal_1 = (pc_pc_next1[31:12] == tag_val) ? 1'b1 : 1'b0;
    assign signal_2 = bht_pc[1];
    and(signal_3,signal_1,signal_2);
    assign pc_next_1 = signal_3 ? pred_pc_pc : pc_next;
    assign pc_pc_next1 = ((PCsrc&miss_ex)==1) ? pc_imm : pc_next_1; 
    assign pc_pc_next = ((bht_old_ex[1]==1)&(miss_ex==1))?((a_32_ex[1:0]==2'b11)?pc_ex+4:pc_ex+2):pc_pc_next1;
FP_PC_IF ipcif ( clk, en_if, rst_if, pc_pc, a  ,a_32_out, bht_pc,
                                     pc_if , a_if ,a_32_if, bht_if );

/////////////////  IF ////////////////////////////////////////////////////////////////////
Regfile iregfile( Regwrite_wb, a_if[19:15], a_if[24:20], rd_wb, wr_data,
                               data_a_if, data_b_if);
assign ALUop = {a_if[30],a_if[14:12],a_if[6:0]};
imm a393(a_if ,imm);
assign Nb = a_if[14:12];
controlunit u144(a_if[6:0],Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch);

////////////////   ID ////////////////////////////////////////////////////////////////////
           
FP_ID_EX  I1 (clk, en_ex, rst_ex, 
              a_if,a_32_if,pc_if, data_a_if, data_b_if, a_if[11:7],imm,    ALUsrc, Regwrite,       Memtoreg,    Memread,    Memwrite,    Branch,    ALUop,    Nb,    a_if[19:15], a_if[24:20], bht_if,pattern_ex_new,
              a_ex,a_32_ex,pc_ex, data_a_ex, data_b_ex, rd_ex, imm_ex,ALUsrc_ex, Regwrite_ex, Memtoreg_ex, Memread_ex, Memwrite_ex, Branch_ex, ALUop_ex, Nb_ex, rs1_ex, rs2_ex, bht_old_ex, pattern_ex   );

////////////////   EX /////////////////////////////////////////////////////////////////////
wire [31:0] rd_data_cache;
wire signal_cache;
wire [31:0] rs1_data_ex_cache, rs2_data_ex_cache;
wire en_wb1;
wire AAforward_sel, BBforward_sel;
MUX3 a20(data_a_ex, ALU_result_mem, wr_data,Aforward_sel,rs1_data_ex);
MUX3 a21(data_b_ex, ALU_result_mem, wr_data,Bforward_sel,rs2_data_ex);
assign rs1_data_ex_cache = (AAforward_sel == 1 )?rd_data_cache:rs1_data_ex;
assign rs2_data_ex_cache = (BBforward_sel == 1 )?rd_data_cache:rs2_data_ex;
wire [31:0]data_b_imm_ex, data_a_pc_ex ;
wire [31:0]pc_imm_ex ;
assign pc_imm_ex = pc_ex + imm_ex;
assign data_a_pc_ex = ((a_ex[6:0]==7'b0010111)|(a_ex[6:0]==7'b1101111))?pc_ex : rs1_data_ex_cache ; // jal auipc
//assign data_b_id4 = ((a_id==7'b1100111)|(a_id==7'b1101111))?32'd4 : data_b_id;                     // jal jalr
assign data_b_imm_ex = (ALUsrc_ex)? imm_ex : rs2_data_ex_cache ; // jal jalr auipc 
ALU a9(data_a_pc_ex,data_b_imm_ex,ALUop_ex,zero_ex,ALU_result_ex);
assign ALU_result_ex1 = (a_ex[6:0]==7'b1100011)? pc_imm_ex: ALU_result_ex;
assign ALU_result_ex_imm = (a_ex[6:0]==7'b0110111)?imm_ex : ALU_result_ex1 ; // lui
assign ALU_result_ex2 = ((a_ex[6:0]==7'b1100111)|(a_ex==7'b1101111))? pc_ex +32'd4 : ALU_result_ex_imm;// jal jalr  rd <= pc +4 

assign pc_imm=ALU_result_ex1;
//and (Branch_ex , zero_ex,PCsrc);
assign PCsrc= Branch_ex & zero_ex;
always @(*)
 begin
if((PCsrc&miss_ex )==1)begin
rst_ex=1;
rst_id=1;rst_if=1; 
end else begin 
rst_id=0;rst_ex=0;
 rst_if=0;
end end
br_inst_detect br_inst_detect2(a_ex[6:0],br_inst_detect_ex);
compare compare2(br_inst_detect_ex, bht_old_ex[1], PCsrc,
                miss_ex);
fsm fsm2( ALU_result_ex, br_inst_detect_ex, bht_old_ex, miss_ex,
             bht_new_ex, pred_new_pc_ex);
shift_pattern shift_pattern1(br_inst_detect_ex, miss_ex, pattern_ex, bht_old_ex[1], 
                     pattern_ex_new);
FP_EX_MEM b1( clk ,en_mem,rst_mem,
             pc_ex,  ALU_result_ex2, zero,     rs2_data_ex_cache,   rd_ex, Regwrite_ex,  Memtoreg_ex, Memread_ex, Memwrite_ex,Branch_ex, Nb_ex,
             pc_mem, ALU_result_mem, zero_mem, rs2_data_mem,rd_mem,Regwrite_mem, Memtoreg_mem, Memread_mem, Memwrite_mem, Branch_mem, Nb_mem  );

/////////////////   MEM   /////////////////////////////////////////////////

cachemem cache1 (clk,Nb_mem,Memwrite_mem , Memread_mem , ALU_result_mem ,rs2_data_mem ,
             rd_data_cache,signal_cache);
forwarding a122(Regwrite_mem, Regwrite_wb,Regwrite_ex, rd_mem,rd_wb, rs1_ex,rs2_ex,ALU_result_mem,ALU_result_ex,signal_cache,
  Aforward_sel, Bforward_sel,AAforward_sel, BBforward_sel,Memread_mem, en_id1, en_if1, en_ex1, en_mem1,en_wb1,rst_pc1,rst_id1,delay1);
assign en_t =en_wb1;assign en_if=en_if1; assign en_id=en_id1;assign en_ex=en_ex1;//assign en_wb = delay1;
assign en_pc=en_mem1;assign rst_mem=rst_id1;//assign rst_wb=rst_ex1; 
data_mem   a10  (clk,Nb_mem, Memwrite_mem , Memread_mem , ALU_result_mem ,rs2_data_mem ,
             rd_data_mem);

FP_MEM_WB a95( clk ,en_wb,rst_wb,pc_mem,rd_mem,ALU_result_mem,Regwrite_mem, Memtoreg_mem,rd_data_mem,PCsrc3,delay1 ,
                                  pc_wb ,rd_wb,ALU_result_wb,Regwrite_wb ,Memtoreg_wb ,rd_data_wb,PCsrc2  ,delay2);
///////////////  WB ///////////////////////////////////////////////////////////////////
MUX u1(ALU_result_wb,rd_data_wb,wr_data,Memtoreg_wb);

endmodule 





module t_Main2;
reg clk;
wire [31:0]pc_imm,pred_pc_pc,pc_pc_next, pc_pc, pc_if, pc_id, pc_ex, pc_mem, pc_wb, a,rd_data_wb ;
wire PCsrc,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,zero,br_inst_detect_ex,signal_1,signal_cache;
wire br_inst_detect_pc,miss_ex;
wire [31:0]wr_data,ALU_result_wb,ALU_result_ex,ALU_result_mem,rs1_data_ex , rs2_data_ex,imm_ex,data_a_pc_ex,data_b_imm_ex;
wire [4:0] rd_wb,rs1_ex,rs2_ex;
wire [2:0] Nb;
wire [7:0] pattern_ex, pattern_ex_new;
wire [1:0]Aforward_sel,Bforward_sel,bht_pc,bht_old_ex,bht_new_ex;
wire [10:0]ALUop_ex;
wire [19:0] tag_val;

parameter time_out = 100;
Main2 a4(clk,
        pc_imm,pred_pc_pc,pc_pc_next, pc_pc, pc_if, pc_id, pc_ex, pc_mem, pc_wb, a,rd_data_wb ,PCsrc ,
        Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,signal_cache,
        wr_data,ALU_result_wb,ALU_result_ex,ALU_result_mem,rs1_data_ex , rs2_data_ex,imm_ex,data_a_pc_ex,data_b_imm_ex,
        rd_wb,rs1_ex,rs2_ex,Aforward_sel,Bforward_sel,Nb,zero,ALUop_ex,bht_pc,bht_old_ex,bht_new_ex,tag_val,pattern_ex, pattern_ex_new,br_inst_detect_ex
, signal_1,br_inst_detect_pc,miss_ex);
initial begin
	clk = 0;
end
always #5 clk = ~clk;


endmodule
