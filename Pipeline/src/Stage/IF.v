module IF (
    input         clk,
    input         rst,

    // from ID
    input         branch,
    input         branch_taken,

    output [31:0] pc,
    output [31:0] imm,
    output        stall,

    // Cache control
    input         flush,
    output [31:0] instruction,
    output        cache_miss_detected,
    output        refill_complete,

    // AXI3 interface
    output [31:0] ARADDR,
    output        ARVALID,
    input         ARREADY,
    input  [31:0] RDATA,
    input         RVALID,
    output        RREADY
);  

    // Internal wires
    wire [31:0] icache_data_out;
    wire        icache_valid;
    wire [31:0] icache_addr;
    wire        icache_miss_detected;

    // AXI interface wires
    wire mem_req;
    wire mem_we;
    wire [31:0] mem_addr;
    wire [31:0] mem_read_data;
    wire mem_data_valid;
    wire mem_ready;

    // Branch prediction module
    Branch_Predict branch_predict (
        .clk(clk), 
        .rst(rst), 
        .branch_taken(branch_taken), 
        .branch(branch), 
        .branch_prediction(branch_prediction)
    );

    // Immediate extension module
    Immediate_Extension immediate_extension (
        .instruction(instruction), 
        .imm(imm)
    );

    // Instruction Cache Controller
    Instruction_Cache_Controller instruction_cache_controller (
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
        .mem_read_data(mem_read_data), 
        .mem_data_valid(mem_data_valid), 
        .mem_ready(mem_ready), 
        .refill_complete(refill_complete)
    );

    // Instruction Cache
    Instruction_Cache instruction_cache (
        .clk(clk), 
        .rst(rst), 
        .flush(flush), 
        .query_valid(icache_valid), 
        .query_addr(icache_addr), 
        .query_data_out(icache_data_out), 
        .query_hit(!icache_miss_detected)
    );

    // PC Generator
    PC_Generator pc_generator (
        .clk(clk), 
        .rst(rst), 
        .stall(stall), 
        .PC_Write(),/////////////////////////////////////////////// 
        .branch_taken(branch_taken), 
        .branch_prediction(branch_prediction),
        .imm(imm), 
        .pc(pc)
    );

    // AXI3 signal connections
    assign ARADDR  = mem_addr;
    assign ARVALID = mem_req && !mem_we;
    assign RREADY  = RVALID;

    // Cache miss and refill complete signal
    assign cache_miss_detected = icache_miss_detected;
    assign instruction = icache_data_out;

endmodule
