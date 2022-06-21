
module decoder ( a , b );
input [31:0] a; 
output [31:0] b ; 
wire [31:0]a ; 
reg [31:0]b ; 

always @( a ) 
begin 
if ( a[1:0] == 2'b11 ) 
     b <= a ; 
 
 else    if ( a[1:0]==2'b00)
         
        case (a[15:13]) 
                             // [         imm[11:0]         ]     [rs1] [funct3][ rd  ] [ opcode ]
            3'b000 : b[31:0]<= {4'd0,a[3:2],a[12],a[6:4],2'd0 ,5'b00010 ,3'b010,a[11:7], 7'b0000011}       ; // C.LWSP -> lw rd, offset[7:2](x2)
                             // [  imm[11:5]    ] [rs2] [   rs1  ][funct3][ imm[4:0]  ] [ opcode ]
            3'b001 : b[31:0]<= {4'd0,a[8:7],a[12],a[6:2],5'b00010 ,3'b010,a[11:9],2'd0, 7'b0100011}  ; // C.SWSP -> sw rs2, offset[7:2](x2)
                             // [             imm[11:0]             ][ rs1  ] [funct3] [   rd    ]  [ opcode ]
            3'b010 : b[31:0]<= {4'd0,a[10:7],a[12:11],a[5],a[6],2'b0,5'b00010 ,3'b000,2'b0,a[4:2], 7'b0010011}   ; // C.ADDI4SPN -> addi rd0, x2, zimm[9:2]
                             // [   imm[11:0]   ] [ rs1 ][funct3][ rd ]  [ opcode ]
            3'b011 : b[31:0]<= {6'd0,a[12],a[6:2],a[11:7],3'b001,a[11:7], 7'b0010011}   ; // C.SLLI ->  slli rd, rd, shamt[5:0]
                             // [   0000000 shamt      ][ rs1  ][funct3][  rd ] [ opcode ]
            3'b100 : b[31:0]<= {7'd0,a[12],a[6:2]      ,a[11:7] ,3'b101,a[11:7], 7'b0010011}       ; // 
       
            endcase
        
 else if( a[1:0]==2'b10) 
           
        case (a[15:13])
                             // [         imm[11:0]         ] [    rs1     ][funct3][     rd    ] [ opcode ]
            3'b000 : b[31:0]<= {5'd0,a[5],a[12:10],a[6],2'd0   ,2'b00,a[9:7],3'b010,2'b00,a[4:2], 7'b0000011}       ; // C.LW -> lw rd0, offset[6:2](rs10)
                             // [   imm[11:5]        ][    rs2     ][   rs1   ][funct3][     imm[4:0]    ][ opcode ]
            3'b001 : b[31:0]<= {5'd0,a[5],a[12]        ,2'd0,a[4:2],2'd0,a[9:7],3'b010,a[11:10],a[6],2'b0,7'b0100011}  ; // C.SW -> sw rs20, offset[6:2](rs10)                  
            3'b010 : begin 
                     if (a[6:5]==2'b00)
                            // [  imm[11:]   ][   rs1   ][funct3][   rd    ][ opcode ]
                     b[31:0]<= {9'd0,a[12:10],2'd0,a[9:7],3'b000,2'b0,a[4:2], 7'b0010011}   ; // C.ADDIN -> addi rd0, rs10, nzimm[2:0]
                     else if (a[6:5]==2'b01)
                            // [  imm[11:]   ][   rs1   ][funct3][   rd    ][ opcode ]
                     b[31:0]<= {9'd0,a[12:10],2'd0,a[9:7],3'b111,2'b0,a[4:2], 7'b0010011}   ; // C.ANDIN -> andi rd0, rs10, nzimm[2:0]
                     else if (a[6:5]==2'b10)
                            // [  imm[11:]   ][   rs1   ][funct3][   rd    ][ opcode ]
                     b[31:0]<= {9'd0,a[12:10],2'd0,a[9:7],3'b110,2'b0,a[4:2], 7'b0010011}   ; // C.ORIN -> ori rd0, rs10, nzimm[2:0]
                     else if (a[6:5]==2'b01)
                            // [  imm[11:]   ][   rs1   ][funct3][   rd    ][ opcode ]
                     b[31:0]<= {9'd0,a[12:10],2'd0,a[9:7],3'b100,2'b0,a[4:2], 7'b0010011}   ; // C.XORIN -> xori rd0, rs10, nzimm[2:0]
                     
                    end 
            3'b011:  begin
                     if (a[6:5]==2'b00)
                            //  [  funct7 ][   rs2   ][    rs1   ][funct3][   rd      ][ opcode ]
                     b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b000,2'b0,a[12:10], 7'b0110011}   ; // C.ADD3 -> add rd0, rs10, rs20
                     else if (a[6:5]==2'b01)
                            // [  funct7  ][   rs2   ][    rs1   ][funct3][   rd      ][ opcode ]
                     b[31:0]<= {7'b0100000,2'd0,a[4:2],2'd0,a[9:7],3'b000,2'b0,a[12:10], 7'b0110011}   ; // C.SUB3 -> sub rd0, rs10, rs20
                     else if (a[6:5]==2'b10)
                            // [  funct7  ][   rs2   ][    rs1   ][funct3][   rd      ][ opcode ]
                     b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b111,2'b0,a[12:10], 7'b0110011}   ; // C.AND3 -> and rd0, rs10, rs20
                     else if (a[6:5]==2'b11)
                            // [  funct7  ][   rs2   ][    rs1   ][funct3][   rd      ][ opcode ]
                     b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b110,2'b0,a[12:10], 7'b0110011}   ; // C.OR3 -> or rd0, rs10, rs20
                     
                    end  
                     // [   0000000 shamt      ][ rs1  ][funct3][  rd ] [ opcode ]
            3'b100 : b[31:0]<= {2'b01,5'd0,a[12],a[6:2],a[11:7] ,3'b101,a[11:7], 7'b0010011}       ; // C.CSRAI -> srai rd, rd, shamt[5:0]      
            3'b101 : begin
                                                    //[7'd0000  ][  rs2  ][    rs1   ]  [funct3] [  rd   ][  opcode  ]
            if({a[15:10],a[6:5]}==8'b10100000)         b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b100,2'd0,a[9:7], 7'b0110011}  ; // C.XOR -> xor rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100001)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b001,2'd0,a[9:7], 7'b0110011}  ; // C.SLL -> sll rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100010)   b[31:0]<= {2'b01,5'd0,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[9:7], 7'b0110011}  ; // C.SRL -> srl rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100011)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[9:7], 7'b0110011}  ; // C.SRA -> sra rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100100)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b010,2'd0,a[9:7], 7'b0110011}  ; // C.SLT -> slt rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100101)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b011,2'd0,a[9:7], 7'b0110011}  ; // C.SLTU -> sltu rd0, rd0, rs20
                                                                 //[7'd0000  ][  rs2  ][    rs1   ]  [funct3] [  rd   ][  opcode  ]
            else  if({a[15:10],a[6:5]}==8'b10100110)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b001,2'd0,a[4:2], 7'b0110011}  ; // C.SLLR -> sll rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10100111)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[4:2], 7'b0110011}  ; // C.SRLR -> srl rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10101000)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b010,2'd0,a[4:2], 7'b0110011}  ; // C.SLTR -> slt rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10101001)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b011,2'd0,a[4:2], 7'b0110011}  ; // C.SLTUR -> sltu rd0, rs10, rd0
            
                     end 
                      //c.mv --> add rd,x0,rs2  rs2#0
            3'b110 : if(a[12]==1'b0 && a[11:7]!=5'b0 && a[6:2]!=5'h0)
                     b[31:0]={7'b0,a[6:2],5'h0,3'b000,a[11:7],7'b0110011};
     
                      //c.add --> ADD rd,rd,rs2, rs2#0
                    else if(a[12]==1'b1 && a[11:7]!=5'b0 && a[6:2]!=5'h0) 
                     b[31:0]={7'b0,a[6:2],a[11:7],3'b000,a[11:7],7'b0110011};
            endcase 
 else if( a[1:0]==2'b01)
         
        case (a[15:13]) 
                             // [       imm[20|10:0|11|19:12]      ] [  rd   ] [ opcode ]
            3'b000 : if (a[12:2]==11'b0)
                     b[31:0]<={25'b0,7'b0010011};            // nop if nzim=0, rd=0 nop==addi xo,xo,0
                     else
                     b[31:0]<= {3'd0,a[8:7],a[2],a[6:3],a[12],8'd0 ,5'b00000, 7'b1101111}       ; // C.J -> jal x0, offset[11:1]
            3'b001 : b[31:0]<= {3'd0,a[8:7],a[2],a[6:3],a[12],8'd0 ,5'b00001, 7'b1101111}       ; // C.JAL -> jal x1, offset[11:1]
                             // [     imm[12|10:5|  ][rs2] [     rs1    ][funct3][ imm4:1|11] [ opcode ]
            3'b010 : b[31:0]<= {3'd0,a[12:10],a[2]  ,5'd0 ,2'b00,a[9:7] ,3'b000,a[6:3],1'b0, 7'b1100011}       ; // C.BEQZ ->beq rs10, x0, offset[8:1]
            3'b011 : b[31:0]<= {3'd0,a[12:10],a[2]  ,5'd0 ,2'b00,a[9:7] ,3'b001,a[6:3],1'b0, 7'b1100011}       ; // C.BNEZ ->bne rs10, x0, offset[8:1]
                             // [     imm[11:0|] [  rs  ][funct3][  rd ] [ opcode ]
            3'b100 : b[31:0]<= {{6{a[12]}},a[12],a[6:2] ,5'd0 ,3'b000,a[11:7], 7'b0010011}       ; // C.LI -> addi rd, x0, nzimm[5:0]
                             // [       imm[31:12]     ] [  rd ] [ opcode ]
            3'b101 : b[31:0]<= {{14{a[12]}},a[12],a[6:0],12'd0, a[11:7], 7'b0110111}       ; // C.LUI -> lui rd, nzimm[17:12]
                             // [         imm[11:0|    ] [  rs  ][funct3][  rd ] [ opcode ]
            3'b110 : b[31:0]<= {{6{a[12]}},a[12],a[6:2] ,a[11:7],3'b000,a[11:7], 7'b0010011}       ; // C.ADDI -> addi rd, rd, nzimm[5:0]
            3'b111 : if ( a[11:7]!=5'd0)
                     b[31:0]<= {    {6'd0},a[12],a[6:2] ,a[11:7],3'b000,a[11:7], 7'b0010011}       ; // C.ADDIW -> addiw rd, rd, imm[5:0]
                     else
                     b[31:0]<= {{2{a[12]}},a[12],a[4:2],a[5],a[6],a[11:7],3'b000,a[11:7],7'b0010011}       ; // C.ADDI16SP ->  addi x2, x2, nzimm[9:4]
                             //[imm[12|10:5]][  rs2  ][    rs1   ][funct3][imm[4:1][11]][ opcode ]
            /*3'b101 : b[31:0]<= {6'd0,a[2]   ,5'b00000,2'b00,a[9:7],3'b100 ,a[6:3],1'b0, 7'b1100011}       ; // C.BLTZ -> blt rs10, x0, offset[8:1]
            3'b110 : b[31:0]<= {6'd0,a[2]   ,5'b00000,2'b00,a[9:7],3'b101 ,a[6:3],1'b0, 7'b1100011}       ; // C.BGEZ -> bge rs10, x0, offset[8:1]
                             // [      imm[11:0]      ][ rs1  ][funct3][  rd  ] [ opcode ]
            3'b111 : b[31:0]<= {6'd0,a[12],a[6:2],a[11:7] ,3'b000,a[11:7], 7'b0010011}   ; // C.ANDI -> andi rd, rd, nzimm[5:0]
                            
*/

            endcase     
  /*else if( a[1:0]==2'b11)
        case (a[15:13])
                             //[imm[12|10:5]][  rs2  ][    rs1   ][funct3][imm[4:1][11]][ opcode ]
            3'b000 : b[31:0]<= {6'd0,a[2]   ,5'b00000,2'b00,a[9:7],3'b100 ,a[6:3],1'b0, 7'b1100011}       ; // C.BLTZ -> blt rs10, x0, offset[8:1]
            3'b001 : b[31:0]<= {6'd0,a[2]   ,5'b00000,2'b00,a[9:7],3'b101 ,a[6:3],1'b0, 7'b1100011}       ; // C.BGEZ -> bge rs10, x0, offset[8:1]
                             // [      imm[11:0]      ][ rs1  ][funct3][  rd  ] [ opcode ]
            3'b010 : b[31:0]<= {6'd0,a[12:10],a[12],a[11:7] ,3'b000,a[11:7], 7'b0010011}   ; // C.ANDI -> andi rd, rd, nzimm[5:0]
                             // [   0000000 shamt      ][ rs1  ][funct3][  rd ] [ opcode ]
            3'b011 : b[31:0]<= {7'd0,1'd0,a[6:2]       ,a[11:7] ,3'b001,a[11:7], 7'b0010011}       ; // C.CSLLIW -> slliw rd, rd, shamt[4:0]
            3'b100 : b[31:0]<= {7'd0,a[12],a[6:2]      ,a[11:7] ,3'b101,a[11:7], 7'b0010011}       ; // C.CSRLI -> srli rd, rd, shamt[5:0]
            3'b101 : b[31:0]<= {2'b01,5'd0,a[12],a[6:2],a[11:7] ,3'b101,a[11:7], 7'b0010011}       ; // C.CSRAI -> srai rd, rd, shamt[5:0]
            3'b110 : begin                                   
                                                    //[7'd0000  ][  rs2  ][    rs1   ]  [funct3] [  rd   ][  opcode  ]
            if({a[15:10],a[6:5]}==8'b10100000)         b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b100,2'd0,a[9:7], 7'b0110011}  ; // C.XOR -> xor rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100001)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b001,2'd0,a[9:7], 7'b0110011}  ; // C.SLL -> sll rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100010)   b[31:0]<= {2'b01,5'd0,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[9:7], 7'b0110011}  ; // C.SRL -> srl rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100011)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[9:7], 7'b0110011}  ; // C.SRA -> sra rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100100)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b010,2'd0,a[9:7], 7'b0110011}  ; // C.SLT -> slt rd0, rd0, rs20
            else  if({a[15:10],a[6:5]}==8'b10100101)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b011,2'd0,a[9:7], 7'b0110011}  ; // C.SLTU -> sltu rd0, rd0, rs20
                                                                 //[7'd0000  ][  rs2  ][    rs1   ]  [funct3] [  rd   ][  opcode  ]
            else  if({a[15:10],a[6:5]}==8'b10100111)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b001,2'd0,a[4:2], 7'b0110011}  ; // C.SLLR -> sll rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10101000)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b101,2'd0,a[4:2], 7'b0110011}  ; // C.SRLR -> srl rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10101001)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b010,2'd0,a[4:2], 7'b0110011}  ; // C.SLTR -> slt rd0, rs10, rd0
            else  if({a[15:10],a[6:5]}==8'b10101010)   b[31:0]<= {7'd0      ,2'd0,a[4:2],2'd0,a[9:7],3'b011,2'd0,a[4:2], 7'b0110011}  ; // C.SLTUR -> sltu rd0, rs10, rd0
                     end 
       endcase */
end

endmodule
module t_decoder;
  reg [31:0]a;
  wire [31:0]b;
  decoder t(a,b);
  initial begin
     #0 a=32'b0000_0000_0000_0000_0000_1010_0011_0101;
    #10 a=32'b0000_0000_0000_0000_0110_1010_0001_0100;
    #10 a=32'b0000_0000_0000_0000_0110_1010_0110_1111;
    /*#10 in=32'b0000_0000_0000_0000_0110_1010_0110_0111;
    #10 in=32'b0000_0000_0000_0000_0110_1010_0110_0011;
    #10 in=32'b0000_0000_0000_0000_0110_1010_0000_0011;
    #10 in=32'b0000_0000_0000_0000_0110_1010_0010_0011;
    #10 in=32'b0000_0000_0000_0000_0110_1010_0001_0011;*/
  end
endmodule
