`timescale 1ns/1ps

// 這裡假設你將所有 L1/L2/L3 + Controllers 合併後，
// 產生了一個名為 Data_Cache 的大模組檔案: Data_Cache.v
// (可改檔名)
`include "Data_Cache.v"

module Data_Cache_tb;

//----------------------------------------------------------------
// 0) 參數、時鐘、重置
//----------------------------------------------------------------
reg clk;
reg rst;

// 假設 line=64 bytes => 512 bits
localparam LINE_BITS = 512;
localparam STRB_BITS = 64;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    #20;
    rst = 0;
end

//----------------------------------------------------------------
// 1) 寫幾個暫時用的 CPU 介面信號
//----------------------------------------------------------------
reg         cpu_load_valid;
reg [31:0]  cpu_load_addr;
wire [31:0] cpu_load_data_out;
wire        cpu_load_miss_detected;

reg         cpu_store_valid;
reg [31:0]  cpu_store_addr;
reg [31:0]  cpu_store_data_in;
wire        cpu_store_miss_detected;

//----------------------------------------------------------------
// 2) AXI 介面信號
//----------------------------------------------------------------
// AW
wire        axi_awvalid;
reg         axi_awready;
wire [31:0] axi_awaddr;

// W
wire        axi_wvalid;
reg         axi_wready;
wire [LINE_BITS-1:0] axi_wdata;
wire [STRB_BITS-1:0] axi_wstrb;
wire                 axi_wlast;

// B
reg         axi_bvalid;
wire        axi_bready;

// AR
wire        axi_arvalid;
reg         axi_arready;
wire [31:0] axi_araddr;

// R
reg         axi_rvalid;
wire        axi_rready;
reg  [LINE_BITS-1:0] axi_rdata;

//----------------------------------------------------------------
// 3) 實例化 Data_Cache (整合好的大模組)
//----------------------------------------------------------------
Data_Cache #(
    // 依你實際實作要的參數
    .L1_DATA_LENGTH(32),
    .L2_DATA_LENGTH(32),
    .L3_DATA_LENGTH(32)
    // .L1_LINE_SIZE(64), ...
) u_data_cache (
    .clk   (clk),
    .rst   (rst),
    .flush (1'b0),

    // CPU load
    .cpu_load_valid       (cpu_load_valid),
    .cpu_load_addr        (cpu_load_addr),
    .cpu_load_data_out    (cpu_load_data_out),
    .cpu_load_miss_detected(cpu_load_miss_detected),

    // CPU store
    .cpu_store_valid      (cpu_store_valid),
    .cpu_store_addr       (cpu_store_addr),
    .cpu_store_data_in    (cpu_store_data_in),
    .cpu_store_miss_detected(cpu_store_miss_detected),

    // AXI master
    .axi_awvalid(axi_awvalid),
    .axi_awready(axi_awready),
    .axi_awaddr (axi_awaddr),

    .axi_wvalid (axi_wvalid),
    .axi_wready (axi_wready),
    .axi_wdata  (axi_wdata),
    .axi_wstrb  (axi_wstrb),
    .axi_wlast  (axi_wlast),

    .axi_bvalid (axi_bvalid),
    .axi_bready (axi_bready),

    .axi_arvalid(axi_arvalid),
    .axi_arready(axi_arready),
    .axi_araddr (axi_araddr),

    .axi_rvalid (axi_rvalid),
    .axi_rready (axi_rready),
    .axi_rdata  (axi_rdata)
);

//----------------------------------------------------------------
// 4) 假裝的 AXI Slave / DRAM
//----------------------------------------------------------------
// 這裡用簡化版本：
//   - 同拍握手 AW/AWREADY, W/WREADY
//   - 幾拍後送 BVALID
//   - 同理 AR/ARREADY, 幾拍後送 RVALID + RDATA
//   - 內部 fake_mem
//

localparam MEM_SIZE   = 1024;  // 只示範 1024 行
reg [LINE_BITS-1:0]   fake_mem [0:MEM_SIZE-1];

integer i;
initial begin
    for (i=0; i<MEM_SIZE; i=i+1) begin
        fake_mem[i] = {LINE_BITS{1'b0}};
    end
end

initial begin
    axi_awready = 0;
    axi_wready  = 0;
    axi_bvalid  = 0;

    axi_arready = 0;
    axi_rvalid  = 0;
    axi_rdata   = 0;
end

reg [3:0] slave_delay_cnt;
integer ridx;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        axi_awready <= 0;
        axi_wready  <= 0;
        axi_bvalid  <= 0;

        axi_arready <= 0;
        axi_rvalid  <= 0;
        axi_rdata   <= 0;

        slave_delay_cnt <= 0;
    end else begin
        // 預設拉低
        axi_awready <= 0;
        axi_wready  <= 0;
        axi_bvalid  <= 0;

        axi_arready <= 0;
        axi_rvalid  <= 0;

        // Write channel
        if (axi_awvalid) begin
            axi_awready <= 1;  // 同拍握手
        end
        if (axi_wvalid) begin
            axi_wready <= 1;
        end
        // 如果 AW+W 都握手，則記錄地址 + wdata => write memory
        // line_idx = axi_awaddr >> 6
        // (簡化: single-beat => wdata=整個 line)
        if (axi_awvalid && axi_awready && axi_wvalid && axi_wready) begin
            integer line_idx;
            line_idx = axi_awaddr[31:6];
            fake_mem[line_idx] <= axi_wdata;
            slave_delay_cnt <= 3; // 幾拍後送 bvalid
        end
        else if (slave_delay_cnt>0) begin
            slave_delay_cnt <= slave_delay_cnt - 1;
            if (slave_delay_cnt==1) begin
                axi_bvalid <= 1;
            end
        end

        // Master handshake b => bready => next cycle bvalid=0
        // (此處簡化)

        // Read channel
        if (axi_arvalid) begin
            axi_arready <= 1;
            // single beat => 幾拍後送 rvalid
            slave_delay_cnt <= 3;
        end
        else if (slave_delay_cnt>0) begin
            slave_delay_cnt <= slave_delay_cnt - 1;
            if (slave_delay_cnt==1) begin
                axi_rvalid <= 1;
                // 讀 memory

                ridx = axi_araddr[31:6];
                axi_rdata <= fake_mem[ridx];
            end
        end
    end
end

assign axi_bready = 1;     // always ready to accept B
assign axi_rready = 1;     // always ready to accept R

//----------------------------------------------------------------
// 5) 測試邏輯 (CPU行為)
//----------------------------------------------------------------
initial begin
    // 等reset
    @(negedge rst);
    #10;

    // (A) load_valid=1, addr=0x1000 => 預期 miss => refill => hit
    $display("[TB] Test(A) load on 0x1000 => refill => hit");
    cpu_load_valid <= 1;
    cpu_load_addr  <= 32'h00001000;
    cpu_store_valid <= 0;
    cpu_store_addr  <= 32'h0;
    cpu_store_data_in <= 32'h0;

    @(posedge clk);
    // 等 miss or hit
    while (!cpu_load_miss_detected && !cpu_load_miss_detected && !cpu_load_miss_detected && !cpu_load_miss_detected && !cpu_load_miss_detected && !cpu_load_miss_detected && !cpu_store_miss_detected && !cpu_load_miss_detected && !cpu_load_miss_detected) begin
        @(posedge clk);
    end
    // 事實上，你可以檢查 cpu_load_miss_detected or query_hit from signals
    // 這裡簡化, 也可以等 refill_complete
    // ... 省略詳細

    // (B) store_valid=1 => ...
    // ... 你可以重複
    repeat(50) @(posedge clk);
    $finish;
end

//----------------------------------------------------------------
// Dump waveform & Timeout
//----------------------------------------------------------------
initial begin
    $fsdbDumpfile("Data_Cache_tb.fsdb");
    $fsdbDumpvars(0, Data_Cache_tb);
end

always @(posedge clk) begin
    if ($time>1_000_000) begin
        $display("TIMEOUT!!");
        $finish;
    end
end

endmodule
