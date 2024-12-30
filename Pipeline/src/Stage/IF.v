`include "IF/Branch_Predict.v"
`include "IF/Immediate_Extension.v"
`include "IF/Instruction_Cache_Controller.v"
`include "IF/Instruction_Cache.v"
`include "IF/PC_Generator.v"

module IF (

    input         clk,
    input         rst,

    ///from ID
    input         branch,
    input         branch_taken,

    output [31:0] pc,
    output [31:0] imm
    output        stall,

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

    // Internal wires
    wire [31:0] icache_data_out;
    wire        icache_valid;
    wire [31:0] icache_addr;
    wire        icache_miss_detected;

    // Cache wires
    wire cache_query_valid;
    wire [31:0] cache_query_addr;
    wire cache_query_hit;
    wire [$clog2(8)-1:0] cache_query_hit_way;
    wire [31:0] cache_query_data_out;

    // AXI interface wires
    wire mem_req;
    wire mem_we;
    wire [31:0] mem_addr;
    wire [63:0] mem_write_data;
    wire [63:0] mem_read_data;
    wire mem_data_valid;
    wire mem_ready;

    Branch_Predict branch_predict(
        .clk(clk), 
        .rst(rst), 
        .branch_taken(branch_taken), 
        .branch(branch), 
        .branch_prediction(branch_prediction)
    );

     Immediate_Extension immediate_extension(
        .instruction(instruction_out), 
        .imm(imm)
    );

    Instruction_Cache_Controller instruction_cache_controller(
        .clk(clk), 
        .rst(rst), 
        .flush(flush), 
        .icache_valid(icache_valid), 
        .icache_addr(icache_addr), 
        .icache_data_out(icache_data_out), 
        .icache_miss_detected(icache_miss_detected), 
        .mem_req(mem_req), 
        .mem_we(mem_we), 
        .mem_addr(mem_addr), 
        .mem_write_data(mem_write_data), 
        .mem_read_data(mem_read_data), 
        .mem_data_valid(mem_data_valid), 
        .mem_ready(mem_ready), 
        .refill_complete(refill_complete), 
        .cache_query_valid(cache_query_valid), 
        .cache_query_addr(cache_query_addr), 
        .cache_query_hit(cache_query_hit), 
        .cache_query_hit_way(cache_query_hit_way), 
        .cache_query_data_out(cache_query_data_out), 
        .cache_do_store(), 
        .cache_store_data_in(), 
        .cache_store_way(), 
        .cache_store_addr(), 
        .cache_do_update_line(cache_do_update_line), 
        .cache_do_update_tag_and_valid(cache_do_update_tag_and_valid), 
        .cache_do_clear_dirty(cache_do_clear_dirty), 
        .cache_update_addr(cache_update_addr), 
        .cache_update_line_data(cache_update_line_data), 
        .cache_update_way(cache_update_way), 
        .cache_update_dirty_bit(), 
        .cache_victim_way(), 
        .cache_victim_addr(), 
        .cache_victim_tag_out(), 
        .cache_victim_dirty_out(), 
        .cache_victim_line_data_out()
    );

    Instruction_Cache instruction_cache(
        .clk(clk), 
        .rst(rst), 
        .flush(flush), 
        .query_valid(cache_query_valid), 
        .query_addr(cache_query_addr), 
        .query_data_out(cache_query_data_out), 
        .query_hit(cache_query_hit), 
        .query_hit_way(cache_query_hit_way), 
        .do_store(), 
        .store_data_in(), 
        .store_way(), 
        .store_addr(), 
        .do_update_line(), 
        .do_update_tag_and_valid(), 
        .do_clear_dirty(), 
        .update_addr(), 
        .update_line_data(), 
        .update_way(), 
        .update_dirty_bit(), 
        .victim_way(), 
        .victim_addr(), 
        .victim_tag_out(), 
        .victim_dirty_out(), 
        .victim_line_data_out()
    );

    PC_Generator pc_generator(
        .clk(clk), 
        .rst(rst), 
        .stall(stall), 
        .PC_Write(PC_Write), 
        .branch_taken(branch_taken), 
        .branch_prediction(branch_prediction),
        .imm(imm), 
        .pc(pc)
    );

    // AXI signal connections
    assign ARADDR = mem_addr;
    assign ARVALID = mem_req && !mem_we;
    assign RREADY = mem_data_valid;

endmodule