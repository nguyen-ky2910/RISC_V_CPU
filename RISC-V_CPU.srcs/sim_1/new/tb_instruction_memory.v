`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 08:52:50 PM
// Design Name: 
// Module Name: tb_instruction_memory
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



module tb_instruction_memory;
    reg clk;
    reg rst_n;
    reg RegWriteM, MemWriteM, ResultSrcM;
    reg [4:0] RD_M;
    reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

    wire RegWriteW, ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;


    instruction_memory caoky (
        .clk(clk), 
        .rst_n(rst_n), 
        .RegWriteM(RegWriteM), 
        .MemWriteM(MemWriteM), 
        .ResultSrcM(ResultSrcM), 
        .RD_M(RD_M), 
        .PCPlus4M(PCPlus4M), 
        .WriteDataM(WriteDataM), 
        .ALU_ResultM(ALU_ResultM), 
        .RegWriteW(RegWriteW), 
        .ResultSrcW(ResultSrcW), 
        .RD_W(RD_W), 
        .PCPlus4W(PCPlus4W), 
        .ALU_ResultW(ALU_ResultW), 
        .ReadDataW(ReadDataW)
    );
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // --- Kh?i t?o ---
        clk = 0;
        rst_n = 0; 
        RegWriteM = 0; MemWriteM = 0; ResultSrcM = 0;
        RD_M = 0;
        PCPlus4M = 0; WriteDataM = 0; ALU_ResultM = 0;

        // --- Release Reset ---
        #10 rst_n = 1;

        // --- TEST CASE 1: Ghi vào Memory (Store) ---
        // Ghi giá tr? 32'hAABB_CCDD vào ??a ch? 4
        #10;
        MemWriteM = 1;          
        ALU_ResultM = 32'd4;    
        WriteDataM = 32'hAABB_CCDD; 
        
        // --- TEST CASE 2: ??c t? Memory (Load) ---
        // ??c l?i t? ??a ch? 4, ki?m tra d? li?u ?i qua Pipeline Register
        #10;
        MemWriteM = 0;          
        ALU_ResultM = 32'd4;    
        
        RegWriteM = 1;          // Test tín hi?u ?i?u khi?n
        RD_M = 5'd5;            // Test ??a ch? thanh ghi ?ích
        ResultSrcM = 1;
        
        // ??i 1 chu k? clock ?? Pipeline Register c?p nh?t
        // T?i th?i ?i?m này trên Waveform: ReadDataW s? ??i thành hAABB_CCDD
        #10;

        // --- TEST CASE 3: ALU Pass-through ---
        // Ki?m tra d? li?u ALU ?i th?ng qua pipeline (không liên quan memory)
        #10;
        ALU_ResultM = 32'h1122_3344; 
        ResultSrcM = 0; 

        // ??i pipeline c?p nh?t
        // T?i th?i ?i?m này trên Waveform: ALU_ResultW s? ??i thành h1122_3344
        #10;

        // K?t thúc mô ph?ng
        #20 $finish;
    end

endmodule



