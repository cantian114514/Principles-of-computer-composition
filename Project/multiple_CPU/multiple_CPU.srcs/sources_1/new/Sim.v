`timescale 1ns / 1ps
module Sim;
	reg CLK;	//ʱ���ź�
	reg Reset;	//�����ź�
	MultipleCPU mcpu(CLK,Reset);
	initial begin
		CLK=	0;
		Reset=	1;	//�տ�ʼ����pcΪ0
		#50;	//�ȴ�Reset���
		CLK=	!CLK;	//�½��أ�ʹPC������
		#50;
		Reset=	0;	//��������ź�
	  	forever #50 begin	//����ʱ���źţ�����Ϊ50s
			CLK=	!CLK;
		end
	end
endmodule