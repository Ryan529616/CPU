module ID (
    input         clk,
    input         rst,
    input         RegWrite_in,
    input  [4:0]  rd_in,
    input  [31:0] instruction,
    input  [31:0] pc,
    input  [31:0] Write_data,
    input         MemRead_ex,

    output [6:0]  opcode,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd_out,
    output [2:0]  funct3,
    output [6:0]  funct7,
    output [31:0] Read_data_1,
    output [31:0] Read_data_2,

    output        branch_taken,
    
    // Control Signals
    output        Branch,
    output        MemRead,
    output        MemtoReg,
    output [1:0]  MemWrite,
    output        ALUSrc,
    output        RegWrite,
    output [4:0]  ALUOp,
    output        PC2Reg,
    output        PC_Write,
    output        IF_ID_Write,
    output        flush
);
    wire nop;

    // ALU Controller
    ALU_Controller alu_controller (
        .funct7(funct7), 
        .funct3(funct3), 
        .opcode(opcode), 
        .ALUOp(ALUOp)
    );

    // Branch Comparator
    Branch_Comparator branch_comparator (
        .funct3(funct3), 
        .opcode(opcode), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2), 
        .branch_taken(branch_taken)
    );

    // Controller
    Controller controller (
        .nop(nop), 
        .instruction(instruction), 
        .opcode(opcode), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd_out), 
        .funct3(funct3), 
        .funct7(funct7), 
        .Branch(Branch), 
        .MemRead(MemRead), 
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .RegWrite(RegWrite),
        .PC2Reg(PC2Reg)
    );

    // Hazard Detection Unit
    Hazard_Detection_Unit hazard_detection_unit (
        .rs1(rs1), 
        .rs2(rs2), 
        .rd_ex(rd_out), 
        .MemRead_ex(MemRead_ex),
        .branch_taken(branch_taken), 
        .branch_prediction(branch_taken), 
        .nop(nop), 
        .flush(flush), 
        .IF_ID_Write(IF_ID_Write), 
        .PC_Write(PC_Write)
    );

    // Register File
    RegFile regfile (
        .clk(clk),
        .rst(rst),
        .Read_register_1(rs1), 
        .Read_register_2(rs2), 
        .Write_register(rd_in), 
        .Write_data(Write_data), 
        .RegWrite(RegWrite_in), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2)
    );

endmodule
