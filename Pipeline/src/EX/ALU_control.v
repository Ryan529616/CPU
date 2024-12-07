<<<<<<< HEAD
module ALU_control (
    input      [2:0] funct3,
    input      [6:0] funct7,
    input      [6:0] opcode
    output reg [4:0] ALUOp
);

    always@*begin
        case(opcode) 
            `LUI:   ALUOp = `ADD;
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
=======
module ALU_control (
    input      [2:0] funct3,
    input      [6:0] funct7,
    input      [6:0] opcode
    output reg [4:0] ALUOp
);

    always@*begin
        case(opcode) 
            `LUI:   ALUOp = `ADD;
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
>>>>>>> bdb7ead (2024/12/8)
endmodule