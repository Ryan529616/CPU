module L3_Data_Cache_Controller #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 8 * 1024 * 1024,
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    //------------------------------------------------
    // 與上層 (L2/CPU) 溝通
    //------------------------------------------------
    input  wire                   load_valid,
    input  wire [31:0]           load_addr,
    output reg  [DATA_LENGTH-1:0]load_data_out,
    output reg                   load_miss_detected,

    input  wire                  store_valid,
    input  wire [31:0]           store_addr,
    input  wire [DATA_LENGTH-1:0]store_data_in,
    output reg                   store_miss_detected,

    //------------------------------------------------
    // 與 AXI Master介面
    //------------------------------------------------
    // AW
    output reg                   axi_awvalid,
    input  wire                  axi_awready,
    output reg [31:0]           axi_awaddr,
    // (可加 awid, awsize, awburst, 省略)
    // W
    output reg                   axi_wvalid,
    input  wire                  axi_wready,
    output reg [LINE_SIZE*8-1:0] axi_wdata,
    output wire [LINE_SIZE-1:0]  axi_wstrb,
    output wire                  axi_wlast,
    // B
    input  wire                  axi_bvalid,
    output reg                   axi_bready,

    // AR
    output reg                   axi_arvalid,
    input  wire                  axi_arready,
    output reg [31:0]            axi_araddr,
    // R
    input  wire                  axi_rvalid,
    output reg                   axi_rready,
    input  wire [LINE_SIZE*8-1:0]axi_rdata,
    // (rlast, ...省略)

    output reg                   refill_complete,

    //------------------------------------------------
    // 與 L3_Cache 連線
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

    // -------------------------------------------------------
    // [1] Basic parameter calculation
    // -------------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;

    // -------------------------------------------------------
    // [2] Query to L3_Cache
    // -------------------------------------------------------
    assign cache_query_valid = (load_valid || store_valid);
    assign cache_query_addr  = (load_valid) ? load_addr : store_addr;

    reg load_hit_r, store_hit_r;
    always @(*) begin
        load_hit_r  = (load_valid  && cache_query_hit);
        store_hit_r = (store_valid && cache_query_hit);
    end

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_data_out <= 0;
        end else if (load_hit_r) begin
            load_data_out <= cache_query_data_out;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_miss_detected  <= 0;
            store_miss_detected <= 0;
        end else begin
            load_miss_detected  <= (load_valid  && !cache_query_hit);
            store_miss_detected <= (store_valid && !cache_query_hit);
        end
    end

    // -------------------------------------------------------
    // [3] Store Hit => do_store
    // -------------------------------------------------------
    always @(*) begin
        cache_do_store       = 1'b0;
        cache_store_data_in  = store_data_in;
        cache_store_way      = cache_query_hit_way;
        cache_store_addr     = store_addr;
        if (store_hit_r) begin
            cache_do_store = 1'b1;
        end
    end

    // -------------------------------------------------------
    // [4] State Machine for Miss Flow
    // -------------------------------------------------------
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

    reg miss_is_store;
    reg [31:0] miss_addr;
    reg [$clog2(WAYS)-1:0] replace_way;

    reg [31:0] victim_tag;
    reg        victim_dirty;
    reg [LINE_SIZE*8-1:0] victim_line_data;

    // LFSR for replacement way
    reg [$clog2(WAYS)-1:0] lfsr;
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= {$clog2(WAYS){1'b1}};
        else
            lfsr <= {lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
    end

    // next_state logic
    always @(*) begin
        next_state = state;
        case(state)
        IDLE: begin
            if (load_miss_detected || store_miss_detected) begin
                next_state = CHECK;
            end
        end
        CHECK: begin
            // read victim line
            next_state = (cache_victim_dirty_out) ? WB : REFILL;
        end
        WB: begin
            // do AXI AW+W handshake
            if (axi_awready && axi_wready) next_state = WB_WAIT;
        end
        WB_WAIT: begin
            // wait B
            if (axi_bvalid) next_state = REFILL;
        end
        REFILL: begin
            // do AXI AR handshake
            if (axi_arready) next_state = REFILL_WAIT;
        end
        REFILL_WAIT: begin
            // wait R
            if (axi_rvalid) next_state = IDLE;
        end
        default: next_state = IDLE;
        endcase
    end

    // rec param
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            miss_is_store <= 0;
            miss_addr     <= 0;
            replace_way   <= 0;
        end else if (state==IDLE) begin
            if (load_miss_detected) begin
                miss_is_store <= 0;
                miss_addr     <= load_addr;
                replace_way   <= lfsr;
            end
            else if (store_miss_detected) begin
                miss_is_store <= 1;
                miss_addr     <= store_addr;
                replace_way   <= lfsr;
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
        if (state==CHECK) begin
            victim_tag       <= cache_victim_tag_out;
            victim_dirty     <= cache_victim_dirty_out;
            victim_line_data <= cache_victim_line_data_out;
        end
    end

    // -------------------------------------------------------
    // [5] AXI handshake (WB / Refill)
    // -------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_awvalid <= 0;
            axi_wvalid  <= 0;
            axi_awaddr  <= 0;
            axi_wdata   <= 0;

            axi_bready  <= 0;

            axi_arvalid <= 0;
            axi_araddr  <= 0;
            axi_rready  <= 0;
        end else begin
            // default
            axi_awvalid <= 0;
            axi_wvalid  <= 0;
            axi_bready  <= 1;  // always ready to get B

            axi_arvalid <= 0;
            axi_rready  <= 1;  // always ready to get R

            case(state)
            WB: begin
                // do AW+W
                if (!axi_awready || !axi_wready) begin
                    axi_awvalid <= 1;
                    axi_awaddr  <= { victim_tag[TAG_BITS-1:0], get_index(miss_addr), {BLOCK_OFFSET_BITS{1'b0}} };
                    axi_wvalid  <= 1;
                    axi_wdata   <= victim_line_data;
                end
            end
            WB_WAIT: begin
                // wait B => do nothing special
            end
            REFILL: begin
                // do AR
                if (!axi_arready) begin
                    axi_arvalid <= 1;
                    axi_araddr  <= { miss_addr[31:BLOCK_OFFSET_BITS], {BLOCK_OFFSET_BITS{1'b0}} };
                end
            end
            REFILL_WAIT: begin
                // wait R => do nothing
            end
            endcase
        end
    end

    assign axi_wlast = 1'b1;
    assign axi_wstrb = {LINE_SIZE{1'b1}};

    // -------------------------------------------------------
    // [6] refill_complete & cache update
    // -------------------------------------------------------
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
                if (axi_bvalid) begin
                    // writeback done => clear dirty
                    cache_do_clear_dirty <= 1;
                    cache_update_addr    <= miss_addr;
                    cache_update_way     <= replace_way;
                end
            end
            REFILL_WAIT: begin
                if (axi_rvalid) begin
                    // refill
                    cache_do_update_line          <= 1;
                    cache_update_addr             <= miss_addr;
                    cache_update_way              <= replace_way;
                    cache_update_line_data        <= axi_rdata;
                    cache_do_update_tag_and_valid <= 1;

                    if (miss_is_store) begin
                        cache_update_dirty_bit <= 1;
                    end

                    refill_complete <= 1;
                end
            end
            endcase
        end
    end

    // store miss => post_refill_store
    reg do_post_refill_store;
    always @(posedge clk or posedge rst) begin
        if (rst) do_post_refill_store <= 0;
        else begin
            if (state==REFILL_WAIT && next_state==IDLE && miss_is_store)
                do_post_refill_store <= 1;
            else
                do_post_refill_store <= 0;
        end
    end

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
