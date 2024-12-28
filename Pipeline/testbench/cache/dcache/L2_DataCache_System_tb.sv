`timescale 1ns/1ps

// 你需要 L2_Data_Cache.v  + L2_Data_Cache_Controller.v + CacheCore.v
`include "L2_Data_Cache.v"
`include "L2_Data_Cache_Controller.v"

module tb_L2_DataCache_System;

//----------------------------------------------------------------
// 0) 參數定義
//----------------------------------------------------------------
parameter DATA_LENGTH = 32;
parameter CACHE_SIZE  = 1024 * 1024; // 1MB
parameter LINE_SIZE   = 64;
parameter WAYS        = 16;

//----------------------------------------------------------------
// 1)時鐘 / 重置信號
//----------------------------------------------------------------
reg clk;
reg rst;

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
// 實例化 L2_Data_Cache
//----------------------------------------------------------------
wire query_valid;
wire [31:0] query_addr;
wire query_hit;
wire [$clog2(WAYS)-1:0] query_hit_way;
wire [DATA_LENGTH-1:0]  query_data_out;

wire do_store;
wire [DATA_LENGTH-1:0] store_data_in;
wire [$clog2(WAYS)-1:0] store_way;
wire [31:0] store_addr;

wire do_update_line;
wire do_update_tag_and_valid;
wire do_clear_dirty;
wire [31:0] update_addr;
wire [LINE_SIZE*8-1:0] update_line_data;
wire [$clog2(WAYS)-1:0] update_way;
wire update_dirty_bit;

// debug/監控訊號
wire [WAYS-1:0] valid_per_way;
wire [WAYS-1:0] dirty_per_way;
wire [31:0] dbg_current_tag;
wire [31:0] dbg_current_data;

// Victim介面
wire [$clog2(WAYS)-1:0] victim_way;
wire [31:0] victim_addr;
wire [31:0] victim_tag_out;
wire victim_dirty_out;
wire [LINE_SIZE*8-1:0] victim_line_data_out;

reg flush = 0;

//=== Instantiate L2_Data_Cache ===
L2_Data_Cache #(
    .DATA_LENGTH(DATA_LENGTH),
    .CACHE_SIZE(CACHE_SIZE),
    .LINE_SIZE(LINE_SIZE),
    .WAYS(WAYS)
) u_l2_cache (
    .clk                (clk),
    .rst                (rst),
    .flush              (flush),

    .query_valid        (query_valid),
    .query_addr         (query_addr),
    .query_data_out     (query_data_out),
    .query_hit          (query_hit),
    .query_hit_way      (query_hit_way),

    .do_store           (do_store),
    .store_data_in      (store_data_in),
    .store_way          (store_way),
    .store_addr         (store_addr),

    .do_update_line          (do_update_line),
    .do_update_tag_and_valid (do_update_tag_and_valid),
    .do_clear_dirty          (do_clear_dirty),
    .update_addr             (update_addr),
    .update_line_data        (update_line_data),
    .update_way              (update_way),
    .update_dirty_bit        (update_dirty_bit),

    .valid_per_way           (valid_per_way),
    .dirty_per_way           (dirty_per_way),
    .dbg_current_tag         (dbg_current_tag),
    .dbg_current_data        (dbg_current_data),

    .victim_way              (victim_way),
    .victim_addr             (victim_addr),
    .victim_tag_out          (victim_tag_out),
    .victim_dirty_out        (victim_dirty_out),
    .victim_line_data_out    (victim_line_data_out)
);

//----------------------------------------------------------------
// 實例化 L2_Data_Cache_Controller
//----------------------------------------------------------------
reg load_valid;
reg [31:0] load_addr;
wire [DATA_LENGTH-1:0] load_data_out;
wire load_miss_detected;

reg store_valid;
reg [31:0] store_addr_in;
reg [DATA_LENGTH-1:0] store_data_in_reg;
wire store_miss_detected;

// 下層 memory 接口
wire mem_req;
wire mem_we;
wire [31:0] mem_addr;
wire [LINE_SIZE*8-1:0] mem_write_data;
reg  [LINE_SIZE*8-1:0] mem_read_data;
reg  mem_data_valid;
reg  mem_ready;
wire refill_complete;

//=== Instantiate L2_Data_Cache_Controller ===
L2_Data_Cache_Controller #(
    .DATA_LENGTH(DATA_LENGTH),
    .CACHE_SIZE (CACHE_SIZE),
    .LINE_SIZE  (LINE_SIZE),
    .WAYS       (WAYS)
) u_l2_controller (
    .clk(clk),
    .rst(rst),
    .flush(flush),

    // 與上層溝通
    .load_valid        (load_valid),
    .load_addr         (load_addr),
    .load_data_out     (load_data_out),
    .load_miss_detected(load_miss_detected),

    .store_valid       (store_valid),
    .store_addr        (store_addr_in),
    .store_data_in     (store_data_in_reg),
    .store_miss_detected(store_miss_detected),

    // 與 Memory 溝通
    .mem_req           (mem_req),
    .mem_we            (mem_we),
    .mem_addr          (mem_addr),
    .mem_write_data    (mem_write_data),
    .mem_read_data     (mem_read_data),
    .mem_data_valid    (mem_data_valid),
    .mem_ready         (mem_ready),
    .refill_complete   (refill_complete),

    // 與 L2 Cache 連線
    .cache_query_valid     (query_valid),
    .cache_query_addr      (query_addr),
    .cache_query_hit       (query_hit),
    .cache_query_hit_way   (query_hit_way),
    .cache_query_data_out  (query_data_out),

    .cache_do_store        (do_store),
    .cache_store_data_in   (store_data_in),
    .cache_store_way       (store_way),
    .cache_store_addr      (store_addr),

    .cache_do_update_line          (do_update_line),
    .cache_do_update_tag_and_valid (do_update_tag_and_valid),
    .cache_do_clear_dirty          (do_clear_dirty),
    .cache_update_addr             (update_addr),
    .cache_update_line_data        (update_line_data),
    .cache_update_way              (update_way),
    .cache_update_dirty_bit        (update_dirty_bit),

    .cache_victim_way       (victim_way),
    .cache_victim_addr      (victim_addr),
    .cache_victim_tag_out   (victim_tag_out),
    .cache_victim_dirty_out (victim_dirty_out),
    .cache_victim_line_data_out (victim_line_data_out)
);

//----------------------------------------------------------------
// 假裝的 Memory (fake_mem) - 3-cycle 延遲
//----------------------------------------------------------------
localparam MEM_LINES = 1024; // 只示範 1024 行, 每行 64 bytes
reg [LINE_SIZE*8-1:0] fake_mem [0:MEM_LINES-1];

// 初始化
integer i;
initial begin
    for (i = 0; i < MEM_LINES; i = i + 1) begin
        fake_mem[i] = {LINE_SIZE*8{1'b0}};
    end
end

initial begin
    mem_ready      = 1; // 假設 memory 永遠可以接收
    mem_data_valid = 0;
    mem_read_data  = 0;
end

reg [2:0] mem_delay_cnt = 0;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_data_valid <= 0;
        mem_delay_cnt  <= 0;
        mem_read_data  <= 0;
    end else begin
        mem_data_valid <= 0; // 預設

        if (mem_req) begin
            // 取得 line_idx
            integer line_idx;
            line_idx = mem_addr[31:6]; // 只示範簡單位址切分

            if (mem_we) begin
                // write => 將 mem_write_data 存入 fake_mem
                fake_mem[line_idx] <= mem_write_data;
                mem_delay_cnt <= 3;
            end else begin
                // read => 從 fake_mem[line_idx] 讀出
                mem_read_data <= fake_mem[line_idx];
                mem_delay_cnt <= 3;
            end
        end
        else if (mem_delay_cnt > 0) begin
            mem_delay_cnt <= mem_delay_cnt - 1;
            if (mem_delay_cnt == 1) begin
                mem_data_valid <= 1; // 第3拍結束時拉高
            end
        end
    end
end

//----------------------------------------------------------------
// 測試流程
//----------------------------------------------------------------
initial begin
    // 等 reset
    @(negedge rst);
    #10;

    //========================================================
    // Test 1: Load Miss => refill => hit
    //========================================================
    $display("[TB] Test1: load miss on 0x1000 => refill => hit");
    load_valid <= 1;
    load_addr  <= 32'h00001000;
    store_valid <= 0;
    store_addr_in <= 0;
    store_data_in_reg <= 0;

    // 等到 miss_detected or query_hit
    @(posedge clk);
    while (!load_miss_detected && !query_hit) begin
        @(posedge clk);
    end
    if (query_hit) begin
        $display(" - Already hit? Possibly you re-run test. It's okay.");
    end 
    else begin
        $display(" - Miss => wait refill_complete...");
        while (!refill_complete) @(posedge clk);
        $display(" - Refill done => check query_hit");
        @(posedge clk);
        if (!query_hit) begin
            $fatal("[FAIL] after refill, still not hit!");
        end
    end
    $display("[PASS] Load Miss => Refill => Hit at 0x1000");
    load_valid <= 0;

    //========================================================
    // Test 2: Read same addr => immediate hit
    //========================================================
    $display("[TB] Test2: read same address => immediate hit");
    load_addr  <= 32'h00001000;
    load_valid <= 1;
    @(posedge clk);
    if (!query_hit) begin
        $fatal("[FAIL] Should be immediate hit on 0x1000!");
    end
    $display("[PASS] immediate hit");
    load_valid <= 0;
    @(posedge clk);

    //========================================================
    // Test 3: Store Miss => refill => post-store => verify
    //========================================================
    $display("[TB] Test3: store miss => refill => post-store => final read");
    store_valid       <= 1;
    store_addr_in     <= 32'h00002000;
    store_data_in_reg <= 32'hDEAD_BEEF;
    load_valid        <= 0;

    // 等 store_miss_detected
    @(posedge clk);
    while (!store_miss_detected && !query_hit) begin
        @(posedge clk);
    end
    if (query_hit) begin
        $display(" - Already in cache? skip refill...");
    end else begin
        $display(" - Store miss => wait refill...");
        while (!refill_complete) @(posedge clk);
        $display(" - Refill done => controller do post-store");
    end
    // 等幾拍
    repeat(20) @(posedge clk);
    store_valid <= 0;

    // 讀 0x2000 => 應該 hit + data=DEAD_BEEF
    load_valid <= 1;
    load_addr  <= 32'h00002000;
    @(posedge clk);
    if (!query_hit) begin
        $fatal("[FAIL] Should hit after store refill!");
    end
    @(posedge clk);
    if (load_data_out !== 32'hDEAD_BEEF) begin
        $fatal("[FAIL] Data mismatch! read=%h, expect=DEAD_BEEF", load_data_out);
    end

    $display("[PASS] store miss => refill => post-store => final read success!");
    load_valid <= 0;

    //========================================================
    // 結束
    //========================================================

    $display("All tests passed!");
    $finish;
end

//----------------------------------------------------------------
// 6) 波形與 Timeout
//----------------------------------------------------------------

    initial begin
        $fsdbDumpfile("tb_L2_DataCache_System.fsdb");
        $fsdbDumpvars(0, tb_L2_DataCache_System);
    end
endmodule
