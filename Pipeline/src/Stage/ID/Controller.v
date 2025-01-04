module Controller(
    input           nop,
    input   [31:0]  instruction,
    output  [6:0]   opcode,
    output  [4:0]   rs1,
    output  [4:0]   rs2,
    output  [4:0]   rd,
    output  [2:0]   funct3,
    output  [6:0]   funct7,
    output reg          Branch,
    output reg          MemRead,
    output reg          MemtoReg,
    output reg  [1:0]   MemWrite,
    output reg          ALUSrc,
    output reg          RegWrite,
    output reg          PC2Reg
    /*
    output reg          csr_we_id2ex,
    output reg  [11:0]  csr_addr
    */
);

    assign opcode   = instruction[6:0];
    assign rd       = instruction[11:7];
    assign funct3   = instruction[14:12];
    assign rs1      = instruction[19:15];
    assign rs2      = instruction[24:20];
    assign funct7   = instruction[31:25];


    always@*begin
        if(nop)begin
            {Branch,MemRead,MemtoReg,ALUSrc,RegWrite} = 5'b00000;
        end
        else begin
            case(opcode)
                `LUI:   {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000110;
                `AUIPC: {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000111;
                `JAL:   {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b100111;
                `JALR:  {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b100111;
                `BRANCH:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b100100;
                `LOAD:  {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b011110;
                `STORE: {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000100;
                `OP_IMM:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000110;
                `OP:    {Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000010;
                default:{Branch,MemRead,MemtoReg,ALUSrc,RegWrite,PC2Reg} = 6'b000000;
            endcase
        end
    end

    always@*begin
        if(nop) MemWrite = `WRITE_IDLE;
        else if(opcode == `STORE)begin
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
