
`timescale 1ns / 1ps

module sram_verilator_test;

    // Parameters
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
    localparam CLK_PERIOD = 10;

    // Testbench signals
    reg clk0;
    reg csb0;
    reg web0;
    reg [3:0] wmask0;
    reg [ADDR_WIDTH-1:0] addr0;
    reg [DATA_WIDTH-1:0] din0;
    wire [DATA_WIDTH-1:0] dout0;

    // Unused port 1
    reg clk1;
    reg csb1;
    reg [ADDR_WIDTH-1:0] addr1;
    wire [DATA_WIDTH-1:0] dout1;

    // Instantiate the SRAM
    sky130_sram_1kbyte_1rw1r_32x256_8 uut (
        .clk0(clk0),
        .csb0(csb0),
        .web0(web0),
        .wmask0(wmask0),
        .addr0(addr0),
        .din0(din0),
        .dout0(dout0),
        // Tie off unused port 1
        .clk1(1'b0),
        .csb1(1'b1),
        .addr1({ADDR_WIDTH{1'b0}}),
        .dout1(dout1)
    );

    // Clock generation
    initial begin
        clk0 = 0;
        forever #(CLK_PERIOD/2) clk0 = ~clk0;
    end

    // Main test sequence
    initial begin
        $display("Starting Verilator SRAM Test");
        csb0 = 1;
        web0 = 1;
        wmask0 = 4'b0;
        addr0 = 0;
        din0 = 0;

        // Wait for reset
        repeat(2) @(posedge clk0);

        // --- WRITE TEST ---
        $display("Writing 0xDEADBEEF to address 5...");
        csb0 = 0;       // Chip select active
        web0 = 0;       // Write enable active
        wmask0 = 4'b1111; // Write all 4 bytes
        addr0 = 8'd5;
        din0 = 32'hDEADBEEF;
        @(posedge clk0);
        
        // De-assert signals
        csb0 = 1;
        web0 = 1;
        wmask0 = 4'b0;
        
        repeat(2) @(posedge clk0);

        // --- READ TEST ---
        $display("Reading from address 5...");
        csb0 = 0;       // Chip select active
        web0 = 1;       // Write disable (to read)
        addr0 = 8'd5;
        @(posedge clk0);
        
        // After one cycle, the data should be on dout0.
        // We check it on the next clock edge for stability.
        @(posedge clk0);
        $display("Read data: %h", dout0);

        if (dout0 === 32'hDEADBEEF) begin
            $display("SUCCESS: Read data matches written data!");
        end else begin
            $display("FAILURE: Read data (%h) does not match written data (DEADBEEF)!", dout0);
        end

        // --- FINISH ---
        repeat(2) @(posedge clk0);
        $display("Test finished.");
        $finish;
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("sram_verilator_test.vcd");
        $dumpvars(0, sram_verilator_test);
    end

endmodule
