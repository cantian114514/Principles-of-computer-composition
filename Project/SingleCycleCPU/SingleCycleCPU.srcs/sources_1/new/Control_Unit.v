`timescale 1ns / 1ps

module Control_Unit(
    input zero,
    input sign,
    input [5:0]op,
    input [5:0]func,
    output reg PCWre,
    output reg RegWre,
    output reg ExtSel,
    output reg InsMemRw,
    output reg DBDataSrc,
    output reg RegDst,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg [1:0] PCSrc,
    output reg mRD,
    output reg mWR,
    output reg [2:0] ALUOp
//    output  PCWre,
//    output  RegWre,
//    output  ExtSel,
//    output  InsMemRw,
//    output  DBDataSrc,
//    output  RegDst,
//    output  ALUSrcA,
//    output  ALUSrcB,
//    output  [1:0] PCSrc,
//    output  mRD,
//    output  mWR,
//    output  [2:0] ALUOp
    );
    initial begin
    //起初只有PC相关的为1，其余均为停机状态
           PCWre=1;
           InsMemRw=1;
           mRD=0;
           mWR=0;
           DBDataSrc=0;
     end
     always@(*)
     begin //这里写影响上面五条控制信号的指令
        PCWre=(op==6'b111111)?0:1;//halt
        InsMemRw=(op==6'b111111)?0:1;//halt
        mRD=(op==6'b100011)?1:0;
        mWR=(op==6'b101011)?1:0;
        DBDataSrc=(op==6'b100011)?1:0;
        case(op)
                //op码为000000时
                6'b000000:
                   begin
                        case(func)
                               6'b100000://add
                               begin
                                    ExtSel = 0;
                                    RegDst = 1;
                                    RegWre = 1;
                                    ALUSrcA = 0;
                                    ALUSrcB = 0;
                                    PCSrc = 2'b00;
                                    ALUOp = 3'b000;
                               end
                               6'b100010://sub
                               begin
                                    ExtSel = 0;
                                    RegDst = 1;
                                    RegWre = 1;
                                    ALUSrcA = 0;
                                    ALUSrcB = 0;
                                    PCSrc = 2'b00;
                                    ALUOp = 3'b001;
                               end
                               6'b100100://and
                               begin
                                    ExtSel = 0;
                                    RegDst = 1;
                                    RegWre = 1;
                                    ALUSrcA = 0;
                                    ALUSrcB = 0;
                                    PCSrc = 2'b00;
                                    ALUOp = 3'b100;
                               end    
                               6'b100101://or
                               begin
                                    ExtSel = 0;
                                    RegDst = 1;
                                    RegWre = 1;
                                    ALUSrcA = 0;
                                    ALUSrcB = 0;
                                    PCSrc = 2'b00;
                                    ALUOp = 3'b011;
                               end
                               6'b000000://sll
                               begin
                                    ExtSel = 0;
                                    RegDst = 1;
                                    RegWre = 1;
                                    ALUSrcA = 1;
                                    ALUSrcB = 0;
                                    PCSrc = 2'b00;
                                    ALUOp = 3'b010;
                               end                                         
                        endcase
                   end
                6'b001001://addiu
                   begin
                       ExtSel = 1;
                       RegDst = 0;
                       RegWre = 1;
                       ALUSrcA = 0;
                       ALUSrcB = 1;
                       PCSrc = 2'b00;
                       ALUOp = 3'b000;                   
                   end
                6'b001100://andi
                   begin
                      ExtSel = 0;
                      RegDst = 0;
                      RegWre = 1;
                      ALUSrcA = 0;
                      ALUSrcB = 1;
                      PCSrc = 2'b00;
                      ALUOp = 3'b100;                   
                   end                
                6'b001101://ori
                   begin
                      ExtSel = 0;
                      RegDst = 0;
                      RegWre = 1;
                      ALUSrcA = 0;
                      ALUSrcB = 1;
                      PCSrc = 2'b00;
                      ALUOp = 3'b011;                   
                   end 
                6'b001010://slti
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 1;
                      ALUSrcA = 0;
                      ALUSrcB = 1;
                      PCSrc = 2'b00;
                      ALUOp = 3'b110;
                   end    
                6'b101011://sw
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 1;
                      PCSrc = 2'b00;
                      ALUOp = 3'b000;
                   end    
                6'b100011://lw
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 1;
                      ALUSrcA = 0;
                      ALUSrcB = 1;
                      PCSrc = 2'b00;
                      ALUOp = 3'b000;
                   end    
                6'b000100://beq
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 0;
                      PCSrc = (zero==0) ? 2'b00 : 2'b01;
                      ALUOp = 3'b001;
                   end
                6'b000101://bne
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 0;
                      PCSrc = (zero==1) ? 2'b00 : 2'b01;
                      ALUOp = 3'b001;
                   end
                6'b000001://bltz
                   begin
                      ExtSel = 1;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 0;
                      PCSrc = (sign==0) ? 2'b00 : 2'b01;
                      ALUOp = 3'b001;
                   end
                6'b000010://j
                   begin
                      ExtSel = 0;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 0;
                      PCSrc = 2'b10;
                      ALUOp = 3'b000;                   
                   end
                6'b111111://halt
                   begin
                      ExtSel = 0;
                      RegDst = 0;
                      RegWre = 0;
                      ALUSrcA = 0;
                      ALUSrcB = 0;
                      PCSrc = 2'b11;
                      ALUOp = 3'b000;
                   end
        endcase
     end
endmodule
//parameter halt = 6'b111111;
//    parameter addiu = 6'b001001;
//    parameter ori = 6'b001101;
//    parameter bne =6'b000101;
//    parameter slti = 6'b001010;
//    parameter beq = 6'b110000;
//    parameter sw = 6'b101011;
//    parameter lw = 6'b100011;
//    parameter bltz = 6'b000001;
//    parameter j = 6'b000010;
//    parameter andi = 6'b001000;
//    parameter add_func = 6'b100000;
//    parameter sub_func = 6'b100010; 
//    parameter and_func = 6'b100100;
//    parameter or_func=  6'b100101;
//    parameter sll_func = 6'b000000;
//    parameter add_ = 3'b000;
//    parameter sub_ = 3'b001;
//    parameter sll_ = 3'b010;
//    parameter or_ =  3'b011;
//    parameter and_ = 3'b100;
//    parameter slti_ = 3'b110;
   
//    wire RegWre_func ;
//    wire ALUOp_sub;
//    wire ALUOp_add;
//    wire ALUOp_and;
//    wire ALUOp_or;
    
//    assign RegWre_func = func==add_func||func==sub_func||func==or_func||func==and_func||func==sll_func;
//    assign ALUOp_sub = func==sub_func||op==bne||op==beq||op==bltz;
//    assign ALUOp_add = func==add_func||op==addiu;
//    assign ALUOp_and = func==and_func||op==andi;
//    assign ALUOp_or = func==or_func||op==ori;
//    assign PCWre = op!=halt;
//    assign ALUSrcA = func==sll_func;
//    assign ALUSrcB = op==addiu||op==andi||op==ori||op==slti||op==sw||op==lw;
//    assign DBDataSrc = op==lw;
//    assign RegWre = RegWre_func||op==addiu||op==ori||op==andi||op==slti||op==lw;
//    assign InsMemRw = 1;
//    assign mRD = op==lw;
//    assign mWR = op==sw;
//    assign RegDst = func==add_func||func==or_func||func==sub_func||func==sll_func||func==and_func;
//    assign ExtSel = op!=andi&&op!=ori;  //op==slti||op==sw||op==lw||op==beq||op==bne||op==bltz||op==addiu;
//    assign PCSrc[0] = (op==beq&&zero==1)||(op==bne&&zero==0)||(op==bltz&&sign==1);
//    assign PCSrc[1] = op==j; 
//    assign ALUOp = ALUOp_add?add_:ALUOp_sub?sub_:ALUOp_or?or_:func==sll_func?sll_:op==slti?slti_:ALUOp_and?and_:111;
//endmodule
