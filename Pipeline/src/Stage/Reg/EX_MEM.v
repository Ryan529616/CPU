module EX_MEM (
    input clk,
    input rst,
    input [31:0] pc_in,
    input [31:0] imm_in,
    input [31:0] rd_data_in,
    input [4:0] rd_in,
    input Branch_ALU_in,
    input [31:0] pc_imm_in,
    input RegWrite_in,
    input MemtoReg_in,
    input [31:0] ALU_result_in,
    input [31:0] rd_data_in,
    input [31:0] pc_in,
    input [31:0] imm_in,
    input [31:0] instruction_in,
    output [31:0] pc_out,
    output [31:0] imm_out,
    output [31:0] rd_data_out,
    output [4:0] rd_out,
    output Branch_ALU_out,
    output [31:0] pc_imm_out,
    output RegWrite_out,
    output MemtoReg_out,
    output [31:0] ALU_result_out,
    output [31:0] rd_data_out,
    output [31:0] pc_out,
    output [31:0] imm_out,
    output [31:0] instruction_out
);
    always@(posedge clk)begin
        if(rst) begin
            pc_out <= 32'b0;
            imm_out <= 32'b0;
            rd_data_out <= 32'b0;
            rd_out <= 5'b0;
            Branch_ALU_out <= 1'b0;
            pc_imm_out <= 32'b0;
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            ALU_result_out <= 32'b0;
            rd_data_out <= 32'b0;
            pc_out <= 32'b0;
            imm_out <= 32'b0;
            instruction_out <= 32'b0;
        end
        else begin
            pc_out <= pc_in;
            imm_out <= imm_in;
            rd_data_out <= rd_data_in;
            rd_out <= rd_in;
            Branch_ALU_out <= Branch_ALU_in;
            pc_imm_out <= pc_imm_in;
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            ALU_result_out <= ALU_result_in;
            rd_data_out <= rd_data_in;

endmodule