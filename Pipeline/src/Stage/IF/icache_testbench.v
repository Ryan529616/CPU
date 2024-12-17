`timescale 1ns/1ps
`include "Instruction_cache.v"

module icache_axi_testbench;

    // Testbench 信號
    reg clk;
    reg rst;
    reg [31:0] addr;
    reg fetch_req;
    wire [31:0] data_out;
    wire hit;

    // AXI3 接口信號
    wire [31:0] ARADDR;
    wire ARVALID;
    reg ARREADY;
    reg [31:0] RDATA;
    reg RVALID;
    wire RREADY;

    integer k;

    // Instance of the DUT (Device Under Test)
    Instruction_cache uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .fetch_req(fetch_req),
        .data_out(data_out),
        .hit(hit),
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        .RDATA(RDATA),
        .RVALID(RVALID),
        .RREADY(RREADY)
    );

    // Clock 信號生成
    initial begin
        clk = 0; 
        forever #5 clk = ~clk;  // 10ns 時鐘週期
    end

    // 初始化 AXI3 信號
    initial begin
        ARREADY = 0;
        RDATA = 0;
        RVALID = 0;
    end

    // 模擬主存接受讀取請求與返回數據
    reg [3:0] read_delay;

    always @(posedge clk) begin
        // 地址接受邏輯
        if (ARVALID && !ARREADY) begin
            ARREADY <= 1;  // 地址被接受
            read_delay <= 4;  // 模擬主存讀取延遲
        end else begin
            ARREADY <= 0;  // 等待下一個請求
        end

        // 數據返回邏輯
        if (read_delay > 0) begin
            read_delay <= read_delay - 1;
        end

        if (read_delay == 1) begin
            RDATA <= $random;  // 模擬返回數據
            RVALID <= 1;           // 數據有效信號
        end else if (RVALID && RREADY) begin
            RVALID <= 0;  // 快取已接收數據
        end
    end

    // Testbench 主流程
    initial begin
        // 初始化
        rst = 0;
        fetch_req = 0;
        addr = 0;

        // 重置操作
        #10 rst = 1;
        #10 rst = 0;
        $display("Reset completed. Starting cache tests...");

        // 測試 1：命中測試
        addr = 32'h0000_1000;  // 測試地址 1
        fetch_req = 1;
        #10 fetch_req = 0;
        wait(RVALID) $display("Test 1: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 2：相同地址的第二次請求（應為 Hit）
        #50;
        addr = 32'h0000_1000;
        fetch_req = 1;
        #10 fetch_req = 0;
        wait(hit) $display("Test 2: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 3：新地址的請求（應觸發 AXI 讀取）
        #20;
        addr = 32'h0000_2000;
        fetch_req = 1;
        #10 fetch_req = 0;
        wait(RVALID) $display("Test 3: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 4：再次訪問地址 3（應為 Hit）
        #20;
        addr = 32'h0000_2000;
        fetch_req = 1;
        #10 fetch_req = 0;
        wait(hit) $display("Test 4: Addr=0x%h, Hit=%b, Data=0x%h", addr, hit, data_out);

        // 測試 5：測試 AXI3 行為的多地址隨機測試
        $display("Starting random address tests...");
        for (k = 0; k < 50; k = k + 1) begin
            #20;
            addr = $random & 32'hFF;  // 生成隨機地址
            fetch_req = 1;
            #10 fetch_req = 0;
            wait(RVALID|hit)if(hit)$display("HIT!!!!!!!! Random Test %0d: Addr=0x%h, Hit=%b, Data=0x%h", k, addr, hit, data_out);
            else #20 $display("Not HIT!!!! Random Test %0d: Addr=0x%h, Hit=%b, Data=0x%h", k, addr, hit, data_out);
        end

        // 結束模擬
        #100;
        $display("Simulation complete.");
        $finish;
    end

    initial begin
        $fsdbDumpfile("icache_axi_testbench.fsdb");
        $fsdbDumpvars(0, icache_axi_testbench);
    end
endmodule
