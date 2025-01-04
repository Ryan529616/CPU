module WB (
    input MemtoReg,
    input RegWrite,
    input PC2Reg,
    input [2:0] funct3,
    input [4:0] rd_in,
    input [31:0] Mem_out,
    input [31:0] rd_data,

    output [4:0] rd_out,
    output [31:0] Write_data
);

    LD_Filter ld_filter (
        .funct3(funct3),
        .load_data(Mem_out),
        .sign_extended_data(sign_extended_data)
    );

    RegWrite_MUX regwrite_mux (
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .PC2Reg(PC2Reg),
        .ALU_result(rd_data),
        .Read_data(sign_extended_data),
        .Write_data(Write_data)
    );

endmodule