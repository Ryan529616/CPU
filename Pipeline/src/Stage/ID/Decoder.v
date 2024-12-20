`include "../defines.v"

module Decoder(
    input    [2:0]  current_state,
    input   [31:0]  instruction,
    output  [6:0]   opcode,
    output  [4:0]   rs1,
    output  [4:0]   rs2,
    output  [4:0]   rd,
    output  [2:0]   funct3,
    output  [6:0]   funct7
    output reg          Branch,
    output reg          MemRead,
    output reg          MemtoReg,
    output reg  [1:0]  MemWrite,
    output reg          ALUSrc,
    output reg          RegWrite,
    output reg          csr_we_id2ex,
    output reg  [11:0]  csr_addr
);

    assign opcode   = instruction[6:0];
    assign rd       = instruction[11:7];
    assign funct3   = instruction[14:12];
    assign rs1      = instruction[19:15];
    assign rs2      = instruction[24:20];
    assign funct7   = instruction[31:25];


    always@*begin
        case(current_state)
        `NORMAL: begin
            case(opcode)
                `LUI:   {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01011;
                `AUIPC: {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01011;
                `JAL:   {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b11011;
                `JALR:  {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b11011;
                `BRANCH:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b11010;
                `LOAD:  {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01111;
                `STORE: {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01010;
                `OP_IMM:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01011;
                `OP:    {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01001;
                default:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01000;
            endcase
        end
        `NOP: begin
            {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b00000;
        end
        default: begin
            {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b01000;
        end
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
