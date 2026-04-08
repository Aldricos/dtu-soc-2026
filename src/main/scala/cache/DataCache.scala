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
  val NUM_WORDS = 64
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
  val validArray = RegInit(VecInit(Seq.fill(NUM_WORDS)(false.B)))
  val tagArray   = Reg(Vec(NUM_WORDS, UInt(TAG_BITS.W)))

  // OpenRam Module
  // Used Guide:
  // https://armleo-openlane.readthedocs.io/en/merge-window-4/tutorials/openram.html
  val dataRam = Module(new OpenRamSP_64x32("sky130_sram_256byte_1r1w_32x64_6.v"))
  dataRam.io.clk   := clock
  dataRam.io.rst_n := !reset.asBool

  dataRam.io.en    := false.B
  dataRam.io.we    := false.B
  dataRam.io.wmask := 0.U
  dataRam.io.addr  := 0.U
  dataRam.io.wdata := 0.U

  // Power pins
  dataRam.io.vccd1 := 0.U
  dataRam.io.vssd1 := 0.U

  val sIdle :: sHitRead :: sMiss :: Nil = Enum(3)
  val state = RegInit(sIdle)

  val missAddrReg  = Reg(UInt(BIT_WIDTH.W))
  val missIndexReg = Reg(UInt(INDEX_BITS.W))
  val missTagReg   = Reg(UInt(TAG_BITS.W))

  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(ADDR_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  val hit = validArray(index) && (tagArray(index) === tag)
  val hitIndexReg = Reg(UInt(INDEX_BITS.W))

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
          hitIndexReg := index
          dataRam.io.en   := true.B
          dataRam.io.we   := false.B
          dataRam.io.addr := index

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
      io.cpuIO.rdData := dataRam.io.rdata
      io.cpuIO.stall  := false.B
      state := sIdle
    }

    is(sMiss) {
      io.memIO.address := missAddrReg
      io.memIO.rd      := true.B

      when(!io.memIO.stall) {
        dataRam.io.en    := true.B
        dataRam.io.we    := true.B
        dataRam.io.wmask := "b1111".U
        dataRam.io.addr  := missIndexReg
        dataRam.io.wdata := io.memIO.rdData

        tagArray(missIndexReg)   := missTagReg
        validArray(missIndexReg) := true.B

        io.cpuIO.rdData := io.memIO.rdData
        io.cpuIO.stall  := false.B
        state := sIdle
      }
    }
  }
}