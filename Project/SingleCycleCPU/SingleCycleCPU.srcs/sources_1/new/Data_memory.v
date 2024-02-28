`timescale 1ns / 1ps

module Data_memory(
      input CLK,
      input mRD,
      input mWR,//RD是读数据，WR是写数据
      input [31:0] DAddr,
      input [31:0] DataIn,
      output reg [31:0] DataOut
    );
          reg [7:0] mem [0:31];//一个128层高 7层宽的存储器
          integer i;
          initial begin
                for(i=0;i<32;i=i+1) mem[i]<=0;
          end
          always@(mRD or DAddr)
          begin
               if(mRD)
               begin
                    DataOut[31:24]=mem[DAddr];//汇编后地址会×8
                    DataOut[23:16]=mem[DAddr+1];
                    DataOut[15:8]=mem[DAddr+2];
                    DataOut[7:0] =mem[DAddr+3];
               end
          end
          
          always@(negedge CLK)
          begin
              if(mWR)
              begin
                   mem[DAddr]<=DataIn[31:24];
                   mem[DAddr+1]<=DataIn[23:16];
                   mem[DAddr+2]<=DataIn[15:8];
                   mem[DAddr+3]<=DataIn[7:0];
              end
          end
endmodule
