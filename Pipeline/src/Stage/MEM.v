module MEM (
    input         clk,
    input         rst,
    input         flush,
    input         MemRead,
    input  [1:0]  MemWrite,
    input  [31:0] Read_data_2,
    input  [31:0] rd_data,
    output [31:0] Mem_out,
    // AXI Interface
    output        axi_awvalid,
    input         axi_awready,
    output [31:0] axi_awaddr,
    output        axi_wvalid,
    input         axi_wready,
    output [31:0] axi_wdata,
    output [3:0]  axi_wstrb,
    output        axi_wlast,
    input         axi_bvalid,
    output        axi_bready,
    output        axi_arvalid,
    input         axi_arready,
    output [31:0] axi_araddr,
    input         axi_rvalid,
    output        axi_rready,
    input  [31:0] axi_rdata
);

    // Internal wires
    wire Mem_Write_in;
    wire cpu_load_miss_detected;
    wire cpu_store_miss_detected;
    wire l1_refill_complete;
    wire l2_refill_complete;
    wire l3_refill_complete;

    // MemWrite check (combination logic)
    assign Mem_Write_in = |MemWrite; // 判斷是否有有效的寫入

    // Data_Cache instance
    Data_Cache data_cache(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .cpu_load_valid(MemRead),
        .cpu_load_addr(rd_data),
        .cpu_load_data_out(Mem_out), // Correct output mapping
        .cpu_load_miss_detected(cpu_load_miss_detected),
        .cpu_store_valid(Mem_Write_in),
        .cpu_store_addr(rd_data),
        .cpu_store_data_in(Read_data_2),
        .cpu_store_miss_detected(cpu_store_miss_detected),

        // AXI Write Address Channel
        .axi_awvalid(axi_awvalid),
        .axi_awready(axi_awready),
        .axi_awaddr(axi_awaddr),

        // AXI Write Data Channel
        .axi_wvalid(axi_wvalid),
        .axi_wready(axi_wready),
        .axi_wdata(axi_wdata),
        .axi_wstrb(axi_wstrb),
        .axi_wlast(axi_wlast),

        // AXI Write Response Channel
        .axi_bvalid(axi_bvalid),
        .axi_bready(axi_bready),

        // AXI Read Address Channel
        .axi_arvalid(axi_arvalid),
        .axi_arready(axi_arready),
        .axi_araddr(axi_araddr),

        // AXI Read Data Channel
        .axi_rvalid(axi_rvalid),
        .axi_rready(axi_rready),
        .axi_rdata(axi_rdata),

        // Refill Complete Signals
        .l1_refill_complete(l1_refill_complete),
        .l2_refill_complete(l2_refill_complete),
        .l3_refill_complete(l3_refill_complete)
    );

endmodule
