`timescale 1ns / 1ps
module multipleCPU(
	input CLK,
	input Reset,
	output [5:0] op,
	output [4:0] rs,rt,rd,sa,
	output [5:0] func,
	output [15:0] immediate,
	output [31:0] ReadData1,ReadData2,
	output [31:0] WriteData,
	output [31:0] DataOut,
	output [31:0] curPC,newPC,
	output [31:0] result,
	output PCWre
);
	wire [31:0] A,B;
	wire [31:0] curPC_4, exImm, curPC_imm, outPC, DBtoREG;
	wire [4:0] WriteReg;
	wire zero,sign, ALUSrcA,ALUSrcB, DBDataSrc, RegWre, WrRegData, InsMemRW, DataMemRW, IRWre;
	wire [1:0] ExtSel, PCSrc, RegOut;
	wire [2:0] ALUOp;
	wire [31:0] RegReadData1, RegReadData2, RegResult, RegDataOut;
	
	assign curPC_4 = curPC + 4;
	assign outPC[31:28]= curPC[31:28];
    assign outPC[27:2] =exImm[25:0];
    assign outPC[1:0] = 2'b00;
	assign curPC_imm = curPC_4 + (exImm << 2);
	
	PC pc(CLK, Reset, PCWre, newPC, curPC);
	Ins_mem im(InsMemRW, curPC,CLK,IRWre,op,rs,rt,rd,sa,func,immediate);
	Register_File rf(CLK, RegWre, rs, rt, WriteReg, WriteData, ReadData1, ReadData2);
	ALU alu(ALUOp, A, B, zero, result,sign);
	SignZeroExtend sze(ExtSel, immediate, exImm);
	DataMemory dm(DataMemRW, RegResult, RegReadData2, DataOut);
	ControlUnit cu(CLK,Reset,op,func,zero,sign,PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre,WrRegData,InsMemRW,DataMemRW,IRWre,ExtSel,PCSrc,RegOut,ALUOp);
	//线转寄存器  2022.12.9 这里添加了function 如果出错可以检查这里
	WTR wtrA(CLK,ReadData1, RegReadData1);
	WTR wtrB(CLK,ReadData2, RegReadData2);
	WTR wtrALU(CLK,result, RegResult);
	WTR wtrMEM(CLK , DataOut, RegDataOut);

	MUX2L_32 mux2_1(WrRegData, curPC_4, DBtoREG, WriteData);
	MUX2L_32 mux2_4(ALUSrcA, RegReadData1,{27'b000000000000000000000000000,sa}, A);
	MUX2L_32 mux2_2(ALUSrcB, RegReadData2, exImm, B);
	MUX2L_32 mux2_3(DBDataSrc, result, RegDataOut, DBtoREG);
	MUX4L_5 mux4_1(RegOut, 5'b11111, rt, rd, 5'b00000, WriteReg);
	MUX4L_32 mux4_2(PCSrc, curPC_4, curPC_imm, ReadData1, outPC, newPC);

endmodule