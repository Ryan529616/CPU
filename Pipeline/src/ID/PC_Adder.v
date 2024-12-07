`timescale 1ns/1ps

module PC_Adder(
    input   [31:0]  pc,
    input   [31:0]  imm,
    output  [31:0]  pc_imm,
);
    assign pc_imm = pc + imm;
endmodule

