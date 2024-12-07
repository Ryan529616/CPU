<<<<<<< HEAD
module ID (
    input         clk,
    input         rst,
    input         RegWrite_in,
    input  [4:0]  rd_in,
    input  [31:0] instruction,
    input  [31:0] pc,
    input  [31:0] Write_data,

    output [6:0]  opcode,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd_out,
    output [2:0]  funct3,
    output [6:0]  funct7
    output [31:0] Read_data_1,
    output [31:0] Read_data_2,
    output [31:0] pc_imm,
////Controller
    output        Branch,
    output        MemREAD,
    output        MemtoReg,
    output [1:0]  MemWrite,
    output        ALUSrc,
    output        RegWrite,
    output        PCSrc,
    output [4:0]  ALUOp
);

    Controller controller(
        .opcode(opcode), 
        .funct3(funct3), 
        .funct7(funct7), 
        .ALUOp(ALUOp), 
        .Branch(Branch), 
        .MemREAD(MemRead), 
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
        .rd(rd_out), 
        .funct3(funct3), 
        .funct7(funct7)
    );

    Imme_Ext imme_ext(
        .instruction(instruction), 
        .imm(imm)
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

    PC_Adder pc_adder(
        .pc(pc), 
        .imm(imm), 
        .pc_imm(pc_imm)
    );

=======
module ID (
    input         clk,
    input         rst,
    input         RegWrite_in,
    input  [4:0]  rd_in,
    input  [31:0] instruction,
    input  [31:0] pc,
    input  [31:0] Write_data,

    output [6:0]  opcode,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd_out,
    output [2:0]  funct3,
    output [6:0]  funct7
    output [31:0] Read_data_1,
    output [31:0] Read_data_2,
    output [31:0] pc_imm,
////Controller
    output        Branch,
    output        MemREAD,
    output        MemtoReg,
    output [1:0]  MemWrite,
    output        ALUSrc,
    output        RegWrite,
    output        PCSrc,
    output [4:0]  ALUOp
);

    Controller controller(
        .opcode(opcode), 
        .funct3(funct3), 
        .funct7(funct7), 
        .ALUOp(ALUOp), 
        .Branch(Branch), 
        .MemREAD(MemRead), 
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
        .rd(rd_out), 
        .funct3(funct3), 
        .funct7(funct7)
    );

    Imme_Ext imme_ext(
        .instruction(instruction), 
        .imm(imm)
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

    PC_Adder pc_adder(
        .pc(pc), 
        .imm(imm), 
        .pc_imm(pc_imm)
    );

>>>>>>> bdb7ead (2024/12/8)
endmodule