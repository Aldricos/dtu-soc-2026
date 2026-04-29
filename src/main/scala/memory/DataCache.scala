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
  val BIT_WIDTH   = 32
  val ADDR_WIDTH  = 28 // local address width inside 0xe000_0000 - 0xefff_ffff
  val INDEX_BITS  = log2Ceil(NUM_WORDS) // 8
  val OFFSET_BITS = 2                   // 32-bit word offset
  val TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS // 18

  val io = IO(new Bundle {
    val cpuIO = new PipeCon(32)
    val memIO = Flipped(new PipeCon(32))
  })

  // ------------------------------------------------
  // Address decoding
  // CPU address: 0xeXXX_XXXX
  //
  // Inside the cache we ignore the high nibble and use:
  // localAddr = address(27, 0)
  //
  // index = localAddr(9, 2)
  // tag   = localAddr(27, 10)
  // ------------------------------------------------
  val localAddr = io.cpuIO.address(ADDR_WIDTH - 1, 0)
  val reqIndex  = localAddr(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val reqTag    = localAddr(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  def backingAddress(addr: UInt): UInt = {
    // Strip the memory-map nibble 0xe before sending to backing memory.
    // If your SpiFlashController expects the full 0xe... address instead,
    // replace this with simply: addr
    Cat(0.U(4.W), addr(27, 0))
  }

  // ------------------------------------------------
  // Registers
  // ------------------------------------------------
  val initCounter = RegInit(0.U(INDEX_BITS.W))

  val addrReg    = Reg(UInt(32.W))
  val indexReg   = Reg(UInt(INDEX_BITS.W))
  val tagReg     = Reg(UInt(TAG_BITS.W))
  val wrDataReg  = Reg(UInt(32.W))
  val wrMaskReg  = Reg(UInt(4.W))
  val isWriteReg = Reg(Bool())
  val hitReg     = Reg(Bool())

  // rdDataReg holds the last returned read value.
  // ackReg pulses for one cycle after a read/write response is ready.
  val rdDataReg  = RegInit(0.U(32.W))
  val ackReg     = RegInit(false.B)

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

  val metaOut   = metaRam.io.dout1
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
  // FSM
  // ------------------------------------------------

  // FSM States
  val sInit :: sIdle :: sMetaRead :: sCheckHit :: sDataRead :: sDataWait :: sHitRead :: sReadMiss :: sWriteMem :: sWriteCache :: Nil = Enum(10)
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
      when((io.cpuIO.rd || io.cpuIO.wr) && !ackReg) {
        addrReg    := io.cpuIO.address
        indexReg   := reqIndex
        tagReg     := reqTag
        wrDataReg  := io.cpuIO.wrData
        wrMaskReg  := io.cpuIO.wrMask
        isWriteReg := io.cpuIO.wr

        metaRam.io.csb1  := false.B
        metaRam.io.addr1 := reqIndex

        state := sMetaRead
      }
    }

    is(sMetaRead) {
      metaRam.io.csb1  := false.B
      metaRam.io.addr1 := indexReg
      state := sCheckHit
    }

    is(sCheckHit) {
      hitReg := hit
      when(isWriteReg) {
        // Write-through: always write backing memory.
        io.memIO.address := backingAddress(addrReg)
        io.memIO.wr      := true.B
        io.memIO.wrData  := wrDataReg
        io.memIO.wrMask  := wrMaskReg
        state := sWriteMem
      }.otherwise {
        when(hit) {
          // Read hit: start synchronous data SRAM read.
          dataRam.io.csb1  := false.B
          dataRam.io.addr1 := indexReg
          state := sDataRead
        }.otherwise {
          // Read miss: fetch word from backing memory.
          io.memIO.address := backingAddress(addrReg)
          io.memIO.rd      := true.B
          state := sReadMiss
        }
      }
    }

    is(sDataRead) {
      dataRam.io.csb1  := false.B
      dataRam.io.addr1 := indexReg
      state := sDataWait
    }

    is(sDataWait) {
      dataRam.io.csb1  := false.B
      dataRam.io.addr1 := indexReg
      state := sHitRead
    }

    is(sHitRead) {
      rdDataReg := dataRam.io.dout1
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
        state := sIdle
      }
    }

    is(sWriteMem) {
      io.memIO.address := backingAddress(addrReg)
      io.memIO.wr      := true.B
      io.memIO.wrData  := wrDataReg
      io.memIO.wrMask  := wrMaskReg

      when(io.memIO.ack) {
        when(hitReg) {
          state := sWriteCache
        }.otherwise {
          ackReg := true.B
          state := sIdle
        }
      }
    }

    is(sWriteCache) {
      dataRam.io.csb0   := false.B
      dataRam.io.web0   := false.B
      dataRam.io.wmask0 := wrMaskReg
      dataRam.io.addr0  := indexReg
      dataRam.io.din0   := wrDataReg

      metaRam.io.csb0   := false.B
      metaRam.io.web0   := false.B
      metaRam.io.wmask0 := "b1111".U
      metaRam.io.addr0  := indexReg
      metaRam.io.din0   := packMeta(true.B, tagReg)

      ackReg := true.B
      state := sIdle
    }
  }
}