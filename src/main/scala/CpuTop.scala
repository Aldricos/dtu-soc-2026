import chisel3._
import wildcat.Util
import chisel.lib.uart._

import wildcat.pipeline._
import cache._

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
class CpuTop(file: String, dmemNrByte: Int = 4096) extends Module {
  val CACHE_LENGTH = 16

  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
  })

  val (memory, start) = Util.getCode(file)

  // Here switch between different designs
  val cpu = Module(new ThreeCats())
  // val cpu = Module(new WildFour())
  // val cpu = Module(new StandardFive())
  val dmem = Module(new ScratchPadMem(memory, nrBytes = dmemNrByte))
  val imem = Module(new InstructionROM(memory))
  val cache = Module(new DataCache(CACHE_LENGTH))

  cpu.io.dmem <> dmem.io
  cpu.io.imem <> imem.io

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

  // CACHE 0xE
  cache.io.memIO.rdData := 0.U
  cache.io.cpuIO.wr := 0.U
  cache.io.memIO.ready := 0.U
  cache.io.cpuIO.rd := 0.U
  cache.io.cpuIO.wrData := 0.U
  cache.io.cpuIO.address := 0.U
  when (cpu.io.dmem.address(31, 28) === 0xe.U) {
    cache.io.cpuIO.address := cpu.io.dmem.address
  }

}

object CpuTop extends App {
  emitVerilog(new CpuTop(args(0)), Array("--target-dir", "generated"))
}