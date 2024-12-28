`include "../../general/CacheCore.v"

module L2_Data_Cache #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 1024 * 1024, // 1MB
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    //------------------------------------------------
    // 1) 與 CPU (或上層) 的查詢介面
    //------------------------------------------------
    input  wire                    query_valid,
    input  wire [31:0]             query_addr,
    output wire [DATA_LENGTH-1:0]  query_data_out,
    output wire                    query_hit,
    output wire [$clog2(WAYS)-1:0] query_hit_way,

    //------------------------------------------------
    // 2) Store動作介面
    //------------------------------------------------
    input  wire                    do_store,
    input  wire [DATA_LENGTH-1:0]  store_data_in,
    input  wire [$clog2(WAYS)-1:0] store_way,
    input  wire [31:0]             store_addr,

    //------------------------------------------------
    // 3) Refill / Writeback 更新介面
    //------------------------------------------------
    input  wire                    do_update_line,
    input  wire                    do_update_tag_and_valid,
    input  wire                    do_clear_dirty,
    input  wire [31:0]             update_addr,
    input  wire [LINE_SIZE*8-1:0]  update_line_data,
    input  wire [$clog2(WAYS)-1:0] update_way,
    input  wire                    update_dirty_bit,

    //------------------------------------------------
    // 4) Debug/監控
    //------------------------------------------------
    output wire [WAYS-1:0]         valid_per_way,
    output wire [WAYS-1:0]         dirty_per_way,
    output wire [31:0]             dbg_current_tag,
    output wire [31:0]             dbg_current_data,

    //------------------------------------------------
    // 5) Victim 讀取介面
    //------------------------------------------------
    input  wire [$clog2(WAYS)-1:0] victim_way,
    input  wire [31:0]             victim_addr,

    output wire [31:0]             victim_tag_out,
    output wire                    victim_dirty_out,
    output wire [LINE_SIZE*8-1:0]  victim_line_data_out
);

    //======================================================================
    // 直接實例化 CacheCore
    //======================================================================
    CacheCore #(
        .DATA_LENGTH(DATA_LENGTH),
        .CACHE_SIZE (CACHE_SIZE),
        .LINE_SIZE  (LINE_SIZE),
        .WAYS       (WAYS)
    ) u_cache_core (
        .clk   (clk),
        .rst   (rst),
        .flush (flush),

        // Query
        .query_valid    (query_valid),
        .query_addr     (query_addr),
        .query_data_out (query_data_out),
        .query_hit      (query_hit),
        .query_hit_way  (query_hit_way),

        // Store
        .do_store       (do_store),
        .store_data_in  (store_data_in),
        .store_way      (store_way),
        .store_addr     (store_addr),

        // Refill / update
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

        // Victim
        .victim_addr            (victim_addr),
        .victim_way             (victim_way),
        .victim_tag_out         (victim_tag_out),
        .victim_dirty_out       (victim_dirty_out),
        .victim_line_data_out   (victim_line_data_out)
    );

endmodule
