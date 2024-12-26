`include "defines.v"

module ALU (
    input  wire  [4:0] ALUOp,
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    output reg  [31:0] rd_data,
);
    always @* begin
        rd_data = 32'b0;
        case(ALUOp)
            `ADD: begin
                rd_data = rs1_data + rs2_data;
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
            default:begin
            end
        endcase
    end

endmodule
