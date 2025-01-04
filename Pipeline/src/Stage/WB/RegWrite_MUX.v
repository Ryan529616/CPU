module RegWrite_MUX (
    input           MemtoReg,
    input           PC2Reg,
    input           RegWrite,
    input   [31:0]  pc,
    input   [31:0]  ALU_result,
    input   [31:0]  Read_data,
    output  [31:0]  Write_data
);
    assign Write_data = PC2Reg ? (pc + 32'd4) : (MemtoReg) ? Read_data : (RegWrite)? ALU_result : 32'b0;
    
endmodule
