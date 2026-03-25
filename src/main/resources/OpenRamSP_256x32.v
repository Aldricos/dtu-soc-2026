// Verilog Interface for OpenRam 1kb memory

module OpenRamSP_256x32 (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        en,        // access enable
    input  wire        we,        // write enable
    input  wire [3:0]  wmask,     // byte write enable
    input  wire [7:0]  addr,      // 256 x 32-bit words
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    // Optional hold register to make read behavior friendlier at top level,
    reg [31:0] rdata_stored;
    reg        en_d;

    wire [31:0] rdata_int;
    wire [31:0] unused_dout1;

    always @(posedge clk) begin
        if (!rst_n) begin
            en_d         <= 1'b0;
            rdata_stored <= 32'b0;
        end else begin
            if (en) begin
                rdata_stored <= rdata_int;
            end
            en_d <= en;
        end
    end

    // Hold previous value when SRAM is not actively selected.
    assign rdata = en_d ? rdata_int : rdata_stored;

    sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
        .clk0   (clk),
        .csb0   (!en),      // active low
        .web0   (!we),      // active low
        .wmask0 (wmask),
        .addr0  (addr),
        .din0   (wdata),
        .dout0  (rdata_int),

        // unused second port
        .clk1   (1'b0),
        .csb1   (1'b1),
        .addr1  (8'b0),
        .dout1  (unused_dout1)

      // TODO: add vccd1 vssd1
    );

endmodule