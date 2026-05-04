package raytracer

import chisel3._
import chisel3.util._
import OpenRam.sky130_sram_1kbyte_1rw1r_32x256_8

/** Byte FIFO using the sky130 1KB SRAM macro.
  * Producer: pixel stream from raytracer. Consumer: UART TX (or MMIO drain).
  * Overkill but reuses the macro that already has a sim model.
  */
class PixelFifo extends Module {
  val DEPTH = 1024
  val PTR_W = log2Ceil(DEPTH)

  val io = IO(new Bundle {
    val enq = Flipped(Decoupled(UInt(8.W)))
    val deq = Decoupled(UInt(8.W))
  })

  val mem = Module(new sky130_sram_1kbyte_1rw1r_32x256_8)

  // wrap bits to disambiguate empty/full
  val wrPtr  = RegInit(0.U(PTR_W.W))
  val rdPtr  = RegInit(0.U(PTR_W.W))
  val wrWrap = RegInit(false.B)
  val rdWrap = RegInit(false.B)

  val empty = (wrPtr === rdPtr) && (wrWrap === rdWrap)
  val full  = (wrPtr === rdPtr) && (wrWrap =/= rdWrap)

  io.enq.ready := !full

  // write port: byte-masked into a 32-bit word
  val wrFire = io.enq.valid && io.enq.ready
  mem.io.clk0   := clock
  mem.io.csb0   := false.B
  mem.io.web0   := !wrFire
  mem.io.addr0  := wrPtr(PTR_W - 1, 2)
  mem.io.din0   := Fill(4, io.enq.bits)
  mem.io.wmask0 := UIntToOH(wrPtr(1, 0))

  when (wrFire) {
    when (wrPtr === (DEPTH - 1).U) {
      wrPtr  := 0.U
      wrWrap := !wrWrap
    } .otherwise {
      wrPtr  := wrPtr + 1.U
    }
  }

  // read port: SRAM is sync-read so we need a small pipeline
  // sIdle -> sFetch -> sLatch -> sValid, then back to sFetch after deq.fire
  val sIdle :: sFetch :: sLatch :: sValid :: Nil = Enum(4)
  val rState   = RegInit(sIdle)
  val headByte = Reg(UInt(8.W))

  val readByteSel = Reg(UInt(2.W))

  mem.io.clk1  := clock
  mem.io.csb1  := false.B
  mem.io.addr1 := rdPtr(PTR_W - 1, 2)

  val dout1Byte = MuxLookup(readByteSel, 0.U)(Seq(
    0.U -> mem.io.dout1(7,  0),
    1.U -> mem.io.dout1(15, 8),
    2.U -> mem.io.dout1(23, 16),
    3.U -> mem.io.dout1(31, 24)
  ))

  switch (rState) {
    is (sIdle) {
      when (!empty) {
        readByteSel := rdPtr(1, 0)
        rState      := sFetch
      }
    }
    is (sFetch) {
      rState := sLatch
    }
    is (sLatch) {
      headByte := dout1Byte
      rState   := sValid
    }
    is (sValid) {
      when (io.deq.ready) {
        val nextRdPtr  = Mux(rdPtr === (DEPTH - 1).U, 0.U,         rdPtr + 1.U)
        val nextRdWrap = Mux(rdPtr === (DEPTH - 1).U, !rdWrap,     rdWrap)
        val emptyAfter = (wrPtr === nextRdPtr) && (wrWrap === nextRdWrap)

        rdPtr  := nextRdPtr
        rdWrap := nextRdWrap

        when (emptyAfter) {
          rState := sIdle
        } .otherwise {
          readByteSel := nextRdPtr(1, 0)
          rState      := sFetch
        }
      }
    }
  }

  io.deq.valid := (rState === sValid)
  io.deq.bits  := headByte
}
