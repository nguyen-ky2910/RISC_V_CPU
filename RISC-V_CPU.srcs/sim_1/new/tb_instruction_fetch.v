`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 04:38:39 PM
// Design Name: 
// Module Name: tb_instruction_fetch
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



module tb_instruction_fetch(
);
    reg PCSrcE, rst_n, clk;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;
    
    instruction_fetch caoky(
        .clk(clk), 
        .rst_n(rst_n), 
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D)
    );
  
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
       
    initial begin
        // --- Giai ?o?n 1: Kh?i t?o ---
        // B? dòng "clk = 0" ? ?ây ?i nhé, ?ã có ? trên r?i
        rst_n = 0;      // ?ang Reset
        PCSrcE = 0;     // Ch?a nh?y
        PCTargetE = 0;
        
        // --- Giai ?o?n 2: Reset h? th?ng ---
        #10;
        rst_n = 1;      // Th? Reset
        
        // --- Giai ?o?n 3: Ch?y tu?n t? ---
        // Ch? 50ns ?? th?y PC t?ng: 0 -> 4 -> 8 -> 12 -> 16
        #50;
        
        // --- Giai ?o?n 4: Test l?nh Nh?y (Branch) ---
        // T?i s??n xu?ng c?a clock (?? tránh race condition), b?t c? nh?y
        @(negedge clk); 
        PCSrcE = 1;               // B?t c? nh?y
        PCTargetE = 32'h00000020; // Nh?y ??n ??a ch? 32 (hex 20)
        
        @(negedge clk); // Gi? trong 1 chu k? ?? Mux k?p ch?n
        
        // --- Giai ?o?n 5: Quay l?i ch?y tu?n t? ---
        PCSrcE = 0;     // T?t c? nh?y
        
        // Quan sát PC ti?p t?c ch?y t? 32 tr? ?i
        #40;

        $finish;
    end
endmodule