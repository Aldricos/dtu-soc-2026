package memory

import chisel3._
import chisel3.util._
import soc.PipeCon

class SpiFlashController extends Module {
  val io = IO(new Bundle {
    val mem = new PipeCon(32)   // requests from cache
    val spi = new SpiMemIO      // physical pins
  })

  val sIdle :: sCmd :: sAddr :: sRead :: sDone :: Nil = Enum(5)
  val state = RegInit(sIdle)

  val addrReg    = Reg(UInt(32.W))
  val dataReg    = Reg(UInt(32.W))
  val bitCount   = Reg(UInt(6.W))
  val shiftOut   = Reg(UInt(8.W))
  val shiftIn    = Reg(UInt(32.W))

  io.mem.rdData := dataReg
  io.mem.ack    := false.B

  io.spi.cs   := true.B
  io.spi.sck  := false.B
  io.spi.mosi := false.B

  switch(state) {
    is(sIdle) {
      when(io.mem.rd) {
        addrReg  := io.mem.address
        shiftOut := "h03".U // standard SPI read command
        bitCount := 7.U
        state    := sCmd
      }
    }

    is(sCmd) {
      io.spi.cs   := false.B
      io.spi.mosi := shiftOut(bitCount(2,0))
      io.spi.sck  := true.B
      when(bitCount === 0.U) {
        bitCount := 23.U
        state := sAddr
      }.otherwise {
        bitCount := bitCount - 1.U
      }
    }

    is(sAddr) {
      io.spi.cs   := false.B
      io.spi.mosi := addrReg(bitCount(4,0))
      io.spi.sck  := true.B
      when(bitCount === 0.U) {
        bitCount := 31.U
        shiftIn := 0.U
        state := sRead
      }.otherwise {
        bitCount := bitCount - 1.U
      }
    }

    is(sRead) {
      io.spi.cs  := false.B
      io.spi.sck := true.B
      shiftIn := Cat(shiftIn(30,0), io.spi.miso)
      when(bitCount === 0.U) {
        dataReg := Cat(shiftIn(30,0), io.spi.miso)
        state := sDone
      }.otherwise {
        bitCount := bitCount - 1.U
      }
    }

    is(sDone) {
      io.mem.ack := true.B
      state := sIdle
    }
  }
}