package programmable_IMEM
import chisel3._
import chisel3.util._
import wishbone._
import chisel3.util.log2Floor

class programmable_IMEM(val depth: Int) extends Module {

  val N = log2Floor(depth)
  val wb = IO(Flipped(new WishboneIO(N)))
  val mem = SyncReadMem(depth, UInt(32.W))
  // Wishbone registers
  val ackReg    = RegInit(false.B)

  wb.ack    := ackReg

  val word_addr   = wb.addr(N-1,0)

  when(ackReg) {
    ackReg := false.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := true.B
  }
  val read_data = mem.read(word_addr)
  wb.rdData := read_data
  when(wb.we) {
    mem.write(word_addr, wb.wrData)
  }
}