`include "../defines.v"

`define WORK 3'b000
`define NOP 3'b010
`define HALT 3'b011
`define FLUSH 3'b100
`define MUL 3'b101

module Controller (
    input clk,
    input rst,
    input wake,
    input  stall,
    input branch_taken,
    input [6:0] opcode,
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
            if (current_state == `MUL) mul_counter <= mul_counter + 3'b1;
        end
    end
    always@* begin
        case(current_state)
            `WORK: begin
                if (branch_taken) next_state = `FLUSH;
                else if (opcode ==`LOAD) next_state = `NOP;
                else if (opcode == `ECALL) next_state = `HALT;
                else if (opcode == `MUL)  next_state = `MUL;
                else  next_state = `WORK;
            end
            `NOP: begin
                next_state = `WORK;
                nop = 1'b1;
            end
            `HALT: begin
                halt = 1'b1;
                if (wake) next_state = `WORK;
                else next_state = `HALT;
            end
            `FLUSH: begin
                next_state = `WORK;
                flush = 1'b1;
            end
            `MUL: begin
                if (mul_counter == 3'd5) begin
                    next_state = `WORK;
                end
                else begin
                    next_state = `MUL;
                end
            end
            default: begin
                next_state = `WORK;
            end
        endcase
    end
endmodule