module WB (
    input   [2:0] funct3,
    input   [4:0] rd_in,
    input  [31:0] Mem_out,
    input  [31:0] rd_data,
    output  [4:0] rd_out,
    output [31:0] Write_data
);
    wire sign_extended_data;
    assign rd_out = rd_in;

    LD_Filter ld_filter(
        .load_data(Mem_out), 
        .funct3(funct3), 
        .sign_extended_data(sign_extended_data)
    );

    RegWrite_MUX regwrite_mux(
        .MemtoReg(MemtoReg), 
        .PCSrc(PCSrc), 
        .pc2reg(pc2reg), 
        .ALU_result(rd_data), 
        .Read_data(sign_extended_data), 
        .Write_data(Write_data)
    );

endmodule