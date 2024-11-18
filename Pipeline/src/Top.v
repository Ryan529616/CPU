`timescale 1ns/1ps
`include "Reg_PC.v"
`include "Instruction_Memory.v"
`include "Decoder.v"
`include "Imme_Ext.v"
`include "Controller.v"
`include "RegFile.v"
`include "ALU_Src_MUX.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "LD_Filter.v"
`include "Branch_Unit.v"
`include "RegWrite_MUX.v"

module Top(
    input clk,
    input rst
);
    wire    [31:0]  pc;
    wire    [31:0]  next_pc;
    wire    [31:0]  instruction;
    wire    [6:0]   opcode;
    wire    [4:0]   rs1;
    wire    [4:0]   rs2;
    wire    [4:0]   rd;
    wire    [2:0]   funct3;
    wire    [6:0]   funct7;
    wire            Branch;
    wire            MemRead;
    wire            MemtoReg;
    wire    [1:0]   MemWrite;
    wire            ALUSrc;
    wire            RegWrite;
    wire    [4:0]   ALUOp;
    wire            PCSrc;
    wire    [31:0]  Read_data_1;
    wire    [31:0]  Read_data_2;
    wire    [31:0]  imm;
    wire    [31:0]  rd_data;
    wire    [31:0]  Mem_out;
    wire    [31:0]  sign_extended_data;
    wire            Branch_ALU;
    wire    [31:0]  pc2reg;
    wire    [31:0]  ALU_in2;
    wire    [31:0]  Write_data;

endmodule
