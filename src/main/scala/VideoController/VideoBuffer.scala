package videoController

import chisel3._
import chisel3.util._
import OpenRam.sky130_sram_2kbyte_1rw1r_32x512_8

class VideoBuffer extends Module {
  val io = IO(new Bundle {
    val addr0 = Input(UInt(12.W))
    val din0 = Input(UInt(8.W))
    val we0 = Input(Bool())

    val addr1 = Input(UInt(12.W))
    val dout1 = Output(UInt(8.W))
  })

  val mem0 = Module(new sky130_sram_2kbyte_1rw1r_32x512_8)
  val mem1 = Module(new sky130_sram_2kbyte_1rw1r_32x512_8)

  // Wildcat write port
  val din0_32 = io.din0 ## io.din0 ## io.din0 ## io.din0
  val wmask0 = WireDefault(0.U(4.W))

  switch (io.addr0(1,0)) {
    is (0.U) { wmask0 := "b0001".U }
    is (1.U) { wmask0 := "b0010".U }
    is (2.U) { wmask0 := "b0100".U }
    is (3.U) { wmask0 := "b1000".U }
  }

  mem0.io.clk0 := clock
  mem0.io.csb0 := false.B
  mem0.io.web0 := true.B
  mem0.io.wmask0 := wmask0
  mem0.io.addr0 := io.addr0(10,2)
  mem0.io.din0 := din0_32

  mem1.io.clk0 := clock
  mem1.io.csb0 := false.B
  mem1.io.web0 := true.B
  mem1.io.wmask0 := wmask0
  mem1.io.addr0 := io.addr0(10,2)
  mem1.io.din0 := din0_32

  when(io.addr0(11)) {
    mem1.io.web0 := !io.we0
  } .otherwise {
    mem0.io.web0 := !io.we0
  }

  // Video read port
  mem0.io.clk1 := clock
  mem0.io.csb1 := false.B
  mem0.io.addr1 := io.addr1(10,2)

  mem1.io.clk1 := clock
  mem1.io.csb1 := false.B
  mem1.io.addr1 := io.addr1(10,2)

  val dout1_32 = WireDefault(0.U(32.W))

  when (RegNext(io.addr1(11))) {
    dout1_32 := mem1.io.dout1
  } .otherwise {
    dout1_32 := mem0.io.dout1
  }

  val dout1 = WireDefault(0.U(8.W))

  switch (RegNext(io.addr1(1,0))) {
    is (0.U) { dout1 := dout1_32(7,0) }
    is (1.U) { dout1 := dout1_32(15,8) }
    is (2.U) { dout1 := dout1_32(23,16) }
    is (3.U) { dout1 := dout1_32(31,24) }
  }

  io.dout1 := dout1
}
