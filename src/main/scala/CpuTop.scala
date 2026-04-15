import chisel.lib.uart._
import chisel3._
import wildcat.Util
import wildcat.pipeline._
import cache._
import videoController.VideoController


/*
 * This file is a modification of the RISC-V processor Wildcat
 * for implementation in Caravel.
 *
 * This is the top-level for a three stage pipeline.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 * Edited by F26 02118
 *
 */
class CpuTop(file: String, dmemNrByte: Int = 16) extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
    val video = Output(UInt(8.W))
  })

  val (memory, start) = Util.getCode(file)

  val cpu = Module(new ThreeCats())
  val dmem = Module(new ScratchPadMem(memory, nrBytes = dmemNrByte))
  val imem = Module(new InstructionROM(memory))
  val cache = Module(new DataCache())

  cpu.io.imem <> imem.io

  // ------------------------------------------------
  // Memory Connections
  // ------------------------------------------------
  // Memory Registers
  val memAddrReg   = RegNext(cpu.io.dmem.address)
  val memRdReg     = RegNext(cpu.io.dmem.rd, false.B)
  val memWrReg     = RegNext(cpu.io.dmem.wr, false.B)
  val memWrDataReg = RegNext(cpu.io.dmem.wrData)
  val memWrMaskReg = RegNext(cpu.io.dmem.wrMask)

  // Default CPU outputs
  cpu.io.dmem.rdData := 0.U
  cpu.io.dmem.ack    := false.B

  // Default dmem inputs
  dmem.io.address := 0.U
  dmem.io.rd      := false.B
  dmem.io.wr      := false.B
  dmem.io.wrData  := 0.U
  dmem.io.wrMask  := 0.U

  // Default cache CPU-side inputs
  cache.io.cpuIO.address := memAddrReg
  cache.io.cpuIO.rd      := false.B
  cache.io.cpuIO.wr      := false.B
  cache.io.cpuIO.wrData  := memWrDataReg
  cache.io.cpuIO.wrMask  := memWrMaskReg

  // Default cache backing-memory inputs
  cache.io.memIO.rdData := 0.U
  cache.io.memIO.ack    := false.B


  // Here IO stuff
  // IO is mapped ot 0xf000_0000
  // use lower bits to select IOs

  // UART:
  // 0xf000_0000 status:
  // bit 0 TX ready (TDE)
  // bit 1 RX data available (RDF)
  // 0xf000_0004 send and receive register

  // Cache
  // 0xe000_0000 - 0xefff_ffff

  val tx = Module(new BufferedTx(100000000, 115200))
  val rx = Module(new Rx(100000000, 115200))
  io.tx := tx.io.txd
  rx.io.rxd := io.rx

  tx.io.channel.bits := cpu.io.dmem.wrData(7, 0)
  tx.io.channel.valid := false.B
  rx.io.channel.ready := false.B

  // UART 0xF
  val uartStatusReg = RegNext(rx.io.channel.valid ## tx.io.channel.ready)
  val memAddressReg = RegNext(cpu.io.dmem.address)
  when (memAddressReg(31, 28) === 0xf.U && memAddressReg(19,16) === 0.U) {
    when (memAddressReg(3, 0) === 0.U) {
      cpu.io.dmem.rdData := uartStatusReg
    } .elsewhen(memAddressReg(3, 0) === 4.U) {
      cpu.io.dmem.rdData := rx.io.channel.bits
      rx.io.channel.ready := cpu.io.dmem.rd
    }
  }

  // LED 0xF
  val ledReg = RegInit(0.U(8.W))
  when ((cpu.io.dmem.address(31, 28) === 0xf.U) && cpu.io.dmem.wr) {
    when (cpu.io.dmem.address(19,16) === 0.U && cpu.io.dmem.address(3, 0) === 4.U) {
      printf(" %c %d\n", cpu.io.dmem.wrData(7, 0), cpu.io.dmem.wrData(7, 0))
      tx.io.channel.valid := true.B
    } .elsewhen (cpu.io.dmem.address(19,16) === 1.U) {
      ledReg := cpu.io.dmem.wrData(7, 0)
    }
    dmem.io.wr := false.B
  }

  io.led := 1.U ## 0.U(7.W) ## RegNext(ledReg)

  // ------------------------------------------------
  // Memory
  // ------------------------------------------------
  when (memAddrReg(31, 28) === 0x0.U) { // DMem 0x0
    dmem.io.address := memAddrReg
    dmem.io.rd      := memRdReg
    dmem.io.wr      := memWrReg
    dmem.io.wrData  := memWrDataReg
    dmem.io.wrMask  := memWrMaskReg

    cpu.io.dmem.rdData := dmem.io.rdData
    cpu.io.dmem.ack    := dmem.io.ack
  }
  when (memAddrReg(31, 28) === 0xe.U) { // CACHE 0xE
    // CPU -> cache
    cache.io.cpuIO.address := memAddrReg
    cache.io.cpuIO.rd      := memRdReg
    cache.io.cpuIO.wr      := memWrReg
    cache.io.cpuIO.wrData  := memWrDataReg
    cache.io.cpuIO.wrMask  := memWrMaskReg

    // cache -> dmem
    dmem.io.address := cache.io.memIO.address
    dmem.io.rd      := cache.io.memIO.rd
    dmem.io.wr      := cache.io.memIO.wr
    dmem.io.wrData  := cache.io.memIO.wrData
    dmem.io.wrMask  := cache.io.memIO.wrMask

    // dmem -> cache
    cache.io.memIO.rdData := dmem.io.rdData
    cache.io.memIO.ack    := dmem.io.ack

    // cache -> CPU
    cpu.io.dmem.rdData := cache.io.cpuIO.rdData
    cpu.io.dmem.ack    := cache.io.cpuIO.ack
  }

  // Video Controller
  // 0xf200_0000
  val videoController = Module(new VideoController)
  videoController.io.address := 0.U
  videoController.io.wrData := 0.U
  videoController.io.wr := false.B
  io.video := videoController.io.video
  
  when ((cpu.io.dmem.address(31, 28) === 0xf.U) && cpu.io.dmem.address(27,24) === 0x2.U) {
    videoController.io.address := cpu.io.dmem.address(11,0)
    videoController.io.wrData := cpu.io.dmem.wrData(7, 0)
    videoController.io.wr := cpu.io.dmem.wr
  }
}

object CpuTop extends App {
  emitVerilog(new CpuTop(args(0)), Array("--target-dir", "generated"))
}