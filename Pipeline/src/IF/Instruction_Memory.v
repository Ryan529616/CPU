`timescale 1ns/1ps
`include "defines.v"

module Instruction_Memory(
    input               clk,
    input      [31:0]   pc,
    output reg [31:0]   instruction
);
    Sram sram(
        .clk(clk),
        .MemREAD(1'b1),
        .MemWrite(`WRITE_IDLE),
        .address(pc),
        .write_data(32'bz),
        .read_data(instruction)
    );

endmodule
