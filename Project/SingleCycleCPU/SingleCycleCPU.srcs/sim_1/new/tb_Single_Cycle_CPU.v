`timescale 1ns / 1ps
module tb_Single_Cycle_CPU();
       	reg CLK;	// ±÷”–≈∫≈
        reg Reset;    //÷√¡„–≈∫≈
        wire [31:0] cur_PC;
        wire [31:0] new_PCaddr;
        wire [31:0] Instruction;
        wire [31:0] Data_rs;
        wire [31:0] Data_rt;
        wire [31:0] ALU_Res;
        wire [31:0] Write_Data;
        Single_Cycle_CPU scpu(CLK,Reset,cur_PC,new_PCaddr,Instruction,Data_rs,Data_rt,ALU_Res,Write_Data);
        initial begin
           CLK = 0;
           Reset = 0;
           #500;
           CLK = ~CLK;
           #500;
           Reset = 1;
           forever #500
           begin
                CLK = ~CLK;
           end
         end
endmodule
