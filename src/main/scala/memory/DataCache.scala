/*
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
  val ADDR_WIDTH  = 28
  val INDEX_BITS  = log2Ceil(NUM_WORDS)
  val OFFSET_BITS = 2
  val TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS

  val io = IO(new Bundle {
    val cpuIO = new PipeCon(32)
    val memIO = Flipped(new PipeCon(32))
  })

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

  // ------------------------------------------------
  // State
  // ------------------------------------------------
  val sIdle :: sLookup :: sHitRead :: sReadMiss :: sWriteMem :: sWriteCache :: Nil = Enum(6)
  val state = RegInit(sIdle)

  // Registers
  val addrReg   = Reg(UInt(32.W))
  val indexReg  = Reg(UInt(INDEX_BITS.W))
  val tagReg    = Reg(UInt(TAG_BITS.W))
  val wrDataReg = Reg(UInt(32.W))
  val wrMaskReg = Reg(UInt(4.W))
  val isWriteReg = Reg(Bool())

  val refillDataReg = Reg(UInt(32.W))

  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  def packMeta(valid: Bool, tag: UInt): UInt = {
    Cat(0.U((32 - 1 - TAG_BITS).W), tag, valid)
  }

  val metaOut   = metaRam.io.dout1
  val metaValid = metaOut(0)
  val metaTag   = metaOut(TAG_BITS, 1)
  val hit       = metaValid && (metaTag === tagReg)

  io.cpuIO.rdData := 0.U
  io.cpuIO.ack    := false.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U
  io.memIO.wrMask  := 0.U

  switch(state) {
    is(sIdle) {
      when(io.cpuIO.rd || io.cpuIO.wr) {
        addrReg    := io.cpuIO.address
        indexReg   := index
        tagReg     := tag
        wrDataReg  := io.cpuIO.wrData
        wrMaskReg  := io.cpuIO.wrMask
        isWriteReg := io.cpuIO.wr

        // Lookup metadata first for both reads and writes
        metaRam.io.csb1  := false.B
        metaRam.io.addr1 := index

        state := sLookup
      }
    }

    is(sLookup) {
      when(isWriteReg) {
        // Write-through always writes backing memory
        io.memIO.address := addrReg
        io.memIO.wr      := true.B
        io.memIO.wrData  := wrDataReg
        io.memIO.wrMask  := wrMaskReg

        state := sWriteMem
      }.otherwise {
        when(hit) {
          // Read hit -> read cached data
          dataRam.io.csb1  := false.B
          dataRam.io.addr1 := indexReg
          state := sHitRead
        }.otherwise {
          // Read miss -> fetch from backing memory
          io.memIO.address := addrReg
          io.memIO.rd      := true.B
          state := sReadMiss
        }
      }
    }

    is(sHitRead) {
      io.cpuIO.rdData := dataRam.io.dout1
      io.cpuIO.ack    := true.B
      state := sIdle
    }

    is(sReadMiss) {
      io.memIO.address := addrReg
      io.memIO.rd      := true.B

      when(io.memIO.ack) {
        refillDataReg := io.memIO.rdData

        // Fill data cache line
        dataRam.io.csb0   := false.B
        dataRam.io.web0   := false.B
        dataRam.io.wmask0 := "b1111".U
        dataRam.io.addr0  := indexReg
        dataRam.io.din0   := io.memIO.rdData

        // Fill metadata
        metaRam.io.csb0   := false.B
        metaRam.io.web0   := false.B
        metaRam.io.wmask0 := "b1111".U
        metaRam.io.addr0  := indexReg
        metaRam.io.din0   := packMeta(true.B, tagReg)

        io.cpuIO.rdData := io.memIO.rdData
        io.cpuIO.ack    := true.B
        state := sIdle
      }
    }

    is(sWriteMem) {
      // Write-through to backing memory
      io.memIO.address := addrReg
      io.memIO.wr      := true.B
      io.memIO.wrData  := wrDataReg
      io.memIO.wrMask  := wrMaskReg

      when(io.memIO.ack) {
        state := sWriteCache
      }
    }

    is(sWriteCache) {
      // Update or allocate cache line with same write mask
      dataRam.io.csb0   := false.B
      dataRam.io.web0   := false.B
      dataRam.io.wmask0 := wrMaskReg
      dataRam.io.addr0  := indexReg
      dataRam.io.din0   := wrDataReg

      // Mark metadata valid and install tag
      metaRam.io.csb0   := false.B
      metaRam.io.web0   := false.B
      metaRam.io.wmask0 := "b1111".U
      metaRam.io.addr0  := indexReg
      metaRam.io.din0   := packMeta(true.B, tagReg)

      io.cpuIO.ack := true.B
      state := sIdle
    }
  }
}