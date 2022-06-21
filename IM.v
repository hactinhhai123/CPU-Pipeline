
/******** Instruction Memmory Block ********/
module IMEM( addr, data_32);
input		[31:0]addr;
output	reg	[31:0]data_32;
reg [31:0] IMEM [1023:0];
reg [7:0] IMEM2 [1023:0];
reg [31:0] data;
integer i,j;
/********* Instruction Memmory *************/
initial begin
//$readmemh("E:/TestCode/pipeline_test.txt",IMEM);
//$readmemh("E:/TestCode/test_nen.txt",IMEM);
$readmemh("E:/TestCode/tinhgiaithua.txt",IMEM);
//$readmemh("E:/TestCode/test_day.txt",IMEM);
//$readmemh("E:/TestCode/test_load.txt",IMEM);
for ( i = 1 ; i<=1024; i= i+1) begin
data = IMEM[i];
 
IMEM2[i*4-1]=data[31:24];
IMEM2[i*4-2]=data[23:16];
IMEM2[i*4-3]=data[15:8];
IMEM2[i*4-4]=data[7:0];

end
end

//assign IMEM2[addr*4-1]=IMEM[addr][31:24];
		// {IMEM2[addr2-1],IMEM2[addr2-2],IMEM2[addr2-3],IMEM2[addr2-4]}=IMEM[addr];
		assign data_32 = {IMEM2[addr+3],IMEM2[addr+2],IMEM2[addr+1],IMEM2[addr]};
endmodule

