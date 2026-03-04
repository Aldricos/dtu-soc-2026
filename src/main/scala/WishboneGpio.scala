import chisel3._


// Simple Wishbone device : 8-bit in , 8-bit out
class WishboneExample extends Module {
  val wb = IO(new wishbone.WishboneIO(addrWidth = 1, dataWidth = 32))
  val io = IO(new Bundle {
    val in = Input(UInt (8.W))
    val out = Output(UInt (8.W))
  })

  val outReg = RegInit(0.U(8.W))
  // wishbone combinational ack generation
  wb.ack := wb.cyc && wb.stb
  io.out := outReg
  // input with two FFs to contain meta stability
  wb.dout := RegNext(RegNext(io.in))
  // Wishbone write
  when(wb.cyc && wb.stb && wb.we) {
    outReg := wb.din
  }
}
