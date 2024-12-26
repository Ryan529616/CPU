module L3_Data_Cache #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 32 * 1024 * 1024,  // 預設 32MB
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    // -----------------------------
    // 與 L2 / (或單一核心直接) 的存取介面
    // -----------------------------
    input  wire                   access_valid,    // 表示有存取要求
    input  wire [31:0]            access_addr,
    input  wire                   access_isStore,  // 1=store, 0=load
    input  wire [DATA_LENGTH-1:0] store_data_in,
    output reg  [DATA_LENGTH-1:0] load_data_out,
    output reg                    miss_detected,

    // ---------------------------------------
    // AXI3 介面（簡化示範）
    // 只寫最基本信號，不包含 burst / size / ID ...
    // ---------------------------------------
    // Read Address
    output reg  [31:0] axi_araddr,
    output reg         axi_arvalid,
    input  wire        axi_arready,

    // Read Data
    input  wire [DATA_LENGTH-1:0] axi_rdata,
    input  wire                   axi_rvalid,
    output reg                    axi_rready,

    // Write Address
    output reg  [31:0] axi_awaddr,
    output reg         axi_awvalid,
    input  wire        axi_awready,

    // Write Data
    output reg  [DATA_LENGTH-1:0] axi_wdata,
    output reg                    axi_wvalid,
    input  wire                   axi_wready,

    // Write Response
    input  wire                   axi_bvalid,
    output reg                    axi_bready
);

    // ------------------------------------------------------
    // 1) 基本計算
    // ------------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE    = LINE_SIZE / (DATA_LENGTH/8);

    // ------------------------------------------------------
    // 2) Cache 結構 (Tag / Data / Valid / Dirty) - 簡化
    // ------------------------------------------------------
    reg [TAG_BITS-1:0]               tag_array   [0:SETS-1][0:WAYS-1];
    reg [DATA_LENGTH-1:0]            data_array  [0:SETS-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    reg                              valid_array [0:SETS-1][0:WAYS-1];
    reg                              dirty_array [0:SETS-1][0:WAYS-1];

    // ------------------------------------------------------
    // 3) Address decode
    // ------------------------------------------------------
    wire [TAG_BITS-1:0]         in_tag   = access_addr[31 : 32 - TAG_BITS];
    wire [SET_INDEX_BITS-1:0]   in_index = access_addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    wire [BLOCK_OFFSET_BITS-1:2]in_word  = access_addr[BLOCK_OFFSET_BITS-1 : 2];

    // ------------------------------------------------------
    // 4) LFSR Replace Way (簡化)
    // ------------------------------------------------------
    reg [$clog2(WAYS)-1:0] lfsr;
    reg [$clog2(WAYS)-1:0] replace_way;

    integer i,j,w;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= {$clog2(WAYS){1'b1}};
        end else begin
            lfsr <= { lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2] };
        end
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            replace_way <= 0;
        end
    end

    // ------------------------------------------------------
    // 5) Flush/Reset
    // ------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] <= 1'b0;
                    dirty_array[i][j] <= 1'b0;
                end
            end
        end
    end

    // ------------------------------------------------------
    // 6) 命中檢查
    // ------------------------------------------------------
    reg hit_internal;
    reg [$clog2(WAYS)-1:0] hit_way;

    always @(*) begin
        hit_internal = 1'b0;
        hit_way      = 0;
        if (access_valid) begin
            for (j = 0; j < WAYS; j = j + 1) begin
                if ( valid_array[in_index][j] &&
                     (tag_array[in_index][j] == in_tag) ) begin
                    hit_internal = 1'b1;
                    hit_way      = j;
                end
            end
        end
    end

    // ------------------------------------------------------
    // 7) 讀出資料、Miss
    // ------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            load_data_out <= 0;
            miss_detected <= 0;
        end else begin
            if (access_valid && !hit_internal) begin
                miss_detected <= 1;
            end else begin
                miss_detected <= 0;
            end
            if (hit_internal && !access_isStore) begin
                load_data_out <= data_array[in_index][hit_way][in_word];
            end
        end
    end

    // ------------------------------------------------------
    // 8) Store (write-back + write-allocate) - 簡化
    // ------------------------------------------------------
    // Store Hit
    always @(posedge clk) begin
        if (!rst && access_valid && access_isStore && hit_internal) begin
            data_array[in_index][hit_way][in_word] <= store_data_in;
            dirty_array[in_index][hit_way]         <= 1'b1;
        end
    end

    // （Store Miss 的 refill / write-allocate + AXI3 讀寫機制 => 見後面的FSM示範）

    // ------------------------------------------------------
    // 9) AXI3 讀寫狀態機 (簡化示範)
    // ------------------------------------------------------
    // 說明：
    //  - 当 miss 時，需要向外發起 AXI 讀請求 (AR) → 收到 R 資料 → 寫到 data_array
    //  - 当 dirty eviction 時，需要向外發起 AXI 寫請求 (AW) + 寫資料 (W) → 等 B
    // 為了簡化，我們只示範 read miss refill。
    // 若要做 write-back eviction，需要再擴充 AW/W/B 流程。

    localparam IDLE = 3'd0, READ_REQ = 3'd1, READ_DATA = 3'd2, REFILL_DONE = 3'd3;
    reg [2:0] state, next_state;

    reg [5:0] refill_count;
    reg [31:0] saved_addr; // 暫存

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            refill_count    <= 0;
            saved_addr      <= 0;

            // AXI預設
            axi_araddr      <= 32'b0;
            axi_arvalid     <= 1'b0;
            axi_rready      <= 1'b0;
            axi_awaddr      <= 32'b0;
            axi_awvalid     <= 1'b0;
            axi_wdata       <= 32'b0;
            axi_wvalid      <= 1'b0;
            axi_bready      <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (access_valid && !hit_internal) begin
                        // 啟動 read request
                        saved_addr  <= access_addr;
                        axi_araddr  <= {access_addr[31: BLOCK_OFFSET_BITS], {BLOCK_OFFSET_BITS{1'b0}}};
                        axi_arvalid <= 1'b1;
                    end else begin
                        axi_arvalid <= 1'b0;
                    end
                    refill_count <= 0;
                    axi_rready   <= 1'b0;
                end

                READ_REQ: begin
                    if (axi_arready) begin
                        // 下層準備好接 AR, 進入讀資料階段
                        axi_arvalid <= 1'b0;
                        axi_rready  <= 1'b1; 
                    end
                end

                READ_DATA: begin
                    // 連續讀 WORDS_PER_LINE 個資料 (簡化：一次回傳一 word)
                    // axi_rvalid=1 時表示下層送來一筆資料
                    if (axi_rvalid) begin
                        // 寫入 data_array
                        data_array[in_index][replace_way][refill_count] <= axi_rdata;
                        tag_array[in_index][replace_way]                <= in_tag;
                        valid_array[in_index][replace_way]              <= 1'b1;

                        if (refill_count < WORDS_PER_LINE-1) begin
                            refill_count <= refill_count + 1;
                        end else begin
                            refill_count <= 0;
                        end
                    end
                end

                REFILL_DONE: begin
                    // 結束 refill
                    axi_rready <= 1'b0;
                end
            endcase
        end
    end

    // Next State
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // miss -> go READ_REQ
                if (access_valid && !hit_internal) next_state = READ_REQ;
            end
            READ_REQ: begin
                if (axi_arready) next_state = READ_DATA;
            end
            READ_DATA: begin
                if (refill_count == WORDS_PER_LINE-1 && axi_rvalid) begin
                    next_state = REFILL_DONE;
                end
            end
            REFILL_DONE: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
