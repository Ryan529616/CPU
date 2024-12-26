module L1_Data_Cache #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 48 * 1024,
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 12
) (
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    //------------------------------------------------
    // 與 CPU 溝通的介面
    //------------------------------------------------
    // 讀取(Load)介面
    input  wire                   load_valid,          // 是否要讀取
    input  wire            [31:0] load_addr,
    output reg  [DATA_LENGTH-1:0] load_data_out,
    output reg                    load_miss_detected,
    
    // 寫入(Store)介面
    input  wire                   store_valid,         // 是否要寫入
    input  wire            [31:0] store_addr,
    input  wire [DATA_LENGTH-1:0] store_data_in,
    output reg                    store_miss_detected,

    //------------------------------------------------
    // 與 L2 (或 Memory) 溝通的介面
    //------------------------------------------------
    output reg                    l2_req,        // L2 request (讀或寫)
    output reg                    l2_we,         // 1=write, 0=read
    output reg            [31:0]  l2_addr,       // L2存取的位址
    output reg  [LINE_SIZE*8-1:0] l2_write_data, // 如果是write，整個cache line打包送
    input  wire [LINE_SIZE*8-1:0] l2_read_data,  // 如果是read，整個cache line回傳
    input  wire                   l2_data_valid, // L2回傳資料有效
    input  wire                   l2_ready,      // L2可以接受 request

    //------------------------------------------------
    // 其他
    //------------------------------------------------
    output reg                    refill_complete  // 用來示範 refill 是否結束
);

    //------------------------------------------------
    // 1) 基本參數計算
    //------------------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE    = LINE_SIZE / (DATA_LENGTH/8);

    //------------------------------------------------
    // 2) Cache 結構宣告：Tag / Data / Valid / Dirty
    //------------------------------------------------
    reg [TAG_BITS-1:0]               tag_array   [0:SETS-1][0:WAYS-1];
    reg [DATA_LENGTH-1:0]            data_array  [0:SETS-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    reg                              valid_array [0:SETS-1][0:WAYS-1];
    reg                              dirty_array [0:SETS-1][0:WAYS-1];

    // 替換策略：使用 LFSR 來決定替換哪個 way
    reg [$clog2(WAYS)-1:0] lfsr;
    reg [$clog2(WAYS)-1:0] replace_way;

    //------------------------------------------------
    // 3) 地址解析
    //------------------------------------------------
    // load
    wire [TAG_BITS-1:0]         load_tag   = load_addr[31 : 32 - TAG_BITS];
    wire [SET_INDEX_BITS-1:0]   load_index = load_addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    wire [BLOCK_OFFSET_BITS-1:2]load_word  = load_addr[BLOCK_OFFSET_BITS-1 : 2];

    // store
    wire [TAG_BITS-1:0]         store_tag   = store_addr[31 : 32 - TAG_BITS];
    wire [SET_INDEX_BITS-1:0]   store_index = store_addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    wire [BLOCK_OFFSET_BITS-1:2]store_word  = store_addr[BLOCK_OFFSET_BITS-1 : 2];

    //------------------------------------------------
    // 4) LFSR for Replacement Way
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 例如初始化全1
            lfsr <= {$clog2(WAYS){1'b1}};
        end else begin
            // LFSR: 簡易 shift xor
            lfsr <= {lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            replace_way <= 0;
        end
        else if (!load_hit_internal) begin
            // 這裡只是示範，你應該在「miss被偵測、要替換line」時才去更新 replace_way
            replace_way <= lfsr;
        end
    end

    //------------------------------------------------
    // 5) Flush / Reset
    //------------------------------------------------
    integer i, j, w;
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j]  <= 1'b0;
                    dirty_array[i][j]  <= 1'b0;
                end
            end
        end
    end

    //------------------------------------------------
    // 6) Load(讀取) - 命中檢查
    //------------------------------------------------
    reg load_hit_internal;
    reg [$clog2(WAYS)-1:0] load_hit_way;

    always @(*) begin
        load_hit_internal = 1'b0;
        load_hit_way      = 0;
        if (load_valid) begin
            for (j = 0; j < WAYS; j = j + 1) begin
                if ( valid_array[load_index][j] &&
                     (tag_array[load_index][j] == load_tag) ) begin
                    load_hit_internal = 1'b1;
                    load_hit_way      = j;
                end
            end
        end
    end

    // Load 資料輸出
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_data_out <= {DATA_LENGTH{1'b0}};
        end else if (load_hit_internal) begin
            load_data_out <= data_array[load_index][load_hit_way][load_word];
        end else begin
            load_data_out <= {DATA_LENGTH{1'b0}};
        end
    end

    // Load Miss Detect
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_miss_detected <= 1'b0;
        end else if (load_valid && !load_hit_internal) begin
            load_miss_detected <= 1'b1;
        end else begin
            load_miss_detected <= 1'b0;
        end
    end

    //------------------------------------------------
    // 7) Store(寫入) - 命中檢查
    //------------------------------------------------
    reg store_hit_internal;
    reg [$clog2(WAYS)-1:0] store_hit_way;

    always @(*) begin
        store_hit_internal = 1'b0;
        store_hit_way      = 0;
        if (store_valid) begin
            for (j = 0; j < WAYS; j = j + 1) begin
                if ( valid_array[store_index][j] &&
                     (tag_array[store_index][j] == store_tag) ) begin
                    store_hit_internal = 1'b1;
                    store_hit_way      = j;
                end
            end
        end
    end

    // Store Miss Detect
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            store_miss_detected <= 1'b0;
        end else if (store_valid && !store_hit_internal) begin
            store_miss_detected <= 1'b1;
        end else begin
            store_miss_detected <= 1'b0;
        end
    end

    // (A) Store Hit: 直接寫入 L1 cache，dirty bit = 1
    always @(posedge clk) begin
        if (!rst && store_valid && store_hit_internal) begin
            data_array[store_index][store_hit_way][store_word] <= store_data_in;
            dirty_array[store_index][store_hit_way]            <= 1'b1;
        end
    end

    //------------------------------------------------
    // 8) 狀態機：處理 load/store miss
    //------------------------------------------------
    // 簡易的示範流程：
    //   IDLE 狀態檢查有沒有 miss：
    //      -> 若有 miss，檢查要替換的 line是否 dirty？
    //         -> 若 dirty 需要 writeback -> 進 WB state
    //         -> 否則 直接進 REFILL state
    //   REFILL 狀態：
    //      -> 下 L2 讀請求 (l2_req=1, l2_we=0, addr=???)
    //      -> 等 l2_data_valid=1 收到整個 cache line
    //      -> 寫入 data_array
    //      -> 回到 IDLE
    //   WB 狀態：
    //      -> 下 L2 寫請求 (l2_req=1, l2_we=1,...)
    //      -> 等 l2_data_valid / or l2_ready / or write complete
    //      -> dirty=0
    //      -> 進 REFILL
    //
    // 你可以視系統bus規格做更完整的 handshaking / burst
    //------------------------------------------------

    localparam IDLE    = 3'd0;
    localparam CHECK   = 3'd1;
    localparam WB      = 3'd2;
    localparam WB_WAIT = 3'd3;
    localparam REFILL  = 3'd4;
    localparam REFILL_WAIT = 3'd5;

    reg [2:0] state, next_state;

    // 先把「誰 miss」的訊息暫存，因為可能是 load miss 或 store miss
    reg        miss_is_store;   
    reg [31:0] miss_addr;
    reg [SET_INDEX_BITS-1:0] miss_index;
    reg [TAG_BITS-1:0]       miss_tag;

    // 在這個例子裡，假設一次只能處理一個 miss
    // 亦即若 load, store 同時 valid 會怎麼辦？還有 pipeline issue？
    // 這裡先不深究，只示範「有miss就做」的骨架

    // state register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // next_state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // 若發生 load miss 或 store miss，就進CHECK
                if (load_miss_detected || store_miss_detected) begin
                    next_state = CHECK;
                end
            end
            CHECK: begin
                // 決定要不要 writeback
                // (這裡只示範：檢查 dirty_array[miss_index][replace_way]，若 dirty=1 -> WB，否則->REFILL)
                // 但真正要替換的 way 應該根據 LRU 或 lfsr 等機制
                // 這裡直接用 replace_way 取代
                next_state = (dirty_array[miss_index][replace_way]) ? WB : REFILL;
            end
            WB: begin
                // 在 WB 狀態發 writeback_req 給 L2
                // 這裡簡化為：只要 L2可以接受(l2_ready=1) 就送 request
                // 然後進 WB_WAIT
                if (l2_ready) begin
                    next_state = WB_WAIT;
                end
            end
            WB_WAIT: begin
                // 等 L2 處理完寫回(可能依系統不同)
                // 這裡假設 l2_data_valid 表示"L2處理完寫回"（實際系統多半不一定如此）
                if (l2_data_valid) begin
                    next_state = REFILL;
                end
            end
            REFILL: begin
                // 與 WB 類似，若 L2 ready，發起 read request
                if (l2_ready) begin
                    next_state = REFILL_WAIT;
                end
            end
            REFILL_WAIT: begin
                // 等 L2 把整個 line 傳回來 (l2_data_valid=1)
                if (l2_data_valid) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // 在 CHECK state 會把「miss資訊」鎖進暫存
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            miss_is_store <= 1'b0;
            miss_addr     <= 32'b0;
            miss_index    <= {SET_INDEX_BITS{1'b0}};
            miss_tag      <= {TAG_BITS{1'b0}};
        end else if (state == IDLE) begin
            if (load_miss_detected) begin
                miss_is_store <= 1'b0;
                miss_addr     <= load_addr;
                miss_index    <= load_index;
                miss_tag      <= load_tag;
                // 這裡應該也要決定 replace_way
            end else if (store_miss_detected) begin
                miss_is_store <= 1'b1;
                miss_addr     <= store_addr;
                miss_index    <= store_index;
                miss_tag      <= store_tag;
                // 這裡也要決定 replace_way
            end
        end
    end

    //------------------------------------------------
    // 9) 在 WB 狀態，組合要寫回 L2 的資料
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l2_req         <= 1'b0;
            l2_we          <= 1'b0;
            l2_addr        <= 32'b0;
            l2_write_data  <= 0;
        end else begin
            case (state)
                CHECK: begin
                    // 準備要不要 WB
                    l2_req        <= 1'b0; // 還沒下request
                    l2_we         <= 1'b0;
                end
                WB: begin
                    if (l2_ready) begin
                        l2_req    <= 1'b1;   // 發request
                        l2_we     <= 1'b1;   // write
                        // l2_addr 要根據被替換的 line 的 tag + index
                        // 這裡簡化 => 把 miss_index, miss_tag 直接當成是要寫回的(實際應該記錄"舊"的tag, not miss_tag)
                        // 你需要再做一個「victim_tag」暫存
                        l2_addr   <= { miss_tag, miss_index, {BLOCK_OFFSET_BITS{1'b0}}};
                        
                        // 把整個 line 打包到 l2_write_data
                        for (w=0; w<WORDS_PER_LINE; w=w+1) begin
                            l2_write_data[ (w+1)*DATA_LENGTH-1 : w*DATA_LENGTH]
                                <= data_array[miss_index][replace_way][w];
                        end
                    end else begin
                        l2_req <= 1'b0; // L2還沒ready就不送
                    end
                end
                WB_WAIT: begin
                    l2_req <= 1'b0;   // 維持，或看系統需求
                    // 如果 L2寫回完成 -> dirty=0
                    if (l2_data_valid) begin
                        dirty_array[miss_index][replace_way] <= 1'b0;
                    end
                end
                REFILL: begin
                    // 等待 L2 ready 後，對 L2 發 read request
                    if (l2_ready) begin
                        l2_req <= 1'b1;
                        l2_we  <= 1'b0; // read
                        l2_addr <= { miss_tag, miss_index, {BLOCK_OFFSET_BITS{1'b0}}};
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
    // 10) 在 REFILL_WAIT 狀態：收到 l2_data_valid=1，寫回 data_array
    //------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refill_complete <= 1'b0;
        end else begin
            refill_complete <= 1'b0;
            if (state == REFILL_WAIT && l2_data_valid) begin
                // 把 l2_read_data 逐字寫入
                integer wref;
                for (wref=0; wref<WORDS_PER_LINE; wref=wref+1) begin
                    data_array[miss_index][replace_way][wref]
                        <= l2_read_data[(wref+1)*DATA_LENGTH-1 : wref*DATA_LENGTH];
                end
                // 設置 tag, valid=1
                tag_array[miss_index][replace_way]   <= miss_tag;
                valid_array[miss_index][replace_way] <= 1'b1;
                
                // 如果這次是 store miss，記得把對應的 word寫進來 + dirty=1
                if (miss_is_store) begin
                    // 這裡假設 store_data_in 你要另外暫存起來
                    // 下面只是示範
                    // store_data_in -> 你可能要在 state=IDLE 就抓起來 pending
                    // 這裡先簡化：直接寫
                    data_array[miss_index][replace_way][ miss_addr[BLOCK_OFFSET_BITS-1:2] ]
                        <= store_data_in;
                    dirty_array[miss_index][replace_way] <= 1'b1;
                end

                refill_complete <= 1'b1; 
            end
        end
    end

endmodule
