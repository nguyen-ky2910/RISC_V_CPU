`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 11:08:25 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU( 
    input [31:0] A, B,
    input [2:0] ALUControl,// tin hieu chon phep tinh
    output Carry,          // bien nho
    output OverFlow,       // kiem tra tran so
    output Zero,           // xac dinh co nhay hay ko
    output Negative,       // dau
    output [31:0] Result   // ket qua
    );
    
    wire Cout;
    wire [31:0] Sum;
    
    assign Sum = (ALUControl[0] == 1'b0) ? A + B:        // cong binh thuong
                                          A + ((~B) + 1);// tru ( cong voi so bu 2)

    assign {Cout, Result} = (ALUControl == 3'b000) ? Sum :    // cong binh thuong
                            (ALUControl == 3'b001) ? Sum :    // tru ( cong voi so bu 2)
                            (ALUControl == 3'b010) ? A & B :  // AND
                            (ALUControl == 3'b011) ? A | B :  //OR
                            (ALUControl == 3'b101) ? {{32{1'b0}}, Sum[31]} :// kiem tra phep tru de nhay( neu = 1 => ko nhay)
                                                     {33{1'b0}};            // neu = 0 => ko nhay
    assign OverFlow = ((Sum[31] ^ A[31]) & //kiem tra su bien doi dau ( neu A duong ma ket qua am thi dang nghi)
                      (~(ALUControl[0] ^ B[31] ^ A[31])) & 
//truong hop phep cong (ALUControl[0] = 0): 
//bieu thuc tro thanh : ~(0 ^ B[31] ^ A[31]) = ~(A[31] ^ B[31]).
//phep XNOR (not XOR) nay tra ve 1 khi A va B cung dau
//tran so chi xay ra khi cong 2 so cung dau ( duong + duong hoac am + am)

//truong hop phep tru (ALUControl[0] = 1):
//bieu thuc tro thanh ~(1 ^ B[31] ^ A[31]) <=> A[31] ^ B[31]
//phep XOR nay tra ve 1 khi A va B trai dau
//tran so khi tru chi xay ra khi 2 so trai dau( duong - am = duong lon hoac am - duong = am lon)
                      (~ALUControl[1]));// chi xet dau cong tru, ~ALUControl[1] = 1 khi ALUControl[1] =0)
    
    assign Carry = ((~ALUControl[1]) & Cout);// bien nho chi co khi thuc hien phep cong tru
    assign Zero = &(~Result);// nhay khi Result full 0, chi can co 1 bit 1 thi ko nhay
    assign Negative = Result[31]; // bit dau    
endmodule






