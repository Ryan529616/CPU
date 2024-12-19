`include "../defines.v"

module Controller (
    input clk,
    input rst,
    input cache_miss_detected,
    input refill_complete,
    input [6:0] opcode,
    output stall,
    output reg nop,
    output reg halt,
    output reg flush
);
    reg [2:0] mul_counter;
    reg [2:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            current_state <= `WORK;
        end
        else begin 
            current_state <= next_state;
        end
    end

    always@* begin
        halt = 1'b0;
        case(current_state)
            `NORMAL: begin
                if (branch_taken) next_state = `FLUSH;
                else if (opcode ==`LOAD) next_state = `NOP;
                else if ((opcode == `ECALL)||(opcode==`EBREAK)) next_state = `HALT;
                else if (cache_miss_detected)begin 
                    flush = 1'b1;
                    next_state = `CACHE_MISS;
                end
                else  next_state = `NORMAL;
            end
            `NOP: begin
                next_state = `NORMAL;
            end
            `HALT: begin
                halt = 1'b1;
            end
            `CACHE_MISS: begin
                if(refill_complete) next_state = `NORMAL;
                else next_state = `CACHE_MISS;
            end
            default: begin
                next_state = `NOP;
            end
        endcase
    end
endmodule