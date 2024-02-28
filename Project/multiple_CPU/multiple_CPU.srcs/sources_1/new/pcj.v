`timescale 1ns / 1ps
module pcj(
	input [31:0] PC0,	//指令
	input [25:0] inAddress,	//输入地址
	output [31:0] outAddress	//输出地址(指令)
);
	assign outAddress[31:28] = PC0[31:28];
	assign outAddress[27:2] = inAddress;
	assign outAddress[1:0] = 2'b00;
endmodule