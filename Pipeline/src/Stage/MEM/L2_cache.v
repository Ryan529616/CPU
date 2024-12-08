module L2_cache (
    input [31:0] address_in,
    input [31:0] data_in
    output [31:0] address_out,
    output [31:0] data_out
);
    
    assign address_out = address_in;
    assign data_out = data_in;
    
endmodule