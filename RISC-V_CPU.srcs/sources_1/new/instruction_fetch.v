`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 04:16:21 PM
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(
    input PCSrcE, rst_n, clk,
    input [31:0]PCTargetE,
    output [31:0] InstrD, PCD, PCPlus4D
    );
    wire [31:0]PC_F, PCF, PCPlus4F;
    wire [31:0]InstrF;
    reg [31:0]InstrF_reg, PCF_reg, PCPlus4F_reg;
    //reg la du lieu luu trong buffer register
    //de sau nay decode lay su dung
    mux_2_1 Mux( .a(PCPlus4F), .b(PCTargetE), .s(PCSrcE), .c(PC_F));
    pc_module PC( .clk(clk), .rst_n(rst_n), .pc_next(PC_F), .pc(PCF));
    instruction_memmory IM( .rst_n(rst_n), .A(PCF), .RD(InstrF));
    pc_adder PCA( .a(PCF), .b(32'h00000004), .c(PCPlus4F));
    
    
    always @ ( posedge clk or negedge rst_n) begin// dung them negedge de bat dong bo
        if(~rst_n) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end
    
    assign  InstrD = (~rst_n) ? 32'h00000000 : InstrF_reg;
    assign  PCD = (~rst_n) ? 32'h00000000 : PCF_reg;
    assign  PCPlus4D = (~rst_n) ? 32'h00000000 : PCPlus4F_reg;
    
endmodule
