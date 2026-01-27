`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 02:14:23 PM
// Design Name: 
// Module Name: main_decoder
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

// module nay se quyet dinh cho chiec luoc chung( ghi RAM, ghi thanh ghi, loai so hang nao)
module main_decoder(
    input [6:0]Op,
    output RegWrite, MemWrite, Branch, ALUSrc, Jump,
    output [1:0] ALUOp, ImmSrc, ResultSrc
    );
//0110011	R-Type	add, sub, ...	tinh toan binh thuong voi cac thanh ghi
//0010011	I-Type	addi, ori...	tinh toan voi so hang (immediate)
//0000011	Load	lw	            doc du lieu tu bo nho
//0100011	Store	sw	            ghi du lieu tu bo nho
//1100011	Branch	beq	            re nhanh co dieu kien
//1101111   Jump    jal             nhay ko dieu kien
    assign RegWrite  = ( Op == 7'b0110011 || Op == 7'b0010011 || Op == 7'b0000011|| Op == 7'b1101111) ? 1'b1// cho phep ghi vao register file
                                                                                 : 1'b0;// ko cho ghi vao register file
 
    assign ResultSrc = (Op == 7'b0000011) ? 2'b01 : // lw -> lay tu bo nho
                       (Op == 7'b1101111) ? 2'b10 : // jal -> lay PC + 4 ( de lay dia chi tra ve bo nho)
                                            2'b00;  // mac dinh --> lay ALU
 
    assign MemWrite  = ( Op == 7'b0100011 ) ? 1'b1  // cho ghi vao RAM (store)
                                            : 1'b0; // ko cho ghi vao RAM 
  
    assign Branch =    ( Op == 7'b1100011 ) ? 1'b1  // cho nhay
                                            : 1'b0; // ko cho nhay
  
    assign Jump      = (Op == 7'b1101111) ? 1'b1 : 1'b0;
    
    assign ALUSrc =    ( Op == 7'b0000011 || Op == 7'b0100011 || Op == 7'b0010011 ) ? 1'b1  // chon dau vao thu 2 cua ALU la so hang
                                                                                  : 1'b0; // chon dau vao thu 2 cua ALU la thanh ghi
   
    assign ImmSrc    = (Op == 7'b0100011) ? 2'b01 : // S-type
                       (Op == 7'b1100011) ? 2'b10 : // B-type
                       (Op == 7'b1101111) ? 2'b11 : // J-type 
                                            2'b00;  // I-type
   
    assign ALUOp =     (Op == 7'b0110011 || 7'b0010011 ) ? 2'b10 : // bao ALU decoder tu nhin vao funct3/7 ma tinh di
                       (Op == 7'b1100011) ? 2'b01 : // bao ALU decoder lam phep tru( sub ) de so sanh 2 so
                                            2'b00 ; // bao ALU decoder lam phep cong de tinh dia chi bo nho = base + offset
endmodule
