package OpenRam
import chisel3._
import chisel3.util._

class OpenRamSP_64x32(file : String) extends BlackBox with HasBlackBoxResource {
  val io = IO(new Bundle {
    val clk   = Input(Clock())
    val rst_n = Input(Bool())

    val en    = Input(Bool())
    val we    = Input(Bool())
    val wmask = Input(UInt(4.W))
    val addr  = Input(UInt(6.W)) // Memory address width
    val wdata = Input(UInt(32.W))
    val rdata = Output(UInt(32.W))

    val vccd1 = Input(Bool())
    val vssd1 = Input(Bool())
  })

  addResource("/OpenRamSP_64x32.v")
  addResource(f"/$file")
}
