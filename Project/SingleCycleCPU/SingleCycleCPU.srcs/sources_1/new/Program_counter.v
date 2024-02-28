`timescale 1ns / 1ps

module Program_counter(
      input Reset,
      input CLK,
      input PCWre,
      input [31:0] new_addr,//��pc��ַ
      output reg [31:0] PC//��ǰpc��ַ
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
