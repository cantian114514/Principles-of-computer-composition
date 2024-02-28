`timescale 1ns / 1ps

module Extension(
     input [15:0]immediately,
     input ExtSel,
     output [31:0] res
    );
    assign res[15:0] = immediately;//extsel为0时进行0拓展，为1时进行符号拓展
    assign res[31:16] = ExtSel?(immediately[15]?16'hffff:16'h0000):16'h0000;//大端
endmodule
