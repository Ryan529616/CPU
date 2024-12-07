module ID_EX (
    input clk,
//    output  [6:0]  opcode,
//    output  [6:0]  funct7
    
    input  [4:0] rs1_in,
    input  [4:0] rs2_in,
    input  [4:0] rd_in,
    input  [2:0] funct3_in,
    input [31:0] pc_in,
    input [31:0] Read_data_1_in,
    input [31:0] Read_data_2_in,
    input [31:0] imm_in,

    output  [4:0] rs1_out,
    output  [4:0] rs2_out,
    output  [4:0] rd_out,
    output  [2:0] funct3_out,
    output [31:0] pc_out,
    output [31:0] Read_data_1_out,
    output [31:0] Read_data_2_out,
    output [31:0] imm_out,

////Controller
    input         Branch_in,
    input         MemREAD_in,
    input         MemtoReg_in,
    input   [1:0] MemWrite_in,
    input         ALUSrc_in,
    input         RegWrite_in,
    input         PCSrc_in,
    input   [4:0] ALUOp_in,

    output        Branch_out,
    output        MemREAD_out,
    output        MemtoReg_out,
    output  [1:0] MemWrite_out,
    output        ALUSrc_out,
    output        RegWrite_out,
    output        PCSrc_out,
    output  [4:0] ALUOp_out
);

    always@(posedge clk)begin
        rs1_out         <= rs1_in; 
        rs2_out         <= rs2_in;
        rd_out          <= rd_in;
        funct3_out      <= funct3_in;
        pc_out          <= pc_in;
        Read_data_1_out <= Read_data_1_in;
        Read_data_2_out <= Read_data_2_in;
        imm_out         <= imm_in;

        Branch_out      <= Branch_in;
        MemREAD_out     <= MemREAD_in;
        MemtoReg_out    <= MemtoReg_in;
        MemWrite_out    <= MemWrite_in;
        ALUSrc_out      <= ALUSrc_in;
        RegWrite_out    <= RegWrite_in;
        PCSrc_out       <= PCSrc_in;
        ALUOp_out       <= ALUOp_in;
    end

endmodule