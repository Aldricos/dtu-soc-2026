import OpenRam._
import chisel3._
import soc._
import wishbone.WishboneIO

/**
 * Instruction RAM.
 * - PipeCon interface for CPU instruction fetch
 * - Wishbone port for Caravel programming
 */
class WishboneInstrRam extends Module {
  val io = IO(new Bundle {
    val cpu = PipeCon(32)
    val wb  = Flipped(new WishboneIO(32))
  })

  val ram = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  ram.io.clk0 := clock
  ram.io.clk1 := clock

  // Wishbone RW: Port 0
  val wbActive = io.wb.cyc && io.wb.stb
  ram.io.csb0 := false.B  // Active low chip select
  ram.io.web0 := io.wb.we  // Write enable
  ram.io.wmask0 := io.wb.sel
  ram.io.addr0 := io.wb.addr(7, 0)  // 8-bit address for 1KB RAM
  ram.io.din0 := io.wb.wrData

  // CPU (R) port: Port 1
  val cpuRead = io.cpu.rd
  ram.io.csb1 := !cpuRead  // Active low chip select
  ram.io.addr1 := io.cpu.address(7, 0)  // 8-bit address for 1KB RAM

  // CPU side
  val cpuAck = RegInit(false.B)
  val cpuData = Reg(UInt(32.W))

  // Register the read data and acknowledge
  cpuAck := cpuRead
  cpuData := ram.io.dout1  // CPU reads from Port 1

  io.cpu.rdData := cpuData
  io.cpu.ack := cpuAck

  // no writes for instMem
  dontTouch(io.cpu.wr)
  dontTouch(io.cpu.wrData)
  dontTouch(io.cpu.wrMask)

  // Wishbone things
  val wbAck = RegInit(false.B)
  wbAck := wbActive
  io.wb.ack := wbAck
  io.wb.rdData := ram.io.dout0  // Wishbone reads from Port 0
}