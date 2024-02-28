`timescale 1ns / 1ps
module SignZeroExtend(
       input [1:0] ExtSel,
       input [15:0] immediate,
       output [31:0] result
    );
    assign result[4:0] = (ExtSel==2'b00)? immediate[10:6] : immediate[4:0];
    assign result[15:5] = (ExtSel==2'b00)? 11'b00000000000:immediate[15:5];
    assign result[31:16] = (ExtSel==2'b10)?(immediate[15]==1?16'hffff:16'h0000):16'h0000;
endmodule
