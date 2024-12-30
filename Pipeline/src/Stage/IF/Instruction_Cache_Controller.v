module Instruction_Cache_Controller #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 32 * 1024, // 32KB
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 8
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    //------------------------------------------------
    // 與 CPU 溝通 (只示範指令讀取)
    //------------------------------------------------
    input  wire                   icache_valid,     // CPU 要求讀取指令
    input  wire [31:0]            icache_addr,
    output reg  [DATA_LENGTH-1:0] icache_data_out,
    output reg                    icache_miss_detected,

    //------------------------------------------------
    // 與 AXI 或下層 Memory 介面
    //------------------------------------------------
    output reg                    mem_req,
    output reg                    mem_we,      // 1=write, 0=read
    output reg  [31:0]            mem_addr,
    output reg  [LINE_SIZE*8-1:0] mem_write_data,
    input  wire [LINE_SIZE*8-1:0] mem_read_data,
    input  wire                   mem_data_valid,
    input  wire                   mem_ready,
    output reg                    refill_complete,

    //------------------------------------------------
    // 與 iCache 連線
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
    output reg [31:0]            cache_victim_addr,
    input  wire [31:0]           cache_victim_tag_out,
    input  wire                  cache_victim_dirty_out,
    input  wire [LINE_SIZE*8-1:0]cache_victim_line_data_out
);

    //------------------------------------------------
    // 參數
    //------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;

    //------------------------------------------------
    // 1) 查詢介面
    //------------------------------------------------
    assign cache_query_valid = icache_valid;  // 只讀
    assign cache_query_addr  = icache_addr;

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            icache_data_out     <= 0;
        end else if (icache_valid && cache_query_hit) begin
            icache_data_out <= cache_query_data_out;
        end
    end

    // miss_detected
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            icache_miss_detected <= 0;
        end else begin
            icache_miss_detected <= (icache_valid && !cache_query_hit);
        end
    end

    //------------------------------------------------
    // 2) Store動作 (iCache通常不需要，但保留)
    //------------------------------------------------
    always @(*) begin
        cache_do_store       = 1'b0;
        cache_store_data_in  = 0;
        cache_store_way      = cache_query_hit_way;
        cache_store_addr     = icache_addr;
    end
    //------------------------------------------------
    // 3) State Machine
    //------------------------------------------------
    localparam IDLE    = 3'd0;
    localparam CHECK   = 3'd1;
    localparam WB      = 3'd2;
    localparam WB_WAIT = 3'd3;
    localparam REFILL  = 3'd4;
    localparam REFILL_WAIT = 3'd5;

    reg [2:0] state, next_state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    reg miss_is_load;  
    reg [31:0] miss_addr;
    reg [$clog2(WAYS)-1:0] replace_way;

    // LFSR
    reg [$clog2(WAYS)-1:0] lfsr;
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= {$clog2(WAYS){1'b1}};
        else
            lfsr <= {lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
    end

    // next_state
    always @(*) begin
        next_state = state;
        case(state)
        IDLE: begin
            if (icache_miss_detected) next_state = CHECK;
        end
        CHECK: begin
            // read victim line
            // if dirty => wb
            next_state = (cache_victim_dirty_out)? WB : REFILL;
        end
        WB: begin
            if (mem_ready) next_state = WB_WAIT;
        end
        WB_WAIT: begin
            if (mem_data_valid) next_state = REFILL;
        end
        REFILL: begin
            if (mem_ready) next_state = REFILL_WAIT;
        end
        REFILL_WAIT: begin
            if (mem_data_valid) next_state = IDLE;
        end
        endcase
    end

    // 在 IDLE->CHECK：記錄 miss_addr
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            miss_is_load <= 0;
            miss_addr    <= 32'h0;
            replace_way  <= 0;
        end else if (state==IDLE) begin
            if (icache_miss_detected) begin
                miss_is_load <= 1'b1;  // iCache 只讀
                miss_addr    <= icache_addr;
                replace_way  <= lfsr;
            end
        end
    end

    // victim
    function [SET_INDEX_BITS-1:0] get_index(input [31:0] addr);
        get_index = addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    endfunction

    always @(posedge clk) begin
        if (state==CHECK) begin
            cache_victim_way  <= replace_way;
            cache_victim_addr <= miss_addr;
        end
    end

    reg [31:0] victim_tag;
    reg        victim_dirty;
    reg [LINE_SIZE*8-1:0] victim_line_data;
    always @(posedge clk) begin
        if (state==CHECK) begin
            victim_tag       <= cache_victim_tag_out;
            victim_dirty     <= cache_victim_dirty_out;
            victim_line_data <= cache_victim_line_data_out;
        end
    end

    //------------------------------------------------
    // 4) 與 Memory/AXI 介面
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_req        <= 0;
            mem_we         <= 0;
            mem_addr       <= 0;
            mem_write_data <= 0;
        end else begin
            case(state)
            CHECK: begin
                mem_req <= 0;
            end
            WB: begin
                if (mem_ready) begin
                    mem_req <= 1;
                    mem_we  <= 1; // write
                    mem_addr <= {victim_tag[TAG_BITS-1:0], get_index(miss_addr), {BLOCK_OFFSET_BITS{1'b0}}};
                    mem_write_data <= victim_line_data;
                end else begin
                    mem_req <= 0;
                end
            end
            WB_WAIT: begin
                mem_req <= 0;
            end
            REFILL: begin
                if (mem_ready) begin
                    mem_req <= 1;
                    mem_we  <= 0; // read
                    mem_addr <= {miss_addr[31:BLOCK_OFFSET_BITS], {BLOCK_OFFSET_BITS{1'b0}}};
                end else begin
                    mem_req <= 0;
                end
            end
            REFILL_WAIT: begin
                mem_req <= 0;
            end
            default: mem_req <= 0;
            endcase
        end
    end

    //------------------------------------------------
    // 5) refill_complete + cache update
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refill_complete               <= 0;
            cache_do_update_line          <= 0;
            cache_do_update_tag_and_valid <= 0;
            cache_do_clear_dirty          <= 0;
            cache_update_dirty_bit        <= 0;
        end else begin
            refill_complete               <= 0;
            cache_do_update_line          <= 0;
            cache_do_update_tag_and_valid <= 0;
            cache_do_clear_dirty          <= 0;
            cache_update_dirty_bit        <= 0;

            case(state)
            WB_WAIT: begin
                if (mem_data_valid) begin
                    // writeback done => clear dirty
                    cache_do_clear_dirty <= 1;
                    cache_update_addr    <= miss_addr;
                    cache_update_way     <= replace_way;
                end
            end
            REFILL_WAIT: begin
                if (mem_data_valid) begin
                    // Refill
                    cache_do_update_line   <= 1;
                    cache_update_addr      <= miss_addr;
                    cache_update_way       <= replace_way;
                    cache_update_line_data <= mem_read_data;

                    cache_do_update_tag_and_valid <= 1;

                    // iCache通常不寫 => dirty_bit=0
                    // 若想支援 self-modifying code，可以在 miss_is_store 之類
                    // 這裡就簡化
                    refill_complete <= 1;
                end
            end
            endcase
        end
    end

endmodule
