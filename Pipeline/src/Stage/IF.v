`include "IF/Branch_Predict.v"
`include "IF/Immediate_Extension.v"
`include "IF/Instruction_Cache_Controller.v"
`include "IF/Instruction_Cache.v"
`include "IF/Reg_PC.v"

module IF (
    input         clk,
    input         rst,
    input         branch,
    input         branch_taken,

    output [31:0] pc,
    output [31:0] next_pc,
    output [31:0] imm

    ////cache control
    input         flush,
    output [31:0] instruction,
    output        cache_miss_detected,
    output        refill_complete,

    //// AXI3
    output [31:0] ARADDR,
    output        ARVALID,
    output        ARREADY,
    input  [31:0] RDATA,
    input         RVALID,
    output        RREADY
);  

    wire fetch_req;
    wire hit;
    wire refill_valid;

    Branch_Predict branch_predict(
        .clk(clk), 
        .rst(rst), 
        .branch_taken(branch_taken), 
        .branch(branch), 
        .pc(pc), 
        .imm(imm), 
        .next_pc(next_pc)
    );

     Immediate_Extension immediate_extension(
        .instruction(instruction_out), 
        .imm(imm)
    );

    Instruction_Cache_Controller instruction_cache_controller(
        .clk(clk), 
        .rst(rst), 
        .fetch_req(fetch_req), 
        .addr(pc), 
        .data_out(instruction_out), 
        .hit(hit), 
        .cache_miss_detected(cache_miss_detected), 
        .refill_valid(refill_valid), 
        .ARADDR(ARADDR), 
        .ARVALID(ARVALID), 
        .ARREADY(ARREADY), 
        .RDATA(RDATA), 
        .RVALID(RVALID), 
        .RREADY(RREADY)
    );

    Instruction_Cache instruction_cache(
        .clk(clk), 
        .rst(rst), 
        .flush(flush),
        .refill_valid(refill_valid),
        .refill_data(RDATA),
        .miss_detected(miss_detected),
        .refill_complete(refill_complete),
        .addr(pc),
        .data_out(instruction_out)
    );

    Instruction_Cache instruction_cache(
        .clk(clk), 
        .rst(rst), 
        .instruction_out(instruction), 
        .pc(pc)
    );

    Reg_PC reg_pc(
        .clk(clk), 
        .rst(rst), 
        .next_pc(next_pc), 
        .pc(pc)
    );

endmodule