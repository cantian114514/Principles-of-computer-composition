`timescale 1ns / 1ps
module Register_File(
      input CLK,
      input RegWE,
      input [4:0] rs,
      input [4:0] rt,
      input [4:0] Write_Reg,
      input [31:0] Write_Data,
      output [31:0] Read_Data1,
      output [31:0] Read_Data2
    );
    reg [31:0] register [0:31];
    integer i;
    initial begin
          for(i = 0;i < 32; i = i + 1)
              register[i] <= 0;
    end
    
    assign Read_Data1=rs!=0?register[rs]:0;
    assign Read_Data2=rt!=0?register[rt]:0;
    
    always@(posedge CLK)//检查的时候注意 如果结果不对可以尝试把这里改成上升沿触发
    begin
         if(RegWE && Write_Reg)
           begin
                register[Write_Reg] = Write_Data;
           end
    end
endmodule
