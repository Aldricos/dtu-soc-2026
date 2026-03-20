package videoController

import chisel3._
import chisel3.util._
import wishbone.WishboneIO

/**
  * TODO: write summary
  */
class Terminal extends Module {
  val io = IO(new Bundle {
    val horizontal = Input(UInt(log2Up(VgaConstants.H_TOTAL).W))
    val vertical = Input(UInt(log2Up(VgaConstants.V_TOTAL).W))
    val red = Output(UInt(2.W))
    val green = Output(UInt(2.W))
    val blue = Output(UInt(2.W))
  })

  io.red := io.horizontal(3,2)
  io.green := io.horizontal(5,4)
  io.blue := io.vertical(4,3)
}
