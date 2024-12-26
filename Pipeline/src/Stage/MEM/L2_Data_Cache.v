module L2_Data_Cache #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE  = 1024 * 1024, // 1MB
    parameter LINE_SIZE   = 64,
    parameter WAYS        = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   flush,

    // 從 L1 來的讀/寫要求 (這裡只示範單一匯流排介面)
    input  wire                   access_valid,   // L1 傳來的讀或寫請求
    input  wire [31:0]            access_addr,
    input  wire                   access_isStore, // 1=store,0=load
    input  wire [DATA_LENGTH-1:0] store_data_in,
    output reg  [DATA_LENGTH-1:0] load_data_out,
    output reg                    miss_detected,
    
    // 與 Memory 之間的 refill 介面
    input  wire                   mem_refill_valid,
    input  wire [DATA_LENGTH-1:0] mem_refill_data,
    output reg                    refill_complete,

    // Write-back 到 Memory
    output reg                    writeback_req,
    output reg [LINE_SIZE*8-1:0]  writeback_data,
    input  wire                   writeback_done
);

    // ----------------------------------------
    // 1) 參數計算
    // ----------------------------------------
    localparam SETS              = CACHE_SIZE / (LINE_SIZE * WAYS); 
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS    = $clog2(SETS);
    localparam TAG_BITS          = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE    = LINE_SIZE / (DATA_LENGTH/8);

    // ----------------------------------------
    // 2) 陣列宣告：Tag / Data / Valid / Dirty
    // ----------------------------------------
    reg [TAG_BITS-1:0]            tag_array   [0:SETS-1][0:WAYS-1];
    reg [DATA_LENGTH-1:0]         data_array  [0:SETS-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    reg                           valid_array [0:SETS-1][0:WAYS-1];
    reg                           dirty_array [0:SETS-1][0:WAYS-1];

    // LFSR 替換策略
    reg [$clog2(WAYS)-1:0] lfsr;
    reg [$clog2(WAYS)-1:0] replace_way;

    // ----------------------------------------
    // 3) 地址解析
    // ----------------------------------------
    wire [TAG_BITS-1:0]         in_tag   = access_addr[31 : 32 - TAG_BITS];
    wire [SET_INDEX_BITS-1:0]   in_index = access_addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    wire [BLOCK_OFFSET_BITS-1:2]in_word  = access_addr[BLOCK_OFFSET_BITS-1 : 2];

    // ----------------------------------------
    // 4) LFSR & Replace way
    // ----------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= {$clog2(WAYS){1'b1}};
        end else begin
            lfsr <= {lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            replace_way <= 0;
        end
        else if (refill_complete) begin
            replace_way <= lfsr;
        end
    end

    // ----------------------------------------
    // 5) Flush / Reset
    // ----------------------------------------
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

    // ----------------------------------------
    // 6) 命中檢查
    // ----------------------------------------
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

    // ----------------------------------------
    // 7) Load/Store 回傳資料 & Miss
    // ----------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            load_data_out <= {DATA_LENGTH{1'b0}};
            miss_detected <= 1'b0;
        end 
        else begin
            // 是否命中
            if (access_valid && !hit_internal) begin
                miss_detected <= 1'b1;  // load or store miss
            end else begin
                miss_detected <= 1'b0;
            end

            // 讀資料
            if (hit_internal && !access_isStore) begin
                load_data_out <= data_array[in_index][hit_way][in_word];
            end else if (!hit_internal) begin
                load_data_out <= {DATA_LENGTH{1'b0}};
            end
        end
    end

    // ----------------------------------------
    // 8) Write-back + Write-allocate store
    // ----------------------------------------
    // Store Hit: 直接寫入 data_array, dirty=1
    always @(posedge clk) begin
        if (!rst && access_valid && access_isStore && hit_internal) begin
            data_array[in_index][hit_way][in_word] <= store_data_in;
            dirty_array[in_index][hit_way]         <= 1'b1;
        end
    end

    // Store Miss: write-allocate (跟 L1 一樣，需要一個狀態機簡化示範)
    reg [DATA_LENGTH-1:0] pending_store_data;
    reg [31:0]            pending_store_addr;
    reg                   store_waiting;
    wire [SET_INDEX_BITS-1:0]   p_index = pending_store_addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];
    wire [BLOCK_OFFSET_BITS-1:2]p_word  = pending_store_addr[BLOCK_OFFSET_BITS-1 : 2];


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            store_waiting      <= 1'b0;
            pending_store_data <= {DATA_LENGTH{1'b0}};
            pending_store_addr <= 32'b0;
        end else begin
            if (access_valid && access_isStore && !hit_internal) begin
                store_waiting      <= 1'b1;
                pending_store_data <= store_data_in;
                pending_store_addr <= access_addr;
            end

            // refill 完畢後，把暫存的 store_data 寫入
            if (refill_complete && store_waiting) begin
                // 這裡簡化：假設填回來的就是我們要的 set/way
                // 從 pending_store_addr 解碼
                

                data_array[p_index][replace_way][p_word] <= pending_store_data;
                dirty_array[p_index][replace_way]        <= 1'b1;

                store_waiting <= 1'b0;
            end
        end
    end

    // ----------------------------------------
    // 9) Refill 流程
    // ----------------------------------------
    reg [5:0] refill_counter;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refill_counter  <= 0;
            refill_complete <= 0;
        end else begin
            if (mem_refill_valid) begin
                data_array[in_index][replace_way][refill_counter] <= mem_refill_data;
                tag_array[in_index][replace_way]                  <= in_tag;
                valid_array[in_index][replace_way]                <= 1'b1;

                if (refill_counter < WORDS_PER_LINE-1) begin
                    refill_counter  <= refill_counter + 1;
                    refill_complete <= 1'b0;
                end else begin
                    refill_counter  <= 0;
                    refill_complete <= 1'b1;
                end
            end else begin
                refill_complete <= 1'b0;
            end
        end
    end

    // ----------------------------------------
    // 10) Write-back 狀態機 (簡化示範)
    // ----------------------------------------
    reg [1:0] wb_state;
    localparam WB_IDLE  = 2'd0,
               WB_WRITE = 2'd1,
               WB_WAIT  = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_state       <= WB_IDLE;
            writeback_req  <= 1'b0;
            writeback_data <= {LINE_SIZE*8{1'b0}};
        end else begin
            case (wb_state)
                WB_IDLE: begin
                    // 偵測到要替換 set/way 時 (這裡簡化示範)
                    if (/* need to evict in_index, replace_way? */ 1'b0) begin
                        if (dirty_array[in_index][replace_way]) begin
                            // 打包 writeback_data
                            for (w=0; w<WORDS_PER_LINE; w=w+1) begin
                                writeback_data[ (w+1)*DATA_LENGTH-1 : w*DATA_LENGTH ]
                                    <= data_array[in_index][replace_way][w];
                            end
                            writeback_req <= 1'b1;
                            wb_state      <= WB_WRITE;
                        end else begin
                            // 不用 writeback
                            // ...
                        end
                    end
                end

                WB_WRITE: begin
                    if (writeback_done) begin
                        writeback_req                         <= 1'b0;
                        dirty_array[in_index][replace_way]    <= 1'b0;
                        wb_state                              <= WB_WAIT;
                    end
                end

                WB_WAIT: begin
                    wb_state <= WB_IDLE;
                end
            endcase
        end
    end

endmodule
