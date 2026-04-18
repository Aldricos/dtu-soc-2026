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

class clk_wiz_0 extends BlackBox {
  val io = IO(new Bundle {
    val clk_in = Input(Clock())
    val clk_out = Output(Clock())
  })
}

class FpgaTop extends Module {
  val io = IO(new Bundle {
    val out = Output(UInt(9.W))
  })

  val cw = Module(new clk_wiz_0)
  cw.io.clk_in := clock

  withClock(cw.io.clk_out) {
    val ct = Module(new CaravelUserProject)

    // tie off wishbone interface
    ct.wb.stb := 0.U
    ct.wb.addr := 0.U
    ct.wb.wrData := 0.U
    ct.wb.we := 0.U
    ct.wb.cyc := 0.U
    ct.wb.sel := 0.U

    ct.io.in := 0.U
    io.out := ct.io.out(24,16)
  }
}
