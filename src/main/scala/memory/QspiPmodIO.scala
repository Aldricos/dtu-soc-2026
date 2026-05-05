package memory

import chisel3._

class QspiPmodIO extends Bundle {
  val cs0 = Output(Bool())  // flash chip select, active low
  val sd0 = Output(Bool())  // MOSI
  val sd1 = Input(Bool())   // MISO
  val sck = Output(Bool())  // clock
  val sd2 = Output(Bool())  // WP# in standard SPI mode; data bit 2 in quad mode
  val sd3 = Output(Bool())  // HOLD# in standard SPI mode; data bit 3 in quad mode
  val cs1 = Output(Bool())  // PSRAM A chip select, active low
  val cs2 = Output(Bool())  // PSRAM B chip select, active low
}