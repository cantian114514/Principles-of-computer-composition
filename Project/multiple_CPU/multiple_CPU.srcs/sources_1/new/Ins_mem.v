`timescale 1ns / 1ps
module Ins_mem(
     input RW,
     input [31:0] IAddr,
     input CLK,
     input IRWre,
     output reg[5:0] op,   
     output reg[4:0] rs,
     output reg[4:0] rt,
     output reg[4:0] rd,  
     output reg[4:0] sa,
     output reg[5:0] func,
     output reg[15:0] immediate
    );
    reg [7:0] ins_mem [255:0];
    initial
       begin
       op <= 0;
       rs <= 0;
       rt <= 0;
       rd <= 0;
       sa <= 0;
       func <= 0;
       immediate <= 0;
            $readmemb("D:/vivado/Project/multiple_CPU/instruction.txt",ins_mem);
       end
       //注意这里的指令格式要八个一位 否则在simulation的时候会把地址翻译成很奇怪的数
	always@(posedge CLK or posedge IRWre)begin
           if (IRWre)begin
               op = ins_mem[IAddr][7:2];
               rs[4:3] = ins_mem[IAddr][1:0];
               rs[2:0] = ins_mem[IAddr + 1][7:5];
               rt = ins_mem[IAddr + 1][4:0];
               rd = ins_mem[IAddr + 2][7:3];
               sa[4:2] = ins_mem[IAddr+2][2:0];
               sa[1:0] = ins_mem[IAddr+3][7:6];
               func = ins_mem[IAddr+3][5:0];
               immediate[15:8] = ins_mem[IAddr + 2];
               immediate[7:0] = ins_mem[IAddr + 3];
           end
       end
endmodule