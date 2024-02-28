`timescale 1ns / 1ps
// Create Date: 2022/12/03 23:46:31
module MUX2L_32(
     input src,
     input [31:0] data1,
     input [31:0] data2,
     output [31:0] out
    );
    assign out = src==0? data1 : data2;
endmodule
