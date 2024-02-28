`timescale 1ns / 1ps
module Basys3(
	input CLK,
	input[1:0] SW,	//ѡ������ź�
	input Reset,	//���ð�ť
	input Button,	//������
	output reg[3:0] AN,	//�����λѡ���ź�
	output[7:0] Out	//����������ź�
);
	parameter T1MS=	100000;
	reg[16:0] showCounter;
	wire[31:0] ALU_Out;	//ALU��result���ֵ
	wire[31:0] CurPC;
	wire[31:0] WriteData;	//DB����ֵ
	wire[31:0] Reg1Out;	//�Ĵ�����rs�Ĵ�����ֵ
	wire[31:0] Reg2Out;	//�Ĵ�����rt�Ĵ�����ֵ
	wire[31:0] instcode;
	wire myCLK;
	reg[3:0] store;	//��¼��ǰҪ��ʾλ��ֵ
	wire[31:0] newAddress;

	Single_Cycle_CPU scpu(myCLK,Reset,CurPC,newAddress,instcode,Reg1Out,Reg2Out,ALU_Out,WriteData);

	Debounce debounce(CLK,Button,myCLK);

	initial begin
		showCounter<=	0;
		AN<=	4'b0111;
	end
	always@(posedge CLK)
		begin
		if(Reset==0)begin
		  showCounter<=	0;
		  AN<=	4'b0000;
		end else begin
			showCounter<=	showCounter+1;
			if(showCounter==T1MS)
				begin
					showCounter<=	0;
					case(AN)
						4'b1110:	begin
							AN<=	4'b1101;
						end
						4'b1101:	begin
							AN<=	4'b1011;
						end
						4'b1011:	begin
							AN<=	4'b0111;
						end
						4'b0111:	begin
							AN<=	4'b1110;
						end
						4'b0000:	begin
							AN<=	4'b0111;
					   end
					endcase
				end
			end
		end
	SegLed led(store,Reset,Out);
	always@(myCLK)begin
	   case(AN)
			4'b1110:	begin
				case(SW)
					2'b00:	store<=	newAddress[3:0];
					2'b01:	store<=	Reg1Out[3:0];
					2'b10:	store<=	Reg2Out[3:0];
					2'b11:	store<=	WriteData[3:0];
				endcase
			end
			4'b1101:	begin
				case(SW)
					2'b00:	store<=	newAddress[7:4];
					2'b01:	store<=	Reg1Out[7:4];
					2'b10:	store<=	Reg2Out[7:4];
					2'b11:	store<=	WriteData[7:4];
				endcase
			end
			4'b1011:	begin
				case(SW)
					2'b00:	store<=	CurPC[3:0];
					2'b01:	store<=	instcode[24:21];
					2'b10:	store<=	instcode[19:16];
					2'b11:	store<=	ALU_Out[3:0];
				endcase
			end
			4'b0111 : begin
				case(SW)
					2'b00:	store<=	CurPC[7:4];
					2'b01:	store<=	{3'b000,instcode[25]};
					2'b10:	store<=	{3'b000,instcode[20]};
					2'b11:	store<=	ALU_Out[7:4];
				endcase
			end
		endcase
	end
endmodule