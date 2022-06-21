module cachemem(clk,Nb,mem_wr , mem_rd , addr ,wr_data , rd_data_out,signal);
input [31:0]addr;
input [2:0] Nb;
input mem_wr , mem_rd,clk ; 
input [31:0] wr_data;
output [31:0]rd_data_out ;
output signal;
reg [52:0]cache[12400:0]; // 4 20  31 
reg [52:0]data_m,data_b,data_h,data_w,data_o;
reg [31:0]rd_data;
integer i;
initial begin
for (i=0;i<102400;i=i+1)
cache[i]=0;
  //rd_data <= 32'b0;
end
always @(* ) 
begin 
if (mem_wr ==1) begin
             
             data_b<= {1'b1,addr[31:12], 24'd0,wr_data[7:0]};
             data_h<= {1'b1,addr[31:12], 16'd0,wr_data[15:0]};
             data_w<= {1'b1,addr[31:12], wr_data};
             //d<= { 16'd0,wr_data[15:0]};
                case(Nb)
3'b000 :   cache[addr[11:0]]<= data_b ; // sb
3'b001 :   cache[addr[11:0]]<= data_h ; // sh
3'b010 :   cache[addr[11:0]]<= data_w ;   // sw
                endcase
              end 
  
  else if (mem_rd ==1)begin
               data_m<=cache[addr[11:0]];
                case (Nb)
       3'b010 :   rd_data<=data_m;   // lw
       3'b000 :   rd_data<={24'd0,data_m[7:0]};   // lb
       3'b001 :   rd_data<={16'd0,data_m[15:0]};   // lh
       3'b100 :   rd_data<={{24{data_m[7]}},data_m[7:0]};   // lbu
       3'b101 :   rd_data<={{16{data_m[15]}},data_m[15:0]};   // lhu
       
                endcase
                 end 

data_o<= cache[addr[11:0]];
end
assign rd_data_out = ((data_m[52]==1)&&(addr[31:12]==data_m[51:32]))? rd_data:32'd0;
assign signal = ((data_m[52]==1)&&(addr[31:12]==data_m[51:32])&&(mem_rd ==1)); 
endmodule
