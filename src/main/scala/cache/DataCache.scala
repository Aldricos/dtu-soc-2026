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
  val NUM_WORDS = 256
  val BIT_WIDTH   = 32
  val ADDR_WIDTH = 28
  val INDEX_BITS  = log2Ceil(NUM_WORDS)
  val OFFSET_BITS = 2
  val TAG_BITS    = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS


  val io = IO(new Bundle {
    val cpuIO = new CacheIO
    val memIO = Flipped(new CacheIO)
  })


  // --- CACHE MEMORY---
  // val validArray = RegInit(VecInit(Seq.fill(NUM_WORDS)(false.B)))
  // val tagArray   = Reg(Vec(NUM_WORDS, UInt(TAG_BITS.W)))

  // OpenRam Module
  // Used Guide:
  // https://armleo-openlane.readthedocs.io/en/merge-window-4/tutorials/openram.html
  val dataRam = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())
  dataRam.io.clk0 := clock
  dataRam.io.csb0 := true.B
  dataRam.io.web0 := true.B
  dataRam.io.wmask0 := 0.U
  dataRam.io.addr0 := 0.U
  dataRam.io.din0 := 0.U

  // Port 1: R
  dataRam.io.clk1 := clock
  dataRam.io.csb1 := true.B
  dataRam.io.addr1 := 0.U

  val sIdle :: sHitRead :: sMiss :: Nil = Enum(3)
  val state = RegInit(sIdle)

  val missAddrReg  = Reg(UInt(32.W))
  val missIndexReg = Reg(UInt(INDEX_BITS.W))
  val missTagReg   = Reg(UInt(TAG_BITS.W))

  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  val hit = true.B // validArray(index) && (tagArray(index) === tag)

  io.cpuIO.rdData := 0.U
  io.cpuIO.stall  := true.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U

  switch(state) {
    is(sIdle) {
      when(io.cpuIO.rd) {
        when(hit) {
          // Use read-only port 1 for cache hit reads
          dataRam.io.csb1  := false.B
          dataRam.io.addr1 := index

          state := sHitRead
        }.otherwise {
          missAddrReg  := io.cpuIO.address
          missIndexReg := index
          missTagReg   := tag

          io.memIO.address := io.cpuIO.address
          io.memIO.rd      := true.B

          state := sMiss
        }
      }.otherwise {
        io.cpuIO.stall := false.B
      }
    }

    is(sHitRead) {
      // Data from port 1 read
      io.cpuIO.rdData := dataRam.io.dout1
      io.cpuIO.stall  := false.B
      state := sIdle
    }

    is(sMiss) {
      io.memIO.address := missAddrReg
      io.memIO.rd      := true.B

      when(!io.memIO.stall) {
        // Refill cache line through RW port 0 as a write
        dataRam.io.csb0   := false.B
        dataRam.io.web0   := false.B          // write enable is active low
        dataRam.io.wmask0 := "b1111".U
        dataRam.io.addr0  := missIndexReg
        dataRam.io.din0   := io.memIO.rdData

        // tagArray(missIndexReg)   := missTagReg
        // validArray(missIndexReg) := true.B

        io.cpuIO.rdData := io.memIO.rdData
        io.cpuIO.stall  := false.B
        state := sIdle
      }
    }
  }
}