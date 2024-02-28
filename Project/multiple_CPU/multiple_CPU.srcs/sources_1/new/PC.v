`timescale 1ns / 1ps
module PC(
	input CLK,
	input Reset,
	input PCWre,	//PC是否更改，如果为0，PC不更改
	input [31:0] newPC,
	output reg[31:0] curPC
);
	initial begin
		curPC <= 0;
	end
	always@(posedge CLK or negedge Reset)begin
		if (Reset)  curPC<= 0;
		else begin
			if (PCWre)  curPC <= newPC;
			else  curPC <= curPC;
		end
	end
endmodule