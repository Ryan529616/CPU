module Instruction_cache #(
    parameter DATA_LENGTH = 32,        // 指令長度
    parameter CACHE_SIZE = 32 * 1024,  // 總大小 32 KB
    parameter LINE_SIZE = 32,          // 每行大小 32 Bytes
    parameter WAYS = 8                 // 8 路相連
) (
    input wire clk,
    input wire rst,
    
    // 與 CPU 的接口
    input wire [31:0] addr,            // CPU 發出的地址
    input wire fetch_req,              // 指令請求信號
    output reg [DATA_LENGTH-1:0] data_out, // 返回給 CPU 的數據
    output reg hit,                    // 命中信號

    // AXI3 接口信號
    output reg [31:0] ARADDR,          // AXI 讀取地址
    output reg ARVALID,                // 地址有效
    input wire ARREADY,                // 地址已被接受
    input wire [DATA_LENGTH-1:0] RDATA,// AXI 返回的數據
    input wire RVALID,                 // 數據有效
    output reg RREADY                  // 準備接收數據
);

    // Cache 設計參數
    localparam SETS = CACHE_SIZE / (LINE_SIZE * WAYS);             // 組數
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);              // 偏移位數
    localparam SET_INDEX_BITS = $clog2(SETS);                      // 組索引位數
    localparam TAG_BITS = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS; // 標籤位數

    // 狀態機定義
    localparam CHECK_HIT = 2'b00; // 檢查命中
    localparam MISS      = 2'b01; // 發送 AXI 請求
    localparam REFILL    = 2'b10; // 填充數據

    reg [1:0] state, next_state;

    // Cache 結構
    reg [TAG_BITS-1:0] tag_array [0:SETS-1][0:WAYS-1];      // 標籤存儲
    reg [DATA_LENGTH-1:0] data_array [0:SETS-1][0:WAYS-1];            // 數據存儲
    reg valid_array [0:SETS-1][0:WAYS-1];                   // 有效位存儲

    // 地址分解
    wire [TAG_BITS-1:0] tag_in;
    wire [SET_INDEX_BITS-1:0] set_index;

    assign tag_in = addr[31:32-TAG_BITS];
    assign set_index = addr[32-TAG_BITS-1:BLOCK_OFFSET_BITS];

    // 替換策略
    reg [$clog2(WAYS)-1:0] replace_way;

    integer i, j;

    // 初始化 Cache
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            replace_way = {$clog2(WAYS){1'b0}};
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] = 1'b0;
                end
            end
        end
    end

    // 狀態機：狀態轉移邏輯
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= CHECK_HIT;
        end else begin
            state <= next_state;
        end
    end

    // 狀態機：下一狀態邏輯
    always @(*) begin
        case (state)
            CHECK_HIT: begin
                next_state = hit ? CHECK_HIT : MISS; // 命中繼續檢查下一個請求，否則進入 MISS
            end
            MISS: begin
                next_state = ARREADY ? REFILL : MISS; // 等待 AXI 接受請求
            end
            REFILL: begin
                next_state = RVALID ? CHECK_HIT : REFILL; // 等待數據返回後處理下一個請求
            end
        endcase
    end

    // 狀態機：輸出邏輯與行為
    always @* begin
        // 默認值（避免鎖存器）
        hit = 0;
        ARVALID = 0;
        RREADY = 0;
        ARADDR = 0;
        case (state)
            CHECK_HIT: begin
                if(fetch_req) begin
                    for (i = 0; i < WAYS; i = i + 1) begin
                        if (valid_array[set_index][i] && (tag_array[set_index][i] == tag_in)) begin
                            hit = 1;
                            data_out = data_array[set_index][i]; // 提取命中的數據
                        end
                    end
                end
            end
            MISS: begin
                // 發送 AXI 讀取請求
                ARADDR = {addr[31:BLOCK_OFFSET_BITS], {BLOCK_OFFSET_BITS{1'b0}}}; // Cache Line 對齊地址
                ARVALID = 1;
            end

            REFILL: begin
                if (RVALID) begin
                    // 接收數據並填充 Cache
                    tag_array[set_index][replace_way] = tag_in;
                    valid_array[set_index][replace_way] = 1'b1;
                    data_array[set_index][replace_way] = RDATA;  
                    data_out = RDATA;  // 返回填充數據
                    RREADY = 1'b1;  // 表示準備接收數據
                end
            end
        endcase
    end



endmodule
