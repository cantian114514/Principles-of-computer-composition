`timescale 1ns / 1ps
module MUX4L_5(
       input [1:0] src,
       input [4:0] data1,
       input [4:0] data2,
       input [4:0] data3,
       input [4:0] data4,
       output [4:0] out
    );
    assign out = src[1]==1?(src[0]==1?data4:data3):(src[0]==1?data2:data1);
endmodule
