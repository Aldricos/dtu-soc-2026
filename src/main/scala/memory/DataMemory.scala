package memory

import chisel3._
import chisel3.util._
import OpenRam._

import soc._

class DataMemory() extends Module {
  val io = IO(PipeCon(32))

  // Four byte-wide SRAMs:
  val bank0 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8()) // bank0 = bits  7:0
  val bank1 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8()) // bank1 = bits 15:8
  val bank2 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8()) // bank2 = bits 23:16
  val bank3 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8()) // bank3 = bits 31:24

  val banks = Seq(bank0, bank1, bank2, bank3)

  // 4 kB total = 1024 words
  // word address selects one 32-bit word
  val wordAddr = io.address(11, 2)

  // -----------------------------
  // Default connections for all banks
  // -----------------------------
  for (bank <- banks) {
    // Port 0: RW
    bank.io.clk0   := clock
    bank.io.csb0   := true.B
    bank.io.web0   := true.B
    bank.io.wmask0 := 0.U
    bank.io.addr0  := 0.U
    bank.io.din0   := 0.U

    // Port 1: R
    bank.io.clk1   := clock
    bank.io.csb1   := true.B
    bank.io.addr1  := 0.U
  }

  // -----------------------------
  // Read path
  // -----------------------------
  when(io.rd) {
    bank0.io.csb1  := false.B
    bank0.io.addr1 := wordAddr

    bank1.io.csb1  := false.B
    bank1.io.addr1 := wordAddr

    bank2.io.csb1  := false.B
    bank2.io.addr1 := wordAddr

    bank3.io.csb1  := false.B
    bank3.io.addr1 := wordAddr
  }

  io.rdData := bank3.io.dout1 ## bank2.io.dout1 ## bank1.io.dout1 ## bank0.io.dout1

  // -----------------------------
  // Write path
  // -----------------------------
  when(io.wr) {
    when(io.wrMask(0)) {
      bank0.io.csb0   := false.B
      bank0.io.web0   := false.B
      bank0.io.wmask0 := 1.U
      bank0.io.addr0  := wordAddr
      bank0.io.din0   := io.wrData(7, 0)
    }

    when(io.wrMask(1)) {
      bank1.io.csb0   := false.B
      bank1.io.web0   := false.B
      bank1.io.wmask0 := 1.U
      bank1.io.addr0  := wordAddr
      bank1.io.din0   := io.wrData(15, 8)
    }

    when(io.wrMask(2)) {
      bank2.io.csb0   := false.B
      bank2.io.web0   := false.B
      bank2.io.wmask0 := 1.U
      bank2.io.addr0  := wordAddr
      bank2.io.din0   := io.wrData(23, 16)
    }

    when(io.wrMask(3)) {
      bank3.io.csb0   := false.B
      bank3.io.web0   := false.B
      bank3.io.wmask0 := 1.U
      bank3.io.addr0  := wordAddr
      bank3.io.din0   := io.wrData(31, 24)
    }
  }

  // -----------------------------
  // Ack
  // -----------------------------
  io.ack := RegNext(io.rd || io.wr, false.B)
}
