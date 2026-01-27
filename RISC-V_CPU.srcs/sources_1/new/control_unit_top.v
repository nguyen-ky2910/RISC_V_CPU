`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 03:28:24 PM
// Design Name: 
// Module Name: control_unit_top
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


module control_unit_top(
    input [6:0]Op,funct7, 
    input [2:0]funct3, 
    output RegWrite,ALUSrc,MemWrite,Branch, Jump,
    output [1:0]ImmSrc, ResultSrc,
    output [2:0]ALUControl
    );
    wire [1:0]ALUOp;
    
    main_decoder Main_Decoder(
                .Op(Op),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Jump(Jump),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp)
    );
    ALU_decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .Op(Op),
                            .ALUControl(ALUControl)
    );

endmodule
