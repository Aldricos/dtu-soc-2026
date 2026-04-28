package memory

import chisel3._

class QspiPmodIO extends Bundle {
  val cs0 = Output(Bool())  // flash chip select, active low
  val sd0 = Output(Bool())  // MOSI
  val sd1 = Input(Bool())   // MISO
  val sck = Output(Bool())  // clock
}