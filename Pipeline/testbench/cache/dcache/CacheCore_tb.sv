`timescale 1ns/1ps
`include "L1_Data_Cache.v"  // 裡面已經 `include "CacheCore.v"`

module CacheCore_tb;

    // --------------------------------------------------------------------
    // 0) 參數宣告
    // --------------------------------------------------------------------
    localparam DATA_LENGTH = 32;
    localparam CACHE_SIZE  = 48 * 1024;
    localparam LINE_SIZE   = 64;
    localparam WAYS        = 12;
    
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE    = LINE_SIZE / (DATA_LENGTH/8);

    // --------------------------------------------------------------------
    // 1) 測試用信號宣告
    // --------------------------------------------------------------------
    reg clk;
    reg rst;
    reg flush;

    // --- 查詢介面 ---
    reg               query_valid;
    reg  [31:0]       query_addr;
    wire              query_hit;
    wire [$clog2(WAYS)-1:0] query_hit_way;
    wire [DATA_LENGTH-1:0]  query_data_out;

    // --- Store介面 ---
    reg                     do_store;
    reg  [DATA_LENGTH-1:0]  store_data_in;
    reg  [$clog2(WAYS)-1:0] store_way;
    reg  [31:0]            store_addr;

    // --- 更新(Refill / Writeback)介面 ---
    reg                     do_update_line;
    reg                     do_update_tag_and_valid;
    reg                     do_clear_dirty;
    reg  [31:0]            update_addr;
    reg  [LINE_SIZE*8-1:0] update_line_data;
    reg  [$clog2(WAYS)-1:0] update_way;
    reg                     update_dirty_bit;

    // --- Debug訊號 ---
    wire [WAYS-1:0] valid_per_way;
    wire [WAYS-1:0] dirty_per_way;
    wire [31:0]     dbg_current_tag;
    wire [31:0]     dbg_current_data;

    // --- Victim介面 ---
    reg  [$clog2(WAYS)-1:0] victim_way;
    reg  [31:0]             victim_addr;
    wire [31:0]             victim_tag_out;
    wire                    victim_dirty_out;
    wire [LINE_SIZE*8-1:0]  victim_line_data_out;

    // 用來暫存從 victim_line_data_out 擷取出來的 word
    reg [31:0] victim_word_reg;
    integer i, word_idx;

    // --------------------------------------------------------------------
    // 2) 建立 DUT (實際上是 L1_Data_Cache wrapper, 內部含 CacheCore)
    // --------------------------------------------------------------------
    L1_Data_Cache #(
        .DATA_LENGTH(DATA_LENGTH),
        .CACHE_SIZE (CACHE_SIZE),
        .LINE_SIZE  (LINE_SIZE),
        .WAYS       (WAYS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),

        // 查詢
        .query_valid    (query_valid),
        .query_addr     (query_addr),
        .query_data_out (query_data_out),
        .query_hit      (query_hit),
        .query_hit_way  (query_hit_way),

        // store
        .do_store       (do_store),
        .store_data_in  (store_data_in),
        .store_way      (store_way),
        .store_addr     (store_addr),

        // refill / update
        .do_update_line          (do_update_line),
        .do_update_tag_and_valid (do_update_tag_and_valid),
        .do_clear_dirty          (do_clear_dirty),
        .update_addr             (update_addr),
        .update_line_data        (update_line_data),
        .update_way              (update_way),
        .update_dirty_bit        (update_dirty_bit),

        // debug
        .valid_per_way   (valid_per_way),
        .dirty_per_way   (dirty_per_way),
        .dbg_current_tag (dbg_current_tag),
        .dbg_current_data(dbg_current_data),

        // Victim 介面
        .victim_way            (victim_way),
        .victim_addr           (victim_addr),
        .victim_tag_out        (victim_tag_out),
        .victim_dirty_out      (victim_dirty_out),
        .victim_line_data_out  (victim_line_data_out)
    );

    // --------------------------------------------------------------------
    // 3) Clock & Reset
    // --------------------------------------------------------------------
    always #5 clk = ~clk;  // 10ns 週期

    initial begin
        clk   = 0;
        rst   = 1;
        flush = 0;
        #20;
        rst   = 0;
    end

    // --------------------------------------------------------------------
    // 4) 初始訊號 + 測試流程
    // --------------------------------------------------------------------
    initial begin
        // 預設先拉低所有控制訊號
        query_valid = 0;
        query_addr  = 0;

        do_store       = 0;
        store_data_in  = 32'h0;
        store_way      = 0;
        store_addr     = 32'h0;

        do_update_line          = 0;
        do_update_tag_and_valid = 0;
        do_clear_dirty          = 0;
        update_addr             = 32'h0;
        update_line_data        = {LINE_SIZE*8{1'b0}};
        update_way              = 0;
        update_dirty_bit        = 0;

        victim_way   = 0;
        victim_addr  = 0;

        // 等待 reset 結束
        @(negedge rst);
        #10;

        // ----------------------------------------------------------------
        // Test 1: Reset 後 valid/dirty 應該全部清空
        // ----------------------------------------------------------------
        $display("[Test1] Check reset/flush initialization...");
        #10;
        if (valid_per_way != 0) begin
            $fatal("[Test1] Valid array is not reset to 0!");
        end
        if (dirty_per_way != 0) begin
            $fatal("[Test1] Dirty array is not reset to 0!");
        end

        // ----------------------------------------------------------------
        // Test 2: 基本 store + query
        // ----------------------------------------------------------------
        $display("[Test2] Basic store + query...");
        // 在 way=0 存入 {addr=ABCD_1234, data=DEAD_BEEF}
        store_addr     = 32'hABCD_1234;
        store_way      = 0;
        store_data_in  = 32'hDEAD_BEEF;
        do_store       = 1;
        #10;
        do_store       = 0;

        // Query 該地址 => 應該要 hit
        query_valid    = 1;
        query_addr     = 32'hABCD_1234;
        #10;
        query_valid    = 0;
        if (!query_hit) begin
            $fatal("[Test2] Should hit but missed!");
        end
        if (query_data_out !== 32'hDEAD_BEEF) begin
            $fatal("[Test2] Data mismatch! read=%h, expect=DEAD_BEEF", query_data_out);
        end

        // ----------------------------------------------------------------
        // Test 3: Refill + Update Tag
        // ----------------------------------------------------------------
        $display("[Test3] Refill a line + update tag/valid...");
        update_addr      = 32'h0000_2000;  // example
        update_way       = 1;
        // 整行(64 bytes = 512 bits)都填 FF
        update_line_data = { (LINE_SIZE*8){1'b1} };
        do_update_line          = 1;
        do_update_tag_and_valid = 1;
        #10;
        do_update_line          = 0;
        do_update_tag_and_valid = 0;

        // Query 該地址 => 應該 hit
        query_valid = 1;
        query_addr  = 32'h0000_2000; 
        #10;
        query_valid = 0;
        if (!query_hit) begin
            $fatal("[Test3] Cache miss after refill+tag_update!");
        end

        // 用 dbg_current_tag 做更嚴謹檢查
        if (dbg_current_tag != { {(32 - TAG_BITS){1'b0}}, (update_addr[31 : 32-TAG_BITS]) }) begin
            $fatal("[Test3] Tag mismatch! dbg_current_tag=%h", dbg_current_tag);
        end

        // ----------------------------------------------------------------
        // Test 4: Flush => 全部失效
        // ----------------------------------------------------------------
        $display("[Test4] Flush => all lines invalid...");
        flush = 1;
        #10;
        flush = 0;
        // 查任何地址都應該 miss
        query_valid = 1;
        query_addr  = 32'h0000_1000;
        #10;
        query_valid = 0;
        if (query_hit) begin
            $fatal("[Test4] Unexpected hit after flush!");
        end

        // ----------------------------------------------------------------
        // Test 5: Victim 介面 (重點)
        // ----------------------------------------------------------------
        $display("[Test5] Victim port read test...");

        // 先做一筆 store => (addr = 0x3000_4000, way=2, data= 0xFACE_B00C)
        store_addr     = 32'h3000_4000;
        store_way      = 2;
        store_data_in  = 32'hFACE_B00C;
        do_store       = 1;
        #10;
        do_store       = 0;

        // 設定 victim_way=2 + victim_addr=0x3000_4000 來讀取
        victim_way  = 2;
        victim_addr = 32'h3000_4000;

        // Victim 讀取是同步 => 在下一個 clock 才能讀到正確資料
        #10;
        $display("Victim read => tag=%h, dirty=%b, line_data_out=%h", victim_tag_out, victim_dirty_out, victim_line_data_out);

        // 檢查 tag是否正確 (compare with store_addr)
        if ( victim_tag_out[TAG_BITS-1:0] !== store_addr[31 : 32-TAG_BITS] ) begin
            $fatal("[Test5] Victim tag mismatch!");
        end

        // 檢查 dirty bit => 因為 store => dirty=1
        if (!victim_dirty_out) begin
            $fatal("[Test5] Victim dirty bit mismatch (should be 1)!");
        end

        // 用程式區塊擷取 victim_line_data_out 中對應 word

        word_idx = store_addr[BLOCK_OFFSET_BITS-1 : 2];
        victim_word_reg = victim_line_data_out[ (word_idx*32) +: 32 ];
        if (victim_word_reg !== 32'hFACE_B00C) begin
            $fatal("[Test5] Victim line data mismatch! read=%h, expect=FACE_B00C", victim_word_reg);
        end

        $display("Victim port read => PASS");

        // ----------------------------------------------------------------
        // 結束
        // ----------------------------------------------------------------
        $display("All tests PASSED!");
        $finish;
    end
    initial begin
        $fsdbDumpfile("cache_core_tb.fsdb");
        $fsdbDumpvars(0, CacheCore_tb);
    end
endmodule
