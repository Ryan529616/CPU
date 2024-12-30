`include "ID/ALU_Controller.v"
`include "ID/Branch_Comparator.v"
`include "ID/Controller.v"
`include "ID/Hazard_Detection_Unit.v"
`include "ID/RegFile.v"
//`include "ID/CSR_RegFile.v"

module ID (
    input         clk,
    input         rst,
    input         RegWrite_in,
    input  [4:0]  rd_in,
    input  [31:0] instruction,
    input  [31:0] pc,
    input  [31:0] Write_data,

    output [6:0]  opcode,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd_out,
    output [2:0]  funct3,
    output [6:0]  funct7,
    output [31:0] Read_data_1,
    output [31:0] Read_data_2,

    output        branch_taken,
    
////Control Signals
    output        Branch,
    output        MemRead,
    output        MemtoReg,
    output [1:0]  MemWrite,
    output        ALUSrc,
    output        RegWrite,
    output [4:0]  ALUOp,

/*
////CSR_Regfile
    output [31:0] csr_rd,
    output [31:0] clint_csr_mstatus,
    output [31:0] clint_csr_mepc,
    output [31:0] clint_csr_mtvec,
    output        interrupt_enable,

*/

);

    ALU_Controller alu_controller(
        .funct7(funct7), 
        .funct3(funct3), 
        .opcode(opcode), 
        .ALUOp(ALUOp)
    );

    Branch_Comparator branch_comparator(
        .funct3(funct3), 
        .opcode(opcode), 
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2), 
        .branch_taken(branch_taken)
    );

    Controller controller(
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
        .RegWrite(RegWrite)
        /*
        .csr_we_id2ex(csr_we_id2ex), 
        .csr_addr(csr_addr)
        */
    );
/*
    CSR csr(
        .clk(clk), 
        .rst(rst), 
        .csr_we_ex(csr_we_ex), 
        .csr_ra_id(csr_ra_id), 
        .csr_wa_ex(csr_wa_ex), 
        .csr_wd_ex(csr_wd_ex), 
        .we_clint(we_clint), 
        .wa_clint(wa_clint), 
        .wd_clint(wd_clint), 
        .csr_rd(csr_rd), 
        .clint_csr_mstatus(clint_csr_mstatus), 
        .clint_csr_mepc(clint_csr_mepc), 
        .clint_csr_mtvec(clint_csr_mtvec), 
        .interrupt_enable(interrupt_enable)
    );
*/

    Hazard_Detection_Unit hazard_detection_unit(
        .rs1(rs1), 
        .rs2(rs2), 
        .rd_ex(rd_out), 
        .MemRead_ex(MemRead), 
        .branch_taken(branch_taken), 
        .branch_prediction(branch_taken), 
        .nop(nop), 
        .flush(flush), 
        .IF_ID_Write(IF_ID_Write), 
        .PC_Write(PC_Write)
    );

    RegFile regfile(
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