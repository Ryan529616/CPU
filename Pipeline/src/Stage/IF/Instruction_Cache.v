module Instruction_Cache #(
    parameter DATA_LENGTH = 32,
    parameter CACHE_SIZE = 32 * 1024,
    parameter LINE_SIZE = 64,
    parameter WAYS = 8
) (
    input wire clk,
    input wire rst,
    input wire flush,
    input wire refill_valid,
    input wire [DATA_LENGTH-1:0] refill_data,
    input wire [31:0] addr,
    output reg miss_detected,
    output reg refill_complete,
    output reg [DATA_LENGTH-1:0] data_out
);

    localparam SETS = CACHE_SIZE / (LINE_SIZE * WAYS);
    localparam BLOCK_OFFSET_BITS = $clog2(LINE_SIZE);
    localparam SET_INDEX_BITS = $clog2(SETS);
    localparam TAG_BITS = 32 - SET_INDEX_BITS - BLOCK_OFFSET_BITS;
    localparam WORDS_PER_LINE = LINE_SIZE / (DATA_LENGTH / 8);

    // Cache 結構
    reg [TAG_BITS-1:0] tag_array [0:SETS-1][0:WAYS-1];
    reg [DATA_LENGTH-1:0] data_array [0:SETS-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    reg valid_array [0:SETS-1][0:WAYS-1];
    reg [$clog2(WAYS)-1:0] replace_way;

    // 地址解析
    wire [TAG_BITS-1:0] tag_in;
    wire [SET_INDEX_BITS-1:0] set_index;

    assign tag_in = addr[31:32 - TAG_BITS];
    assign set_index = addr[32 - TAG_BITS - 1 : BLOCK_OFFSET_BITS];

    // 替換策略 - LFSR
    reg [$clog2(WAYS)-1:0] lfsr;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= {$clog2(WAYS){1'b1}};
        end else begin
            lfsr <= {lfsr[$clog2(WAYS)-2:0], lfsr[$clog2(WAYS)-1] ^ lfsr[$clog2(WAYS)-2]};
        end
    end

    reg [5:0] refill_counter;

    integer i, j;

    // 初始化
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            for (i = 0; i < SETS; i = i + 1) begin
                for (j = 0; j < WAYS; j = j + 1) begin
                    valid_array[i][j] <= 1'b0;
                end
            end
        end
    end

    // 命中檢查
    reg hit_internal;
    reg [$clog2(WAYS)-1:0] hit_way;

    always @(*) begin
        hit_internal = 0;
        hit_way = 0;
        for (i = 0; i < WAYS; i = i + 1) begin
            if (valid_array[set_index][i] && (tag_array[set_index][i] == tag_in)) begin
                hit_internal = 1;
                hit_way = i;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            data_out <= 32'bz;
        end else if (hit_internal) begin
            data_out <= data_array[set_index][hit_way][addr[BLOCK_OFFSET_BITS-1:2]];
        end else begin
            data_out <= 0;
        end
    end

    // Miss 檢測
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            miss_detected <= 0;
        end else if (!hit_internal) begin
            miss_detected <= 1;
        end else begin
            miss_detected <= 0;
        end
    end
    

    // 填充邏輯

    always @(posedge clk or posedge rst) begin
        if (rst || flush) replace_way <= 0;
        else if(refill_complete) replace_way <= lfsr; // 使用 LFSR 產生新的替換路徑
    end

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            refill_counter <= 0;
            refill_complete <= 0;
        end else if (refill_valid) begin
            data_array[set_index][replace_way][refill_counter] <= refill_data;
            tag_array[set_index][replace_way] <= tag_in;
            valid_array[set_index][replace_way] <= 1'b1;

            if (refill_counter < WORDS_PER_LINE-1) begin
                refill_counter <= refill_counter + 1;
                refill_complete <= 0;
            end else begin
                refill_counter <= 0;
                refill_complete <= 1;
            end
        end else begin
            refill_complete <= 0;
        end
    end

endmodule
