module EX (
    input         ALU_Src,
    input  [31:0] pc,
    input  [31:0] imm,
    input  [31:0] Read_data_1,
    input  [31:0] Read_data_2,
    input  [4:0]  rd_in,
    input  [4:0]  rs1_in,
    input  [4:0]  rs2_in,
    input  [4:0]  ALUOp_in,
    input         RegWrite_in,
    input         MemtoReg_in,
    output [4:0]  rd_out,
    output        Branch_ALU,
    output [31:0] pc_imm,
    output [31:0] rd_data
);

    // Wire declaration
    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    wire [1:0]  ForwardA;
    wire [1:0]  ForwardB;
    wire [31:0] Write_data;

    // ALU_Src1_MUX instance
    ALU_Src1_MUX alu_src1_mux(
        .ALU_Src(ALU_Src),
        .ForwardA(ForwardA),
        .Read_data_1(Read_data_1),
        .rd_data(rd_data),
        .Write_data(Write_data),
        .ALU_in1(ALU_in1)
    );

    // ALU_Src2_MUX instance
    ALU_Src2_MUX alu_src2_mux(
        .ALU_Src(ALU_Src),
        .ForwardB(ForwardB),
        .imm(imm),
        .Read_data_2(Read_data_2),
        .rd_data(rd_data),
        .Write_data(Write_data),
        .ALU_in2(ALU_in2)
    );

    // ALU instance
    ALU alu(
        .ALUOp(ALUOp_in),
        .rs1_data(ALU_in1),
        .rs2_data(ALU_in2),
        .rd_data(rd_data)
    );

    // Forwarding Unit instance
    Forwarding_Unit forwarding_unit(
        .EX_MEM_RegWrite(RegWrite_in),
        .MEM_WB_RegWrite(MemtoReg_in),
        .rs1(rs1_in),
        .rs2(rs2_in),
        .EX_MEM_rd(rd_in),
        .MEM_WB_rd(rd_out),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

endmodule
