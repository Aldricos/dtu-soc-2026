import circt.stage.ChiselStage
import chisel3._
import chisel3.util._
import wishbone.WishboneIO
import wildcat.pipeline._
import videoController.VideoController

object CaravelUserProject extends App {
  emitVerilog(
    new CaravelUserProject(), 
    Array("--target-dir", "verilog/rtl")
  )
}


class CaravelUserProject extends Module {

  val WB_ADDR_WIDTH = 28
  val MPRJ_IO_PADS = 38

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val io = IO(new Bundle {
    val in = Input(UInt(MPRJ_IO_PADS.W))
    val out = Output(UInt(MPRJ_IO_PADS.W))
    val oeb = Output(UInt(MPRJ_IO_PADS.W))
  })
  // Wildcat Integration
  val wc = Module(new CpuTop("a.out"))

  val led = wc.io.led
  val tx = wc.io.tx
  wc.io.rx := false.B

  // create dummy gpio peripheral for testing
  val gpio = Module(new WishboneGpio(8))
  gpio.wb <> wb
  gpio.wb.cyc := 0.B
  gpio.io.in := io.in(15,8)

  // create dummy gcd peripheral for testing
  val gcd = Module(new WishboneGcd(16))
  gcd.wb <> wb
  gcd.wb.cyc := 0.B

  // TODO: move to CpuTop
  val vc = Module(new VideoController)
  io.out := led ## vc.io.hSync ## vc.io.vSync ## vc.io.red ## vc.io.green ## vc.io.blue
  io.oeb := ~("x00000001FF".U)

  // address decoding for the peripherals
  // lower 20 bits of the address are used inside the peripherals, so we ignore them for decoding
  // the upper 8 bits [27:20] are used for decoding
  switch(wb.addr(WB_ADDR_WIDTH - 1, WB_ADDR_WIDTH - 8)) {
    is(0x0.U) {
      gpio.wb.cyc := wb.cyc
      wb.ack := gpio.wb.ack
      wb.rdData := gpio.wb.rdData
    }
    is(0x1.U) {
      gcd.wb.cyc := wb.cyc
      wb.ack := gcd.wb.ack
      wb.rdData := gcd.wb.rdData
    }
  }

  // connect output ports
  io.out := led ## gpio.io.out ## 0.U(8.W)
  io.oeb := 0.U(1.W) ## gpio.io.oeb ## 0.U(8.W)
}
