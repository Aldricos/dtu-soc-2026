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
import soc.PipeCon
import chisel3.dontTouch


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

  // Port 1: R
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

  // Port 1: R
  metaRam.io.clk1   := clock
  metaRam.io.csb1   := true.B
  metaRam.io.addr1  := 0.U

  dontTouch(metaRam.io.dout1)
  dontTouch(metaRam.io.addr0)
  dontTouch(metaRam.io.addr1)
  dontTouch(metaRam.io.din0)
  dontTouch(metaRam.io.csb0)
  dontTouch(metaRam.io.csb1)
  dontTouch(metaRam.io.web0)

  // ------------------------------------------------
  // State
  // ------------------------------------------------
  val sIdle :: sLookup :: sHitRead :: sMiss :: Nil = Enum(4)
  val state = RegInit(sIdle)

  val missAddrReg  = Reg(UInt(32.W))
  val missIndexReg = Reg(UInt(INDEX_BITS.W))
  val missTagReg   = Reg(UInt(TAG_BITS.W))
  val refillDataReg = Reg(UInt(32.W))

  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  def packMeta(valid: Bool, tag: UInt): UInt = {
    Cat(0.U((32 - 1 - TAG_BITS).W), tag, valid)
  }

  val metaOut   = metaRam.io.dout1
  val metaValid = metaOut(0)
  val metaTag   = metaOut(TAG_BITS, 1)
  val hit       = metaValid && (metaTag === missTagReg)

  io.cpuIO.rdData := 0.U
  io.cpuIO.ack  := false.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U
  io.memIO.wrMask := 0.U

  switch(state) {
    is(sIdle) {
      when(io.cpuIO.rd) {
        missAddrReg  := io.cpuIO.address
        missIndexReg := index
        missTagReg   := tag

        // First read metadata for this index
        metaRam.io.csb1  := false.B
        metaRam.io.addr1 := index

        state := sLookup
      }
    }

    is(sLookup) {
      when(hit) {
        // Metadata says hit, so read data word
        dataRam.io.csb1  := false.B
        dataRam.io.addr1 := missIndexReg

        state := sHitRead
      }.otherwise {
        io.memIO.address := missAddrReg
        io.memIO.rd      := true.B

        state := sMiss
      }
    }

    is(sHitRead) {
      io.cpuIO.rdData := dataRam.io.dout1
      io.cpuIO.ack  := true.B
      state := sIdle
    }

    is(sMiss) {
      io.memIO.address := missAddrReg
      io.memIO.rd      := true.B

      when(io.memIO.ack) {
        refillDataReg := io.memIO.rdData

        // Write fetched data into data RAM
        dataRam.io.csb0   := false.B
        dataRam.io.web0   := false.B
        dataRam.io.wmask0 := "b1111".U
        dataRam.io.addr0  := missIndexReg
        dataRam.io.din0   := io.memIO.rdData

        // Write tag + valid into metadata RAM
        metaRam.io.csb0   := false.B
        metaRam.io.web0   := false.B
        metaRam.io.wmask0 := "b1111".U
        metaRam.io.addr0  := missIndexReg
        metaRam.io.din0   := packMeta(true.B, missTagReg)

        io.cpuIO.rdData := io.memIO.rdData
        io.cpuIO.ack  := true.B

        state := sIdle
      }
    }
  }
}