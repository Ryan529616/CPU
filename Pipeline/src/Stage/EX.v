module EX (
    input         ALU_Src,
    input  [31:0] pc,
    input  [31:0] imm,
    input  [31:0] Read_data_1,
    input  [31:0] Read_data_2,
    input  [4:0]  rd_in,
    output [4:0]  rd_out,
    output        Branch_ALU,
    output [31:0] pc_imm,
    output [31:0] rd_data


    input   [4:0] rs1_in,
    input   [4:0] rs2_in,
    input   [4:0] rd_in,
    input   [2:0] funct3_in,
    input  [31:0] Read_data_1_in,
    input  [31:0] Read_data_2_in,
    input  [31:0] imm_in,

    output  [4:0] rs1_out,
    output  [4:0] rs2_out,
    output  [4:0] rd_out,
    output  [2:0] funct3_out,
    output [31:0] Read_data_1_out,
    output [31:0] Read_data_2_out,
    output [31:0] imm_out,

////Controller
    input         Branch_in,
    input         MemREAD_in,
    input         MemtoReg_in,
    input   [1:0] MemWrite_in,
    input         ALUSrc_in,
    input         RegWrite_in,
    input         PCSrc_in,
    input   [4:0] ALUOp_in,

    output        Branch_out,
    output        MemREAD_out,
    output        MemtoReg_out,
    output  [1:0] MemWrite_out,
    output        ALUSrc_out,
    output        RegWrite_out,
    output        PCSrc_out,
    output  [4:0] ALUOp_out,

    //csr
    input   [31:0] csr_rd;
    output  [31:0] csr_wd;

);
    wire ALU_in2;

    ALU_Src_MUX alu_src_mux(
        .ALU_Src(ALUSrc), 
        .imm(imm), 
        .Read_data_2(Read_data_2), 
        .ALU_in2(ALU_in2)
    );

    ALU alu(
        .ALUOp(ALUOp), 
        .rs1_data(ALU_in1), 
        .rs2_data(ALU_in2), 
        .rd_data(rd_data), 
        .Branch_ALU(Branch_ALU)
    );

    //csr logit
    always@(*) begin
        case (funct3_in)
			`CSRRW: csr_wd = rs1;
			`CSRRS: csr_wd = csr_rd | rs1;
			`CSRRC: csr_wd = csr_rd & ~rs1;
			`CSRRWI: csr_wd = {27'b0, rs1[4:0]};
			`CSRRSI: csr_wd = csr_rd | {27'b0, rs1[4:0]};
			`CSRRCI: csr_wd = csr_rd & ~{27'b0, rs1[4:0]};
			default: csr_wd = 32'b0;
		endcase
    end

endmodule