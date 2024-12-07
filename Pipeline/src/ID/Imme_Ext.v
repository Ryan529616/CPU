<<<<<<< HEAD
`timescale 1ns/1ps
`include "defines.v"

module Imme_Ext(
    input      [31:0]  instruction,
    output reg [31:0]  imm
); 
    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always@* begin
        case(opcode)
            `I_type, `JALR, `LOAD: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            `S_type: begin
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            `B_type: begin
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            `LUI,`AUIPC: begin
                imm = {instruction[31:12], 12'b0};
            end
            `J_type: begin
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            default: begin
                imm = 32'h0;
            end
        endcase 
    end
endmodule
=======
`timescale 1ns/1ps
`include "defines.v"

module Imme_Ext(
    input      [31:0]  instruction,
    output reg [31:0]  imm
); 
    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always@* begin
        case(opcode)
            `I_type, `JALR, `LOAD: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            `S_type: begin
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            `B_type: begin
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            `LUI,`AUIPC: begin
                imm = {instruction[31:12], 12'b0};
            end
            `J_type: begin
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            default: begin
                imm = 32'h0;
            end
        endcase 
    end
endmodule
>>>>>>> bdb7ead (2024/12/8)
