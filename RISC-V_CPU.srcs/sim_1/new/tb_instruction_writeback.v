`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 10:24:33 PM
// Design Name: 
// Module Name: tb_instruction_writeback
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



module tb_instruction_writeback;
    reg [1:0] ResultSrcW;
    reg [31:0] PCPlus4W;
    reg [31:0] ALU_ResultW;
    reg [31:0] ReadDataW;

    wire [31:0] ResultW;

    instruction_writeback caoky (
        .ResultSrcW(ResultSrcW), 
        .PCPlus4W(PCPlus4W), 
        .ALU_ResultW(ALU_ResultW), 
        .ReadDataW(ReadDataW), 
        .ResultW(ResultW)
    );

    initial begin
        // Kh?i t?o d? li?u m?u (Hex) ?? d? nh?n di?n trên Waveform
        ALU_ResultW = 32'hAAAA_AAAA; 
        ReadDataW   = 32'hBBBB_BBBB;
        PCPlus4W    = 32'hCCCC_CCCC;
        
        // --- Test Case 1: Ch?n ALU (00) ---
        // K?t qu? mong ??i trên Waveform: ResultW = AAAAAAAA
        ResultSrcW = 2'b00;
        #10; // Ch? 10ns

        // --- Test Case 2: Ch?n Memory (01) ---
        // K?t qu? mong ??i: ResultW = BBBBBBBB
        ResultSrcW = 2'b01;
        #10;

        // --- Test Case 3: Ch?n PC+4 (10) ---
        // K?t qu? mong ??i: ResultW = CCCCCCCC
        ResultSrcW = 2'b10;
        #10;

        // --- Test Case 4: Tr??ng h?p l? (11) ---
        // K?t qu? mong ??i: ResultW = XXXXXXXX (??)
        ResultSrcW = 2'b11;
        #10;

        // --- Test Case 5: D? li?u thay ??i t?c th?i ---
        // Quay l?i ch?n ALU, ??i giá tr? ??u vào -> Output ph?i ??i theo ngay l?p t?c
        ResultSrcW = 2'b00;
        #5 ALU_ResultW = 32'h1234_5678;
        #10;

        $finish; // D?ng mô ph?ng
    end

endmodule