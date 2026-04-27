`timescale 1ns / 1ps

module sram_test_complex;

    // Parameters
    parameter NUM_WMASKS = 4;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 8;
    parameter RAM_DEPTH = 1 << ADDR_WIDTH;
    parameter CLK_PERIOD = 10;

    // Ports
    reg clk0, clk1;
    reg csb0, csb1;
    reg web0;
    reg [NUM_WMASKS-1:0] wmask0;
    reg [ADDR_WIDTH-1:0] addr0, addr1;
    reg [DATA_WIDTH-1:0] din0;
    wire [DATA_WIDTH-1:0] dout0, dout1;

    integer i;
    integer error_count;

    sky130_sram_1kbyte_1rw1r_32x256_8_test uut (
        .clk0(clk0), .csb0(csb0), .web0(web0), .wmask0(wmask0), .addr0(addr0), .din0(din0), .dout0(dout0),
        .clk1(clk1), .csb1(csb1), .addr1(addr1), .dout1(dout1)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk0 = ~clk0;
    always #(CLK_PERIOD/2) clk1 = ~clk1;

    // Helper tasks
    task write_word;
        input [ADDR_WIDTH-1:0] address;
        input [DATA_WIDTH-1:0] data;
        input [NUM_WMASKS-1:0] mask;
        begin
            @(negedge clk0);
            csb0 = 0;
            web0 = 0;
            addr0 = address;
            din0 = data;
            wmask0 = mask;
            @(negedge clk0);
            csb0 = 1;
            web0 = 1;
        end
    endtask

    task read_word_p0;
        input [ADDR_WIDTH-1:0] address;
        output [DATA_WIDTH-1:0] data;
        begin
            @(negedge clk0);
            csb0 = 0;
            web0 = 1; // Read operation
            addr0 = address;
            @(negedge clk0); // Wait one cycle for address to latch
            @(negedge clk0); // Wait another cycle for data to be available
            data = dout0;
            csb0 = 1;
        end
    endtask
    
    task read_word_p1;
        input [ADDR_WIDTH-1:0] address;
        output [DATA_WIDTH-1:0] data;
        begin
            @(negedge clk1);
            csb1 = 0;
            addr1 = address;
            @(negedge clk1); // Wait one cycle for address to latch
            @(negedge clk1); // Wait another cycle for data to be available
            data = dout1;
            csb1 = 1;
        end
    endtask


    reg [DATA_WIDTH-1:0] read_data;
    reg [DATA_WIDTH-1:0] mask_read_data;

    initial begin
        $dumpfile("sram_test.vcd");
        $dumpvars(0, sram_test_complex);
        // Initialization
        clk0 = 0; clk1 = 0;
        csb0 = 1; csb1 = 1;
        web0 = 1;
        wmask0 = {NUM_WMASKS{1'b1}};
        addr0 = 0; addr1 = 0;
        din0 = 0;
        error_count = 0;

        $display("***********************************");
        $display("****** Starting Complex Test ******");
        $display("***********************************");

        // 1. Full memory write/read test
        $display("\n[TEST 1] Full memory write and readback...");
        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            write_word(i, {i[7:0], i[7:0], i[7:0], i[7:0]}, 4'b1111);
        end

        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            read_word_p0(i, read_data);
            if (read_data !== {i[7:0], i[7:0], i[7:0], i[7:0]}) begin
                $display("ERROR [TEST 1]: Address %h: Expected %h, Got %h", i, {i[7:0], i[7:0], i[7:0], i[7:0]}, read_data);
                error_count = error_count + 1;
            end
        end
        if (error_count == 0) $display("[TEST 1] PASSED!");

        // 2. Write Mask Test
        $display("\n[TEST 2] Write mask test...");
        error_count = 0;
        write_word(8'hA5, 32'hDEADBEEF, 4'b1111); // Initial value
        write_word(8'hA5, 32'h12345678, 4'b0110); // Write bytes 1 and 2
        
        read_word_p0(8'hA5, mask_read_data);
        if (mask_read_data !== 32'hDE3456EF) begin
            $display("ERROR [TEST 2]: Expected %h, Got %h", 32'hDE3456EF, mask_read_data);
            error_count = error_count + 1;
        end
        if (error_count == 0) $display("[TEST 2] PASSED!");

        // 3. Simultaneous Write (P0) and Read (P1) to different addresses
        $display("\n[TEST 3] Simultaneous Write (P0) and Read (P1)...");
        error_count = 0;
        write_word(8'h42, 32'hCAFEBABE, 4'b1111); // Pre-load data for reading
        
        @(negedge clk0);
        // Port 0: Write to 8'hC0
        csb0 = 0;
        web0 = 0;
        addr0 = 8'hC0;
        din0 = 32'hFEEDF00D;
        wmask0 = 4'b1111;

        // Port 1: Read from 8'h42
        csb1 = 0;
        addr1 = 8'h42;

        @(negedge clk0); // Cycle 1: Signals propagate
        @(negedge clk0); // Cycle 2: Data is available on dout1
        if (dout1 !== 32'hCAFEBABE) begin
             $display("ERROR [TEST 3]: P1 Read failed. Expected %h, Got %h", 32'hCAFEBABE, dout1);
             error_count = error_count + 1;
        end
        csb0 = 1; web0 = 1;
        csb1 = 1;
        
        read_word_p0(8'hC0, mask_read_data); // Use a temp var
        if (mask_read_data !== 32'hFEEDF00D) begin
             $display("ERROR [TEST 3]: P0 Write failed. Read back %h", mask_read_data);
             error_count = error_count + 1;
        end
        if (error_count == 0) $display("[TEST 3] PASSED!");

        // 4. Simultaneous Write (P0) and Read (P1) to the same address
        $display("\n[TEST 4] Simultaneous Write/Read on same address...");
        error_count = 0;
        
        @(negedge clk0);
        // Port 0: Write to 8'hFF
        csb0 = 0;
        web0 = 0;
        addr0 = 8'hFF;
        din0 = 32'h11223344;
        wmask0 = 4'b1111;

        // Port 1: Read from 8'hFF
        csb1 = 0;
        addr1 = 8'hFF;

        @(negedge clk0); // Cycle 1
        @(negedge clk0); // Cycle 2
        // Behavior can be implementation specific.
        // A common behavior is "read-before-write" or "write-through".
        // Let's assume write-through: the read port gets the new data.
        if (dout1 !== 32'h11223344) begin
             $display("WARNING [TEST 4]: P1 Read during write returned %h (Expected %h for write-through behavior)", dout1, 32'h11223344);
             // This might not be an error depending on the SRAM architecture
        end else begin
             $display("[TEST 4] Write-through behavior confirmed.");
        end
        csb0 = 1; web0 = 1;
        csb1 = 1;
        if (error_count == 0) $display("[TEST 4] PASSED (observation complete).");


        $display("\n***********************************");
        $display("********* Test Finished *********");
        $display("***********************************");
        $finish;
    end

endmodule
