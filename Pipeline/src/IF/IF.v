module IF (
    input             clk,
    input             rst,
    input             PCSrc,
    input      [31:0] pc_imm,
    output     [31:0] instruction,
    output reg [31:0] pc
);  
    wire next_pc;
    assign next_pc = (PCSrc)? pc_imm : pc + 32'd4;

    Instruction_Memory instruction_memory(
        .clk(clk), 
        .pc(pc), 
        .instruction(instruction)
    );

    Reg_PC PC(
        .clk(clk), 
        .rst(rst), 
        .next_pc(next_pc), 
        .pc(pc)
    );

endmodule