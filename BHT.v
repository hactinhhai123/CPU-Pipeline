module BHT (br_inst_detect,
           ID_EX_br_inst_detect,
            pc,
            ID_EX_pc,

            ID_EX_new_bht,

            ID_EX_old_pattern,
            ID_EX_new_pattern,

            bht_out
);
    input               br_inst_detect;
    input               ID_EX_br_inst_detect;
    input [31:0]        ID_EX_pc,pc;
    input [1:0]         ID_EX_new_bht;
    input [7:0]         ID_EX_old_pattern,ID_EX_new_pattern;
    output reg [1:0]    bht_out;

    reg [1:0] bht_mem [1023:0];
    wire ID_EX_br_inst_detect;
    wire[8:0]          bht_wr_addr;
    wire[8:0]          bht_rd_addr;
    assign bht_wr_addr = ID_EX_pc[11:1]; //^ ID_EX_old_pattern;
    assign bht_rd_addr = pc[11:1]; //^ ID_EX_new_pattern;
    //assign bht_wr_addr = ID_EX_pc[8:1] ^ ID_EX_old_pattern;
    //assign bht_rd_addr = pc[8:1] ^ ID_EX_new_pattern;
integer i;
    initial begin
for ( i = 0 ; i<=1023; i= i+1) begin
         bht_out =2'b00;
        bht_mem[i] = 2'b00; end
    end

       

    always @(*) begin
        case({br_inst_detect,ID_EX_br_inst_detect}) 
            2'b00: begin                                    // neu 2 lenh o pc và ex là 2 lenh khong nhay
              // bht_mem[bht_wr_addr] <= bht_mem[bht_wr_addr];    // không thay doi gia tri o bht_mem
               bht_out <= 2'b00;                                
            end

            2'b01: begin                                   // neu lenh o pc khong nhay  và ex là lenh nhay
                bht_mem[bht_wr_addr] <= ID_EX_new_bht;     // luu gia tri nhay moi vao bht_mem
                bht_out <= 2'b00;
            end

            2'b10: begin                                    // neu lenh o pc nhay  và ex là lenh không nhay
               //bht_mem[bht_wr_addr] <= bht_mem[bht_wr_addr]; // không thay doi gia tri o bht_mem
               bht_out <= bht_mem[bht_rd_addr];             // xuat gia tri bht moi 
            end
            2'b11: begin                                   // neu lenh o pc nhay  và ex là lenh không nhay
               bht_mem[bht_wr_addr] <= ID_EX_new_bht;      // luu gia tri nhay moi vao bht_mem
               bht_out <= bht_mem[bht_rd_addr];             // xuat gia tri bht moi 
            end

            default: begin
                bht_mem[bht_wr_addr] <= 2'b00;
                bht_out <= 2'b00;
            end
        endcase
    end
endmodule
