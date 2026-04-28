package programmable_IMEM
import chisel3._
import chisel3.util._
import wishbone._
import OpenRam._
import soc._
import wishbone.WishboneIO

class programmable_IMEM() extends Module {

  val wb = IO(Flipped(new WishboneIO(32)))
  val cpu_connection = IO(PipeCon(32))
  val cpu_enable = IO(Input(Bool()))
  
  val mem = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

    // Wishbone registers
  val ackReg    = RegInit(false.B)

  wb.ack    := ackReg

  when(ackReg) {
    ackReg := false.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := true.B
  }
  //memory connections
  mem.io.clk0 := clock
  mem.io.csb0 := !(wb.cyc && wb.stb) //wishbone chip select is active high
  mem.io.web0 := !wb.we //wishbone write enable is active high
  mem.io.wmask0 := wb.sel
  mem.io.addr0 := wb.addr(9,2)
  mem.io.din0 := wb.wrData
  wb.rdData := mem.io.dout0 

  //cpu side
  mem.io.clk1 := clock
  mem.io.csb1 := !(cpu_connection.rd && cpu_enable)
  mem.io.addr1 := cpu_connection.address(9,2)
  cpu_connection.rdData := mem.io.dout1

  // Keep the fetch port idle while the CPU is held in reset so the first
  // acknowledged read corresponds to the first post-reset fetch.
  cpu_connection.ack := RegNext(cpu_connection.rd && cpu_enable, false.B)


}
