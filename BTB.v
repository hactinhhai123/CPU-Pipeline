module BTB ( br_inst_detect, ID_EX_br_inst_detect,pc,ID_EX_pc, ID_EX_new_pred_pc_val,
             ID_EX_old_pattern,ID_EX_new_pattern,
             tag_val,pred_pc_val
);
//------------------------------------------------------------------------
        input           br_inst_detect,ID_EX_br_inst_detect;
        input [31:0]    pc, ID_EX_pc;
        input [31:0]    ID_EX_new_pred_pc_val;
        input [7:0]     ID_EX_old_pattern,ID_EX_new_pattern;

        output reg [19:0]   tag_val;
        output reg [31:0]   pred_pc_val;

        wire [10:0]      tag_predpc_wr_addr;
        wire [10:0]      tag_predpc_rd_addr;

        reg [19:0]      tag_table [1024:0];
        reg [31:0]      pred_pc_table [1024:0];
//------------------------------------------------------------------------
        assign tag_predpc_wr_addr = ID_EX_pc[11:2] ;//^  ID_EX_old_pattern
        assign tag_predpc_rd_addr = pc[11:2];//^ID_EX_new_pattern;
        //assign tag_predpc_wr_addr = ID_EX_pc[8:1] ^  ID_EX_old_pattern;
        //assign tag_predpc_rd_addr = pc[8:1]    ^ ID_EX_new_pattern;
//------------------------------------------------------------------------
      
integer i,j; 
        initial begin
            for ( i = 0 ; i<=1025 ; i= i+1)begin 
           tag_table[i] = 20'd0;
          
        pred_pc_table[i] = 32'd0;
        end 
    end
 always @(*) begin
            case ({br_inst_detect,ID_EX_br_inst_detect})
                2'b00: begin
                    tag_val <= 0;
                    pred_pc_val <= 0;
                    tag_table[tag_predpc_wr_addr] <= tag_table[tag_predpc_wr_addr];
                    pred_pc_table[tag_predpc_wr_addr] <= pred_pc_table[tag_predpc_wr_addr];
                end

                2'b01: begin
                   tag_val <= 0;
                   pred_pc_val <= 0;
                   tag_table[tag_predpc_wr_addr] <= ID_EX_pc[31:12];
                   pred_pc_table[tag_predpc_wr_addr] <= ID_EX_new_pred_pc_val;
                end

                2'b10: begin
                    tag_val <= tag_table[tag_predpc_rd_addr];
                    pred_pc_val <= pred_pc_table[tag_predpc_rd_addr];
                    tag_table[tag_predpc_wr_addr] <= tag_table[tag_predpc_wr_addr];
                    pred_pc_table[tag_predpc_wr_addr] <= pred_pc_table[tag_predpc_wr_addr];
                end 

                2'b11: begin
                    tag_val <= tag_table[tag_predpc_rd_addr];
                    pred_pc_val <= pred_pc_table[tag_predpc_rd_addr];
                    tag_table[tag_predpc_wr_addr] <= ID_EX_pc[31:12];
                    pred_pc_table[tag_predpc_wr_addr] <= ID_EX_new_pred_pc_val;
                end

                default: begin
                    tag_val <= 0;
                    pred_pc_val <=0;
                    tag_table[tag_predpc_wr_addr] <= 0;
                    pred_pc_table[tag_predpc_wr_addr] <= 0;
                end
            endcase
        end

endmodule
