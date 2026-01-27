`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2025 12:12:34 PM
// Design Name: 
// Module Name: instruction_execute
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


module instruction_execute(
    input clk, rst_n, RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE,
    input [1:0] ResultSrcE,
    input [2:0] ALUControlE,
    input [31:0] RD1_E, RD2_E, Imm_Ext_E,
    input [4:0] RD_E,
    input [31:0] PCE, PCPlus4E,
    input [31:0] ResultW,
    input [1:0] ForwardA_E, ForwardB_E,

    output PCSrcE, RegWriteM, MemWriteM, 
    output [1:0]ResultSrcM,
    output [4:0] RD_M,
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM,
    output [31:0] PCTargetE
);
   
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE;

    reg RegWriteE_r, MemWriteE_r;
    reg [1:0]ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    mux_3_1 srca_mux (
                        .a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .d(Src_A)
                        );

    mux_3_1 srcb_mux (
                        .a(RD2_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardB_E),
                        .d(Src_B_interim)
                        );
    mux_2_1 alu_src_mux (
        .a(Src_B_interim),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(Src_B)
    );

    ALU alu (// van khai bao Overflow,... de cho nguyen ven, sau nay con su dung cho khac)
        .A(Src_A),
        .B(Src_B),
        .Result(ResultE),
        .ALUControl(ALUControlE),
        .OverFlow(), // Unconnected
        .Carry(),    // Unconnected
        .Zero(ZeroE),
        .Negative()  // Unconnected
    );

    pc_adder branch_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE)
    );

    always @(posedge clk or negedge rst_n) begin// them reset muc thap de bat dong bo
        if(rst_n == 1'b0) begin
            RegWriteE_r <= 1'b0;
            MemWriteE_r <= 1'b0;
            ResultSrcE_r <= 2'b00;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000;
            RD2_E_r <= 32'h00000000;
            ResultE_r <= 32'h00000000;
        end
        else begin
            RegWriteE_r <= RegWriteE;
            MemWriteE_r <= MemWriteE;
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E;
            RD2_E_r <= Src_B_interim;
            ResultE_r <= ResultE;
        end
    end

    assign PCSrcE = JumpE | (ZeroE & BranchE);
    assign RegWriteM  = RegWriteE_r;   
    assign MemWriteM  = MemWriteE_r;   
    assign ResultSrcM = ResultSrcE_r;  
    assign RD_M       = RD_E_r;        
    assign PCPlus4M   = PCPlus4E_r;    
    assign WriteDataM = RD2_E_r;       
    assign ALU_ResultM = ResultE_r;    

endmodule
