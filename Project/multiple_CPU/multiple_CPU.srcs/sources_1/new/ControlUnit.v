`timescale 1ns / 1ps
module ControlUnit(
	input CLK,	//ʱ��
	input reset,	//�����ź�
	input [5:0] op,	//op������
	input [5:0] func,
	input zero,	//ALU��zero���
	input sign,
	output reg PCWre,	//(PC)PC�Ƿ���ģ����Ϊ0��PC�����ģ����⣬��D_Tri == 000״̬֮�⣬����״̬Ҳ���ܸı�PC��ֵ��
	output reg ALUSrcA,
	output reg ALUSrcB,
	output reg DBDataSrc,
	output reg RegWre,	//(RF)дʹ���źţ�Ϊ1ʱ����ʱ��������д��
	output reg WrRegData,	//2·ѡ�������ж�����д���Ƿ�ΪPCָ����Ϊ1�����ǣ�jar�õ�
	output reg InsMemRW,	//(IM)��д�����źţ�1Ϊд��0λ�����̶�Ϊ0
	output reg DataMemRW,	//(DM)���ݴ洢����д�����źţ�Ϊ1д��Ϊ0��
	output reg IRWre,	//�Ĵ���дʹ�ܣ���ʱûʲô�ã��̶�Ϊ1
	output reg[1:0] ExtSel,	//(EXT)���Ʋ�λ�����Ϊ1�����з�����չ�����Ϊ0��ȫ��0
	output reg[1:0] PCSrc,	//4·ѡ������ѡ��PCָ����Դ
	output reg[1:0] RegOut,	//4·ѡ�������ж�д�Ĵ�����ַ����Դ
	output reg[2:0] ALUOp	//(ALU)ALU��������
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
		IF=	3'b000,	//3λD������������8��״̬
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
		//������function
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
	//D�������仯��PS��Ϊ�˱��⾺��ð�գ�����ֵ�仯��Ϊ�½��ش���
	//PCWre��RegWre��DataMemRW�ı仯Ӱ��ܴ�Ҫ������д
	always@(negedge CLK or posedge reset)begin
		if(reset)begin//��������
			D_Tri=IF;
			PCWre=0;
			RegWre=0;
		 end
		else begin
			case (D_Tri)
				//IF -> ID
				IF: begin
					D_Tri <= ID;
					//��ֹдָ��Ĵ��������ڴ�
					PCWre=0;
					RegWre=0;
					DataMemRW=0;
				end
				//ID -> EXE
				ID:begin
					case (op)
						//�����BEQָ�����EXEBR
						BEQ, BNE, BLTZ:  D_Tri <= EXEBR;
						//�����SW��LWָ�����EXELS
						SW, LW:  D_Tri <= EXELS;
						//�����j��JAL��JR��HALT������IF
						J, JAL, HALT:begin
						    D_Tri=IF;
							//���ָ����HALT����ֹдָ��
							if (op == HALT)  PCWre=0;
							else  PCWre=1;
							//���ָ����JAL������д�Ĵ���
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
						//����������EXEAL
						default:  D_Tri=EXEAL;
					endcase
				 end
				//EXEAL -> WBAL
				EXEAL:begin
					D_Tri=WBAL;
					//����д�Ĵ���
					RegWre=1;
				end
				//EXELS -> MEM
				EXELS:begin
					D_Tri=MEM;
					//���ָ��ΪSW������д�ڴ�
					if (op == SW)  DataMemRW=1;
				end
				//MEM -> WBL
				MEM:begin
					//���ָ��ΪSW��MEM -> IF
					if (op == SW)begin
						D_Tri=IF;
						//����дָ��
						PCWre=1;
					end
					//���ָ��ΪLW��MEM -> WBL
					else begin
						D_Tri=WBL;
						//����д�Ĵ���
						RegWre=1;
					end
				end
				//���� -> IF
				default:begin
					D_Tri=IF;
					//����дָ��
					PCWre=1;
					//��ֹд�Ĵ���
					RegWre=0;
				end
			endcase
		end
	end
	always@(op or zero or func)begin//һ���ź�
		ALUSrcA=	func==SLLf;
		ALUSrcB=	op==ADDIU||op==ANDI||op==ORI||op==XORI||op==SLTI||op==LW||op==SW;
		DBDataSrc=	op==LW;
		WrRegData=	op!=JAL;	//2·ѡ�������ж�����д���Ƿ�ΪPCָ����Ϊ1�����ǣ�jar�õ�
		InsMemRW=	0;//(IM)��д�����źţ�0Ϊд��1λ�����̶�Ϊ0
		IRWre=	1;   //�Ĵ���дʹ�ܣ���ʱûʲô�ã��̶�Ϊ1
		ExtSel=	(op==6'b000000&&func==SLLf)?2'b00:op==ANDI||op==XORI||op==ORI?2'b01:2'b10; //(EXT)���Ʋ�λ�����Ϊ1�����з�����չ�����Ϊ0��ȫ��0
		PCSrc=	op==J||op==JAL?2'b11:
				(op==JR && func==6'b001000)?2'b10:
				(op==BEQ&&zero==1)||(op==BNE&&zero==0)||(op==BLTZ&&sign==1)?2'b01:
				2'b00;  //4·ѡ������ѡ��PCָ����Դ
		RegOut=	op==JAL?2'b00:
				func==ADDf||func==SUBf||func==ANDf||func==SLT||func==SLLf?2'b10:
				2'b01; //4·ѡ�������ж�д�Ĵ�����ַ����Դ
		ALUOp=	func==SUBf||op==BEQ||op==BNE||op==BLTZ?_SUB:
				func==SLLf?_SLL:
				op==ORI?_OR:
				op==ANDI||func==ANDf?_AND:
				func==SLT||op==SLTI?_SLT:
				op==XORI?_XOR:_ADD;	//(ALU)ALU��������
	 end
endmodule