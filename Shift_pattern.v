module shift_pattern(en, miss, pattern_old_ex, pred_bit_ex, 
                     pattern_new_ex);
//------------------------------------------------------------------------
    input       en;
    input  [7:0] pattern_old_ex;
    input       miss;
    input       pred_bit_ex;
    output reg [7:0] pattern_new_ex;
//------------------------------------------------------------------------
    initial begin
        pattern_new_ex <= 8'b0;
    end
    always @(*) begin
        if(en == 1'b0) begin
            pattern_new_ex <= pattern_new_ex;
        end else begin
            case(pred_bit_ex) 
                1'b0: begin // Predict = !taken, miss = taken, !miss = !taken
                    if(miss == 1'b0) begin 
                        pattern_new_ex <= {1'b0,pattern_old_ex[7:1]};
                    end else begin
                        pattern_new_ex <= {1'b1,pattern_old_ex[7:1]};
                    end
                end

                1'b1: begin
                    if(miss == 1'b0) begin 
                        pattern_new_ex <= {1'b1,pattern_old_ex[7:1]};
                    end else begin
                        pattern_new_ex <= {1'b0,pattern_old_ex[7:1]};
                    end
                end

                default: pattern_new_ex <= 8'b0;
            endcase
        end
    end
endmodule
