`timescale 1ns/1ps
`include "../src/Top.v"
`include "../src/general/Memory.v"

module CPU_Testbench;

    reg clk;
    reg rst;

    // AXI Signals between Top and Memory
    wire [31:0] awaddr;
    wire awvalid;
    wire awready;
    wire [7:0] awlen;
    wire [2:0] awsize;
    wire [1:0] awburst;

    wire [31:0] wdata;
    wire wvalid;
    wire wready;
    wire wlast;

    wire bvalid;
    wire [1:0] bresp;
    wire bready;

    wire [31:0] araddr;
    wire arvalid;
    wire arready;
    wire [7:0] arlen;
    wire [2:0] arsize;
    wire [1:0] arburst;

    wire [31:0] rdata;
    wire rvalid;
    wire rready;
    wire rlast;

    integer i;

    localparam ARRAY_OFFSET = 32'd4336;

    // Instantiate the DUT (Top Module)
    Top dut (
        .clk(clk),
        .rst(rst),
        // AXI Write Address Channel
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
        .awlen(awlen),
        .awsize(awsize),
        .awburst(awburst),
        // AXI Write Data Channel
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast(wlast),
        // AXI Write Response Channel
        .bvalid(bvalid),
        .bresp(bresp),
        .bready(bready),
        // AXI Read Address Channel
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
        .arlen(arlen),
        .arsize(arsize),
        .arburst(arburst),
        // AXI Read Data Channel
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast(rlast)
    );

    // Instantiate the Memory Module
    Memory memory (
        .aclk(clk),
        .aresetn(rst),
        // AXI Write Address Channel
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
        .awlen(awlen),
        .awsize(awsize),
        .awburst(awburst),
        // AXI Write Data Channel
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast(wlast),
        // AXI Write Response Channel
        .bvalid(bvalid),
        .bresp(bresp),
        .bready(bready),
        // AXI Read Address Channel
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
        .arlen(arlen),
        .arsize(arsize),
        .arburst(arburst),
        // AXI Read Data Channel
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast(rlast)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Testbench Logic
    initial begin
        rst = 1;
        #20 rst = 0;

        // 模擬指令與數據初始化
        $readmemh("quicksort.hex", memory.memory);

        // 顯示初始數據
        $display("Initial Memory:");
        for (i = 0; i < 10; i = i + 1) begin
            $display("Address %0d: %h", i * 4 + ARRAY_OFFSET, memory.memory[i + ARRAY_OFFSET]);
        end

        // 等待操作完成
        repeat (100000) @(posedge clk);

        // 顯示最終數據
        $display("Final Memory:");
        for (i = 0; i < 10; i = i + 1) begin
            $display("Address %0d: %h", i * 4 + ARRAY_OFFSET, memory.memory[i + ARRAY_OFFSET]);
        end

        #50 $finish;
    end

    // FSDB Dump for waveform
    initial begin
        $fsdbDumpfile("CPU_Testbench.fsdb");
        $fsdbDumpvars(0, CPU_Testbench);
    end

endmodule
