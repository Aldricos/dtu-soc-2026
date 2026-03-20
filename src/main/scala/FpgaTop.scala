import circt.stage.ChiselStage
import chisel3._
import chisel3.util._
import wishbone.WishboneIO
import wildcat.pipeline._
import videoController.VideoController

object FpgaTop extends App {
  emitVerilog(
    new FpgaTop(), 
    Array("--target-dir", "verilog/rtl")
  )
}

class FpgaTop extends Module {
  val io = IO(new Bundle {
    val out = Output(UInt(9.W))
  })

  val ct = Module(new CaravelTop)

  // tie off wishbone interface
  ct.wb.stb := 0.U
  ct.wb.addr := 0.U
  ct.wb.wrData := 0.U
  ct.wb.we := 0.U
  ct.wb.cyc := 0.U
  ct.wb.sel := 0.U


  ct.io.in := 0.U
  io.out := ct.io.out(9,0) 


}