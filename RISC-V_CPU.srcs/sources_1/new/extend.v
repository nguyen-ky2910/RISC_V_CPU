`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 04:19:47 PM
// Design Name: 
// Module Name: extend
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


module extend (
    input [31:0] In,
    input [1:0] ImmSrc,
    output [31:0] Imm_Ext
    );

    assign Imm_Ext = (ImmSrc == 2'b00) ? {{20{In[31]}}, In[31:20]} :                         // I-Type (lw, addi)
                     (ImmSrc == 2'b01) ? {{20{In[31]}}, In[31:25], In[11:7]} :               // S-Type (sw)
                     (ImmSrc == 2'b10) ? {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0} :  // B-Type (beq) 
                     32'h00000000;                                                           // J-Type ho?c l?i
endmodule


// Bit Index    R-Type (add)    I-Type (addi, lw)  S-Type (sw)     B-Type (beq)
//31 - 25       funct7          Imm [11:0]          Imm [11:5]      Imm [12
//24 - 20       rs2             Imm [11:0](cont)    rs2             rs2
//19 - 15       rs1             rs1                 rs1             rs1
//14 - 12       funct3          funct3              funct3          funct3
//11 - 7        rd              rd                  Imm [4:0]       Imm [4:1
//6 - 0         Opcode          pcode               Opcode          Opcode

