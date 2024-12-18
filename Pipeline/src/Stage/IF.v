`include "IF/Branch_Predict.v"
`include "IF/Imme_Ext.v"
`include "IF/Instruction_cache.v"
`include "IF/Reg_PC.v"

module IF (
    input         clk,
    input         rst,
    input         branch,
    input         branch_taken,
    input  [31:0] instruction_in,
    output [31:0] instruction_out,
    output [31:0] pc,
    output [31:0] next_pc,
    output [31:0] imm
);  

    Branch_Predict branch_predict(
        .clk(clk), 
        .rst(rst), 
        .branch_taken(branch_taken), 
        .branch(branch), 
        .pc(pc), 
        .imm(imm), 
        .next_pc(next_pc)
    );

     Imme_Ext imme_ext(
        .instruction(instruction_out), 
        .imm(imm)
    );

    Instruction_cache instruction_cache(
        .instruction_in(instruction_in), 
        .instruction_out(instruction_out)
    );

    Reg_PC reg_pc(
        .clk(clk), 
        .rst(rst), 
        .next_pc(next_pc), 
        .pc(pc)
    );

endmodule