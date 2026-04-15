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
  val rdDataReg = RegInit(0.U(32.W))

  wb.ack    := ackReg
  wb.rdData := rdDataReg

  val word_addr   = wb.addr(N-1,0)
  val valid_addr  = word_addr < depth.U
  val byteMask = Cat(
    Fill(8, wb.sel(3)),
    Fill(8, wb.sel(2)),
    Fill(8, wb.sel(1)),
    Fill(8, wb.sel(0))
  )

  when(ackReg) {
    ackReg := false.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := true.B
  }
  // when(wb.cyc && wb.stb && ackReg) {
  //   addrReg   := word_addr
  //   wrDataReg := wb.wrData
  //   maskReg   := byteMask
  //   weReg     := wb.we
  //   validReg  := valid_addr
  // }

  val oldData = mem.read(word_addr)
  val newData = Mux(wb.we,
  wb.wrData & byteMask,
  oldData   & byteMask
)

  when(ackReg) {
    when(valid_addr) {
      when(wb.we) {
        mem.write(word_addr, newData)
      }.otherwise {
        rdDataReg := newData
      }
    }.otherwise {
      rdDataReg := 0.U
    }
  }
}