module ID_EX (
    input clk,
    input flush,
    input stall,
    
    input   [4:0] rs1_in,
    input   [4:0] rs2_in,
    input   [4:0] rd_in,
    input   [2:0] funct3_in,
    input [31:0] pc_in,
    input [31:0] Read_data_1_in,
    input [31:0] Read_data_2_in,
    input [31:0] imm_in,

    output   [4:0] rs1_out,
    output   [4:0] rs2_out,
    output   [4:0] rd_out,
    output   [2:0] funct3_out,
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
    input   [4:0] ALUOp_in,
    input         PC2Reg_in,

    output        Branch_out,
    output        MemREAD_out,
    output        MemtoReg_out,
    output  [1:0] MemWrite_out,
    output        ALUSrc_out,
    output        RegWrite_out,
    output  [4:0] ALUOp_out,
    output        PC2Reg_out
);

    always@(posedge clk)begin
        if(flush) begin
            rs1_out         <= 5'b0;
            rs2_out         <= 5'b0;
            rd_out          <= 5'b0;
            funct3_out      <= 3'b0;
            pc_out          <= 32'b0;
            Read_data_1_out <= 32'b0;
            Read_data_2_out <= 32'b0;
            imm_out         <= 32'b0;
            MemREAD_out     <= 1'b0;
            MemWrite_out    <= 1'b0;
            MemtoReg_out    <= 1'b0;
            ALUSrc_out      <= 1'b0;
            RegWrite_out    <= 1'b0;
            ALUOp_out       <= 5'b0;
            PC2Reg_out      <= 1'b0;
        end
        else if(stall) begin
            rs1_out         <= rs1_out;
            rs2_out         <= rs2_out;
            rd_out          <= rd_out;
            funct3_out      <= funct3_out;
            pc_out          <= pc_out;
            Read_data_1_out <= Read_data_1_out;
            Read_data_2_out <= Read_data_2_out;
            imm_out         <= imm_out;
            MemREAD_out     <= MemREAD_out;
            MemWrite_out    <= MemWrite_out;
            MemtoReg_out    <= MemtoReg_out;
            ALUSrc_out      <= ALUSrc_out;
            RegWrite_out    <= RegWrite_out;
            ALUOp_out       <= ALUOp_out;
            PC2Reg_out      <= PC2Reg_out;
        end
        else begin
            rs1_out         <= rs1_in;
            rs2_out         <= rs2_in;
            rd_out          <= rd_in;
            funct3_out      <= funct3_in;
            pc_out          <= pc_in;
            Read_data_1_out <= Read_data_1_in;
            Read_data_2_out <= Read_data_2_in;
            imm_out         <= imm_in;
            MemREAD_out     <= MemREAD_in;
            MemWrite_out    <= MemWrite_in;
            MemtoReg_out    <= MemtoReg_in;
            ALUSrc_out      <= ALUSrc_in;
            RegWrite_out    <= RegWrite_in;
            ALUOp_out       <= ALUOp_in;
            PC2Reg_out      <= PC2Reg_in;
        end
    end







endmodule