`timescale 1ns/1ps
`include "Reg_PC.v"
`include "Decoder.v"
`include "Imme_Ext.v"
`include "Controller.v"
`include "RegFile.v"
`include "ALU_Src_MUX.v"
`include "ALU.v"
`include "LD_Filter.v"
`include "Branch_Unit.v"
`include "RegWrite_MUX.v"

module Top(
    input clk,
    input rst,
    input [31:0] data,
    input [31:0] instruction,
    output [31:0] pc,
    output [31:0] rd_data,
    output [31:0] Read_data_2,
    output MemRead,
    output [1:0]MemWrite
);
    wire    [31:0]  Write_data;
    wire    [31:0]  next_pc;
    wire    [6:0]   opcode;
    wire    [4:0]   rs1;
    wire    [4:0]   rs2;
    wire    [4:0]   rd;
    wire    [2:0]   funct3;
    wire    [6:0]   funct7;
    wire            Branch;
    wire            MemtoReg;
    wire            ALUSrc;
    wire            RegWrite;
    wire    [4:0]   ALUOp;
    wire            PCSrc;
    wire    [31:0]  Read_data_1;
    wire    [31:0]  imm;
    wire    [31:0]  sign_extended_data;
    wire            Branch_ALU;
    wire    [31:0]  pc2reg;
    wire    [31:0]  ALU_in2;


    ALU_Src_MUX alu_src_mux(
        .ALU_Src(ALUSrc), 
        .imm(imm), 
        .Read_data_2(Read_data_2), 
        .ALU_in2(ALU_in2)
    );

    ALU alu(
        .ALUOp(ALUOp), 
        .rs1_data(Read_data_1), 
        .rs2_data(ALU_in2), 
        .rd_data(rd_data), 
        .Branch_ALU(Branch_ALU)
    );

    Branch_Unit branch_unit(
        .pc(pc), 
        .imm(imm), 
        .PCSrc(PCSrc), 
        .Branch_Ctrl(Branch), 
        .Branch_ALU(Branch_ALU), 
        .pc2reg(pc2reg), 
        .next_pc(next_pc),
        .opcode(opcode),
        .rd_data(rd_data)
    );

    Controller controller(
        .opcode(opcode), 
        .funct3(funct3), 
        .funct7(funct7), 
        .ALUOp(ALUOp), 
        .Branch(Branch), 
        .MemRead(MemRead), 
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .RegWrite(RegWrite), 
        .PCSrc(PCSrc)
    );


    Decoder decoder(
        .instruction(instruction), 
        .opcode(opcode), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .funct3(funct3), 
        .funct7(funct7)
    );

    Imme_Ext imme_ext(
        .instruction(instruction), 
        .imm(imm)
    );

    LD_Filter ld_filter(
        .load_data(data), 
        .funct3(funct3), 
        .sign_extended_data(sign_extended_data)
    );

    Reg_PC PC(
        .clk(clk), 
        .rst(rst), 
        .next_pc(next_pc), 
        .pc(pc)
    );

    RegFile regfile(
        .clk(clk), 
        .rst(rst), 
        .Read_register_1(rs1), 
        .Read_register_2(rs2), 
        .Write_register(rd), 
        .Write_data(Write_data), 
        .RegWrite(RegWrite), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2)
    );

    RegWrite_MUX regwrite_mux(
        .MemtoReg(MemtoReg), 
        .pc2reg(pc2reg), 
        .opcode(opcode),
        .ALU_result(rd_data), 
        .Read_data(sign_extended_data), 
        .Write_data(Write_data)
    );

endmodule
