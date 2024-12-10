module CSR (
    input clk,
    input rst,

    input [11:0] csr_ra_id,
    input [31:0] csr_wa_ex,
    input csr_we_ex,
    input [31:0] csr_wd_ex,
    
    output [31:0] csr_rd,
    output [31:0] mstatus,
    output [31:0] mcause,
    output [31:0] mepc,
    output [31:0] mtvec
);

    // CSR Registers
    reg [31:0] mstatus;
    reg [31:0] mie;
    reg [31:0] mtvec;
    reg [31:0] mscratch;
    reg [31:0] mepc;
    reg [31:0] mcause;
    reg [63:0] cycles;

    assign mstatus = mstatus;
    assign mtvec = mtvec;
    assign mcause = mcause;
    assign mepc = mepc;

    // Read logic
    always @(*) begin
        case (csr_ra_id)
            `MSTATUS:  csr_rd = mstatus;
            `MIE:      csr_rd = mie;
            `MTVEC:    csr_rd = mtvec;
            `MSCRATCH: csr_rd = mscratch;
            `MEPC:     csr_rd = mepc;
            `MCAUSE:   csr_rd = mcause;
            // `CYCLEL:   csr_rd = cycles[31:0];
            // `CYCLEH:   csr_rd = cycles[63:32];
            default:  csr_rd = 32'b0;
        endcase
    end

    // Write logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mstatus  <= 32'b0;
            mie      <= 32'b0;
            mtvec    <= 32'b0;
            mscratch <= 32'b0;
            mepc     <= 32'b0;
            mcause   <= 32'b0;
        end else begin
            if (csr_we_ex) begin
                case (csr_wa_ex)
                    `MSTATUS:  mstatus  <= csr_wd_ex;
                    `MIE:      mie      <= csr_wd_ex;
                    `MTVEC:    mtvec    <= csr_wd_ex;
                    `MSCRATCH: mscratch <= csr_wd_ex;
                    `MEPC:     mepc     <= csr_wd_ex;
                    `MCAUSE:   mcause   <= csr_wd_ex;
                endcase
            end
        end
    end
endmodule

