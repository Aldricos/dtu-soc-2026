import circt.stage.ChiselStage
import chisel3._
import chisel3.util._


object CaravelTop extends App {
  ChiselStage.emitSystemVerilogFile(
    new CaravelTop(), 
    Array("--target-dir", "verilog/rtl"), 
    Array("--lowering-options=disallowLocalVariables,disallowPackedArrays")
  )
}


class CaravelTop extends Module {

  val WB_ADDR_WIDTH = 32
  val MPRJ_IO_PADS = 38
  val LA_PINS = 128

  val wb = IO(new wishbone.WishboneIO(WB_ADDR_WIDTH, dataWidth = 32))
  val io = IO(new Bundle {
    val in = Input(UInt(MPRJ_IO_PADS.W))
    val out = Output(UInt(MPRJ_IO_PADS.W))
    val oeb = Output(UInt(MPRJ_IO_PADS.W))
  })


  /// Dummy GCD module instantiation

  val gcd = Module(new DecoupledGcd(16))
  gcd.input.bits.value1 := wb.din(15, 0)
  gcd.input.bits.value2 := wb.din(31, 16)

  val statusAccess = wb.addr(3,0) === 0.U
  val accessOngoingReg = RegNext(wb.cyc && wb.stb, 0.B)
  
  gcd.input.valid := accessOngoingReg && wb.we && !statusAccess
  gcd.output.ready := accessOngoingReg && !wb.we && !statusAccess

  wb.dout := Mux(
    statusAccess,
    gcd.input.ready ## gcd.output.valid,
    gcd.output.bits.gcd
  )
  wb.ack := accessOngoingReg // Acknowledge in the next cycle



  /// Outputs
  io.out := gcd.output.bits.asUInt
  io.oeb := 0.U // All outputs are enabled (active low)




}
