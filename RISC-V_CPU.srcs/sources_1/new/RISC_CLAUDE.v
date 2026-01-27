`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2025 05:16:50 PM
// Design Name: 
// Module Name: RISC_CLAUDE
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


// RISC-V 32-bit CPU v?i pipeline 5 giai ?o?n
// H? tr? RV32I base instruction set

module RISC_CLAUDE  (
    input wire clk,
    input wire rst,
    output wire [31:0] pc_out,
    output wire [31:0] instr_out
);

    // Pipeline registers
    reg [31:0] pc;
    
    // IF/ID Pipeline Register
    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;
    
    // ID/EX Pipeline Register
    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_rs1_data;
    reg [31:0] id_ex_rs2_data;
    reg [31:0] id_ex_imm;
    reg [4:0] id_ex_rd;
    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [3:0] id_ex_alu_op;
    reg id_ex_alu_src;
    reg id_ex_mem_read;
    reg id_ex_mem_write;
    reg id_ex_reg_write;
    reg id_ex_mem_to_reg;
    reg id_ex_branch;
    reg id_ex_jump;
    
    // EX/MEM Pipeline Register
    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_rs2_data;
    reg [4:0] ex_mem_rd;
    reg ex_mem_mem_read;
    reg ex_mem_mem_write;
    reg ex_mem_reg_write;
    reg ex_mem_mem_to_reg;
    reg ex_mem_zero;
    
    // MEM/WB Pipeline Register
    reg [31:0] mem_wb_read_data;
    reg [31:0] mem_wb_alu_result;
    reg [4:0] mem_wb_rd;
    reg mem_wb_reg_write;
    reg mem_wb_mem_to_reg;
    
    // Register file (32 registers x 32-bit)
    reg [31:0] registers [0:31];
    
    // Instruction memory (1KB)
    reg [31:0] instr_mem [0:255];
    
    // Data memory (1KB)
    reg [31:0] data_mem [0:255];
    
    // Control signals
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1, rs2, rd;
    
    // ALU wires
    wire [31:0] alu_result;
    wire zero_flag;
    
    // Forwarding unit wires
    wire [1:0] forward_a, forward_b;
    wire [31:0] forward_rs1_data, forward_rs2_data;
    
    // Initialize registers and memory
    integer i;
    initial begin
        pc = 0;
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 0;
        end
        
        // Example program: Simple addition
        instr_mem[0] = 32'h00500093; // addi x1, x0, 5
        instr_mem[1] = 32'h00a00113; // addi x2, x0, 10
        instr_mem[2] = 32'h002081b3; // add x3, x1, x2
        instr_mem[3] = 32'h00318233; // add x4, x3, x3
        instr_mem[4] = 32'hfe420ae3; // beq x4, x4, -12 (loop back)
    end
    
    // ========== STAGE 1: Instruction Fetch (IF) ==========
    wire [31:0] current_instr = instr_mem[pc[31:2]];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            if_id_pc <= 0;
            if_id_instr <= 32'h00000013; // NOP
        end else begin
            if_id_pc <= pc;
            if_id_instr <= current_instr;
            
            // PC update logic
            if (ex_mem_zero && id_ex_branch) begin
                pc <= id_ex_pc + id_ex_imm;
            end else if (id_ex_jump) begin
                pc <= id_ex_pc + id_ex_imm;
            end else begin
                pc <= pc + 4;
            end
        end
    end
    
    // ========== STAGE 2: Instruction Decode (ID) ==========
    assign opcode = if_id_instr[6:0];
    assign funct3 = if_id_instr[14:12];
    assign funct7 = if_id_instr[31:25];
    assign rs1 = if_id_instr[19:15];
    assign rs2 = if_id_instr[24:20];
    assign rd = if_id_instr[11:7];
    
    // Immediate generation
    wire [31:0] imm_i = {{20{if_id_instr[31]}}, if_id_instr[31:20]};
    wire [31:0] imm_s = {{20{if_id_instr[31]}}, if_id_instr[31:25], if_id_instr[11:7]};
    wire [31:0] imm_b = {{19{if_id_instr[31]}}, if_id_instr[31], if_id_instr[7], if_id_instr[30:25], if_id_instr[11:8], 1'b0};
    wire [31:0] imm_u = {if_id_instr[31:12], 12'b0};
    wire [31:0] imm_j = {{11{if_id_instr[31]}}, if_id_instr[31], if_id_instr[19:12], if_id_instr[20], if_id_instr[30:21], 1'b0};
    
    // Control unit
    reg [3:0] alu_op;
    reg alu_src, mem_read, mem_write, reg_write, mem_to_reg, branch, jump;
    reg [31:0] immediate;
    
    always @(*) begin
        // Default values
        alu_op = 4'b0000;
        alu_src = 0;
        mem_read = 0;
        mem_write = 0;
        reg_write = 0;
        mem_to_reg = 0;
        branch = 0;
        jump = 0;
        immediate = 0;
        
        case (opcode)
            7'b0110011: begin // R-type (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA)
                reg_write = 1;
                case (funct3)
                    3'b000: alu_op = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB : ADD
                    3'b111: alu_op = 4'b0010; // AND
                    3'b110: alu_op = 4'b0011; // OR
                    3'b100: alu_op = 4'b0100; // XOR
                    3'b001: alu_op = 4'b0101; // SLL
                    3'b101: alu_op = (funct7[5]) ? 4'b0111 : 4'b0110; // SRA : SRL
                    3'b010: alu_op = 4'b1000; // SLT
                    3'b011: alu_op = 4'b1001; // SLTU
                endcase
            end
            
            7'b0010011: begin // I-type (ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI)
                reg_write = 1;
                alu_src = 1;
                immediate = imm_i;
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b111: alu_op = 4'b0010; // ANDI
                    3'b110: alu_op = 4'b0011; // ORI
                    3'b100: alu_op = 4'b0100; // XORI
                    3'b001: alu_op = 4'b0101; // SLLI
                    3'b101: alu_op = (funct7[5]) ? 4'b0111 : 4'b0110; // SRAI : SRLI
                    3'b010: alu_op = 4'b1000; // SLTI
                    3'b011: alu_op = 4'b1001; // SLTIU
                endcase
            end
            
            7'b0000011: begin // Load (LW, LH, LB)
                reg_write = 1;
                alu_src = 1;
                mem_read = 1;
                mem_to_reg = 1;
                immediate = imm_i;
                alu_op = 4'b0000; // ADD for address calculation
            end
            
            7'b0100011: begin // Store (SW, SH, SB)
                alu_src = 1;
                mem_write = 1;
                immediate = imm_s;
                alu_op = 4'b0000; // ADD for address calculation
            end
            
            7'b1100011: begin // Branch (BEQ, BNE, BLT, BGE)
                branch = 1;
                immediate = imm_b;
                case (funct3)
                    3'b000: alu_op = 4'b0001; // BEQ (SUB for comparison)
                    3'b001: alu_op = 4'b0001; // BNE
                    3'b100: alu_op = 4'b1000; // BLT
                    3'b101: alu_op = 4'b1000; // BGE
                endcase
            end
            
            7'b1101111: begin // JAL
                reg_write = 1;
                jump = 1;
                immediate = imm_j;
            end
            
            7'b1100111: begin // JALR
                reg_write = 1;
                jump = 1;
                alu_src = 1;
                immediate = imm_i;
            end
            
            7'b0110111: begin // LUI
                reg_write = 1;
                immediate = imm_u;
                alu_op = 4'b1010; // Pass immediate
            end
            
            7'b0010111: begin // AUIPC
                reg_write = 1;
                immediate = imm_u;
                alu_op = 4'b1011; // ADD PC + immediate
            end
        endcase
    end
    
    // Read register file
    wire [31:0] rs1_data = (rs1 == 0) ? 0 : registers[rs1];
    wire [31:0] rs2_data = (rs2 == 0) ? 0 : registers[rs2];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_ex_pc <= 0;
            id_ex_rs1_data <= 0;
            id_ex_rs2_data <= 0;
            id_ex_imm <= 0;
            id_ex_rd <= 0;
            id_ex_rs1 <= 0;
            id_ex_rs2 <= 0;
            id_ex_alu_op <= 0;
            id_ex_alu_src <= 0;
            id_ex_mem_read <= 0;
            id_ex_mem_write <= 0;
            id_ex_reg_write <= 0;
            id_ex_mem_to_reg <= 0;
            id_ex_branch <= 0;
            id_ex_jump <= 0;
        end else begin
            id_ex_pc <= if_id_pc;
            id_ex_rs1_data <= rs1_data;
            id_ex_rs2_data <= rs2_data;
            id_ex_imm <= immediate;
            id_ex_rd <= rd;
            id_ex_rs1 <= rs1;
            id_ex_rs2 <= rs2;
            id_ex_alu_op <= alu_op;
            id_ex_alu_src <= alu_src;
            id_ex_mem_read <= mem_read;
            id_ex_mem_write <= mem_write;
            id_ex_reg_write <= reg_write;
            id_ex_mem_to_reg <= mem_to_reg;
            id_ex_branch <= branch;
            id_ex_jump <= jump;
        end
    end
    
    // ========== STAGE 3: Execute (EX) ==========
    
    // Forwarding logic
    assign forward_a = (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs1)) ? 2'b10 :
                       (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs1)) ? 2'b01 : 2'b00;
    
    assign forward_b = (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs2)) ? 2'b10 :
                       (mem_wb_reg_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs2)) ? 2'b01 : 2'b00;
    
    assign forward_rs1_data = (forward_a == 2'b10) ? ex_mem_alu_result :
                              (forward_a == 2'b01) ? (mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result) :
                              id_ex_rs1_data;
    
    assign forward_rs2_data = (forward_b == 2'b10) ? ex_mem_alu_result :
                              (forward_b == 2'b01) ? (mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result) :
                              id_ex_rs2_data;
    
    // ALU inputs
    wire [31:0] alu_in1 = forward_rs1_data;
    wire [31:0] alu_in2 = id_ex_alu_src ? id_ex_imm : forward_rs2_data;
    
    // ALU
    assign alu_result = (id_ex_alu_op == 4'b0000) ? (alu_in1 + alu_in2) :             // ADD
                        (id_ex_alu_op == 4'b0001) ? (alu_in1 - alu_in2) :             // SUB
                        (id_ex_alu_op == 4'b0010) ? (alu_in1 & alu_in2) :             // AND
                        (id_ex_alu_op == 4'b0011) ? (alu_in1 | alu_in2) :             // OR
                        (id_ex_alu_op == 4'b0100) ? (alu_in1 ^ alu_in2) :             // XOR
                        (id_ex_alu_op == 4'b0101) ? (alu_in1 << alu_in2[4:0]) :       // SLL
                        (id_ex_alu_op == 4'b0110) ? (alu_in1 >> alu_in2[4:0]) :       // SRL
                        (id_ex_alu_op == 4'b0111) ? ($signed(alu_in1) >>> alu_in2[4:0]) : // SRA
                        (id_ex_alu_op == 4'b1000) ? ($signed(alu_in1) < $signed(alu_in2)) : // SLT
                        (id_ex_alu_op == 4'b1001) ? (alu_in1 < alu_in2) :             // SLTU
                        (id_ex_alu_op == 4'b1010) ? id_ex_imm :                       // LUI
                        (id_ex_alu_op == 4'b1011) ? (id_ex_pc + id_ex_imm) : 0;      // AUIPC
    
    assign zero_flag = (alu_result == 0);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_mem_alu_result <= 0;
            ex_mem_rs2_data <= 0;
            ex_mem_rd <= 0;
            ex_mem_mem_read <= 0;
            ex_mem_mem_write <= 0;
            ex_mem_reg_write <= 0;
            ex_mem_mem_to_reg <= 0;
            ex_mem_zero <= 0;
        end else begin
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data <= forward_rs2_data;
            ex_mem_rd <= id_ex_rd;
            ex_mem_mem_read <= id_ex_mem_read;
            ex_mem_mem_write <= id_ex_mem_write;
            ex_mem_reg_write <= id_ex_reg_write;
            ex_mem_mem_to_reg <= id_ex_mem_to_reg;
            ex_mem_zero <= zero_flag;
        end
    end
    
    // ========== STAGE 4: Memory Access (MEM) ==========
    wire [31:0] mem_read_data = data_mem[ex_mem_alu_result[31:2]];
    
    always @(posedge clk) begin
        if (ex_mem_mem_write) begin
            data_mem[ex_mem_alu_result[31:2]] <= ex_mem_rs2_data;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_wb_read_data <= 0;
            mem_wb_alu_result <= 0;
            mem_wb_rd <= 0;
            mem_wb_reg_write <= 0;
            mem_wb_mem_to_reg <= 0;
        end else begin
            mem_wb_read_data <= mem_read_data;
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_rd <= ex_mem_rd;
            mem_wb_reg_write <= ex_mem_reg_write;
            mem_wb_mem_to_reg <= ex_mem_mem_to_reg;
        end
    end
    
    // ========== STAGE 5: Write Back (WB) ==========
    wire [31:0] write_back_data = mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result;
    
    always @(posedge clk) begin
        if (mem_wb_reg_write && mem_wb_rd != 0) begin
            registers[mem_wb_rd] <= write_back_data;
        end
    end
    
    // Debug outputs
    assign pc_out = pc;
    assign instr_out = current_instr;
    
endmodule