`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 03:59:20 PM
// Design Name: 
// Module Name: instruction_memmory
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


module instruction_memmory(
    input rst_n,
    input [31:0] A,
    output [31:0] RD
    );
    
    reg [31:0] mem[255:0];
    
    assign RD = (~rst_n) ? {32{1'b0}} : mem[A[31:2]];
    initial begin
        $readmemh("memfile.mem", mem); 
    end
endmodule
