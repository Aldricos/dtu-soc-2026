package videoController

import chisel3._
import chisel3.util._
import OpenRam.sky130_sram_1kbyte_1rw1r_8x1024_8

class VideoBuffer extends Module {
  val io = IO(new Bundle {
    val addr0 = Input(UInt(12.W))
    val din0 = Input(UInt(8.W))
    val we0 = Input(Bool())

    val addr1 = Input(UInt(12.W))
    val dout1 = Output(UInt(8.W))
  })

  val mem0 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8)
  val mem1 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8)
  val mem2 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8)
  val mem3 = Module(new sky130_sram_1kbyte_1rw1r_8x1024_8)

  // Wildcat write port
  mem0.io.clk0 := clock
  mem0.io.csb0 := false.B
  mem0.io.web0 := true.B
  mem0.io.wmask0 := "b1".U
  mem0.io.addr0 := io.addr0(9,0)
  mem0.io.din0 := io.din0

  mem1.io.clk0 := clock
  mem1.io.csb0 := false.B
  mem1.io.web0 := true.B
  mem1.io.wmask0 := "b1".U
  mem1.io.addr0 := io.addr0(9,0)
  mem1.io.din0 := io.din0

  mem2.io.clk0 := clock
  mem2.io.csb0 := false.B
  mem2.io.web0 := true.B
  mem2.io.wmask0 := "b1".U
  mem2.io.addr0 := io.addr0(9,0)
  mem2.io.din0 := io.din0

  mem3.io.clk0 := clock
  mem3.io.csb0 := false.B
  mem3.io.web0 := true.B
  mem3.io.wmask0 := "b1".U
  mem3.io.addr0 := io.addr0(9,0)
  mem3.io.din0 := io.din0

  switch (io.addr0(11,10)) {
    is (0.U) { mem0.io.web0 := !io.we0 }
    is (1.U) { mem1.io.web0 := !io.we0 }
    is (2.U) { mem2.io.web0 := !io.we0 }
    is (3.U) { mem3.io.web0 := !io.we0 }
  }

  // Video read port
  mem0.io.clk1 := clock
  mem0.io.csb1 := false.B
  mem0.io.addr1 := io.addr1(9,0)

  mem1.io.clk1 := clock
  mem1.io.csb1 := false.B
  mem1.io.addr1 := io.addr1(9,0)

  mem2.io.clk1 := clock
  mem2.io.csb1 := false.B
  mem2.io.addr1 := io.addr1(9,0)

  mem3.io.clk1 := clock
  mem3.io.csb1 := false.B
  mem3.io.addr1 := io.addr1(9,0)

  val dout1 = WireDefault(0.U(8.W))

  switch (RegNext(io.addr1(11,10))) {
    is (0.U) { dout1 := mem0.io.dout1 }
    is (1.U) { dout1 := mem1.io.dout1 }
    is (2.U) { dout1 := mem2.io.dout1 }
    is (3.U) { dout1 := mem3.io.dout1 }
  }

  io.dout1 := dout1
}

