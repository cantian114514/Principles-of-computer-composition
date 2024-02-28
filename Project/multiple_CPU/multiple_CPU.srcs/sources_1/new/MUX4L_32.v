`timescale 1ns / 1ps
module MUX4L_32(
     input [1:0] src,
     input [31:0] data1,
     input [31:0] data2,
     input [31:0] data3,
     input [31:0] data4,
     output [31:0] out
    );
//  always@(src or data1 or data2 or data3 or data4)
//  begin
//    case(src)
//        2'b00:assign out = data1;
//        2'b01:assign out = data2;
//        2'b10:assign out = data3;
//        2'b11:assign out = data4;
//     endcase
//  end
    assign out = src[1]==1?(src[0]==1?data4:data3):(src[0]==1?data2:data1);
endmodule
