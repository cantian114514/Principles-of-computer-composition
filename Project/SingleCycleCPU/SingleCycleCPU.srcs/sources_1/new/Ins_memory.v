`timescale 1ns / 1ps

module Ins_memory(
     input RW,
     input [31:0] IAddr,
     output reg [31:0] IDataOut
    );
    reg [7:0] Ins_mem [255:0];//ǰ��7��0��ָ
    initial
       begin//����д��ָ��Ļ���� ����ָ������Ա��
            $readmemb("D:/vivado/Project/SingleCycleCPU/Instructions.txt",Ins_mem);
       end//ע�������ָ���ʽҪ�˸�һλ ������simulation��ʱ���ѵ�ַ����ɺ���ֵ���
    always@(RW or IAddr)
       begin
            if(RW)//Ϊ0д Ϊ1��
            begin
                 IDataOut[31:24]=Ins_mem[IAddr];
                 IDataOut[23:16]=Ins_mem[IAddr+1];
                 IDataOut[15:8]=Ins_mem[IAddr+2];
                 IDataOut[7:0] =Ins_mem[IAddr+3];
            end  
       end
endmodule