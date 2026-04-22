import circt.stage.ChiselStage
import chisel3._
import chisel3.util._
import wishbone.WishboneIO
import wildcat.pipeline._
import programmable_IMEM.programmable_IMEM

object CaravelUserProject extends App {
  emitVerilog(
    new CaravelUserProject(), 
    Array("--target-dir", "verilog/rtl")
  )
}

class CaravelUserProject extends Module {

  val WB_ADDR_WIDTH = 32
  val MPRJ_IO_PADS = 38

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val io = IO(new Bundle {
    val in = Input(UInt(MPRJ_IO_PADS.W))
    val out = Output(UInt(MPRJ_IO_PADS.W))
    val oeb = Output(UInt(MPRJ_IO_PADS.W))
  })

  // Wildcate Reset Register
  val wcReset = Reg(Bool())
  wcReset := reset

  // Wildcat Integration
  val wc = Module(new CpuTop("a.out"))
  wc.reset := wcReset
  wc.io.wb <> wb
  wc.io.wb.cyc := 0.B

  val led = wc.io.led
  val tx = wc.io.tx
  val video = wc.io.video

  // create dummy gpio peripheral for testing
  val gpio = Module(new WishboneGpio(8))
  gpio.wb <> wb
  gpio.wb.cyc := 0.B

  // create dummy gcd peripheral for testing
  val gcd = Module(new WishboneGcd(16))
  gcd.wb <> wb
  gcd.wb.cyc := 0.B

    // val imem = Module(new programmable_IMEM(depth = 16)) // depth = 1024 words
    // imem.wb<>wb
    // imem.wb.cyc:=0.B

  // address decoding for the peripherals
  // lower 20 bits of the address are used inside the peripherals, so we ignore them for decoding
  // bits [27:20] are used for decoding
  switch(wb.addr(27, 20)) {
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
    is(0x2.U) {
      wc.io.wb.cyc := wb.cyc
      wb.ack := wc.io.wb.ack
      wb.rdData := wc.io.wb.rdData
    }
    // is(0x3.U){
    //   imem.wb.cyc := wb.cyc
    //   wb.ack := imem.wb.ack
    //   wb.rdData := imem.wb.rdData
    // }
    is (0x4.U) {
      wcReset := true.B
    }
  }

  val outVec = Wire(Vec(MPRJ_IO_PADS, Bool()))
  val oebVec = Wire(Vec(MPRJ_IO_PADS, Bool()))

  for (i <- 0 until MPRJ_IO_PADS) {
    outVec(i) := false.B
    oebVec(i) := false.B
  }

  outVec(7) := tx
  oebVec(7) := false.B

  for (i <- 0 until 8) {
    outVec(8 + i) := gpio.io.out(i)
    oebVec(8 + i) := gpio.io.oeb(i)
  }

  for (i <- 0 until 8) {
    outVec(16 + i) := video(i)
    oebVec(16 + i) := false.B
  }

  outVec(24) := led(0)
  oebVec(24) := false.B

  wc.io.rx := io.in(25)
  oebVec(25) := true.B

  outVec(26) := wc.io.flash.cs
  oebVec(26) := false.B

  outVec(27) := wc.io.flash.mosi
  oebVec(27) := false.B

  wc.io.flash.miso := io.in(28)
  oebVec(28) := true.B

  outVec(29) := wc.io.flash.sck
  oebVec(29) := false.B

  gpio.io.in := io.in(15, 8)

  io.out := outVec.asUInt
  io.oeb := oebVec.asUInt

  // connect output ports
  //io.out := 0.U
  //io.oeb := 0.U
  // Pins 0-6 are used by Caravel
  /* This does not work du to a Chisel limitation
  Better define a bundle
  io.out(7) := tx
  io.out(15, 8) := gpio.io.out
  io.oeb(15, 8) := gpio.io.oeb
  io.out(23, 16) := video
  io.oeb(23, 16) := 0.U(8.W)
  io.out(24) := led(0)
  io.oeb(24) := 0.U(1.W)
  */

  //val spi_out = Cat(wc.io.flash.sck, 0.U, wc.io.flash.mosi ,wc.io.flash.cs)
  //val spi_oeb = Cat(0.U, 1.U, 0.U, 0.U)

  // TODO make a Bundle for this
  //io.out := spi_out ## 0.U(1.W) ## led(0) ## video ## gpio.io.out ## tx ##0.U(7.W)
  //io.oeb := spi_oeb ## 1.U(1.W) ## 0.U(1.W) ## 0.U(8.W) ## gpio.io.oeb ## 0.U(1.W) ## 0.U(7.W)
 
  // connect input ports
  //gpio.io.in := io.in(15,8)
  //wc.io.rx := io.in(25)

  //wc.io.flash.miso := io.in(28)
}
