`include "Top.v"

module Chip(
    input clk,
    input rst,
    input [31:0] data,
    input [31:0] instruction,
    output [31:0] pc,
    output [31:0] rd_data,
    output [31:0] Read_data_2,
    output MemREAD,
    output [1:0]MemWrite
);

    Top top(
        .clk(clk),
        .rst(rst),
        .data(data),
        .instruction(instruction),
        .pc(pc),
        .rd_data(rd_data),
        .Read_data_2(Read_data_2),
        .MemREAD(MemREAD),
        .MemWrite(MemWrite)
    );
    
endmodule