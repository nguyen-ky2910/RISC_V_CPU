`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 03:33:29 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input [4:0] A1, A2, A3,
    input clk, rst_n, WE3,
    input [31:0] WD3,
    output [31:0] RD1, RD2
    );
    
    reg [31:0] register [31:0]; 
    integer i; 

    always @ (posedge clk or negedge rst_n) 
    begin
        if (!rst_n) begin // reset toan bo thanh ghi ve 0 het nhe( thanh ghi 0 thi luon = 0)
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'b0;
            end
        end
        else if (WE3 == 1'b1 && A3 != 5'h00) begin
             register[A3] <= WD3;
        end
    end
    
    assign RD1 = (A1 == 5'b0) ? 32'b0 : register[A1];
    assign RD2 = (A2 == 5'b0) ? 32'b0 : register[A2];

endmodule