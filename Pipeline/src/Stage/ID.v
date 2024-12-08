`include "ID/Branch_Comparator.v"
`include "ID/Controller.v"
`include "ID/Decoder.v"
`include "ID/RegFile.v"

module ID (
    input         clk,
    input         rst,
    input         RegWrite_in,
    input   [4:0]  rd_in,
    input   [31:0] instruction,
    input   [31:0] pc,
    input   [31:0] Write_data,

    output [6:0]  opcode,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd_out,
    output [2:0]  funct3,
    output [6:0]  funct7,
    output [31:0] Read_data_1,
    output [31:0] Read_data_2,

    output      branch_taken,
////Controller
    output          Branch,
    output          MemREAD,
    output          MemtoReg,
    output [1:0]  MemWrite,
    output           ALUSrc,
    output           RegWrite,
    output [4:0]  ALUOp
);

    Branch_Comparator branch_comparator(
        .funct3(funct3), 
        .opcode(opcode), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2), 
        .branch_taken(branch_taken)
    );

    Controller controller(
        .opcode(opcode), 
        .funct3(funct3), 
        .funct7(funct7), 
        .Branch(Branch), 
        .MemREAD(MemRead), 
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .RegWrite(RegWrite)
    );

    Decoder decoder(
        .instruction(instruction), 
        .opcode(opcode), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd_out), 
        .funct3(funct3), 
        .funct7(funct7)
    );

    RegFile regfile(
        .clk(clk),
        .Read_register_1(rs1), 
        .Read_register_2(rs2), 
        .Write_register(rd_in), 
        .Write_data(Write_data), 
        .RegWrite(RegWrite_in), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2)
    );



endmodule