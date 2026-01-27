`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 02:04:43 PM
// Design Name: 
// Module Name: tb_instruction_execute
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



module tb_instruction_execute;
    reg clk;
    reg rst_n;
    reg JumpE, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    reg [2:0] ALUControlE;
    reg [31:0] RD1_E, RD2_E, Imm_Ext_E;
    reg [4:0] RD_E;
    reg [31:0] PCE, PCPlus4E;

    wire PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] PCTargetE;

 
    instruction_execute caoky (
        .clk(clk), 
        .rst_n(rst_n), 
        .JumpE(JumpE), 
        .RegWriteE(RegWriteE), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .ResultSrcE(ResultSrcE), 
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .RD1_E(RD1_E), 
        .RD2_E(RD2_E), 
        .Imm_Ext_E(Imm_Ext_E), 
        .RD_E(RD_E), 
        .PCE(PCE), 
        .PCPlus4E(PCPlus4E), 
        .PCSrcE(PCSrcE), 
        .RegWriteM(RegWriteM), 
        .MemWriteM(MemWriteM), 
        .ResultSrcM(ResultSrcM), 
        .RD_M(RD_M), 
        .PCPlus4M(PCPlus4M), 
        .WriteDataM(WriteDataM), 
        .ALU_ResultM(ALU_ResultM), 
        .PCTargetE(PCTargetE)
    );

   initial begin
   clk = 0;
   forever #5 clk = ~clk;
   end 
   
   
    initial begin
        clk = 0;
        rst_n = 0;
        JumpE = 0; RegWriteE = 0; ALUSrcE = 0; MemWriteE = 0; ResultSrcE = 0; BranchE = 0;
        ALUControlE = 3'b000;
        RD1_E = 0; RD2_E = 0; Imm_Ext_E = 0; RD_E = 0;
        PCE = 0; PCPlus4E = 0;

        // --- RESET ---
        #20;
        rst_n = 1; // Th? Reset

        // --- CASE 1: R-Type ADD (10 + 20) ---
        // ALUControl = 000 (ADD), ALUSrc = 0 (Ch?n RD2)
        #20;
        RD1_E = 32'd10;
        RD2_E = 32'd20;
        RD_E  = 5'd5;
        ALUSrcE = 0;
        ALUControlE = 3'b000; 
        RegWriteE = 1;

        // --- CASE 2: I-Type ADDI (10 + 5) ---
        // ALUControl = 000 (ADD), ALUSrc = 1 (Ch?n Imm)
        #20;
        RD1_E = 32'd10;
        Imm_Ext_E = 32'd5;
        ALUSrcE = 1;       
        RegWriteE = 1;

        // --- CASE 3: STORE WORD ---
        // ALU tính ??a ch?, RD2 ?i th?ng ra WriteDataM
        #20;
        RD1_E = 32'd100;   // Base Addr
        Imm_Ext_E = 32'd4; // Offset
        RD2_E = 32'hAAAA;  // Data c?n ghi
        ALUSrcE = 1;       // Address = Base + Offset
        MemWriteE = 1;
        RegWriteE = 0;

        // --- CASE 4: BRANCH TAKEN (Equal) ---
        // Gi? s? 50 - 50 = 0 -> Zero = 1
        #20;
        BranchE = 1;
        MemWriteE = 0;
        RD1_E = 32'd50;
        RD2_E = 32'd50;
        ALUSrcE = 0;
        ALUControlE = 3'b001; // SUB ?? so sánh
        PCE = 32'd200;
        Imm_Ext_E = 32'd8;    // Target

        // --- CASE 5: JUMP ---
        #20;
        BranchE = 0;
        JumpE = 1;

        #50;
        $finish;
    end

endmodule
