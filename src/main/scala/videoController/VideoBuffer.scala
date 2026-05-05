package videoController

import chisel3._
import chisel3.util._
import OpenRam.sky130_sram_1kbyte_1rw1r_32x256_8

class VideoBuffer extends Module {
  val io = IO(new Bundle {
    val addr0 = Input(UInt(9.W))
    val din0 = Input(UInt(8.W))
    val we0 = Input(Bool())

    val addr1 = Input(UInt(12.W))
    val dout1 = Output(UInt(8.W))
  })

  val mem = Module(new sky130_sram_1kbyte_1rw1r_32x256_8)

  // Wildcat write port
  mem.io.clk0 := clock
  mem.io.csb0 := false.B
  mem.io.web0 := !io.we0
  mem.io.wmask0 := 0.U
  mem.io.addr0 := io.addr0(8,2)
  mem.io.din0 := io.din0 ## io.din0 ## io.din0 ## io.din0

  switch (io.addr0(1,0)) {
    is (0.U) { mem.io.wmask0 := "b0001".U }
    is (1.U) { mem.io.wmask0 := "b0010".U }
    is (2.U) { mem.io.wmask0 := "b0100".U }
    is (3.U) { mem.io.wmask0 := "b1000".U }
  }

  // Video read port
  mem.io.clk1 := clock
  mem.io.csb1 := false.B
  mem.io.addr1 := io.addr1(8,2)

  val dout1 = WireDefault(0.U(8.W))

  switch (RegNext(io.addr1(1,0))) {
    is (0.U) { dout1 := mem.io.dout1(7,0) }
    is (1.U) { dout1 := mem.io.dout1(15,8) }
    is (2.U) { dout1 := mem.io.dout1(23,16) }
    is (3.U) { dout1 := mem.io.dout1(31,24) }
  }

  io.dout1 := dout1
}
