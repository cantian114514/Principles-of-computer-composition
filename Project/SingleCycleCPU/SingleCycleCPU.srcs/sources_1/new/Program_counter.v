`timescale 1ns / 1ps

module Program_counter(
      input Reset,
      input CLK,
      input PCWre,
      input [31:0] new_addr,//新pc地址
      output reg [31:0] PC//当前pc地址
    );
  initial begin
     PC=0;
  end
  always@(posedge CLK or negedge Reset)
      begin
        if(Reset==0)
          begin
          PC=0;
          end
        else
          if(PCWre==1)
            begin
            PC=new_addr;
            end
          else
            begin
            PC=PC;
            end
      end
endmodule
