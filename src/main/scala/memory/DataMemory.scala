package memory

import chisel3._
import chisel3.util._
import OpenRam._

import soc._

class DataMemory() extends Module {
  val io = IO(PipeCon(32))

  // One 32-bit-wide SRAM, 256 words deep, byte-write mask
  val bank = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())

  // 256 words => 8-bit word address
  val wordAddr = io.address(9, 2)

  // Default connections
  bank.io.clk0   := clock
  bank.io.csb0   := true.B
  bank.io.web0   := true.B
  bank.io.wmask0 := 0.U
  bank.io.addr0  := 0.U
  bank.io.din0   := 0.U

  bank.io.clk1   := clock
  bank.io.csb1   := true.B
  bank.io.addr1  := 0.U

  // Read path
  when(io.rd) {
    bank.io.csb1  := false.B
    bank.io.addr1 := wordAddr
  }

  io.rdData := bank.io.dout1

  // Write path
  when(io.wr) {
    bank.io.csb0   := false.B
    bank.io.web0   := false.B
    bank.io.wmask0 := io.wrMask
    bank.io.addr0  := wordAddr
    bank.io.din0   := io.wrData
  }

  // Ack
  io.ack := RegNext(io.rd || io.wr, false.B)
}