`timescale 1ns/1ps

`include "L3_Data_Cache.v"
`include "L3_Data_Cache_Controller.v"

module tb_L3_Subsystem;

parameter DATA_LENGTH = 32;
parameter CACHE_SIZE  = 8 * 1024 * 1024; // 8MB
parameter LINE_SIZE   = 64;
parameter WAYS        = 16;

//----------------------------------------------------------------
// 1) Clock / Reset
//----------------------------------------------------------------
reg clk;
reg rst;

// 10ns 週期時鐘
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset
initial begin
    rst = 1;
    #20;
    rst = 0;
end

//----------------------------------------------------------------
// 2) 實例化 L3_Data_Cache (純快取)
//----------------------------------------------------------------
wire l3_query_valid;
wire [31:0] l3_query_addr;
wire l3_query_hit;
wire [$clog2(WAYS)-1:0] l3_query_hit_way;
wire [DATA_LENGTH-1:0]  l3_query_data_out;

wire l3_do_store;
wire [DATA_LENGTH-1:0] l3_store_data_in;
wire [$clog2(WAYS)-1:0] l3_store_way;
wire [31:0] l3_store_addr;

wire l3_do_update_line;
wire l3_do_update_tag_and_valid;
wire l3_do_clear_dirty;
wire [31:0] l3_update_addr;
wire [LINE_SIZE*8-1:0] l3_update_line_data;
wire [$clog2(WAYS)-1:0] l3_update_way;
wire l3_update_dirty_bit;

wire [$clog2(WAYS)-1:0] l3_victim_way;
wire [31:0] l3_victim_addr;
wire [31:0] l3_victim_tag_out;
wire l3_victim_dirty_out;
wire [LINE_SIZE*8-1:0] l3_victim_line_data_out;

L3_Data_Cache #(
    .DATA_LENGTH(DATA_LENGTH),
    .CACHE_SIZE (CACHE_SIZE),
    .LINE_SIZE  (LINE_SIZE),
    .WAYS       (WAYS)
) u_L3_Data_Cache (
    .clk   (clk),
    .rst   (rst),
    .flush (1'b0),

    .query_valid    (l3_query_valid),
    .query_addr     (l3_query_addr),
    .query_data_out (l3_query_data_out),
    .query_hit      (l3_query_hit),
    .query_hit_way  (l3_query_hit_way),

    .do_store       (l3_do_store),
    .store_data_in  (l3_store_data_in),
    .store_way      (l3_store_way),
    .store_addr     (l3_store_addr),

    .do_update_line          (l3_do_update_line),
    .do_update_tag_and_valid (l3_do_update_tag_and_valid),
    .do_clear_dirty          (l3_do_clear_dirty),
    .update_addr             (l3_update_addr),
    .update_line_data        (l3_update_line_data),
    .update_way              (l3_update_way),
    .update_dirty_bit        (l3_update_dirty_bit),

    .valid_per_way(),
    .dirty_per_way(),
    .dbg_current_tag(),
    .dbg_current_data(),

    .victim_way             (l3_victim_way),
    .victim_addr            (l3_victim_addr),
    .victim_tag_out         (l3_victim_tag_out),
    .victim_dirty_out       (l3_victim_dirty_out),
    .victim_line_data_out   (l3_victim_line_data_out)
);

//----------------------------------------------------------------
// 3) L3_Data_Cache_Controller 實例化
//----------------------------------------------------------------
reg load_valid;
reg [31:0] load_addr;
wire [DATA_LENGTH-1:0] load_data_out;
wire load_miss_detected;

reg store_valid;
reg [31:0] store_addr_in;
reg [DATA_LENGTH-1:0] store_data_in_reg;
wire store_miss_detected;

wire refill_complete;

// AXI Master介面
wire         axi_awvalid;
wire         axi_awready;
wire [31:0]  axi_awaddr;
wire         axi_wvalid;
wire         axi_wready;
wire [LINE_SIZE*8-1:0] axi_wdata;
wire [LINE_SIZE-1:0]   axi_wstrb;
wire                   axi_wlast;
wire                   axi_bvalid;
wire                   axi_bready;

wire         axi_arvalid;
wire         axi_arready;
wire [31:0]  axi_araddr;
wire         axi_rvalid;
wire         axi_rready;
wire [LINE_SIZE*8-1:0] axi_rdata;

L3_Data_Cache_Controller #(
    .DATA_LENGTH(DATA_LENGTH),
    .CACHE_SIZE (CACHE_SIZE),
    .LINE_SIZE  (LINE_SIZE),
    .WAYS       (WAYS)
) u_l3_ctl (
    .clk   (clk),
    .rst   (rst),
    .flush (1'b0),

    // CPU/L2 介面
    .load_valid        (load_valid),
    .load_addr         (load_addr),
    .load_data_out     (load_data_out),
    .load_miss_detected(load_miss_detected),

    .store_valid        (store_valid),
    .store_addr         (store_addr_in),
    .store_data_in      (store_data_in_reg),
    .store_miss_detected(store_miss_detected),

    // AXI Master
    .axi_awvalid (axi_awvalid),
    .axi_awready (axi_awready),
    .axi_awaddr  (axi_awaddr),
    .axi_wvalid  (axi_wvalid),
    .axi_wready  (axi_wready),
    .axi_wdata   (axi_wdata),
    .axi_wstrb   (axi_wstrb),
    .axi_wlast   (axi_wlast),
    .axi_bvalid  (axi_bvalid),
    .axi_bready  (axi_bready),

    .axi_arvalid (axi_arvalid),
    .axi_arready (axi_arready),
    .axi_araddr  (axi_araddr),
    .axi_rvalid  (axi_rvalid),
    .axi_rready  (axi_rready),
    .axi_rdata   (axi_rdata),

    .refill_complete(refill_complete),

    // 與 L3_Data_Cache
    .cache_query_valid    (l3_query_valid),
    .cache_query_addr     (l3_query_addr),
    .cache_query_hit      (l3_query_hit),
    .cache_query_hit_way  (l3_query_hit_way),
    .cache_query_data_out (l3_query_data_out),

    .cache_do_store       (l3_do_store),
    .cache_store_data_in  (l3_store_data_in),
    .cache_store_way      (l3_store_way),
    .cache_store_addr     (l3_store_addr),

    .cache_do_update_line         (l3_do_update_line),
    .cache_do_update_tag_and_valid(l3_do_update_tag_and_valid),
    .cache_do_clear_dirty         (l3_do_clear_dirty),
    .cache_update_addr            (l3_update_addr),
    .cache_update_line_data       (l3_update_line_data),
    .cache_update_way             (l3_update_way),
    .cache_update_dirty_bit       (l3_update_dirty_bit),

    .cache_victim_way      (l3_victim_way),
    .cache_victim_addr     (l3_victim_addr),
    .cache_victim_tag_out  (l3_victim_tag_out),
    .cache_victim_dirty_out(l3_victim_dirty_out),
    .cache_victim_line_data_out(l3_victim_line_data_out)
);

//----------------------------------------------------------------
// 4) 假裝的 AXI Slave (Fake DRAM)
//    拆開 write_delay_cnt / read_delay_cnt 分開處理
//----------------------------------------------------------------
reg axi_awready_r;
reg axi_wready_r;
reg axi_bvalid_r;

reg axi_arready_r;
reg axi_rvalid_r;
reg [LINE_SIZE*8-1:0] axi_rdata_r;

// 分成兩個計數器
reg [3:0] write_delay_cnt;
reg [3:0] read_delay_cnt;

// Assign to top
assign axi_awready = axi_awready_r;
assign axi_wready  = axi_wready_r;
assign axi_bvalid  = axi_bvalid_r;

assign axi_arready = axi_arready_r;
assign axi_rvalid  = axi_rvalid_r;
assign axi_rdata   = axi_rdata_r;
assign axi_wlast = 1'b1;
assign axi_wstrb = {LINE_SIZE{1'b1}};

// 初始化
initial begin
    axi_awready_r   = 0;
    axi_wready_r    = 0;
    axi_bvalid_r    = 0;

    axi_arready_r   = 0;
    axi_rvalid_r    = 0;
    axi_rdata_r     = 0;

    write_delay_cnt = 0;
    read_delay_cnt  = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        axi_awready_r   <= 0;
        axi_wready_r    <= 0;
        axi_bvalid_r    <= 0;

        axi_arready_r   <= 0;
        axi_rvalid_r    <= 0;
        axi_rdata_r     <= 0;

        write_delay_cnt <= 0;
        read_delay_cnt  <= 0;
    end else begin
        // 預設拉低
        axi_awready_r <= 0;
        axi_wready_r  <= 0;
        axi_bvalid_r  <= 0;

        axi_arready_r <= 0;
        axi_rvalid_r  <= 0;

        //--------------------------------
        // Write channel (AW/W/B)
        //--------------------------------
        // AW 同拍握手
        if (axi_awvalid) begin
            axi_awready_r <= 1;
        end
        // W 同拍握手
        if (axi_wvalid) begin
            axi_wready_r <= 1;
        end
        // 如果 AW+W 都在同拍握手完成，就開始計時寫延遲
        if (axi_awvalid && axi_awready_r && axi_wvalid && axi_wready_r) begin
            write_delay_cnt <= 4'd3;  // 模擬延遲3拍後送 bvalid
        end else if (write_delay_cnt > 0) begin
            write_delay_cnt <= write_delay_cnt - 1;
            if (write_delay_cnt == 1) begin
                axi_bvalid_r <= 1; // 寫完成
            end
        end

        //--------------------------------
        // Read channel (AR/R)
        //--------------------------------
        // AR 同拍握手
        if (axi_arvalid) begin
            axi_arready_r <= 1;
            // 幾拍後再送 rvalid
            read_delay_cnt <= 4'd3;
        end else if (read_delay_cnt > 0) begin
            read_delay_cnt <= read_delay_cnt - 1;
            if (read_delay_cnt == 1) begin
                axi_rvalid_r <= 1;
                // 假裝都回傳 0xFF
                axi_rdata_r  <= { (LINE_SIZE*8){1'b1} };
            end
        end
    end
end

//----------------------------------------------------------------
// 5) 測試流程
//----------------------------------------------------------------
initial begin
    // 等 reset
    @(negedge rst);
    #10;

    //---------------------
    // Test A: Load miss => refill => hit
    //---------------------
    $display("[TB] Test (A): load miss on 0x1000 => refill => hit");
    load_valid <= 1;
    load_addr  <= 32'h00001000;
    store_valid <= 0;
    store_addr_in <= 32'h0;
    store_data_in_reg <= 32'h0;


    // 等 miss_detected or query_hit
    @(posedge clk);
    while (!load_miss_detected && !l3_query_hit) begin
        @(posedge clk);
    end
    if (l3_query_hit) begin
        $display("   Already hit? Possibly re-run or data from earlier run.");
    end else begin
        $display("   Miss => waiting for refill_complete...");
        while (!refill_complete) @(posedge clk);
        $display("   Refill done => check final hit...");
        @(posedge clk);
        if (!l3_query_hit) begin
            $fatal("[FAIL-A] after refill, still not hit!");
        end
    end
    $display("[PASS] load miss => refill => final hit at 0x1000");
    load_valid <= 0;
    repeat(5) @(posedge clk);

    //---------------------
    // Test B: 同地址 => 直接 hit
    //---------------------
    $display("[TB] Test (B): read same => immediate hit");
    load_valid <= 1;
    load_addr  <= 32'h00001000;
    @(posedge clk);
    if (!l3_query_hit) begin
        $fatal("[FAIL-B] should be immediate hit on 0x1000!");
    end
    $display("[PASS] immediate hit on 0x1000");
    load_valid <= 0;
    repeat(5) @(posedge clk);

    //---------------------
    // Test C: store miss => refill => post-store => final read
    //---------------------
    $display("[TB] Test (C): store miss => refill => post-store => final read");
    store_valid       <= 1;
    store_addr_in     <= 32'h00002000;
    store_data_in_reg <= 32'hDEAD_BEEF;
    load_valid        <= 0;

    @(posedge clk);
    while (!store_miss_detected && !l3_query_hit) begin
        @(posedge clk);
    end
    if (l3_query_hit) begin
        $display("   Already in cache? skip refill...");
    end else begin
        $display("   Store miss => wait refill...");
        while (!refill_complete) @(posedge clk);
        $display("   Refill done => post-store...");
    end

    repeat(5) @(posedge clk);
    store_valid <= 0;

    // 再讀 0x2000 => 應該命中 + data=DEAD_BEEF
    load_valid <= 1;
    load_addr  <= 32'h00002000;
    @(posedge clk);
    if (!l3_query_hit) begin
        $fatal("[FAIL-C] should be hit after store refill!");
    end
    @(posedge clk);
    if (load_data_out !== 32'hDEAD_BEEF) begin
        $fatal("[FAIL-C] mismatch read=%h, expect=DEAD_BEEF", load_data_out);
    end
    $display("[PASS] store miss => refill => post-store => final read OK!");

    load_valid <= 0;

    // 結束
    $display("[TB] All tests done, simulation finish!");
    #50;
    $finish;
end

//----------------------------------------------------------------
// 波形與 Timeout
//----------------------------------------------------------------
initial begin
    $fsdbDumpfile("tb_L3_Subsystem.fsdb");
    $fsdbDumpvars(0, tb_L3_Subsystem);
end

// 若超過 1ms(視系統需求) => Timeout
always @(posedge clk) begin
    if ($time > 1_000_000_00) begin
        $display("[TB] Simulation timeout at time %t ns", $time);
        $finish;
    end
end

endmodule
