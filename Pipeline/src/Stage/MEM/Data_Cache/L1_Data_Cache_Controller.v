module L1_Data_Cache_Controller #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 48 * 1024,   // 48KB for L1
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 12
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    //------------------------------------------------
    // 與 CPU 溝通的介面
    //------------------------------------------------
    // Load
    input  wire                   load_valid,
    input  wire [31:0]            load_addr,
    output reg  [DATA_LENGTH-1:0] load_data_out,
    output reg                    load_miss_detected,

    // Store
    input  wire                   store_valid,
    input  wire [31:0]            store_addr,
    input  wire [DATA_LENGTH-1:0] store_data_in,
    output reg                    store_miss_detected,

    //------------------------------------------------
    // 與 L2 (或更下層 Memory) 溝通的介面
    //------------------------------------------------
    output reg                    l2_req,
    output reg                    l2_we,      // 1=write, 0=read
    output reg [31:0]             l2_addr,
    output reg [LINE_SIZE*8-1:0]  l2_write_data,
    input  wire [LINE_SIZE*8-1:0] l2_read_data,
    input  wire                   l2_data_valid,
    input  wire                   l2_ready,

    // 一個 refill_complete 信號，標示 refill 是否完成
    output reg                    refill_complete,

    //------------------------------------------------
    // 與 L1_Data_Cache 連線
    //------------------------------------------------
    output wire                   cache_query_valid,
    output wire [31:0]            cache_query_addr,
    input  wire                   cache_query_hit,
    input  wire [$clog2(WAYS)-1:0]cache_query_hit_way,
    input  wire [DATA_LENGTH-1:0] cache_query_data_out,

    output reg                    cache_do_store,
    output reg [DATA_LENGTH-1:0]  cache_store_data_in,
    output reg [$clog2(WAYS)-1:0] cache_store_way,
    output reg [31:0]             cache_store_addr,

    output reg                    cache_do_update_line,
    output reg                    cache_do_update_tag_and_valid,
    output reg                    cache_do_clear_dirty,
    output reg [31:0]             cache_update_addr,
    output reg [LINE_SIZE*8-1:0]  cache_update_line_data,
    output reg [$clog2(WAYS)-1:0] cache_update_way,
    output reg                    cache_update_dirty_bit,

    // Victim port
    output reg [$clog2(WAYS)-1:0] cache_victim_way,
    output reg [31:0]             cache_victim_addr,
    input  wire [31:0]            cache_victim_tag_out,
    input  wire                   cache_victim_dirty_out,
    input  wire [LINE_SIZE*8-1:0] cache_victim_line_data_out
);

    //------------------------------------------------
    // 1) 基本參數
    //------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;

    //------------------------------------------------
    // 2) Query給 Cache
    //------------------------------------------------
    assign cache_query_valid = (load_valid || store_valid);
    assign cache_query_addr  = (load_valid) ? load_addr : store_addr;

    reg load_hit_r, store_hit_r;
    always @(*) begin
        load_hit_r  = (load_valid  && cache_query_hit);
        store_hit_r = (store_valid && cache_query_hit);
    end

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_data_out <= {DATA_LENGTH{1'b0}};
        end else if (load_hit_r) begin
            load_data_out <= cache_query_data_out;
        end
    end

    // Miss detected
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_miss_detected  <= 1'b0;
            store_miss_detected <= 1'b0;
        end else begin
            load_miss_detected  <= (load_valid  && !cache_query_hit);
            store_miss_detected <= (store_valid && !cache_query_hit);
        end
    end

    //------------------------------------------------
    // 3) 若 store hit => 直接寫入 cache (write-back)
    //------------------------------------------------
    always @(*) begin
        cache_do_store       = 1'b0;
        cache_store_data_in  = store_data_in;
        cache_store_way      = cache_query_hit_way;
        cache_store_addr     = store_addr;
        if (store_hit_r) begin
            cache_do_store = 1'b1;
        end
    end

    //------------------------------------------------
    // 4) State Machine : Handle Miss
    //------------------------------------------------
    localparam IDLE        = 3'd0;
    localparam CHECK       = 3'd1;
    localparam VICTIM      = 3'd2;
    localparam WB          = 3'd3;
    localparam WB_WAIT     = 3'd4;
    localparam REFILL      = 3'd5;
    localparam REFILL_WAIT = 3'd6;

    reg [2:0] state, next_state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    reg miss_is_store;
    reg [31:0] miss_addr;
    reg [$clog2(WAYS)-1:0] replace_way;

    // LFSR (簡易替換策略)
    reg [$clog2(WAYS)-1:0] lfsr;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= {$clog2(WAYS){1'b1}};
        end else begin
            lfsr <= {lfsr[$clog2(WAYS)-2:0],
                     lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
        end
    end

    always @(*) begin
        case(state)
        IDLE: begin
            if (load_miss_detected || store_miss_detected) begin
                next_state = CHECK;
            end
        end
        CHECK: begin
            // 讀 victim line
            next_state = VICTIM;
        end
        VICTIM: begin
            // dirty=1 => WB, else => REFILL
            next_state = (cache_victim_dirty_out) ? WB : REFILL;
        end
        WB: begin
            if (l2_ready) next_state = WB_WAIT;
        end
        WB_WAIT: begin
            // 等 l2_data_valid=1 表示 writeback 完成(可能不需要回傳data，但這裡簡化)
            if (l2_data_valid) next_state = REFILL;
        end
        REFILL: begin
            if (l2_ready) next_state = REFILL_WAIT;
        end
        REFILL_WAIT: begin
            if (l2_data_valid) next_state = IDLE;
        end
        default: next_state = IDLE;
        endcase
    end

    // 在 IDLE->CHECK：記錄 miss 的資訊
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            miss_is_store <= 1'b0;
            miss_addr     <= 32'h0;
            replace_way   <= 0;
        end 
        else if (state == IDLE) begin
            if (load_miss_detected) begin
                miss_is_store <= 1'b0;
                miss_addr     <= load_addr;
                replace_way   <= lfsr;
            end
            else if (store_miss_detected) begin
                miss_is_store <= 1'b1;
                miss_addr     <= store_addr;
                replace_way   <= lfsr;
            end
        end
    end

    // 在 CHECK狀態：指定 victim_way / victim_addr
    function [SET_INDEX_BITS-1:0] get_index(input [31:0] addr);
        get_index = addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    endfunction

    always @(posedge clk) begin
        if (state == CHECK) begin
            cache_victim_way  <= replace_way;
            cache_victim_addr <= miss_addr;
        end
    end

    // Victim 資料暫存
    reg [31:0] victim_tag;
    reg        victim_dirty;
    reg [LINE_SIZE*8-1:0] victim_line_data;
    always @(posedge clk) begin
        if (state == VICTIM) begin
            victim_tag       <= cache_victim_tag_out;
            victim_dirty     <= cache_victim_dirty_out;
            victim_line_data <= cache_victim_line_data_out;
        end
    end

    //------------------------------------------------
    // 5) 與 L2 (Memory) 介面
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l2_req        <= 1'b0;
            l2_we         <= 1'b0;
            l2_addr       <= 32'b0;
            l2_write_data <= {LINE_SIZE*8{1'b0}};
        end else begin
            case (state)
            CHECK, VICTIM: begin
                l2_req <= 1'b0;
            end
            WB: begin
                // writeback
                if (l2_ready) begin
                    l2_req <= 1'b1;
                    l2_we  <= 1'b1;
                    // WB位址: victim_tag + index + offset=0
                    l2_addr <= { victim_tag[TAG_BITS-1:0],
                                 get_index(miss_addr),
                                 {BLOCK_OFFSET_BITS{1'b0}} };
                    l2_write_data <= victim_line_data;
                end else begin
                    l2_req <= 1'b0;
                end
            end
            WB_WAIT: begin
                l2_req <= 1'b0;
            end
            REFILL: begin
                if (l2_ready) begin
                    l2_req <= 1'b1;
                    l2_we  <= 1'b0;
                    // Refill位址: miss_addr去掉offset
                    l2_addr <= { miss_addr[31:BLOCK_OFFSET_BITS], {BLOCK_OFFSET_BITS{1'b0}} };
                end else begin
                    l2_req <= 1'b0;
                end
            end
            REFILL_WAIT: begin
                l2_req <= 1'b0;
            end
            default: begin
                l2_req <= 1'b0;
            end
            endcase
        end
    end

    //------------------------------------------------
    // 6) refill_complete + cache update
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refill_complete               <= 1'b0;
            cache_do_update_line          <= 1'b0;
            cache_do_update_tag_and_valid <= 1'b0;
            cache_do_clear_dirty          <= 1'b0;
            cache_update_dirty_bit        <= 1'b0;
        end else begin
            // 預設拉低
            refill_complete               <= 1'b0;
            cache_do_update_line          <= 1'b0;
            cache_do_update_tag_and_valid <= 1'b0;
            cache_do_clear_dirty          <= 1'b0;
            cache_update_dirty_bit        <= 1'b0;

            case(state)
            WB_WAIT: begin
                if (l2_data_valid) begin
                    // WB完成 => 清 dirty
                    cache_do_clear_dirty <= 1'b1;
                    cache_update_addr    <= miss_addr;
                    cache_update_way     <= replace_way;
                end
            end
            REFILL_WAIT: begin
                if (l2_data_valid) begin
                    // refill
                    cache_do_update_line   <= 1'b1;
                    cache_update_addr      <= miss_addr;
                    cache_update_way       <= replace_way;
                    cache_update_line_data <= l2_read_data;

                    cache_do_update_tag_and_valid <= 1'b1;

                    if (miss_is_store) begin
                        cache_update_dirty_bit <= 1'b1;
                    end
                    refill_complete <= 1'b1;
                end
            end
            endcase
        end
    end

    // 如果是 store_miss => refill 後要再做一次 store
    reg do_post_refill_store;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            do_post_refill_store <= 1'b0;
        end else begin
            if (state == REFILL_WAIT && next_state == IDLE && miss_is_store) begin
                do_post_refill_store <= 1'b1;
            end else begin
                do_post_refill_store <= 1'b0;
            end
        end
    end

    // 在 IDLE 狀態再做一次 store
    always @(posedge clk) begin
        if (do_post_refill_store) begin
            cache_do_store      <= 1'b1;
            cache_store_data_in <= store_data_in;
            cache_store_way     <= replace_way;
            cache_store_addr    <= miss_addr;
        end else begin
            cache_do_store <= 1'b0;
        end
    end

endmodule
