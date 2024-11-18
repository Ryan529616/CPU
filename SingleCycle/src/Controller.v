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
    output reg          PCSrc,
    output reg  [4:0]   ALUOp
);

    always@*begin
        case(opcode)
            `LUI:   {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010110;
            `AUIPC: {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010111;
            `JAL:   {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b110110;
            `JALR:  {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b110110;
            `BRANCH:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b110000;
            `LOAD:  {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b011110;
            `STORE: {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010100;
            `OP_IMM:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010110;
            `OP:    {Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010010;
            default:{Branch,MemREAD,MemtoReg,ALUSrc,RegWrite,PCSrc} = 6'b010000;
        endcase
    end

    always@*begin
        case(opcode) 
            `LUI:   ALUOp = `LUI_ALUOP;
            `AUIPC: ALUOp = `IDLE;
            `JAL:   ALUOp = `IDLE;
            `JALR:  ALUOp = `IDLE;
            `BRANCH: begin
                case(funct3)
                    3'b000:  ALUOp = `BEQ;
                    3'b001:  ALUOp = `BNE;
                    3'b100:  ALUOp = `BLT;
                    3'b101:  ALUOp = `BGE;
                    3'b110:  ALUOp = `BLTU;
                    3'b111:  ALUOp = `BGEU;
                    default: ALUOp = `IDLE;
                endcase
            end
            `LOAD:  ALUOp = `ADD;
            `STORE: ALUOp = `ADD;
            `OP_IMM: begin
                case(funct3)
                    3'b000: ALUOp = `ADD;
                    3'b001: ALUOp = `SLL;
                    3'b010: ALUOp = `SLT;
                    3'b011: ALUOp = `SLTU;
                    3'b100: ALUOp = `XOR;
                    3'b101: ALUOp = `SRL;
                    3'b110: ALUOp = `OR;
                    3'b111: ALUOp = `AND;
                endcase
            end
            `OP: begin
                case(funct7)
                    7'b0000000: begin
                        case(funct3)
                            3'b000: ALUOp = `ADD;
                            3'b001: ALUOp = `SLL;
                            3'b010: ALUOp = `SLT;
                            3'b011: ALUOp = `SLTU;
                            3'b100: ALUOp = `XOR;
                            3'b101: ALUOp = `SRL;
                            3'b110: ALUOp = `OR;
                            3'b111: ALUOp = `AND;
                        endcase
                    end
                    7'b0100000: begin
                        case(funct3)
                            3'b000:  ALUOp = `SUB;
                            3'b101:  ALUOp = `SRA;
                            default: ALUOp = `IDLE;
                        endcase
                    end
                    default: ALUOp = `IDLE;
                endcase
            end
            default: ALUOp = `IDLE;
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
