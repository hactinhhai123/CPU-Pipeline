module compare (en, pred_bit_ex, PCsrc,
                miss);
        input en ;
        input pred_bit_ex;
        input PCsrc;

        output reg miss;

        always @(*) begin
           if(en == 1'b0)  begin
               miss <= 1'b0;
           end else begin
               if(pred_bit_ex == PCsrc) begin
                   miss <= 1'b0;
               end else begin
                   miss <= 1'b1;
               end
           end
        end
endmodule
