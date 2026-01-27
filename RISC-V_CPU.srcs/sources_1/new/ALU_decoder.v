`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 03:07:10 PM
// Design Name: 
// Module Name: ALU_decoder
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

// module nay se quyet dinh tong the cho ALU( cong, tru , and , or)
module ALU_decoder(
    input [6:0] Op, funct7,
    input [2:0] funct3,
    input [1:0] ALUOp,// dau ra cua module main decoder
    output [2:0] ALUControl
    );
    
    assign ALUControl = (ALUOp == 2'b00) ? 3'b000 : //ADD ( tinh dia chi bo nho base + offset hoac lenh addi )
                        (ALUOp == 2'b01) ? 3'b001 : //SUB ( neu = 0 thi nhay )
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} == 2'b11)) ? 3'b001 : // SUB
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} != 2'b11)) ? 3'b000 : // ADD
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : // lenh STL - set less than
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : // OR
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : // AND
                                                                  3'b000 ;
    
endmodule
