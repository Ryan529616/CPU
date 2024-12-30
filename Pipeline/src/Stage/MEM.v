`include "MEM/Data_Cache.v"

module MEM (
    input         clk,
    input         MemRead,
    input  [1:0]  MemWrite,
    input  [31:0] Read_data_2,
    input  [31:0] rd_data,
    input  [4:0]  rd_in,
    output [4:0]  rd_out,
    output [31:0] Mem_out
);
    wire Mem_Write_in;
    assign Mem_Write_in = ~|MemWrite;

    Data_Cache data_cache(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .cpu_load_valid(MemRead),
        .cpu_load_addr(rd_data),
        .cpu_load_data_out(rd_out),
        .cpu_load_miss_detected(cpu_load_miss_detected),
        .cpu_store_valid(Mem_Write_in),
        .cpu_store_addr(rd_data),
        .cpu_store_data_in(Read_data_2),
        .cpu_store_miss_detected(cpu_store_miss_detected),

        .axi_awvalid(axi_awvalid),
        .axi_awready(axi_awready),
        .axi_awaddr(axi_awaddr),
        .axi_wvalid(axi_wvalid),
        .axi_wready(axi_wready),
        .axi_wdata(axi_wdata),
        .axi_wstrb(axi_wstrb),
        .axi_wlast(axi_wlast),
        .axi_bvalid(axi_bvalid),
        .axi_bready(axi_bready),
        .axi_arvalid(axi_arvalid),
        .axi_arready(axi_arready),
        .axi_araddr(axi_araddr),
        .axi_rvalid(axi_rvalid),
        .axi_rready(axi_rready),
        .axi_rdata(axi_rdata),
        .l1_refill_complete(l1_refill_complete),
        .l2_refill_complete(l2_refill_complete),
        .l3_refill_complete(l3_refill_complete)
    );

endmodule