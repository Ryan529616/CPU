`include "defines.v"

`ifndef SRAM_V
`define SRAM_V
module Sram(
    input               clk,
    input               MemRead,
    input       [1:0]   MemWrite,
    input       [31:0]  address,
    input       [31:0]  write_data,
    output reg  [31:0]  read_data
);
    reg [7:0] mem [0:65535];

    always @(posedge clk) begin

        case(MemWrite)
            `WRITE_IDLE: begin
            end
            `WRITE_BYTE: begin 
                mem[address]            <= write_data[7:0];
            end
            `WRITE_HALF: begin
                mem[address]            <= write_data[7:0]; 
                mem[address + 32'd1]    <= write_data[15:8];
            end
            `WRITE_WORD: begin 
                mem[address]            <= write_data[7:0];
                mem[address + 32'd1]    <= write_data[15:8];
                mem[address + 32'd2]    <= write_data[23:16];
                mem[address + 32'd3]    <= write_data[31:24];
            end
        endcase
    end
    always @* begin
        if (MemRead) begin
            read_data = {mem[address + 3], mem[address + 2], mem[address + 1], mem[address]};
        end else begin
            read_data = 32'bz;
        end
    end

endmodule
`endif