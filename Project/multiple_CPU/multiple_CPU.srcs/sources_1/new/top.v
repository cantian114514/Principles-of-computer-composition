`timescale 1ns / 1ps
module top(
	input CLK,
	input Reset,
	output [5:0] op,
	output [4:0] rs,
	output [4:0] rt,
	output [4:0] rd,
	output [4:0] sa,
	output [5:0] func,
	output [31:0] instruction,
	output [15:0] immediate,
	output [31:0] ReadData1,
	output [31:0] ReadData2,
	output [31:0] WriteData,
	output [31:0] DataOut,
	output [31:0] currentAddress,
	output [31:0] newAddress,
	output [31:0] result,
	output PCWre
);
	wire [31:0] A,B;
	wire [31:0] currentAddress_4, extendImmediate, currentAddress_immediate, outAddress, ALUM2DR;
	wire [4:0] WriteReg;
	wire [25:0] address;
	wire zero,sign, ALUSrcA,ALUSrcB, ALUM2Reg, RegWre, WrRegData, InsMemRW, DataMemRW, IRWre;
	wire [1:0] ExtSel, PCSrc, RegOut;
	wire [2:0] ALUOp;
	wire [31:0] RegReadData1, RegReadData2, RegResult, RegDataOut;
	assign currentAddress_4 = currentAddress + 4;
	assign currentAddress_immediate = currentAddress_4 + (extendImmediate << 2);
	assign outAddress[31:28]= newAddress[31:28];
	assign outAddress[27:2] =extendImmediate[25:0];
	assign outAddress[1:0] = 2'b00;
	PC pc(CLK, Reset, PCWre, newAddress, currentAddress);
//	Ins_mem im(InsMemRW, currentAddress,CLK,IRWre,op,rs,rt,rd,sa,func,immediate);
    Ins_mem im(InsMemRW, currentAddress,instruction);
	IR ir(CLK,IRWre,instruction,op, rs, rt, rd,sa,func,immediate);
	Register_File rf(CLK, RegWre, rs, rt, WriteReg, WriteData, ReadData1, ReadData2);
	ALU alu(ALUOp, A, B, zero, result,sign);
	SignZeroExtend sze(ExtSel, immediate, extendImmediate);
	DataMemory dm(DataMemRW, RegResult, RegReadData2, DataOut);
	ControlUnit cu(CLK,Reset,op,instruction[5:0],zero,sign,PCWre,ALUSrcA,ALUSrcB,ALUM2Reg,RegWre,WrRegData,InsMemRW,DataMemRW,IRWre,ExtSel,PCSrc,RegOut,ALUOp);
	//线转寄存器  2022.12.9 这里添加了function 如果出错可以检查这里
	WTR wtrA(CLK,ReadData1, RegReadData1);
	WTR wtrB(CLK,ReadData2, RegReadData2);
	WTR wtrALU(CLK,result, RegResult);
	WTR wtrMEM(CLK , DataOut, RegDataOut);
	//2路选择器
	MUX2L_32 mux2_1(WrRegData, currentAddress_4, ALUM2DR, WriteData);
	MUX2L_32 mux2_4(ALUSrcA, RegReadData1,{27'b000000000000000000000000000,sa}, A);
	MUX2L_32 mux2_2(ALUSrcB, RegReadData2, extendImmediate, B);
	MUX2L_32 mux2_3(ALUM2Reg, result, RegDataOut, ALUM2DR);
	//4路选择器
	MUX4L_5 mux4_1(RegOut, 5'b11111, rt, rd, 5'b00000, WriteReg);
	MUX4L_32 mux4_2(PCSrc, currentAddress_4, currentAddress_immediate, ReadData1, outAddress, newAddress);

endmodule