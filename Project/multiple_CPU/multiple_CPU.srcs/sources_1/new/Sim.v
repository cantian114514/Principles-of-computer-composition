`timescale 1ns / 1ps
module Sim;
	reg CLK;	//时钟信号
	reg Reset;	//置零信号
	MultipleCPU mcpu(CLK,Reset);
	initial begin
		CLK=	0;
		Reset=	1;	//刚开始设置pc为0
		#50;	//等待Reset完成
		CLK=	!CLK;	//下降沿，使PC先清零
		#50;
		Reset=	0;	//清除保持信号
	  	forever #50 begin	//产生时钟信号，周期为50s
			CLK=	!CLK;
		end
	end
endmodule