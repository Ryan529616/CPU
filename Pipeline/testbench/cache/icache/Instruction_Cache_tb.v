`timescale 1ns/1ps
`include "Instruction_Cache.v"

module Instruction_Cache_tb;

    // 參數設置
    parameter DATA_LENGTH = 32;
    parameter CACHE_SIZE = 32 * 1024;
    parameter LINE_SIZE = 64;
    parameter WAYS = 8;

    // 信號宣告
    reg clk;
    reg rst;
    reg flush;

    // 與 Cache 的接口
    reg [31:0] addr;
    wire miss_detected;
    reg refill_valid;
    reg [DATA_LENGTH-1:0] refill_data;
    wire refill_complete;

    integer i, j;

    // 實例化被測模組 (DUT: Device Under Test)
    Instruction_Cache #(
        .DATA_LENGTH(DATA_LENGTH),
        .CACHE_SIZE(CACHE_SIZE),
        .LINE_SIZE(LINE_SIZE),
        .WAYS(WAYS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .addr(addr),
        .miss_detected(miss_detected),
        .refill_valid(refill_valid),
        .refill_data(refill_data),
        .refill_complete(refill_complete)
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
        flush = 0;
        addr = 32'b0;
        refill_valid = 0;
        refill_data = 0;

        // 釋放重置
        #20 rst = 0;

        // 測試 1: Cache Miss
        addr = 32'h0000_1000; // 設定測試地址
        #10;
        if (miss_detected) $display("Test 1 Passed: Cache miss detected as expected.");
        else $display("Test 1 Failed: Cache miss not detected.");

        // 模擬填充過程
        for (i = 0; i < LINE_SIZE / (DATA_LENGTH / 8); i = i + 1) begin
            refill_data = i; // 模擬從外部提供的數據
            refill_valid = 1;
            #10 refill_valid = 0;
        end
         // 打印 Cache 的內容
        $display("Cache contents after refill:");
        for (j = 0; j < LINE_SIZE / (DATA_LENGTH / 8); j = j + 1) begin
            $display("Word %0d: %0h", j, 
                dut.data_array[dut.set_index][dut.replace_way][j]);
        end
        if (refill_complete) begin
            $display("Test 1 Passed: Cache refill complete.");
        end else begin
            $display("Test 1 Failed: Cache refill incomplete.");
        end

        // 測試 2: 命中新填充的數據
        addr = 32'h0000_1000; // 再次訪問剛剛填充的地址
        #10;
        if (!miss_detected) begin
            $display("Test 2 Passed: Cache hit on refilled data.");
        end else begin
            $display("Test 2 Failed: Cache miss detected unexpectedly.");
        end

       

        // 測試完成
        #50 $finish;
    end
endmodule
