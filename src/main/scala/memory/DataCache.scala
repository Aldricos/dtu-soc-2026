/**
 * This file is an extension of the RISC-V Wildcat
 * implementation in Caravel.
 *
 * This is the implementation of a simple Data Cache
 * which purpose is to act as a bridge between the
 * Processor and an off-chip memory.
 *
 * Author: Group 0 (Mads, Filippo, Bertram, & Mathias)
 */

package memory

import chisel3._
import chisel3.util._
import OpenRam._
import soc.PipeCon

class DataCache() extends Module {
  val NUM_WORDS   = 256
  val ADDR_WIDTH  = 28
  val INDEX_BITS  = log2Ceil(NUM_WORDS)
  val OFFSET_BITS = 2
  val TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS

  val io = IO(new Bundle {
    val cpuIO = new PipeCon(32)
    val memIO = Flipped(new PipeCon(32))
  })

  // ------------------------------------------------
  // Address decoding
  // ------------------------------------------------
  val localAddr = io.cpuIO.address(ADDR_WIDTH - 1, 0)
  val reqIndex  = localAddr(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val reqTag    = localAddr(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  def backingAddress(addr: UInt): UInt = {
    // CPU cached window:
    //   0xE000_0000 - 0xE7FF_FFFF -> PSRAM A
    //   0xE800_0000 - 0xEFFF_FFFF -> PSRAM B

    val deviceNibble = Mux(
      addr(27),
      "h2".U(4.W), // PSRAM B
      "h1".U(4.W)  // PSRAM A
    )

    // Remove selector bit from chip-internal address.
    Cat(deviceNibble, 0.U(1.W), addr(26, 0))
  }

  // ------------------------------------------------
  // Registers
  // ------------------------------------------------
  val initCounter = RegInit(0.U(INDEX_BITS.W))

  val addrReg  = Reg(UInt(32.W))
  val indexReg = Reg(UInt(INDEX_BITS.W))
  val tagReg   = Reg(UInt(TAG_BITS.W))

  val rdDataReg = RegInit(0.U(32.W))
  val ackReg    = RegInit(false.B)

  // ------------------------------------------------
  // Data SRAM
  // ------------------------------------------------
  val dataRam = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  dataRam.io.clk0   := clock
  dataRam.io.csb0   := true.B
  dataRam.io.web0   := true.B
  dataRam.io.wmask0 := 0.U
  dataRam.io.addr0  := 0.U
  dataRam.io.din0   := 0.U

  dataRam.io.clk1   := clock
  dataRam.io.csb1   := true.B
  dataRam.io.addr1  := 0.U

  // ------------------------------------------------
  // Metadata SRAM
  // bit 0           : valid
  // bits TAG_BITS:1 : tag
  // upper bits      : unused
  // ------------------------------------------------
  val metaRam = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  metaRam.io.clk0   := clock
  metaRam.io.csb0   := true.B
  metaRam.io.web0   := true.B
  metaRam.io.wmask0 := 0.U
  metaRam.io.addr0  := 0.U
  metaRam.io.din0   := 0.U

  metaRam.io.clk1   := clock
  metaRam.io.csb1   := true.B
  metaRam.io.addr1  := 0.U

  def packMeta(valid: Bool, tag: UInt): UInt = {
    Cat(0.U((32 - 1 - TAG_BITS).W), tag, valid)
  }

  val metaOut   = metaRam.io.dout0
  val metaValid = metaOut(0)
  val metaTag   = metaOut(TAG_BITS, 1)
  val hit       = metaValid && (metaTag === tagReg)

  // ------------------------------------------------
  // Defaults
  // ------------------------------------------------
  io.cpuIO.rdData := rdDataReg
  io.cpuIO.ack    := ackReg

  ackReg := false.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U
  io.memIO.wrMask  := 0.U

  // ------------------------------------------------
  // Read-only cache FSM
  // ------------------------------------------------
  val sInit :: sIdle :: sMetaRead :: sCheckHit :: sDataRead :: sDataWait :: sHitRead :: sReadMiss :: Nil = Enum(8)
  val state = RegInit(sInit)

  switch(state) {
    is(sInit) {
      metaRam.io.csb0   := false.B
      metaRam.io.web0   := false.B
      metaRam.io.wmask0 := "b1111".U
      metaRam.io.addr0  := initCounter
      metaRam.io.din0   := 0.U

      when(initCounter >= (NUM_WORDS - 1).U) {
        state := sIdle
      }.otherwise {
        initCounter := initCounter + 1.U
      }
    }

    is(sIdle) {
      when(io.cpuIO.rd) {
        addrReg  := io.cpuIO.address
        indexReg := reqIndex
        tagReg   := reqTag

        metaRam.io.csb0  := false.B
        metaRam.io.web0  := true.B
        metaRam.io.addr0 := reqIndex

        state := sMetaRead
      }.elsewhen(io.cpuIO.wr) {
        // Read-only cache: ignore writes but acknowledge them
        // so the CPU cannot hang if a write reaches this module.
        rdDataReg := 0.U
        ackReg    := true.B
        state     := sIdle
      }
    }

    is(sMetaRead) {
      metaRam.io.csb0  := false.B
      metaRam.io.web0  := true.B
      metaRam.io.addr0 := indexReg

      state := sCheckHit
    }

    is(sCheckHit) {
      when(hit) {
        dataRam.io.csb0  := false.B
        dataRam.io.web0  := true.B
        dataRam.io.addr0 := indexReg

        state := sDataRead
      }.otherwise {
        io.memIO.address := backingAddress(addrReg)
        io.memIO.rd      := true.B

        state := sReadMiss
      }
    }

    is(sDataRead) {
      dataRam.io.csb0  := false.B
      dataRam.io.web0  := true.B
      dataRam.io.addr0 := indexReg

      state := sDataWait
    }

    is(sDataWait) {
      dataRam.io.csb0  := false.B
      dataRam.io.web0  := true.B
      dataRam.io.addr0 := indexReg

      state := sHitRead
    }

    is(sHitRead) {
      rdDataReg := dataRam.io.dout0
      ackReg    := true.B
      state     := sIdle
    }

    is(sReadMiss) {
      io.memIO.address := backingAddress(addrReg)
      io.memIO.rd      := true.B

      when(io.memIO.ack) {
        dataRam.io.csb0   := false.B
        dataRam.io.web0   := false.B
        dataRam.io.wmask0 := "b1111".U
        dataRam.io.addr0  := indexReg
        dataRam.io.din0   := io.memIO.rdData

        metaRam.io.csb0   := false.B
        metaRam.io.web0   := false.B
        metaRam.io.wmask0 := "b1111".U
        metaRam.io.addr0  := indexReg
        metaRam.io.din0   := packMeta(true.B, tagReg)

        rdDataReg := io.memIO.rdData
        ackReg    := true.B
        state     := sIdle
      }
    }
  }
}

object DataCache extends App {
  emitVerilog(
    new DataCache(),
    Array("--target-dir", "verilog/rtl")
  )
}