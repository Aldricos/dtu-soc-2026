import chisel3._

package object wishbone {
  class WishbonePort(val addrWidth: Int) extends Bundle {
    val stb = Input(Bool())
    val cyc = Input(Bool())
    val we = Input(Bool())
    val sel = Input(UInt(4.W))
    val dat_i = Input(UInt(32.W))
    val adr = Input(UInt(addrWidth.W))
    val dat_o = Output(UInt(32.W))
    val ack = Output(Bool())
  }
}
