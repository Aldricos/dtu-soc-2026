import OpenRam._
import chisel3._
import soc._
import wishbone.WishboneIO
import chisel3.util._
/**
 * Instruction RAM.
 * - PipeCon interface for CPU instruction fetch
 * - Wishbone port for Caravel programming
 */
class WishboneInstrRam extends Module {
  val io = IO(new Bundle {
    val cpu = PipeCon(32)
    val wb  = Flipped(new WishboneIO(32))
    val reset = Input(Bool())
  })

  val ram = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  ram.io.clk0 := clock
  ram.io.clk1 := clock

  val wbActive = io.wb.cyc && io.wb.stb
  // Wishbone RW: Port 0
  ram.io.csb0   := !(wbActive)
  ram.io.web0   := !(io.wb.we && wbActive)
  ram.io.addr0  := io.wb.addr(9, 2)
  ram.io.din0   := io.wb.wrData
  ram.io.wmask0 := io.wb.sel

  val wbAck  = RegNext(wbActive, false.B)
  io.wb.ack := wbAck
  io.wb.rdData := ram.io.dout0

  // CPU (R) port: Port 1
  ram.io.csb1  := !(io.cpu.rd && !io.reset)  // Active low chip select
  ram.io.addr1 := io.cpu.address(9, 2) // 8-bit address for 1KB RAM

  val cpuAck  = RegInit(false.B)
  // Register the acknowledge
  cpuAck  := io.cpu.rd && !io.reset

  io.cpu.rdData := ram.io.dout1
  io.cpu.ack := cpuAck

  // no writes for instMem
  dontTouch(io.cpu.wr)
  dontTouch(io.cpu.wrData)
  dontTouch(io.cpu.wrMask)
}