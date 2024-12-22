module Hazard_Detection_Unit (
    input wire [4:0] rs1,          // 當前指令的 source register 1
    input wire [4:0] rs2,          // 當前指令的 source register 2
    input wire [4:0] rd_ex,        // EX 階段指令的目標寄存器
    input wire MemRead_ex,         // EX 階段是否為 Load 指令
    input wire branch_taken,       // 分支條件是否成立
    input wire branch_prediction,  // 分支預測是否正確
    output reg nop,                // 插入 NOP 信號
    output reg flush,              // 清空流水線信號
    output reg IF_ID_Write,        // 控制 IF/ID 流水線寄存器是否寫入
    output reg PC_Write            // 控制 PC 是否更新
);

    always @(*) begin
        // 預設值：保持流水線正常執行
        nop = 1'b0;
        flush = 1'b0;
        IF_ID_Write = 1'b1;  // 預設允許寫入
        PC_Write = 1'b1;     // 預設允許 PC 更新

        // 分支錯誤預測處理（優先級高）
        if (branch_prediction != branch_taken) begin
            flush = 1'b1;        // 清空流水線
            IF_ID_Write = 1'b0;  // 禁止寫入 IF/ID
        end
        // Load-Use Hazard 檢測
        else if (MemRead_ex && ((rd_ex == rs1) || (rd_ex == rs2))) begin
            nop = 1'b1;          // 插入 NOP
            IF_ID_Write = 1'b0;  // 停止寫入新指令
            PC_Write = 1'b0;     // 停止更新 PC
        end
    end
endmodule
