package memory

import chisel3._

class SpiMemIO extends Bundle {
  val cs   = Output(Bool())
  val sck  = Output(Bool())
  val mosi = Output(Bool())
  val miso = Input(Bool())
}