import circt.stage.ChiselStage
import chisel3._
import chisel3.util._
import debug.UartDebug

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
    val video_1 = Output(UInt(8.W))
    val video_2 = Output(UInt(8.W))
    val rx = Input(Bool())
    val tx = Output(Bool())
  })

  val cw = Module(new clk_wiz_0)
  cw.io.clk_in := clock

  withClock(cw.io.clk_out) {
    val ct = Module(new CaravelUserProject)

    val debug = Module(new UartDebug(10000000, n = 64))
    debug.io.rx := io.rx
    io.tx := debug.io.tx
    debug.io.din := 0.U

    ct.wb.stb := false.B
    ct.wb.addr := 0.U
    ct.wb.wrData := 0.U
    ct.wb.we := false.B
    ct.wb.cyc := false.B
    ct.wb.sel := 0.U

    when (debug.io.dout =/= RegNext(debug.io.dout)) {
      ct.wb.stb := true.B
      ct.wb.addr := debug.io.dout(63, 32)
      ct.wb.wrData := debug.io.dout(31, 0)
      ct.wb.we := true.B
      ct.wb.cyc := true.B
      ct.wb.sel := "b1111".U
    }

    ct.io.in := 0.U
    io.video_1 := ct.io.out(37,30)
    io.video_2 := ct.io.out(37,30)
  }
}
