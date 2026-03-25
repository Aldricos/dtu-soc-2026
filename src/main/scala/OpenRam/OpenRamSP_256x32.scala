package OpenRam

import chisel3._
import chisel3.util._

class OpenRamSP_256x32 extends BlackBox with HasBlackBoxResource {
  val io = IO(new Bundle {
    val clk   = Input(Clock())
    val rst_n = Input(Bool())

    val en    = Input(Bool())
    val we    = Input(Bool())
    val wmask = Input(UInt(4.W))
    val addr  = Input(UInt(8.W))
    val wdata = Input(UInt(32.W))
    val rdata = Output(UInt(32.W))
  })

  addResource("/OpenRamSP_256x32.v")
  addResource("/sky130_sram_1kbyte_1rw1r_32x256_8.v")
}