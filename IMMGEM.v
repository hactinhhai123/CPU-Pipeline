module imm(in,out);
  input [31:0]in;
  output reg [31:0]out;
  reg[31:0]out1;
always@(in)
case (in[6:0])
  55: out={in[31:12],12'b0}; //LUI, 0110111
  23: out={in[31:12],12'b0}; //AUIPC, 0010111
  111: begin out1={in[31],in[19:12],in[20],in[30:21],12'b0}; out=out1>>>11; end //JAL, 1101111
  103: begin out={20'b0,in[31:20]};  end //JALR, 1100111
  99: begin out1={in[31],in[7],in[30:25],in[11:8],20'b0}; out=out1>>>19; end //B, 1100011
  3: begin out1={in[31:20],20'b0}; out=out1>>>20; end //L, 0000011
  35: begin out1={in[31:25],in[11:7],20'b0}; out=out1>>>20; end //S, 0100011
  19: begin out1={in[31:20],20'b0}; out=out1>>>20; end //ALUopI, 0010011
  default: out=32'b0;
endcase
endmodule


module t_imm;
  reg [31:0]in;
  wire [31:0]out;
  imm test(in,out);
  initial begin
     #0 in=32'b0000_1010_0110_1001_0110_1010_0011_0111;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0001_0111;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0110_1111;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0110_0111;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0110_0011;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0000_0011;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0010_0011;
    #10 in=32'b0000_1010_0110_1001_0110_1010_0001_0011;
  end
endmodule

