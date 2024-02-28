`timescale 1ns / 1ps
module Basys3(
	input CLK,
	input[1:0] SW,	//选择输出信号
	input Reset,	//重置按钮
	input Button,	//单脉冲
	output reg[3:0] AN,	//数码管位选择信号
	output[7:0] Out	//数码管输入信号
);
	parameter T1MS=	100000;
	reg[16:0] counter;
	wire[31:0] ALU_Out;	//ALU的result输出值
	wire[31:0] CurPC;
	wire[31:0] DB;	//DB总线值
	wire[31:0] reg1;	//寄存器组rs寄存器的值
	wire[31:0] reg2;	//寄存器组rt寄存器的值
	wire[31:0] DataOut;
	wire [5:0] op;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] sa;
    wire [5:0] func;
    wire [15:0] immediate;
	wire myCLK;
	reg[3:0] store;	//记录当前要显示位的值
	wire[31:0] newPC;

	multipleCPU mcpu(myCLK,Reset,op,rs,rt,rd,sa,func,immediate,reg1,reg2,DB,DataOut,CurPC,newPC,ALU_Out);
	Debounce debounce(CLK,Button,myCLK);

	initial begin
		counter<=	0;
		AN<=	4'b0111;
	end
	always@(posedge CLK)
		begin
		if(Reset==1)begin
		  counter<=	0;
		  AN<=	4'b0000;
		end else begin
			counter<=	counter+1;
			if(counter==T1MS)
				begin
					counter<=	0;
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
	SEG led(store,Reset,Out);
	always@(myCLK)begin
	   case(AN)
			4'b1110:	begin
				case(SW)
					2'b00:	store<=	newPC[3:0];
					2'b01:	store<=	reg1[3:0];
					2'b10:	store<=	reg2[3:0];
					2'b11:	store<=	DB[3:0];
				endcase
			end
			4'b1101:	begin
				case(SW)
					2'b00:	store<=	newPC[7:4];
					2'b01:	store<=	reg1[7:4];
					2'b10:	store<=	reg2[7:4];
					2'b11:	store<=	DB[7:4];
				endcase
			end
			4'b1011:	begin
				case(SW)
					2'b00:	store<=	CurPC[3:0];
					2'b01:	store<=	rs[3:0];
					2'b10:	store<=	rt[3:0];
					2'b11:	store<=	ALU_Out[3:0];
				endcase
			end
			4'b0111 : begin
				case(SW)
					2'b00:	store<=	CurPC[7:4];
					2'b01:	store<=	{3'b000,rs[4]};
					2'b10:	store<=	{3'b000,rt[4]};
					2'b11:	store<=	ALU_Out[7:4];
				endcase
			end
		endcase
	end
endmodule