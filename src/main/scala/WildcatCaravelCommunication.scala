import chisel3._
import chisel3.util._
import wishbone.WishboneIO

/**
  * Wishbone n-bit GPIO peripheral with 3 registers:
  * - input register at address 0x0 (read-only)
  * - output register at address 0x4 (read-write)
  * - oeb register at address 0x8 (read-write) (1 = input, 0 = output)
  */
class WildcatCaravelCommunication() extends Module {

  // we only need 2 bits to address the 2 registers (input, output)
  val WB_ADDR_WIDTH = 2

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val io = IO(new Bundle {
    val fromWildcat = Input(UInt (32.W))
    val toWildcat = Output(UInt (32.W))
    val wildcatWriteValid = Input(Bool())
  })

  // register to hold outputs
  val toWildcatReg = RegInit(0.U(32.W)) 
  val toCaravelReg = RegInit(0.U(32.W))

  // wishbone acknowledge register
  val ackReg = RegInit(0.B)
  when(ackReg) {
    ackReg := 0.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := 1.B
  }

  // address decoding for the registers
  val inAccess = wb.addr === 0.U
  val outAccess = wb.addr === 1.U

  // wishbone bus response logic (wishbone read)
  wb.ack := ackReg
  wb.rdData := MuxCase(0.U, Seq(
    inAccess -> toCaravelReg,
    outAccess -> toWildcatReg,
  ))

  // wishbone write logic
  when(ackReg && wb.we) {
    when(outAccess) { toWildcatReg := wb.wrData }
  }

  //wildcat write
  when(io.wildcatWriteValid) {
    toCaravelReg := io.fromWildcat
  }
  
  //wildcat read
  io.toWildcat := toWildcatReg
}