`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 10:10:30 PM
// Design Name: 
// Module Name: instruction_writeback
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


module instruction_writeback(
    input [1:0] ResultSrcW,   // Input dieu khien 2 bit (00, 01, 10)
    input [31:0] PCPlus4W,    // Input  1
    input [31:0] ALU_ResultW, // Input  2
    input [31:0] ReadDataW,   // Input  3
    output [31:0] ResultW     // Output
);

    // Logic Mux 3-to-1
    assign ResultW = (ResultSrcW == 2'b00) ? ALU_ResultW :
                     (ResultSrcW == 2'b01) ? ReadDataW :
                     (ResultSrcW == 2'b10) ? PCPlus4W : 
                     32'h00000011; //truong hop mac dinh

endmodule
