`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 05:01:53 PM
// Design Name: 
// Module Name: tb_instruction_decode
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


module tb_instruction_decode;

    // 1. Khai báo tín hi?u Input (reg) và Output (wire)
    reg clk;
    reg rst_n;
    
    // Tín hi?u t? giai ?o?n Writeback (?? gi? l?p vi?c ghi vào Register File)
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] ResultW;

    // Tín hi?u t? giai ?o?n Fetch (L?nh và PC)
    reg [31:0] InstrD;
    reg [31:0] PCD;
    reg [31:0] PCPlus4D;

    // Các tín hi?u Output c?n quan sát (Execute Stage)
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

    // 2. Kh?i t?o DUT (Device Under Test)
    instruction_decode caoky (
        .clk(clk), 
        .rst_n(rst_n), 
        .RegWriteW(RegWriteW), 
        .RDW(RDW), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D), 
        .ResultW(ResultW), 
        .RegWriteE(RegWriteE), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .ResultSrcE(ResultSrcE), 
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .RD1_E(RD1_E), 
        .RD2_E(RD2_E), 
        .Imm_Ext_E(Imm_Ext_E), 
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E), 
        .RD_E(RD_E), 
        .PCE(PCE), 
        .PCPlus4E(PCPlus4E)
    );

    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end 
    
    initial begin
        // --- Kh?i t?o giá tr? ban ??u ---
        clk = 0;
        rst_n = 0; // Reset h? th?ng
        RegWriteW = 0;
        RDW = 0;
        ResultW = 0;
        InstrD = 0;
        PCD = 0;
        PCPlus4D = 0;

        // --- B?t ??u Test ---
        $display("Time\t Instr Type\t RegWriteE\t ALUCtrl\t RD1\t RD2\t Imm_Ext");
        
        // 1. Nh? Reset
        #10 rst_n = 1;

        // ------------------------------------------------------------
        // B??C 1: N?P D? LI?U (Setup)
        // Ghi giá tr? 15 vào thanh ghi x1 và giá tr? 25 vào thanh ghi x2
        // Thao tác này gi? l?p tín hi?u t? Writeback Stage h?i ti?p v?
        // ------------------------------------------------------------
        #10;
        // Ghi x1 = 15
        RegWriteW = 1; RDW = 5'd1; ResultW = 32'd15; 
        #10;
        // Ghi x2 = 25
        RegWriteW = 1; RDW = 5'd2; ResultW = 32'd25; 
        #10;
        // T?t ghi
        RegWriteW = 0;

        // ------------------------------------------------------------
        // B??C 2: TEST L?NH R-TYPE (ADD x3, x1, x2)
        // Machine Code: 0000000 00010 00001 000 00011 0110011
        // rs2=x2, rs1=x1, funct3=0, rd=x3, opcode=R-type
        // ------------------------------------------------------------
        InstrD = 32'h002081B3; 
        PCD = 32'h00000004;
        PCPlus4D = 32'h00000008;
        
        // Ch? 1 chu k? ?? d? li?u ?i qua Pipeline Register
        #10; 
        $display("%0t\t R-Type (ADD)\t %b\t\t %b\t\t %d\t %d\t %h", 
                 $time, RegWriteE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E);
        
        // Mong ??i: 
        // RD1_E = 15 (x1), RD2_E = 25 (x2)
        // ALUControlE = 000 (Add), RegWriteE = 1

        // ------------------------------------------------------------
        // B??C 3: TEST L?NH I-TYPE (ADDI x4, x1, -5)
        // Imm = -5 (12 bit: FFB), rs1=x1, rd=x4
        // Machine Code: 111111111011 00001 000 00100 0010011
        // Hex: FFB08213
        // ------------------------------------------------------------
        InstrD = 32'hFFB08213;
        PCD = 32'h00000008;
        
        #10;
        $display("%0t\t I-Type (ADDI)\t %b\t\t %b\t\t %d\t %d\t %d", 
                 $time, RegWriteE, ALUControlE, RD1_E, RD2_E, $signed(Imm_Ext_E));

        // Mong ??i:
        // RD1_E = 15 (x1)
        // Imm_Ext_E = -5 (FFFFFFFB)
        // ALUSrcE = 1 (Ch?n Imm)

        // ------------------------------------------------------------
        // B??C 4: TEST L?NH BRANCH (BEQ x1, x2, offset)
        // Opcode Branch: 1100011
        // ------------------------------------------------------------
        InstrD = 32'h00208463; // beq x1, x2, 8
        PCD = 32'h0000000C;

        #10;
        $display("%0t\t Branch (BEQ)\t %b\t\t %b\t\t %d\t %d\t %d", 
                 $time, RegWriteE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E);

        // Mong ??i:
        // BranchE = 1, ALUControlE = 001 (Sub ?? so sánh)
        // RegWriteE = 0 (Không ghi thanh ghi)

        // K?t thúc mô ph?ng
        #20 $finish;
    end

endmodule
