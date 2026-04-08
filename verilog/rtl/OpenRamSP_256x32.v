module OpenRamSP_256x32 (
`ifdef USE_POWER_PINS
    inout wire         vccd1,
    inout wire         vssd1,
`endif
    input  wire        clk,
    input  wire        rst_n,

    input  wire        en,
    input  wire        we,
    input  wire [3:0]  wmask,
    input  wire [7:0]  addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    reg [31:0] rdata_stored;
    reg        en_d;

    wire [31:0] rdata_int;
    wire [31:0] unused_dout1;

    always @(posedge clk) begin
        if (!rst_n) begin
            en_d         <= 1'b0;
            rdata_stored <= 32'b0;
        end else begin
            if (en && !we) begin
                rdata_stored <= rdata_int;
            end
            en_d <= en && !we;
        end
    end

    assign rdata = en_d ? rdata_int : rdata_stored;

    sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
`ifdef USE_POWER_PINS
        .vccd1  (vccd1),
        .vssd1  (vssd1),
`endif
        .clk0   (clk),
        .csb0   (!en),
        .web0   (!we),
        .wmask0 (wmask),
        .addr0  (addr),
        .din0   (wdata),
        .dout0  (rdata_int),

        .clk1   (1'b0),
        .csb1   (1'b1),
        .addr1  (8'b0),
        .dout1  (unused_dout1)
    );

endmodule