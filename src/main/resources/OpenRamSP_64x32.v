module OpenRamSP_64x32 (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        en,
    input  wire        we,
    input  wire [3:0]  wmask,   // unused: macro has no byte mask support
    input  wire [5:0]  addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    reg [31:0] rdata_stored;
    reg        read_en_d;

    wire [31:0] rdata_int;

    wire do_write = en && we;
    wire do_read  = en && !we;

    always @(posedge clk) begin
        if (!rst_n) begin
            read_en_d    <= 1'b0;
            rdata_stored <= 32'b0;
        end else begin
            if (do_read) begin
                rdata_stored <= rdata_int;
            end
            read_en_d <= do_read;
        end
    end

    assign rdata = read_en_d ? rdata_int : rdata_stored;

    sky130_sram_256byte_1r1w_32x64_6 u_sram (
        // write port
        .clk0  (clk),
        .csb0  (!do_write),
        .addr0 (addr),
        .din0  (wdata),

        // read port
        .clk1  (clk),
        .csb1  (!do_read),
        .addr1 (addr),
        .dout1 (rdata_int)

        // TODO: add vccd1 vssd1
    );

endmodule