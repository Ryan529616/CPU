`timescale 1ns/1ps
`include "../../src/Stage/IF/Instruction_Cache_Controller.v"
`include "../../src/Stage/IF/Instruction_Cache.v"

module Instruction_Cache_Controller_tb;

    // 參數設置
    parameter DATA_LENGTH = 32;
    parameter CACHE_SIZE = 32 * 1024;
    parameter LINE_SIZE = 64;
    parameter WAYS = 8;

    // 信號宣告
    reg clk;
    reg rst;

    // 與 CPU 的接口
    reg [31:0] addr;
    reg fetch_req;
    wire [DATA_LENGTH-1:0] data_out;
    wire hit;

    // 與 AXI3 的接口
    wire [31:0] ARADDR;
    wire ARVALID;
    reg ARREADY;
    reg [DATA_LENGTH-1:0] RDATA;
    reg RVALID;
    wire RREADY;

    // 內部信號
    wire cache_miss_detected;
    wire refill_valid;
    wire [DATA_LENGTH-1:0] refill_data;
    wire refill_complete;

    integer i;

    // 實例化 Cache
    Instruction_Cache #(
        .DATA_LENGTH(DATA_LENGTH),
        .CACHE_SIZE(CACHE_SIZE),
        .LINE_SIZE(LINE_SIZE),
        .WAYS(WAYS)
    ) cache (
        .clk(clk),
        .rst(rst),
        .flush(rst),
        .addr(addr),
        .miss_detected(cache_miss_detected),
        .refill_valid(refill_valid),
        .refill_data(refill_data),
        .refill_complete(refill_complete)
    );

    // 實例化 Cache Controller
    Instruction_Cache_Controller #(
        .DATA_LENGTH(DATA_LENGTH),
        .LINE_SIZE(LINE_SIZE)
    ) controller (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .fetch_req(fetch_req),
        .data_out(data_out),
        .hit(hit),
        .cache_miss_detected(cache_miss_detected),
        .refill_valid(refill_valid),
        .refill_data(refill_data),
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        .RDATA(RDATA),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    // 時鐘產生
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 時鐘週期為 10ns
    end

    // 測試流程
    initial begin
        // 初始化信號
        rst = 1;
        addr = 0;
        fetch_req = 0;
        ARREADY = 0;
        RDATA = 0;
        RVALID = 0;

        // 釋放重置
        #20 rst = 0;

        // 測試 1: 模擬 Cache Miss 並填充數據
        addr = 32'h0000_1000; // 設定測試地址
        fetch_req = 1;
        #10 fetch_req = 0;

        if (cache_miss_detected) $display("Test 1 Passed: Cache miss detected as expected.");
        else $display("Test 1 Failed: Cache miss not detected.");

        // 模擬 AXI 訪問過程
        ARREADY = 1; // 模擬 AXI 準備好接受請求
        #10 ARREADY = 0;

        // 模擬數據返回
        for (i = 0; i < LINE_SIZE / (DATA_LENGTH / 8); i = i + 1) begin
            RDATA = i; // 模擬返回的數據
            RVALID = 1;
            #10 RVALID = 0;
        end

        // 測試結果檢查
        if (!cache_miss_detected) $display("Test 1 Passed: Data refill completed and hit detected.");
        else $display("Test 1 Failed: Unexpected miss or no hit.");

        // 測試完成
        #50 $finish;
    end
endmodule
