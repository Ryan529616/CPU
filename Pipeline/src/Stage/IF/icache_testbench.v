`timescale 1ns/1ps
`include "Instruction_cache.v"
module icache_testbench;

    // Testbench 信號
    reg clk;
    reg rst;
    reg [31:0] addr;
    reg fetch_req;
    wire [63:0] data_out;
    wire hit;

    // Instance of the DUT (Device Under Test)
    Instruction_cache uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .fetch_req(fetch_req),
        .data_out(data_out),
        .hit(hit)
    );

    // Clock 信號生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns 時鐘週期
    end

    // Testbench 主流程
    initial begin
        // 初始化
        rst = 0;  // 先保持復位
        fetch_req = 0;
        addr = 0;

        // 重置操作
        #20 rst = 1;  // 20 ns 後解除復位

        // 等待一個時鐘週期，確保初始化完成
        #10;

        // 測試 1：第一次請求（應為 Miss，觸發填充）
        addr = 32'h0000_1000;  // 測試地址 1
        fetch_req = 1;
        #10 fetch_req = 0;  // 請求完成
        #10;  // 等待結果穩定
        $display("Test 1: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 2：相同地址的第二次請求（應為 Hit）
        #10;  // 等待一個時鐘週期
        addr = 32'h0000_1000;  // 測試地址 1
        fetch_req = 1;
        #10 fetch_req = 0;  // 請求完成
        #10;
        $display("Test 2: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 3：新地址的請求（應為 Miss）
        #10;  // 等待一個時鐘週期
        addr = 32'h0000_2000;  // 測試地址 2
        fetch_req = 1;
        #10 fetch_req = 0;  // 請求完成
        #10;
        $display("Test 3: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 4：再次訪問地址 2（應為 Hit）
        #10;
        addr = 32'h0000_2000;  // 測試地址 2
        fetch_req = 1;
        #10 fetch_req = 0;
        #10;
        $display("Test 4: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 5：新地址的請求（可能觸發替換）
        #10;
        addr = 32'h0000_3000;  // 測試地址 3
        fetch_req = 1;
        #10 fetch_req = 0;
        #10;
        $display("Test 5: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 結束模擬
        #100;
        $finish;
    end

endmodule
