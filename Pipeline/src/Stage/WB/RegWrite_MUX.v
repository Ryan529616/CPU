module RegWrite_MUX (
    input           MemtoReg,
    input    [6:0]  opcode,
    input   [31:0]  pc2reg,
    input   [31:0]  ALU_result,
    input   [31:0]  Read_data,
    output  [31:0]  Write_data
);
    assign Write_data = (opcode==`AUIPC||opcode==`JAL||opcode==`JALR) ? pc2reg : (MemtoReg) ? Read_data : ALU_result;
    
endmodule
