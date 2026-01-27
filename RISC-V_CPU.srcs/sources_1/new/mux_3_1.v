`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2025 10:18:18 AM
// Design Name: 
// Module Name: mux_3_1
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


module mux_3_1(
    input [31:0] a, b, c,
    input [1:0] s, // forward A,B ta vua tinh o module hazard
    output [31:0] d // dau vao cua ALU
    );
    
    assign d = ( s == 2'b00) ? a : ( s == 2'b01 ) ? b : ( s == 2'b10 ) ? c : 32'h00000000;
endmodule 
