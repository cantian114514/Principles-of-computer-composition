`timescale 1ns / 1ps
module WTR(
       input CLK,
       input [31:0] in,
       output reg[31:0] out
    );
    integer i;
    always@(negedge CLK) begin
        for(i=0;i<32;i=i+1) out[i] = in[i];
    end
endmodule
