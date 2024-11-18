`timescale 1ns/1ps

module RegWrite_MUX (
    input           MemtoReg,
    input           PCSrc,
    input   [31:0]  pc_imm,
    input   [31:0]  ALU_result,
    input   [31:0]  Read_data,
    output  [31:0]  Write_data
);
    assign Write_data = (PCSrc) ? pc2reg : (MemtoReg) ? Read_data : ALU_result;
    
endmodule
