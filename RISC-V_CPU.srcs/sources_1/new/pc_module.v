`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 03:33:13 PM
// Design Name: 
// Module Name: pc_module
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


module pc_module(
    input clk, rst_n, // dung reset kich hoat muc thap
    input [31:0] pc_next,
    output reg [31:0] pc
    );
    
    always @ ( posedge clk or negedge rst_n)// them negedge rst_n de dung bat dong bo (an toan hon)
    begin
    if( ~rst_n)
    pc <= {32{1'b0}};
    else
    pc <= pc_next;
    end
endmodule
