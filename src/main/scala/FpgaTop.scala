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

    // SPI - Group 0
    val cs0 = Output(Bool())
    val sd0 = Output(Bool())

    val sd1 = Input(Bool())
    val sd2 = Output(Bool())
    val sd3 = Output(Bool())
    val sck = Output(Bool())
    val cs1 = Output(Bool())
    val cs2 = Output(Bool())
  })

  val cw = Module(new clk_wiz_0)
  cw.io.clk_in := clock

  withClock(cw.io.clk_out) {
    val ct = Module(new CaravelDebug)
    val inVec = WireInit(VecInit(Seq.fill(38)(0.U(1.W))))
    ct.io.in := inVec.asUInt

    val debug = Module(new UartDebug(10000000, n = 64))
    debug.io.rx := io.rx
    io.tx := debug.io.tx
    debug.io.din := ct.io.debugReadback //0.U

    ct.wb.stb := false.B
    ct.wb.addr := 0.U
    ct.wb.wrData := 0.U
    ct.wb.we := false.B
    ct.wb.cyc := false.B
    ct.wb.sel := 0.U

    val prevDout = RegNext(debug.io.dout)
    val newCmd = debug.io.dout =/= prevDout

    val wbBusy = RegInit(false.B)
    val wbAddr = RegInit(0.U(32.W))
    val wbData = RegInit(0.U(32.W))

    when (!wbBusy && newCmd) {
      wbBusy := true.B
      wbAddr := debug.io.dout(63, 32)
      wbData := debug.io.dout(31, 0)
    } .elsewhen (wbBusy && ct.wb.ack) {
      wbBusy := false.B
    }

    ct.wb.stb := wbBusy
    ct.wb.cyc := wbBusy
    ct.wb.we := wbBusy
    ct.wb.addr := wbAddr
    ct.wb.wrData := wbData
    ct.wb.sel := "b1111".U

    io.video_1 := ct.io.out(37,30)
    io.video_2 := ct.io.out(37,30)

    // SPI IO
    inVec(28) := io.sd1       // MISO — input
    io.cs0 := ct.io.out(26)   // flash chip select
    io.sd0 := ct.io.out(27)   // MOSI
    io.sd2 := true.B
    io.sd3 := true.B
    io.sck := ct.io.out(29)
    io.cs1 := ct.io.out(22)
    io.cs2 := ct.io.out(23)
  }
}
