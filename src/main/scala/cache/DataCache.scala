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

package cache

import chisel3._
import chisel3.util._
import OpenRam._

class DataCache() extends Module {
  val NUM_LINES   = 128
  val BIT_WIDTH   = 32
  val ADDR_WIDTH  = 28
  val INDEX_BITS  = log2Ceil(NUM_LINES)   // 7
  val OFFSET_BITS = 2                     // byte offset within 32-bit word
  val TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS // 19

  // SRAM layout:
  //   0 .. 127   : data array
  //   128 .. 255 : metadata array (valid + tag)
  val META_BASE = NUM_LINES

  val io = IO(new Bundle {
    val cpuIO = new CacheIO
    val memIO = Flipped(new CacheIO)
  })

  val dataRam = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  // -----------------------------
  // Default SRAM port assignments
  // -----------------------------
  // Port 0: RW
  dataRam.io.clk0   := clock
  dataRam.io.csb0   := true.B
  dataRam.io.web0   := true.B
  dataRam.io.wmask0 := 0.U
  dataRam.io.addr0  := 0.U
  dataRam.io.din0   := 0.U

  // Port 1: R
  dataRam.io.clk1  := clock
  dataRam.io.csb1  := true.B
  dataRam.io.addr1 := 0.U

  // -----------------------------
  // State machine
  // -----------------------------
  val sIdle :: sLookupMeta :: sReadData :: sMissWaitMem :: sMissWriteData :: sMissWriteMeta :: Nil = Enum(6)
  val state = RegInit(sIdle)

  // -----------------------------
  // Request / refill registers
  // -----------------------------
  val reqAddrReg    = Reg(UInt(32.W))
  val reqIndexReg   = Reg(UInt(INDEX_BITS.W))
  val reqTagReg     = Reg(UInt(TAG_BITS.W))
  val refillDataReg = Reg(UInt(32.W))

  // CPU address decode
  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  // Metadata format:
  // bit 0          : valid
  // bits TAG_BITS:1: tag
  // upper bits     : unused
  def packMeta(valid: Bool, tag: UInt): UInt = {
    Cat(0.U((32 - 1 - TAG_BITS).W), tag, valid)
  }

  val metaOut   = dataRam.io.dout1
  val metaValid = metaOut(0)
  val metaTag   = metaOut(TAG_BITS, 1)
  val metaHit   = metaValid && (metaTag === reqTagReg)

  // -----------------------------
  // Default IO assignments
  // -----------------------------
  io.cpuIO.rdData := 0.U
  io.cpuIO.stall  := true.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U

  // -----------------------------
  // FSM
  // -----------------------------
  switch(state) {
    is(sIdle) {
      when(io.cpuIO.rd) {
        reqAddrReg  := io.cpuIO.address
        reqIndexReg := index
        reqTagReg   := tag

        // Read metadata from SRAM upper half
        dataRam.io.csb1  := false.B
        dataRam.io.addr1 := (META_BASE.U + index)

        state := sLookupMeta
      }.otherwise {
        // No request, no stall
        io.cpuIO.stall := false.B
      }
    }

    is(sLookupMeta) {
      // metaOut now contains metadata word read last cycle
      when(metaHit) {
        // On hit, read data from SRAM lower half
        dataRam.io.csb1  := false.B
        dataRam.io.addr1 := reqIndexReg

        state := sReadData
      }.otherwise {
        // Cache miss: request off-chip memory
        io.memIO.address := reqAddrReg
        io.memIO.rd      := true.B

        state := sMissWaitMem
      }
    }

    is(sReadData) {
      // Data arrives from read-only port
      io.cpuIO.rdData := dataRam.io.dout1
      io.cpuIO.stall  := false.B
      state := sIdle
    }

    is(sMissWaitMem) {
      io.memIO.address := reqAddrReg
      io.memIO.rd      := true.B

      when(!io.memIO.stall) {
        refillDataReg := io.memIO.rdData
        state := sMissWriteData
      }
    }

    is(sMissWriteData) {
      // Write fetched data into data region
      dataRam.io.csb0   := false.B
      dataRam.io.web0   := false.B          // active low write enable
      dataRam.io.wmask0 := "b1111".U
      dataRam.io.addr0  := reqIndexReg
      dataRam.io.din0   := refillDataReg

      state := sMissWriteMeta
    }

    is(sMissWriteMeta) {
      // Write valid + tag into metadata region
      dataRam.io.csb0   := false.B
      dataRam.io.web0   := false.B
      dataRam.io.wmask0 := "b1111".U
      dataRam.io.addr0  := (META_BASE.U + reqIndexReg)
      dataRam.io.din0   := packMeta(true.B, reqTagReg)

      // Return refill data directly to CPU
      io.cpuIO.rdData := refillDataReg
      io.cpuIO.stall  := false.B

      state := sIdle
    }
  }
}