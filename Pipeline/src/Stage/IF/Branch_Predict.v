`define STRONGLY_NOT_TAKEN  2'b00 
`define WEAKLY_NOT_TAKEN       2'b01  
`define WEAKLY_TAKEN                2'b10  
`define STRONGLY_TAKEN           2'b11

module Branch_Predict (
    input clk,                   
    input rst,                  
    input branch_taken,
    input branch,
    output reg branch_prediction,

);
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= `STRONGLY_NOT_TAKEN; 
            branch_prediction <= 1'b0;
        end 
        else if (branch) begin
            current_state <= next_state; 
            if (current_state == `STRONGLY_TAKEN || current_state == `WEAKLY_TAKEN)
                branch_prediction <= 1'b1;
            else
                branch_prediction <= 1'b0;
        end
        else begin
            current_state <= `STRONGLY_NOT_TAKEN; 
            branch_prediction <= 1'b0;
        end
    end

    always @(*) begin
        case (current_state)
            `STRONGLY_NOT_TAKEN: begin
                if (branch_taken)
                    next_state = `WEAKLY_NOT_TAKEN; 
                else
                    next_state = `STRONGLY_NOT_TAKEN; 
            end
            `WEAKLY_NOT_TAKEN: begin
                if (branch_taken)
                    next_state = `WEAKLY_TAKEN;
                else
                    next_state = `STRONGLY_NOT_TAKEN;
            end
            `WEAKLY_TAKEN: begin
                if (branch_taken)
                    next_state = `STRONGLY_TAKEN;
                else
                    next_state = `WEAKLY_NOT_TAKEN;
            end
            `STRONGLY_TAKEN: begin
                if (branch_taken)
                    next_state = `STRONGLY_TAKEN; 
                else
                    next_state = `WEAKLY_TAKEN;
            end
            default: next_state = `STRONGLY_NOT_TAKEN;
        endcase
    end
endmodule