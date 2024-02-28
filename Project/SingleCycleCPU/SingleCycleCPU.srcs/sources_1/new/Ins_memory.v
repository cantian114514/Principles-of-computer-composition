`timescale 1ns / 1ps

module Ins_memory(
     input RW,
     input [31:0] IAddr,
     output reg [31:0] IDataOut
    );
    reg [7:0] Ins_mem [255:0];//前【7：0】指
    initial
       begin//这里写入指令的汇编码 具体指令见测试表格
            $readmemb("D:/vivado/Project/SingleCycleCPU/Instructions.txt",Ins_mem);
       end//注意这里的指令格式要八个一位 否则在simulation的时候会把地址翻译成很奇怪的数
    always@(RW or IAddr)
       begin
            if(RW)//为0写 为1读
            begin
                 IDataOut[31:24]=Ins_mem[IAddr];
                 IDataOut[23:16]=Ins_mem[IAddr+1];
                 IDataOut[15:8]=Ins_mem[IAddr+2];
                 IDataOut[7:0] =Ins_mem[IAddr+3];
            end  
       end
endmodule