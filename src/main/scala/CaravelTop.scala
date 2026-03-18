import circt.stage.ChiselStage
import chisel3._
import chisel3.util._
import wishbone.WishboneIO
import wildcat.pipeline._

object CaravelTop extends App {
  emitVerilog(
    new CaravelTop(), 
    Array("--target-dir", "verilog/rtl")
  )
}


class CaravelTop extends Module {

  val WB_ADDR_WIDTH = 28
  val MPRJ_IO_PADS = 38

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val io = IO(new Bundle {
    val in = Input(UInt(MPRJ_IO_PADS.W))
    val out = Output(UInt(MPRJ_IO_PADS.W))
    val oeb = Output(UInt(MPRJ_IO_PADS.W))
  })


  // Dummy assignments to avoid unconnected IOs
  // io.out := 0.U
  // io.oeb := 0.U

  val wc = Module(new CpuTop("wildcat/a.out"))

  val led = wc.io.led
  val tx = wc.io.tx
  wc.io.rx := false.B

  io.out := led << 8.U
  io.oeb := ~(1.U(38.W) << 8.U)

  // TODO: instantiate the wishbone GPIO peripheral
  // TODO: connect the GPIO peripheral to the Wishbone bus
  // TODO: set the wb.cyc port to 0 as a default
  // TODO: connect the GPIO peripheral's input and output ports to the top-level IO

  // create dummy gcd peripheral for testing
  val gcd = Module(new WishboneGcd(16))
  gcd.wb <> wb
  gcd.wb.cyc := 0.B

  // address decoding for the peripherals
  // lower 16 bits of the address are used inside the peripherals, so we ignore them for decoding
  // the upper 4 bits [19:16] are used for decoding
  switch(wb.addr(WB_ADDR_WIDTH - 1, WB_ADDR_WIDTH - 8)) {
    is(0x0.U) {
      // TODO: connect the GPIO peripheral to the Wishbone bus
    }
    is(0x1.U) {
      gcd.wb.cyc := wb.cyc
      wb.ack := gcd.wb.ack
      wb.rdData := gcd.wb.rdData
    }
  }
}
