`timescale 1ns/1ps
`include "defines.v"

module ALU (
    input [4:0] ALUOp,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    output reg [31:0] rd_data,
    output reg Branch_ALU
);
    always @* begin
        Branch_ALU = 1'b0;
        rd_data = 32'b0;
        case(ALUOp)
            `ADD: begin
                rd_data = rs1_data + rs2_data;
                Branch_ALU = 1'b1;
            end
            `SUB: begin
                rd_data = rs1_data - rs2_data;
            end
            `SLL:begin
                rd_data = rs1_data << rs2_data[4:0];
            end
            `SLT:begin
                rd_data[0] = $signed(rs1_data) < $signed(rs2_data);
            end
            `SLTU:begin
                rd_data[0] = rs1_data < rs2_data;
            end
            `XOR:begin
                rd_data = rs1_data ^ rs2_data;
            end
            `SRL:begin
                rd_data = rs1_data >> rs2_data[4:0];
            end
            `SRA:begin
                rd_data = $signed(rs1_data) >>> rs2_data[4:0];
            end
            `OR:begin
                rd_data = rs1_data | rs2_data;
            end
            `AND:begin
                rd_data = rs1_data & rs2_data;
            end
            `BEQ:begin
                if(rs1_data == rs2_data) Branch_ALU = 1'b1;
                else Branch_ALU = 1'b0;
            end
            `BNE:begin
                if(rs1_data != rs2_data) Branch_ALU = 1'b1;
                else Branch_ALU = 1'b0;
            end
            `BLT:begin
                if($signed(rs1_data) < $signed(rs2_data)) Branch_ALU = 1'b1;
                else Branch_ALU = 1'b0;
            end
            `BGE:begin
                if($signed(rs1_data) >= $signed(rs2_data)) Branch_ALU = 1'b1;
                else Branch_ALU = 1'b0;
            end
            `BLTU:begin
                if(rs1_data < rs2_data) Branch_ALU = 1;
                else Branch_ALU = 1'b0;
            end
            `BGEU:begin
                if(rs1_data >= rs2_data) Branch_ALU = 1;
                else Branch_ALU = 1'b0;
            end
            default:begin
            end
        endcase
    end

endmodule
