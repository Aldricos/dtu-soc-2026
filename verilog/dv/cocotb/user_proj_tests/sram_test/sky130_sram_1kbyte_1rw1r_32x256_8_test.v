// OpenRAM SRAM model - Corrected for Icarus Verilog
// Words: 256
// Word size: 32
// Write size: 8

module sky130_sram_1kbyte_1rw1r_32x256_8(
`ifdef USE_POWER_PINS
    vccd1,
    vssd1,
`endif
// Port 0: RW
    clk0,csb0,web0,wmask0,addr0,din0,dout0,
// Port 1: R
    clk1,csb1,addr1,dout1
  );

  parameter NUM_WMASKS = 4 ;
  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = 8 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;

`ifdef USE_POWER_PINS
    inout vccd1;
    inout vssd1;
`endif
  input  clk0; // clock
  input   csb0; // active low chip select
  input  web0; // active low write control
  input [NUM_WMASKS-1:0]   wmask0; // write mask
  input [ADDR_WIDTH-1:0]  addr0;
  input [DATA_WIDTH-1:0]  din0;
  output reg [DATA_WIDTH-1:0] dout0;

  input  clk1; // clock
  input   csb1; // active low chip select
  input [ADDR_WIDTH-1:0]  addr1;
  output reg [DATA_WIDTH-1:0] dout1;

  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
  reg [ADDR_WIDTH-1:0] addr0_reg;
  reg [ADDR_WIDTH-1:0] addr1_reg;

  // Port 0: Synchronous write
  always @(posedge clk0) begin
    if (!csb0 && !web0) begin
      if (wmask0[0]) mem[addr0][7:0]   <= din0[7:0];
      if (wmask0[1]) mem[addr0][15:8]  <= din0[15:8];
      if (wmask0[2]) mem[addr0][23:16] <= din0[23:16];
      if (wmask0[3]) mem[addr0][31:24] <= din0[31:24];
    end
  end

  // Port 0: Synchronous read
  always @(posedge clk0) begin
    addr0_reg <= addr0;
    if (!csb0 && web0) begin
      dout0 <= mem[addr0_reg];
    end
  end

  // Port 1: Synchronous read
  always @(posedge clk1) begin
    addr1_reg <= addr1;
    if (!csb1) begin
      dout1 <= mem[addr1_reg];
    end
  end

endmodule

