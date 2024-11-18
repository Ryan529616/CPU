`timescale 1ns/1ps

module Branch_Unit(
    input   [31:0]  pc,
    input   [31:0]  imm,
    input           PCSrc,
    input           Branch_Ctrl,
    input           Branch_ALU,
    output  [31:0]  pc2reg,
    output  [31:0]  next_pc
);
    assign pc2reg = PCSrc ? (pc + imm) : (pc + 32'd4);
    assign next_pc = (Branch_Ctrl & Branch_ALU) ? (pc + imm) : (pc + 32'd4);
endmodule

