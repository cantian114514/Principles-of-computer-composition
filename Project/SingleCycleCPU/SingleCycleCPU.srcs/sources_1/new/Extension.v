`timescale 1ns / 1ps

module Extension(
     input [15:0]immediately,
     input ExtSel,
     output [31:0] res
    );
    assign res[15:0] = immediately;//extselΪ0ʱ����0��չ��Ϊ1ʱ���з�����չ
    assign res[31:16] = ExtSel?(immediately[15]?16'hffff:16'h0000):16'h0000;//���
endmodule
