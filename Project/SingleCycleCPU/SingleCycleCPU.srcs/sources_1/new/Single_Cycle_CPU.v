`timescale 1ns / 1ps

module Single_Cycle_CPU(
    input CLK,
    input Reset,
    output [31:0] cur_PC,
    output [31:0] new_PCaddr,
    output [31:0] Instruction,
    output [31:0] Data_rs,
    output [31:0] Data_rt,
    output [31:0] ALU_Res,
    output [31:0] Write_Data
    );
      wire [4:0] Write_Reg;
      wire [31:0] DataOut;
      wire [31:0]Ext_Immediate;
      wire PCWre;
      wire RegWre;
      wire ExtSel;
      wire InsMemRw;
      wire DBDataSrc;
      wire RegDst;
      wire ALUSrcA;
      wire ALUSrcB;
      wire mRD;
      wire mWR;
      wire [2:0] ALUOp; 
      wire [1:0] PCSrc;
      wire zero;
      wire sign;
      wire [31:0]ALU_inputA;
      wire [31:0]ALU_inputB;
      wire [31:0] cur_PC_4 = cur_PC + 4;
      
       assign new_PCaddr = (PCSrc==2'b01)?cur_PC_4+(Ext_Immediate<<2):(PCSrc==2'b10)?({cur_PC_4[31:28],Instruction[25:0],2'b00}):cur_PC_4;
       //assign new_PCaddr =	(PCSrc==2'b01)?{cur_PC_4[31:28],Instruction[25:0],2'b00}:(PCSrc==2'b10)?cur_PC_4+(Ext_Immediate<<2):cur_PC_4;
      
      Program_counter pc(Reset,CLK,PCWre,new_PCaddr,cur_PC); 
           
      Ins_memory ins_m(InsMemRw,cur_PC,Instruction);
      
      ALU alu(ALU_inputA,ALU_inputB,ALUOp,sign,zero,ALU_Res);
      
      Data_memory data_m(CLK,mRD,mWR,ALU_Res,Data_rt,DataOut);
      
      Extension extension(Instruction[15:0],ExtSel,Ext_Immediate);
      
      MUX_5b RtorRd_mux_5b(RegDst,Instruction[20:16],Instruction[15:11],Write_Reg);
      
      MUX_32b ALUA_mux_32b(ALUSrcA,{27'b000000000000000000000000000,Instruction[10:6]},Data_rs,ALU_inputA);
      
      MUX_32b ALUB_mux_32b(ALUSrcB,Ext_Immediate,Data_rt,ALU_inputB);
      
      MUX_32b ALUres_mux_32b(DBDataSrc,DataOut,ALU_Res,Write_Data);
      
      Register_File res_file(CLK,RegWre,Instruction[25:21],Instruction[20:16],Write_Reg,Write_Data,Data_rs,Data_rt);
      
      Control_Unit con_unit(zero,sign,Instruction[31:26],Instruction[5:0],PCWre,RegWre,ExtSel,InsMemRw,DBDataSrc,RegDst,ALUSrcA,ALUSrcB,PCSrc,mRD,mWR,ALUOp); 
                            
endmodule
