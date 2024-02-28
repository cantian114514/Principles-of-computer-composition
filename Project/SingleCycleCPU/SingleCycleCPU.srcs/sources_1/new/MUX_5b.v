`timescale 1ns / 1ps

module MUX_5b(
      input RegDst,
      input [4:0] rt,
      input [4:0] rd,
      output [4:0] res
    );
    assign res = RegDst==0?rt:rd;
endmodule
