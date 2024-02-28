`timescale 1ns / 1ps
module ControlUnit(
	input CLK,	//时钟
	input reset,	//重置信号
	input [5:0] op,	//op操作符
	input [5:0] func,
	input zero,	//ALU的zero输出
	input sign,
	output reg PCWre,	//(PC)PC是否更改，如果为0，PC不更改，另外，除D_Tri == 000状态之外，其余状态也不能改变PC的值。
	output reg ALUSrcA,
	output reg ALUSrcB,
	output reg DBDataSrc,
	output reg RegWre,	//(RF)写使能信号，为1时，在时钟上升沿写入
	output reg WrRegData,	//2路选择器，判断数据写入是否为PC指令，如果为1，则不是，jar用到
	output reg InsMemRW,	//(IM)读写控制信号，1为写，0位读，固定为0
	output reg DataMemRW,	//(DM)数据存储器读写控制信号，为1写，为0读
	output reg IRWre,	//寄存器写使能，暂时没什么用，固定为1
	output reg[1:0] ExtSel,	//(EXT)控制补位，如果为1，进行符号扩展，如果为0，全补0
	output reg[1:0] PCSrc,	//4路选择器，选择PC指令来源
	output reg[1:0] RegOut,	//4路选择器，判断写寄存器地址的来源
	output reg[2:0] ALUOp	//(ALU)ALU操作控制
);
	parameter[2:0]
		_ADD=	3'b000,
		_SUB=	3'b001,
		_SLL=	3'b010,
		_OR=	3'b011,
		_AND=	3'b100,
		_SLTU=	3'b101,
		_SLT=	3'b110,
		_XOR=	3'b111,
		IF=	3'b000,	//3位D触发器，代表8个状态
		ID=	3'b001,
		EXELS=	3'b010,
		MEM=	3'b011,
		WBL=	3'b100,
		EXEBR=	3'b101,
		EXEAL=	3'b110,
		WBAL=	3'b111;
	parameter[5:0]
		ADDf=	6'b100000,
		SUBf=	6'b100010,
		ANDf=	6'b100100,
		SLLf=	6'b000000,
		SLT=	6'b101010,
		//以上用function
		ADDIU=	6'b001001,
		ANDI=	6'b001000,
		ORI=	6'b001101,
		XORI=	6'b001110,
		SLTI=	6'b001010,
		SW=	6'b101011,
		LW=	6'b100011,
		BEQ=	6'b000100,
		BNE=	6'b000101,
		BLTZ=	6'b000001,
		J=	6'b000010,
		JR=	6'b000000,
		JAL=	6'b000011,
		HALT=	6'b111111;
	reg[2:0] D_Tri;
	initial begin
		PCWre=0;
		ALUSrcB=0;
		DBDataSrc=0;
		RegWre=0;
		WrRegData=0;
		//no change
		InsMemRW=0;
		DataMemRW=0;
		//no change
		IRWre=1;
		ExtSel=0;
		PCSrc=0;
		RegOut=0;
		ALUOp=0;
		D_Tri=0;
	end
	//D触发器变化，PS：为了避免竞争冒险，所有值变化改为下降沿触发
	//PCWre，RegWre和DataMemRW的变化影响很大，要在这里写
	always@(negedge CLK or posedge reset)begin
		if(reset)begin//重置属性
			D_Tri=IF;
			PCWre=0;
			RegWre=0;
		 end
		else begin
			case (D_Tri)
				//IF -> ID
				IF: begin
					D_Tri <= ID;
					//禁止写指令，寄存器，和内存
					PCWre=0;
					RegWre=0;
					DataMemRW=0;
				end
				//ID -> EXE
				ID:begin
					case (op)
						//如果是BEQ指令，跳到EXEBR
						BEQ, BNE, BLTZ:  D_Tri <= EXEBR;
						//如果是SW，LW指令，跳到EXELS
						SW, LW:  D_Tri <= EXELS;
						//如果是j，JAL，JR，HALT，跳到IF
						J, JAL, HALT:begin
						    D_Tri=IF;
							//如果指令是HALT，禁止写指令
							if (op == HALT)  PCWre=0;
							else  PCWre=1;
							//如果指令是JAL，允许写寄存器
							if (op == JAL)  RegWre=1;
							else  RegWre=0;
						end
						6'b000000:begin
						   if(func==6'b001000) begin
						   D_Tri=IF;//JR
						   PCWre=1;
						   RegWre=0;
						   end
						   else D_Tri=EXEAL;//add and sub sll
						end
						//其他，跳到EXEAL
						default:  D_Tri=EXEAL;
					endcase
				 end
				//EXEAL -> WBAL
				EXEAL:begin
					D_Tri=WBAL;
					//允许写寄存器
					RegWre=1;
				end
				//EXELS -> MEM
				EXELS:begin
					D_Tri=MEM;
					//如果指令为SW，允许写内存
					if (op == SW)  DataMemRW=1;
				end
				//MEM -> WBL
				MEM:begin
					//如果指令为SW，MEM -> IF
					if (op == SW)begin
						D_Tri=IF;
						//允许写指令
						PCWre=1;
					end
					//如果指令为LW，MEM -> WBL
					else begin
						D_Tri=WBL;
						//允许写寄存器
						RegWre=1;
					end
				end
				//其他 -> IF
				default:begin
					D_Tri=IF;
					//允许写指令
					PCWre=1;
					//禁止写寄存器
					RegWre=0;
				end
			endcase
		end
	end
	always@(op or zero or func)begin//一般信号
		ALUSrcA=	func==SLLf;
		ALUSrcB=	op==ADDIU||op==ANDI||op==ORI||op==XORI||op==SLTI||op==LW||op==SW;
		DBDataSrc=	op==LW;
		WrRegData=	op!=JAL;	//2路选择器，判断数据写入是否为PC指令，如果为1，则不是，jar用到
		InsMemRW=	0;//(IM)读写控制信号，0为写，1位读，固定为0
		IRWre=	1;   //寄存器写使能，暂时没什么用，固定为1
		ExtSel=	(op==6'b000000&&func==SLLf)?2'b00:op==ANDI||op==XORI||op==ORI?2'b01:2'b10; //(EXT)控制补位，如果为1，进行符号扩展，如果为0，全补0
		PCSrc=	op==J||op==JAL?2'b11:
				(op==JR && func==6'b001000)?2'b10:
				(op==BEQ&&zero==1)||(op==BNE&&zero==0)||(op==BLTZ&&sign==1)?2'b01:
				2'b00;  //4路选择器，选择PC指令来源
		RegOut=	op==JAL?2'b00:
				func==ADDf||func==SUBf||func==ANDf||func==SLT||func==SLLf?2'b10:
				2'b01; //4路选择器，判断写寄存器地址的来源
		ALUOp=	func==SUBf||op==BEQ||op==BNE||op==BLTZ?_SUB:
				func==SLLf?_SLL:
				op==ORI?_OR:
				op==ANDI||func==ANDf?_AND:
				func==SLT||op==SLTI?_SLT:
				op==XORI?_XOR:_ADD;	//(ALU)ALU操作控制
	 end
endmodule