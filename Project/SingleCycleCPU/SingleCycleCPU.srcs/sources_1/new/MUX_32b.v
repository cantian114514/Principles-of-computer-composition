`timescale 1ns / 1ps
module MUX_32b(
   input enable,
   input [31:0]Data1,
   input [31:0]Data2,
   output [31:0] Res
   );
   
   assign Res = enable?Data1:Data2; 
endmodule