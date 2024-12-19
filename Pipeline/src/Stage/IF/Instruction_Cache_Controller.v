module Instruction_Cache_Controller #(
    parameter DATA_LENGTH = 32, // 指令長度 (32 bits)
    parameter LINE_SIZE = 64    // 每行大小 (64 Bytes)
) (
    input wire clk,
    input wire rst,

    // 與 CPU 的接口
    input wire [31:0] addr,            // CPU 請求的地址
    input wire fetch_req,              // CPU 請求信號
    output reg [DATA_LENGTH-1:0] data_out, // 返回 CPU 的數據
    output reg hit,                    // 命中信號

    // 與 Cache 的接口
    output reg cache_miss_detected,    // 通知 Cache 發生 Miss
    output reg refill_valid,           // 向 Cache 發送填充數據有效信號

    // 與 AXI3 的接口
    output reg [31:0] ARADDR,          // AXI 讀取地址
    output reg ARVALID,                // 地址有效
    input wire ARREADY,                // 地址已被接受
    input wire [DATA_LENGTH-1:0] RDATA,// AXI 返回的數據
    input wire RVALID,                 // 數據有效
    output reg RREADY                  // 準備接收數據
);

    // 狀態機定義
    localparam IDLE   = 2'b00;
    localparam MISS   = 2'b01; // 發送 AXI 請求
    localparam REFILL = 2'b10; // 填充數據

    reg [1:0] state, next_state;
    reg [$clog2(LINE_SIZE / DATA_LENGTH)-1:0] refill_counter; // 填充數據計數器

    // 狀態機切換邏輯
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // 狀態機行為
    always @(*) begin
        case (state)
            IDLE: begin
                if (~hit) begin
                    next_state = MISS;
                end else begin
                    next_state = IDLE;
                end
            end
            MISS: begin
                if (ARREADY) begin
                    next_state = REFILL;
                end else begin
                    next_state = MISS;
                end
            end
            REFILL: begin
                if (refill_counter == (LINE_SIZE / DATA_LENGTH) - 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = REFILL;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // 狀態機操作
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ARADDR <= 0;
            ARVALID <= 0;
            RREADY <= 0;
            refill_valid <= 0;
            refill_counter <= 0;
            hit <= 0;
            data_out <= 0;
            cache_miss_detected <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (fetch_req) begin
                        cache_miss_detected <= 1;
                        hit <= 0;
                    end else begin
                        cache_miss_detected <= 0;
                        hit <= 0;
                    end
                end
                MISS: begin
                    if (!ARVALID) begin
                        ARADDR <= {addr[31:$clog2(LINE_SIZE)], {$clog2(LINE_SIZE){1'b0}}};
                        ARVALID <= 1;
                    end else if (ARREADY) begin
                        ARVALID <= 0;
                    end
                end
                REFILL: begin
                    RREADY <= 1;
                    if (RVALID) begin
                        refill_valid <= 1;
                        if (refill_counter < (LINE_SIZE / DATA_LENGTH) - 1) begin
                            refill_counter <= refill_counter + 1;
                        end else begin
                            refill_counter <= 0;
                            refill_valid <= 0;
                            RREADY <= 0;
                        end
                    end else begin
                        refill_valid <= 0;
                    end
                end
            endcase
        end
    end

endmodule