`timescale 1ns / 1ps
module pcj(
	input [31:0] PC0,	//ָ��
	input [25:0] inAddress,	//�����ַ
	output [31:0] outAddress	//�����ַ(ָ��)
);
	assign outAddress[31:28] = PC0[31:28];
	assign outAddress[27:2] = inAddress;
	assign outAddress[1:0] = 2'b00;
endmodule