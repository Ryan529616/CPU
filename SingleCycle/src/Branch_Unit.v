`include "defines.v"

module Branch_Unit(
    input           PCSrc,
    input           Branch_Ctrl,
    input           Branch_ALU,
    input    [6:0]  opcode,
    input   [31:0]  pc,
    input   [31:0]  imm,
    input   [31:0]  rd_data,
    output  [31:0]  pc2reg,
    output  [31:0]  next_pc
);
    assign pc2reg = PCSrc ? (pc + imm) : (pc + 32'd4);
    assign next_pc = (opcode==`JALR) ? rd_data : ((opcode==`JAL)||(Branch_Ctrl & Branch_ALU)) ? (pc + imm) : (pc + 32'd4);
endmodule

