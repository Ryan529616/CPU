`ifndef CACHE_CORE_V
`define CACHE_CORE_V

module CacheCore #(
    parameter DATA_LENGTH = 32,          // 每個word的bit寬度
    parameter CACHE_SIZE  = 48 * 1024,   // Cache總大小 (bytes)
    parameter LINE_SIZE   = 64,          // 每個Cache line大小 (bytes)
    parameter WAYS        = 12           // 相同set的way數
)(
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    flush,

    //----------------------------------------------------------------------
    // 1) 查詢 (Load/Store) 介面
    //----------------------------------------------------------------------
    input  wire                    query_valid,   
    input  wire [31:0]             query_addr,
    output reg                     query_hit,      
    output reg  [$clog2(WAYS)-1:0] query_hit_way,  
    output reg [DATA_LENGTH-1:0]   query_data_out, 

    //----------------------------------------------------------------------
    // 2) 完成 store 動作介面
    //----------------------------------------------------------------------
    input  wire                    do_store,
    input  wire [DATA_LENGTH-1:0]  store_data_in,
    input  wire [$clog2(WAYS)-1:0] store_way,
    input  wire [31:0]             store_addr,

    //----------------------------------------------------------------------
    // 3) 在 refill / writeback 後，需要更新 Cache line 的 tag、valid、dirty
    //----------------------------------------------------------------------
    input  wire                    do_update_line,          
    input  wire                    do_update_tag_and_valid, 
    input  wire                    do_clear_dirty,           
    input  wire [31:0]             update_addr,              
    input  wire [LINE_SIZE*8-1:0]  update_line_data,         
    input  wire [$clog2(WAYS)-1:0] update_way,              
    input  wire                    update_dirty_bit,         

    //----------------------------------------------------------------------
    // 4) debug / 監控用訊號
    //----------------------------------------------------------------------
    output reg [WAYS-1:0]         valid_per_way,   
    output reg [WAYS-1:0]         dirty_per_way,
    output wire [31:0]            dbg_current_tag,
    output wire [31:0]            dbg_current_data,

    //----------------------------------------------------------------------
    // 5) ** 新增：Victim 讀取介面 **
    //----------------------------------------------------------------------
    input  wire [31:0]             victim_addr,
    input  wire [$clog2(WAYS)-1:0] victim_way,
    output reg [31:0]              victim_tag_out,   
    output reg                     victim_dirty_out,
    output reg [LINE_SIZE*8-1:0]   victim_line_data_out
);

    //----------------------------------------------------------------------
    // 參數計算
    //----------------------------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE    = LINE_SIZE / (DATA_LENGTH/8);

    //======================================================================
    // Address decode function
    //======================================================================
    function [TAG_BITS-1:0] get_tag(input [31:0] addr);
        get_tag = addr[31 : 32 - TAG_BITS];
    endfunction

    function [SET_INDEX_BITS-1:0] get_index(input [31:0] addr);
        get_index = addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    endfunction

    function [$clog2(WORDS_PER_LINE)-1:0] get_word_idx(input [31:0] addr);
        get_word_idx = addr[BLOCK_OFFSET_BITS-1:2];
    endfunction

    //======================================================================
    // Cache結構宣告：Tag / Data / Valid / Dirty
    //======================================================================
    reg [TAG_BITS-1:0]    tag_array   [0:SETS-1][0:WAYS-1];
    reg [DATA_LENGTH-1:0] data_array  [0:SETS-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    reg                   valid_array [0:SETS-1][0:WAYS-1];
    reg                   dirty_array [0:SETS-1][0:WAYS-1];

    //======================================================================
    // Flush / Reset
    //======================================================================
    integer i, j, w;
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] <= 1'b0;
                    dirty_array[i][j] <= 1'b0;
                    tag_array[i][j]   <= {TAG_BITS{1'b0}};
                end
            end
        end
    end

    //======================================================================
    // 1) 查詢邏輯：query_valid=1 時，檢查有無命中
    //======================================================================
    wire [SET_INDEX_BITS-1:0]          query_index    = get_index(query_addr);
    wire [TAG_BITS-1:0]                query_tag      = get_tag(query_addr);
    wire [$clog2(WORDS_PER_LINE)-1:0]  query_word_idx = get_word_idx(query_addr);

    always @(*) begin
        query_hit      = 1'b0;
        query_hit_way  = {($clog2(WAYS)){1'b0}};
        valid_per_way  = {WAYS{1'b0}};
        dirty_per_way  = {WAYS{1'b0}};

        if (query_valid) begin
            for (j = 0; j < WAYS; j = j + 1) begin
                valid_per_way[j] = valid_array[query_index][j];
                dirty_per_way[j] = dirty_array[query_index][j];

                if (valid_array[query_index][j] && (tag_array[query_index][j] == query_tag)) begin
                    query_hit      = 1'b1;
                    query_hit_way  = j[$clog2(WAYS)-1:0];
                end
            end
        end
    end

    always @* begin
        if (rst || flush) begin
            query_data_out <= {DATA_LENGTH{1'b0}};
        end else if (query_hit) begin
            query_data_out <= data_array[query_index][query_hit_way][query_word_idx];
        end else begin
            query_data_out <= query_data_out;
        end
    end

    //======================================================================
    // 2) Store邏輯: do_store=1 => 由上層指定 store_way 和 store_addr
    //======================================================================
    // 修正成同步寫
    wire [SET_INDEX_BITS-1:0]          store_index    = get_index(store_addr);
    wire [$clog2(WORDS_PER_LINE)-1:0]  store_word_idx = get_word_idx(store_addr);

    always @(posedge clk) begin
        if (!rst && !flush) begin
            if (do_store) begin
                data_array[store_index][store_way][store_word_idx] <= store_data_in;
                tag_array[store_index][store_way]                  <= get_tag(store_addr);
                dirty_array[store_index][store_way]                <= 1'b1;
                valid_array[store_index][store_way]                <= 1'b1;
            end
        end
    end

    //======================================================================
    // 3) 更新整行 (Refill) / 更新 tag, valid, dirty
    //======================================================================
    // A) 拆解 update_line_data
    wire [DATA_LENGTH-1:0] splitted_update_line_data [0:WORDS_PER_LINE-1];
    genvar w_idx;
    generate
        for (w_idx = 0; w_idx < WORDS_PER_LINE; w_idx = w_idx + 1) begin : SPLIT_REFILL_DATA
            assign splitted_update_line_data[w_idx] = 
                   update_line_data[(w_idx+1)*DATA_LENGTH - 1 : w_idx*DATA_LENGTH];
        end
    endgenerate

    // B) 取得要更新的 tag / index
    wire [TAG_BITS-1:0]       update_tag   = get_tag(update_addr);
    wire [SET_INDEX_BITS-1:0] update_index = get_index(update_addr);

    // C) 同步邏輯做更新
    always @(posedge clk) begin
        if (!rst && !flush) begin
            // do_update_line => refill整行
            if (do_update_line) begin
                for (w = 0; w < WORDS_PER_LINE; w = w + 1) begin
                    data_array[update_index][update_way][w] 
                        <= splitted_update_line_data[w];
                end
            end

            // do_update_tag_and_valid => 更新 tag + valid
            if (do_update_tag_and_valid) begin
                tag_array[update_index][update_way]   <= update_tag;
                valid_array[update_index][update_way] <= 1'b1;
            end

            // do_clear_dirty => dirty=0
            if (do_clear_dirty) begin
                dirty_array[update_index][update_way] <= 1'b0;
            end

            // update_dirty_bit => dirty=1
            if (update_dirty_bit) begin
                dirty_array[update_index][update_way] <= 1'b1;
            end
        end
    end

    //======================================================================
    // 4) debug輸出: 觀察「目前 query_addr 所對應到的 tag/data」
    //======================================================================
    assign dbg_current_tag  = { {(32 - TAG_BITS){1'b0}}, 
                                tag_array[query_index][query_hit_way] };
    assign dbg_current_data = data_array[query_index][query_hit_way][query_word_idx];

    //======================================================================
    // 5) Victim 讀取介面(同步讀取)
    //======================================================================
    wire [SET_INDEX_BITS-1:0] victim_index = get_index(victim_addr);

    
    always @* begin
        // (A) victim tag => 高位補0
        victim_tag_out <= { {(32 - TAG_BITS){1'b0}}, tag_array[victim_index][victim_way] };
        // (B) victim dirty
        victim_dirty_out <= dirty_array[victim_index][victim_way];
    end
        // (C) victim 整行資料
    genvar vv;
    generate
        for (vv = 0; vv < WORDS_PER_LINE; vv = vv + 1) begin : SPLIT_VICTIM_DATA
            assign victim_line_data_out[(vv+1)*DATA_LENGTH - 1 : vv*DATA_LENGTH]
                   = data_array[victim_index][victim_way][vv];
        end
    endgenerate

endmodule

`endif
