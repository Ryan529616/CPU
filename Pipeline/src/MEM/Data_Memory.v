<<<<<<< HEAD
`timescale 1ns/1ps
`include "defines.v"

module Data_Memory(
    input           clk,
    input           MemREAD,
    input   [1:0]   MemWrite,
    input   [31:0]  address,
    input   [31:0]  write_data,
    output reg [31:0] read_data
);
    Sram sram(
        .clk(clk),
        .MemREAD(MemREAD),
        .MemWrite(MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
endmodule
=======
`timescale 1ns/1ps
`include "defines.v"

module Data_Memory(
    input           clk,
    input           MemREAD,
    input   [1:0]   MemWrite,
    input   [31:0]  address,
    input   [31:0]  write_data,
    output reg [31:0] read_data
);
    Sram sram(
        .clk(clk),
        .MemREAD(MemREAD),
        .MemWrite(MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
endmodule
>>>>>>> bdb7ead (2024/12/8)
