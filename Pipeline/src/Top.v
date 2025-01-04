module Top(
    input clk,
    input rst,
    // AXI Interface
    output [31:0] awaddr,
    output        awvalid,
    input         awready,
    output [7:0]  awlen,    // 新增
    output [2:0]  awsize,   // 新增
    output [1:0]  awburst,  // 新增
    output [31:0] wdata,
    output        wvalid,
    input         wready,
    output        wlast,
    input         bvalid,
    input  [1:0]  bresp,
    output        bready,
    output [31:0] araddr,
    output        arvalid,
    input         arready,
    output [7:0]  arlen,    // 新增
    output [2:0]  arsize,   // 新增
    output [1:0]  arburst,  // 新增
    input  [31:0] rdata,
    input         rvalid,
    output        rready,
    input         rlast
);

    // Pipeline register wires
    wire [31:0] pc_out_IF_ID, imm_out_IF_ID, instruction_out_IF_ID;
    wire [4:0]  rs1_out_ID_EX, rs2_out_ID_EX, rd_out_ID_EX;
    wire [31:0] pc_out_ID_EX, Read_data_1_out_ID_EX, Read_data_2_out_ID_EX, imm_out_ID_EX;
    wire [2:0]  funct3_out_ID_EX;
    wire        Branch_out_ID_EX, MemREAD_out_ID_EX, MemtoReg_out_ID_EX, ALUSrc_out_ID_EX, RegWrite_out_ID_EX;
    wire [1:0]  MemWrite_out_ID_EX;
    wire [4:0]  ALUOp_out_ID_EX;

    wire [31:0] rd_data_out_EX_MEM, Read_data_2_out_EX_MEM;
    wire        MemRead_out_EX_MEM;
    wire [1:0]  MemWrite_out_EX_MEM;

    wire [31:0] Mem_out_MEM_WB, rd_data_out_MEM_WB;
    wire [4:0]  rd_out_MEM_WB;

    // Control and pipeline signals
    wire stall, branch_taken, Branch, flush;
    wire RegWrite, MemtoReg, ALUSrc;
    wire [4:0] ALUOp;

    // Instruction Fetch (IF)
    IF if_stage(
        .clk(clk),
        .rst(rst),
        .branch(Branch),
        .branch_taken(branch_taken),
        .pc(pc),
        .imm(imm_out_IF_ID),
        .stall(stall),
        .instruction(instruction_out_IF_ID),
        .cache_miss_detected(),
        .refill_complete(),
        .ARADDR(),
        .ARVALID(),
        .ARREADY(),
        .RDATA(),
        .RVALID(),
        .RREADY()
    );

    // IF/ID Pipeline Register
    IF_ID if_id(
        .clk(clk),
        .flush(flush),
        .stall(stall),
        .pc_in(pc),
        .imm_in(imm_out_IF_ID),
        .instruction_in(instruction_out_IF_ID),
        .pc_out(pc_out_IF_ID),
        .imm_out(imm_out_IF_ID),
        .instruction_out(instruction_out_IF_ID)
    );

    // Instruction Decode (ID)
    ID id_stage(
        .clk(clk),
        .rst(rst),
        .RegWrite_in(RegWrite),
        .rd_in(rd_out_MEM_WB),
        .instruction(instruction_out_IF_ID),
        .pc(pc_out_IF_ID),
        .Write_data(Mem_out_MEM_WB),
        .opcode(),
        .rs1(rs1_out_ID_EX),
        .rs2(rs2_out_ID_EX),
        .rd_out(rd_out_ID_EX),
        .funct3(funct3_out_ID_EX),
        .funct7(),
        .Read_data_1(Read_data_1_out_ID_EX),
        .Read_data_2(Read_data_2_out_ID_EX),
        .branch_taken(branch_taken),
        .Branch(Branch),
        .MemREAD(MemREAD),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    // ID/EX Pipeline Register
    ID_EX id_ex(
        .clk(clk),
        .flush(flush),
        .stall(stall),
        .rs1_in(rs1_out_ID_EX),
        .rs2_in(rs2_out_ID_EX),
        .rd_in(rd_out_ID_EX),
        .funct3_in(funct3_out_ID_EX),
        .pc_in(pc_out_IF_ID),
        .Read_data_1_in(Read_data_1_out_ID_EX),
        .Read_data_2_in(Read_data_2_out_ID_EX),
        .imm_in(imm_out_IF_ID),
        .rs1_out(),
        .rs2_out(),
        .rd_out(),
        .funct3_out(),
        .pc_out(),
        .Read_data_1_out(),
        .Read_data_2_out(),
        .imm_out(),
        .Branch_in(Branch),
        .MemREAD_in(MemREAD),
        .MemtoReg_in(MemtoReg),
        .MemWrite_in(MemWrite),
        .ALUSrc_in(ALUSrc),
        .RegWrite_in(RegWrite),
        .ALUOp_in(ALUOp),
        .Branch_out(),
        .MemREAD_out(),
        .MemtoReg_out(),
        .MemWrite_out(),
        .ALUSrc_out(),
        .RegWrite_out(),
        .ALUOp_out()
    );

    // Execution (EX)
    EX ex_stage(
        .ALU_Src(ALUSrc_out_ID_EX),
        .pc(pc_out_ID_EX),
        .imm(imm_out_ID_EX),
        .Read_data_1(Read_data_1_out_ID_EX),
        .Read_data_2(Read_data_2_out_ID_EX),
        .rd_in(rd_out_ID_EX),
        .rs1_in(rs1_out_ID_EX),
        .rs2_in(rs2_out_ID_EX),
        .ALUOp_in(ALUOp_out_ID_EX),
        .RegWrite_in(RegWrite_out_ID_EX),
        .MemtoReg_in(MemtoReg_out_ID_EX),
        .rd_out(rd_data_out_EX_MEM),
        .Branch_ALU(),
        .pc_imm(),
        .rd_data(rd_data_out_EX_MEM)
    );

    // EX/MEM Pipeline Register
    EX_MEM ex_mem(
        .clk(clk),
        .flush(flush),
        .MemRead_in(MemREAD_out_ID_EX),
        .MemWrite_in(MemWrite_out_ID_EX),
        .Read_data_2_in(Read_data_2_out_ID_EX),
        .rd_data_in(rd_data_out_EX_MEM),
        .MemRead_out(MemRead_out_EX_MEM),
        .MemWrite_out(MemWrite_out_EX_MEM),
        .Read_data_2_out(Read_data_2_out_EX_MEM),
        .rd_data_out(rd_data_out_EX_MEM)
    );

    // Memory Access (MEM)
    MEM mem_stage(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .MemRead(MemRead_out_EX_MEM),
        .MemWrite(MemWrite_out_EX_MEM),
        .Read_data_2(Read_data_2_out_EX_MEM),
        .rd_data(rd_data_out_EX_MEM),
        .Mem_out(Mem_out_MEM_WB),
        .axi_awvalid(),
        .axi_awready(),
        .axi_awaddr(),
        .axi_wvalid(),
        .axi_wready(),
        .axi_wdata(),
        .axi_wstrb(),
        .axi_wlast(),
        .axi_bvalid(),
        .axi_bready(),
        .axi_arvalid(),
        .axi_arready(),
        .axi_araddr(),
        .axi_rvalid(),
        .axi_rready(),
        .axi_rdata()
    );

    // MEM/WB Pipeline Register
    MEM_WB mem_wb(
        .clk(clk),
        .flush(flush),
        .stall(stall),
        .funct3_in(funct3_out_ID_EX),
        .PC2Reg_in(),
        .rd_in(rd_out_EX_MEM),
        .Mem_out_in(Mem_out_MEM_WB),
        .rd_data_in(rd_data_out_EX_MEM),
        .funct3_out(),
        .PC2Reg_out(),
        .rd_out(rd_out_MEM_WB),
        .Mem_out_out(),
        .rd_data_out(rd_data_out_MEM_WB)
    );

    // Write Back (WB)
    WB wb_stage(
        .funct3(),
        .rd_in(rd_out_MEM_WB),
        .Mem_out(Mem_out_MEM_WB),
        .rd_data(rd_data_out_MEM_WB),
        .rd_out(rd_out_MEM_WB),
        .Write_data()
    );

endmodule
