package memory

import chisel3._
import chisel3.util._
import OpenRam._

import soc._

class DataMemory() extends Module {
  val io = IO(PipeCon(32))


  val bank = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())
  val wordAddr = io.address(9, 2)

  bank.io.clk0   := clock
  bank.io.csb0   := 0.B // always enabled, active low
  bank.io.web0   := !io.wr // active low
  bank.io.wmask0 := io.wrMask
  bank.io.addr0  := wordAddr
  bank.io.din0   := io.wrData
  io.rdData := bank.io.dout0

  bank.io.clk1   := 0.B.asClock 
  bank.io.csb1   := 1.B // always disabled, active low
  bank.io.addr1  := 0.U

  io.ack := RegNext(io.rd || io.wr, 0.B)
}