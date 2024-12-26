module Instruction_Cache_Controller #(
    parameter DATA_LENGTH = 32, // 指令長度 (32 bits)
    parameter LINE_SIZE = 64    // 每行大小 (64 Bytes)
) (
    input wire clk,
    input wire rst,

    // 與 CPU 的接口
    input wire                   branch_taken,      // 分支是否被採納
    input wire                   branch_prediction, // 分支是否正確
    input wire            [31:0] addr_in,           // CPU 請求的地址
    output reg                   stall,             // CPU 是否停頓
    output reg [DATA_LENGTH-1:0] data_out,          // 返回 CPU 的數據

    // 與 Cache 的接口
    input wire                    miss,            // Cache Miss
    input wire                    refill_complete, // Cache 填充完成
    input wire  [DATA_LENGTH-1:0] data_in,         // Cache 返回的數據
    output wire            [31:0] addr_out,        // Cache 請求的地址
    output reg                    flush,           // 清空 Cache
    output reg                    refill_valid,    // 向 Cache 發送填充數據有效信號

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

    assign addr_out = addr_in;
    assign data_out = data_in;

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
        IDLE: next_state = miss ? MISS : IDLE;
        MISS: next_state = flush ? IDLE : (ARREADY ? REFILL : MISS);
        REFILL: next_state = flush ? IDLE : ((refill_counter == (LINE_SIZE / DATA_LENGTH) - 1) ? IDLE : REFILL);
        default: next_state = IDLE;
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
        end else begin
            case (state)
                IDLE: begin
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
                        end 
                        else begin
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

    always @* begin
        if(branch_taken != branch_prediction) flush = 1;
        else flush <= 0;

        if(miss) stall = 1;
        else stall = 0;
    end

endmodule