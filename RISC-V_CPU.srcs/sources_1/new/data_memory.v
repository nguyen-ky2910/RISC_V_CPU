`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 06:51:17 PM
// Design Name: 
// Module Name: data_memory
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



module data_memory(
     input clk, rst_n, WE,
     input [31:0] A, WD,
     output [31:0] RD
    );
    
    reg [31:0] mem[255:0]; 
    integer i; 


    always @ (posedge clk)
    begin
        if (WE) 
           mem[A[31:2]] <= WD; 
    end
    
    assign RD = (~rst_n) ? 32'b0 : mem[A[31:2]];
    
    initial begin
        for (i = 0; i <= 255; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
    end
 
endmodule
