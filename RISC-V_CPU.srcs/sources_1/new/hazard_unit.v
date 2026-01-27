`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2025 09:50:32 AM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input           rst_n, RegWriteM, RegWriteW,
    input  [4:0]    RD_M, RD_W, Rs1_E, Rs2_E,
    output [1:0]    ForwardAE, ForwardBE
    );
    assign ForwardAE = (rst_n == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs1_E)) ? 2'b10 :// uu tien 1: dung ngay ket qua trong mem ( vi moi hon)
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;// uu tien 2: dung sau vi du lieu co the cu hon
    // RegWrite : lenh truoc do cho phep ghi vao thanh ghi nhung ta lay ket qua truoc de nap vao lenh nay(=0 neu la store)
    // RD_M != 5'h00 : thanh ghi 0 luon = 0 nen ko ?c ?ung vao no
    // RD_M == Rs1_E : thanh ghi dich cua lenh truoc trung voi thanh ghi dau vao cua lenh nay
    assign ForwardBE = (rst_n == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

endmodule