module forwarding(EX_MEM_RegWrite, MEM_WB_RegWrite,Regwrite3 ,     
	EX_MEM_rd, MEM_WB_rd,                       
	ID_EX_rs1, ID_EX_rs2,ALU_result,ALU_result1,signal_cache,
         Aforward_sel, Bforward_sel,AAforward_sel, BBforward_sel,
	EX_MEM_WREN,  
	enable_PC,enable_IF_ID,enable_ID_EX,enable_EX_MEM,enable_MEM_WB,
	reset_EX_MEM,reset_MEM_WB,
        delay);
//----------------------------------------------------------------------------//
       input [4:0] EX_MEM_rd,MEM_WB_rd;
       
       input [4:0] ID_EX_rs1,ID_EX_rs2;
       
       input EX_MEM_RegWrite,MEM_WB_RegWrite,EX_MEM_WREN,Regwrite3,signal_cache;
     
       input [31:0] ALU_result,ALU_result1;
   
       output reg [1:0] Aforward_sel,Bforward_sel;
       output reg AAforward_sel, BBforward_sel;
       
       output reg enable_PC,enable_IF_ID, enable_ID_EX, enable_EX_MEM, enable_MEM_WB;
       
       output reg reset_EX_MEM,reset_MEM_WB;
   
       output reg delay;
//----------------------------------------------------------------------------//
       // 00: NoFoward
       // 01: From WB
       // 10: From MEM
//-----------------------------------------------------------------------------//
       initial begin
	       enable_IF_ID = 1'b1;
	       enable_ID_EX = 1'b1;
	       enable_EX_MEM= 1'b1;
	       enable_MEM_WB= 1'b1;
	       enable_PC =1'b1;
	       reset_EX_MEM = 1'b0;
           reset_MEM_WB = 1'b0;
	      
		   Aforward_sel = 2'b00;
           Bforward_sel = 2'b00;
       end
//-----------------------------------------------------------------------------//
//--------------------------- A forwarding -----------------------------------//
       always@(*) 
			begin
               Aforward_sel = 2'b00;
              //FORWARD A from MEM 
				if((EX_MEM_RegWrite == 1'b1) && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs1)) 
                    begin
						Aforward_sel = 2'b01;
                    end
				//FORWARD A from WB	      
				else if((MEM_WB_RegWrite == 1'b1) && (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs1))
                    begin
						Aforward_sel = 2'b10;
					end
            end
//--------------------------- B forwarding ------------------------------------//
       always@(*)
			begin
               Bforward_sel = 2'b00;
				//FORWARD B from MEM
				if((EX_MEM_RegWrite == 1'b1) && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs2)) 
					begin
						Bforward_sel = 2'b01;
					end
				//FORWARD B from WB
				else if((MEM_WB_RegWrite == 1'b1)&& (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs2))
					begin
						Bforward_sel = 2'b10;
                    end
            end

 //---------------------------------- DETECT LOAD --------------------------------------//
     always@(*) 
		begin
            enable_IF_ID = 1'b1;
            enable_ID_EX = 1'b1;
            enable_EX_MEM= 1'b1;
            enable_MEM_WB= 1'b1;
             enable_PC =1'b1;
              delay =1'b0;AAforward_sel = 1'b0; BBforward_sel=1'b0;
			reset_EX_MEM = 1'b0;
			reset_MEM_WB = 1'b0;
               if((EX_MEM_RegWrite == 1'b1)&& (EX_MEM_rd != 5'b0)&& (EX_MEM_WREN  == 1'b1)&& ((EX_MEM_rd == ID_EX_rs1)|| (EX_MEM_rd == ID_EX_rs2)))
              // if((MEM_WB_rd  == 1'b1)&&(Regwrite3  == 1'b1) && (EX_MEM_rd != 5'b0)&& (EX_MEM_WREN  == 1'b1)&& ((EX_MEM_rd == ID_EX_rs1)|| (EX_MEM_rd == ID_EX_rs2))) 
	                begin
                       if ((signal_cache ==1 )   && (EX_MEM_rd == ID_EX_rs1)) AAforward_sel <= 1'b1;
                        else if ((signal_cache ==1 )&& (EX_MEM_rd == ID_EX_rs2)) BBforward_sel <= 1'b1;
                        else
                        begin   
                        enable_EX_MEM= 1'b0; enable_IF_ID = 1'b0;
                    enable_ID_EX = 1'b0;enable_PC =1'b0;
                       reset_EX_MEM = 1'b1; delay =1'b1;reset_MEM_WB = 1'b1;
                    end
end
              /* if(({signal_branch,miss} == 2'b01) || ({signal_branch,miss} == 2'b11) ||((EX_MEM_RegWrite == 1'b1) && (EX_MEM_rd != 5'b0)&& (EX_MEM_MemRead == 1'b1)&& ((EX_MEM_rd == ID_EX_rs1)|| (EX_MEM_rd == ID_EX_rs2)))) begin
                       enable_IF_ID = 1'b0;
                       enable_ID_EX = 1'b0;
               end*/
                end

			/*if((Regwrite3 == 1'b1) && (MEM_WB_rd != 5'b0) && (EX_MEM_WREN == 1'b1) 
				&& (ALU_result ==ALU_result1 ) )
				begin
                    enable_IF_ID = 1'b0;
                    enable_ID_EX = 1'b0;
                    enable_EX_MEM= 1'b0;
                     enable_PC =1'b0;
                  
					reset_EX_MEM = 1'b1;
                             delay =1'b1;
            
                end
		end*/
endmodule

module tea_fr;
reg [4:0] EX_MEM_rd,MEM_WB_rd;
       
       reg[4:0] ID_EX_rs1,ID_EX_rs2;
       
     reg EX_MEM_RegWrite,MEM_WB_RegWrite,EX_MEM_WREN;

       wire [1:0] Aforward_sel,Bforward_sel;
       
       wire  enable_PC,enable_IF_ID, enable_ID_EX, enable_EX_MEM, enable_MEM_WB;
       
     wire  reset_EX_MEM,reset_MEM_WB;


 forwarding a4(EX_MEM_RegWrite, MEM_WB_RegWrite,            
	EX_MEM_rd, MEM_WB_rd,                       
	ID_EX_rs1, ID_EX_rs2,
         Aforward_sel, Bforward_sel,
	EX_MEM_WREN,  
	enable_PC,enable_IF_ID,enable_ID_EX,enable_EX_MEM,enable_MEM_WB,
	reset_EX_MEM,reset_MEM_WB);
//----------------------------------------------------------------------------//

initial begin 
#10  EX_MEM_rd =1;MEM_WB_rd=2;
       
    ID_EX_rs1=1;ID_EX_rs2=3;
       
 EX_MEM_RegWrite=1;MEM_WB_RegWrite=1;EX_MEM_WREN=0;

    end   


   endmodule     
