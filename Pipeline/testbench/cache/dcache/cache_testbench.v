`timescale 1ns/1ps
`include "L1_Data_Cache.v"
`include "L2_Data_Cache.v"
`include "L3_Data_Cache.v"

module cache_testbench;

    // 時鐘/重置信號
    reg clk;
    reg rst;

    // 簡單clock產生
    always #5 clk = ~clk;

    // 1) L1 Cache 介面訊號 (示範 Input→Output)
    reg         l1_load_valid;
    reg         l1_store_valid;
    reg [31:0]  l1_addr;
    reg [31:0]  l1_wdata;
    wire [31:0] l1_rdata;
    wire        l1_miss;

    // 2) L2 Cache 介面訊號
    //   (在真實系統中 L1 -> L2 也是一個連線。這裡僅示範：testbench→L2→(之後再對L3)...)
    reg         l2_access_valid;
    reg [31:0]  l2_addr;
    reg         l2_isStore;
    reg [31:0]  l2_store_data;
    wire [31:0] l2_load_out;
    wire        l2_miss;

    // 3) L3 Cache (AXI3) 介面訊號
    reg         l3_access_valid;
    reg [31:0]  l3_addr;
    reg         l3_isStore;
    reg [31:0]  l3_wdata;
    wire [31:0] l3_rdata;
    wire        l3_miss;

    // AXI3 主記憶體模型 (僅示範部份訊號)
    wire [31:0] axi_araddr;
    wire        axi_arvalid;
    reg         axi_arready;

    reg  [31:0] axi_rdata;
    reg         axi_rvalid;
    wire        axi_rready;

    wire [31:0] axi_awaddr;
    wire        axi_awvalid;
    reg         axi_awready;

    wire [31:0] axi_wdata;
    wire        axi_wvalid;
    reg         axi_wready;

    reg         axi_bvalid;
    wire        axi_bready;

    // ---------------------------
    // 1) 實例化 L1 Cache
    // ---------------------------
    // 這裡範例化：假設你已經將 L1_Data_Cache 改成單一介面 (load/store+mux)。
    // 參數： 48KB / 64B line / 12 ways。
    L1_Data_Cache #(
        .DATA_LENGTH(32),
        .CACHE_SIZE(48*1024),
        .LINE_SIZE(64),
        .WAYS(12)
    ) u_l1 (
        .clk(clk),
        .rst(rst),
        .flush(1'b0),

        // 讀寫請求
        .load_valid(l1_load_valid),
        .load_addr(l1_addr),
        .load_data_out(l1_rdata),
        .load_miss_detected(),

        .store_valid(l1_store_valid),
        .store_addr(l1_addr),
        .store_data_in(l1_wdata),
        .store_miss_detected(l1_miss),

        // refill 介面(假設從 L2 取得)
        // ...
        .refill_valid(/* 連到L2? (簡化暫留) */ 1'b0),
        .refill_data(/* 連到L2? */ 32'b0),
        .refill_complete(),

        // writeback 介面(簡化)
        .writeback_req(),
        .writeback_data(),
        .writeback_done(1'b0)
    );

    // ---------------------------
    // 2) 實例化 L2 Cache
    // ---------------------------
    // 參數： 1MB / 64B line / 16 ways (如同你的截圖)
    L2_Data_Cache #(
        .DATA_LENGTH(32),
        .CACHE_SIZE(1024 * 1024),
        .LINE_SIZE(64),
        .WAYS(16)
    ) u_l2 (
        .clk(clk),
        .rst(rst),
        .flush(1'b0),

        .access_valid(l2_access_valid),
        .access_addr(l2_addr),
        .access_isStore(l2_isStore),
        .store_data_in(l2_store_data),
        .load_data_out(l2_load_out),
        .miss_detected(l2_miss),

        // refill from L3
        .mem_refill_valid(/* 連到L3? */ 1'b0),
        .mem_refill_data(/* 連到L3? */ 32'b0),
        .refill_complete(),

        // writeback to L3
        .writeback_req(),
        .writeback_data(),
        .writeback_done(1'b0)
    );

    // ---------------------------
    // 3) 實例化 L3 Cache with AXI3
    // ---------------------------
    L3_Data_Cache #(
        .DATA_LENGTH(32),
        .CACHE_SIZE(32 * 1024 * 1024),
        .LINE_SIZE(64),
        .WAYS(16)
    ) u_l3 (
        .clk(clk),
        .rst(rst),
        .flush(1'b0),

        // 從 L2 來的介面(簡化)
        .access_valid(l3_access_valid),
        .access_addr(l3_addr),
        .access_isStore(l3_isStore),
        .store_data_in(l3_wdata),
        .load_data_out(l3_rdata),
        .miss_detected(l3_miss),

        // AXI3
        .axi_araddr(axi_araddr),
        .axi_arvalid(axi_arvalid),
        .axi_arready(axi_arready),

        .axi_rdata(axi_rdata),
        .axi_rvalid(axi_rvalid),
        .axi_rready(axi_rready),

        .axi_awaddr(axi_awaddr),
        .axi_awvalid(axi_awvalid),
        .axi_awready(axi_awready),

        .axi_wdata(axi_wdata),
        .axi_wvalid(axi_wvalid),
        .axi_wready(axi_wready),

        .axi_bvalid(axi_bvalid),
        .axi_bready(axi_bready)
    );

    // ---------------------------
    // 4) AXI3 Memory Model (極簡)
    // ---------------------------
    // 這裡僅示範：收到 AR -> 隔幾拍回傳 R data；收到 AW/W -> 回傳 B
    // 真正 AXI3 需要更完整的 burst/size/ID 等細節
    reg [31:0] fake_mem [0:65535];  // 小範例: 64K word

    initial begin
        for (i=0; i<65536; i=i+1) begin
            fake_mem[i] = i; // 簡單初始化
        end
    end

    // Read Address handshake
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_arready <= 1'b0;
        end else begin
            // 簡化：隨時可接收 AR
            axi_arready <= 1'b1;
        end
    end

    // Read Data channel (R)
    // 簡化：偵測到 arvalid & arready 之後，經過幾拍送出連續 word
    reg [3:0] read_count;
    reg [31:0] saved_araddr;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_rvalid   <= 0;
            read_count   <= 0;
            saved_araddr <= 0;
        end else begin
            if (axi_arvalid && axi_arready) begin
                // 啟動送資料
                saved_araddr <= axi_araddr;
                read_count   <= 0;
                axi_rvalid   <= 0;  // 先清0，下一拍再開始送
            end else if (axi_rready) begin
                // 送出連續 WORDS_PER_LINE word
                // 這裡示範一次一拍
                if (read_count < 8) begin // 假設 line=64Byte => 8個32bit words
                    axi_rvalid <= 1'b1;
                    // mem[addr/4 + read_count]
                    axi_rdata  <= fake_mem[(saved_araddr[31:2] + read_count) & 32'hFFFF];
                    read_count <= read_count + 1;
                end else begin
                    // 送完
                    axi_rvalid <= 0;
                end
            end
        end
    end

    // Write Address handshake
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_awready <= 1'b0;
        end else begin
            axi_awready <= 1'b1;
        end
    end

    // Write Data handshake
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_wready <= 1'b0;
        end else begin
            axi_wready <= 1'b1;
        end
    end

    // Write Response
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_bvalid <= 1'b0;
        end else if (axi_wvalid && axi_wready) begin
            // 收到 W 之後一拍回應 B
            axi_bvalid <= 1'b1;
        end else if (axi_bvalid && axi_bready) begin
            axi_bvalid <= 1'b0;
        end
    end

    // ---------------------------
    // 5) 測試程序
    // ---------------------------
    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;

        // 先測 L1
        l1_load_valid  = 1;
        l1_store_valid = 0;
        l1_addr        = 32'h0000_0008; 
        l1_wdata       = 32'hDEAD_BEEF; 
        #10;
        l1_load_valid  = 0;

        // 也許等幾拍，再發 store
        #50;
        l1_store_valid = 1;
        l1_addr        = 32'h0000_0010;
        l1_wdata       = 32'h1234_5678;
        #10;
        l1_store_valid = 0;

        // 同理測 L2
        #50;
        l2_access_valid = 1;
        l2_isStore      = 0;
        l2_addr         = 32'h0000_1000;
        l2_store_data   = 32'hAAAA_5555;
        #10;
        l2_access_valid = 0;

        // 同理測 L3
        #50;
        l3_access_valid = 1;
        l3_isStore      = 0;
        l3_addr         = 32'h0000_2000;
        l3_wdata        = 32'hFFFF_0000;
        #10;
        l3_access_valid = 0;

        // ...
        #200;
        $display("Simulation ends");
        $finish;
    end

endmodule
