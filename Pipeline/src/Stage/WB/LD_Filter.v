`include "defines.v"

module LD_Filter(
    input       [2:0]   funct3,
    input       [31:0]  load_data,
    output reg  [31:0]  sign_extended_data
);
    always@*begin
        case(funct3)
            `LB:     sign_extended_data = {{24{load_data[7]}}, load_data[7:0]};
            `LH:     sign_extended_data = {{16{load_data[15]}}, load_data[15:0]};
            `LW:     sign_extended_data = load_data;
            `LBU:    sign_extended_data = {{24{1'b0}}, load_data[7:0]};
            `LHU:    sign_extended_data = {{16{1'b0}}, load_data[15:0]};
            default: sign_extended_data = 32'b0;
        endcase
    end

endmodule
