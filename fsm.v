module fsm( br_addr, br_inst_detect_ex, old_bht_ex, miss,
             nex_bht_ex, new_pred_ex);
//-----------------------Signal declairation------------------------------
        input[31:0]       br_addr;
        input             br_inst_detect_ex;
        input[1:0]        old_bht_ex;
        input             miss;
        output reg [1:0]  nex_bht_ex;
        output reg [31:0] new_pred_ex;

        parameter ST = 2'b11; // Strong taken;
        parameter WT = 2'b10; // Weak   taken;
        parameter WNT= 2'b01; // Weak not taken;
        parameter SNT= 2'b00; // Strong not taken;
//------------------------------------------------------------------------            
        always @(*) begin
            if(br_inst_detect_ex==0) begin  // Not to be detected as a branch instruction
               nex_bht_ex  = 2'b00;
               new_pred_ex = 32'b00; 
            end else begin                     // To be detected as a branch instruction
                case(old_bht_ex) 
                    ST: begin
                        if(miss == 1'b0) begin // Predict = taken, infact = taken
                        nex_bht_ex  = ST;
                        new_pred_ex = br_addr;
                        end else begin         // Predict = taken, infact = !taken
                        nex_bht_ex  = WT;
                        new_pred_ex = br_addr;
                        end
                    end

                    WT: begin
                        if(miss == 1'b0) begin // Predict = taken, infact = taken
                        nex_bht_ex  = ST;
                        new_pred_ex = br_addr;
                        end else begin         // Predict = taken, infact = !taken
                        nex_bht_ex  = SNT;
                        new_pred_ex = br_addr; 
                        end
                    end

                    WNT:begin
                        if(miss == 1'b0) begin // Predict = !taken, infact = !taken
                        nex_bht_ex  = SNT;
                        new_pred_ex = br_addr;
                        end else begin         // Predict = !taken, infact = taken
                        nex_bht_ex  = WT;
                        new_pred_ex = br_addr;
                        end
                    end

                    SNT:begin
                        if(miss == 1'b0) begin // Predict = !taken , infact = !taken
                        nex_bht_ex  = SNT;
                        new_pred_ex = br_addr;
                        end else begin         // Predict = !taken, infact = taken
                        nex_bht_ex  = WNT;
                        new_pred_ex = br_addr; 
                        end
                    end
                endcase
            end
        end
endmodule
