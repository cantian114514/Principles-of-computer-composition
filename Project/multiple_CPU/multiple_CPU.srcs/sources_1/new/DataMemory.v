`timescale 1ns / 1ps
module DataMemory(
      input DataMemRW,//�洢�����ƶ�д Ϊ1д Ϊ0��
      input [31:0] DAddr,
      input [31:0] DataIn,
      output reg [31:0] DataOut
    );
          reg [7:0] mem [0:255];//һ��128��� 7���Ĵ洢��
          integer i;
          initial begin
                for(i=0;i<256;i=i+1) mem[i]<=0;
                for(i=0;i<32;i=i+1) DataOut[i]<=0;
          end
          always@(DataMemRW or DAddr)
              begin
               if(DataMemRW)
               begin
                mem[DAddr]<=DataIn[31:24];
                mem[DAddr+1]<=DataIn[23:16];
                mem[DAddr+2]<=DataIn[15:8];
                mem[DAddr+3]<=DataIn[7:0];
               end
          else
           begin
               DataOut[31:24]<=mem[DAddr];//�����ַ���8
               DataOut[23:16]<=mem[DAddr+1];
               DataOut[15:8]<=mem[DAddr+2];
               DataOut[7:0]<=mem[DAddr+3];
           end
       end
endmodule
