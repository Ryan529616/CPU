`timescale 1ns/1ps
`include "defines.v"

module Controller(
    input       [6:0]   opcode,
    input       [2:0]   funct3,
    input       [6:0]   funct7,
    output reg          Branch,
    output reg          MemREAD,
    output reg          MemtoReg,
    output reg  [1:0]   MemWrite,
    output reg          ALUSrc,
    output reg          RegWrite,
    output reg          Branch,
);

    always@*begin
        case(opcode)
            `LUI:   {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000110;
            `AUIPC: {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000111;
            `JAL:   {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b100110;
            `JALR:  {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b100110;
            `BRANCH:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b100100;
            `LOAD:  {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b011110;
            `STORE: {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000100;
            `OP_IMM:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000110;
            `OP:    {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000010;
            default:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,Branch} = 6'b000000;
        endcase
    end

    

    always@*begin
        if(opcode == `STORE)begin
            case(funct3)
                `SB:  MemWrite = `WRITE_BYTE;
                `SH:  MemWrite = `WRITE_HALF;
                `SW:  MemWrite = `WRITE_WORD;
                default: MemWrite = `WRITE_IDLE;
            endcase
        end
        else begin
            MemWrite = `WRITE_IDLE;
        end
    end
endmodule
