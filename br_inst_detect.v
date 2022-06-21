module br_inst_detect(opcode,br_inst_detect);
        input [6:0] opcode;
        output reg br_inst_detect;
        initial begin
            br_inst_detect <= 1'b0;
        end

        always @(*) begin
           if((opcode == 7'b1101111)||(opcode == 7'b1100111)||(opcode == 7'b1100011)||(opcode == 7'b0010111)) begin // JAL JALR B AUIPC 
               br_inst_detect = 1'b1;
           end else begin
               br_inst_detect = 1'b0;
           end
        end
endmodule
