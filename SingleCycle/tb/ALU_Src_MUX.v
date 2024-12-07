`timescale 1ns/1ps

module ALU_Src_MUX (
    input           ALU_Src,
    input   [31:0]  imm,
    input   [31:0]  Read_data_2,
    output  [31:0]  ALU_in2
);
    assign ALU_in2 = (ALU_Src) ? imm : Read_data_2;
endmodule
