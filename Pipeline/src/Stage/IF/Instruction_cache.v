module Instruction_cache (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,       // 輸入地址
    input wire fetch_req,         // 指令請求信號
    output reg [63:0] data_out,   // 指令輸出（假設 64-bit 指令）
    output reg hit                // 命中信號
);

    // Cache 設計參數
    parameter CACHE_SIZE = 32 * 1024;  // 總大小 32 KB
    parameter LINE_SIZE = 64;          // 每行大小 64 Bytes
    parameter WAYS = 8;                // 8 路相連
    parameter SETS = CACHE_SIZE / (LINE_SIZE * WAYS);  // 64 組

    // 地址分解參數
    parameter BLOCK_OFFSET_BITS = 6;   // Cache Line 偏移 6 bits (64 Bytes)
    parameter SET_INDEX_BITS = 6;      // 組索引 6 bits (64 Sets)
    parameter TAG_BITS = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS; // 剩餘位元作為 Tag

    // Cache 結構
    reg [TAG_BITS-1:0] tag_array [0:SETS-1][0:WAYS-1];      // 標籤存儲
    reg [63:0] data_array [0:SETS-1][0:WAYS-1];             // 數據存儲
    reg valid_array [0:SETS-1][0:WAYS-1];                   // 有效位存儲

    // 地址分解
    wire [TAG_BITS-1:0] tag_in;
    wire [SET_INDEX_BITS-1:0] set_index;

    assign tag_in = addr[31:32-TAG_BITS];
    assign set_index = addr[32-TAG_BITS-1:BLOCK_OFFSET_BITS];

    integer i, j;

    // 初始化有效位
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // 初始化所有有效位為 0
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] <= 0;
                end
            end
        end
    end

    // 替換策略：隨機替換
    reg [$clog2(WAYS)-1:0] replace_way;  // 替換路數
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            replace_way <= 0;
        end else begin
            replace_way <= $random % WAYS;  // 隨機替換
        end
    end

    // 命中檢測
    reg [WAYS-1:0] hit_way;  // 哪一路命中
    always @(*) begin
        hit = 0;
        hit_way = 0;
        for (i = 0; i < WAYS; i = i + 1) begin
            if (valid_array[set_index][i] && (tag_array[set_index][i] == tag_in)) begin
                hit = 1;
                hit_way = i;
            end
        end
    end

    // 數據填充與讀取邏輯
    always @(posedge clk) begin
        if (fetch_req) begin
            if (hit) begin
                // Cache 命中：直接讀取數據
                data_out <= data_array[set_index][hit_way];
            end else begin
                // Cache Miss：替換數據並更新有效位和標籤
                tag_array[set_index][replace_way] <= tag_in;
                data_array[set_index][replace_way] <= {32'h00000000, addr[31:0]};  // 假設數據填充為地址
                valid_array[set_index][replace_way] <= 1;
                data_out <= {32'h00000000, addr[31:0]};  // 返回新數據
            end
        end
    end

endmodule
