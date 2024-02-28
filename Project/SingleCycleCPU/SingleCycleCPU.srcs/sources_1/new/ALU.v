`timescale 1ns / 1ps

module ALU(
      input [31:0]Data1,
      input [31:0]Data2,
      input [2:0] ALUop,
      output sign,
      output zero,
      output reg [31:0] res
    );
    always@(Data1 or Data2 or ALUop)
       begin
            case(ALUop)
               3'b000: res = Data1 + Data2;
               3'b001: res = Data1 - Data2;
               3'b010: res = Data2<<Data1;
               3'b011: res = Data1 | Data2;
               3'b100: res = Data1 & Data2; 
               3'b101: res = Data1 < Data2? 1 : 0;
               3'b110: res = (((Data1<Data2)&&(Data1[31]==Data2[31]))||(Data1[31]==1&&Data2[31]==0))?1:0;
               3'b111: res = Data1 ^ Data2;
               default: res = 0;
            endcase
       end
       assign zero = res ? 0:1;
       assign sign = res[31] ? 1:0;
endmodule
