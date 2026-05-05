package memory

import chisel3._
import chisel3.util._
import soc.PipeCon

class SpiFlashController extends Module {
  val io = IO(new Bundle {
    val mem = new PipeCon(32)
    val ctrl = new FlashCtrlIO
    val progMode = Input(Bool())
    val spi = new QspiPmodIO
  })

  val sIdle :: sCmd :: sAddr :: sReadWord :: sReadByte :: sWritePage :: sWriteWord :: sDone :: Nil = Enum(8)
  val state = RegInit(sIdle)

  val halfCycle = RegInit(false.B) // false: SCK low, true: SCK high
  val bitCount = RegInit(0.U(6.W))

  val opReg = RegInit(FlashCtrlOp.ReadWord)
  val addrReg = Reg(UInt(24.W))
  val wrByteReg = Reg(UInt(8.W))
  val wrLenReg = Reg(UInt(9.W))
  val wrIdxReg = Reg(UInt(9.W))
  val rdByteReg = RegInit(0.U(8.W))
  val rdWordReg = RegInit(0.U(32.W))
  val shiftOut = RegInit(0.U(32.W))
  val shiftIn = RegInit(0.U(32.W))
  val reqFromMem = RegInit(false.B)
  val deviceReg  = RegInit(FlashDevice.Flash)  // which CS to assert during a transaction
  val wrWordReg  = Reg(UInt(32.W))             // latches io.mem.wrData at transaction start

  val cmdRead = "h03".U(8.W)
  val cmdWriteEnable = "h06".U(8.W)
  val cmdProgram = "h02".U(8.W)
  val cmdSectorErase = "h20".U(8.W)
  val cmdReadStatus = "h05".U(8.W)

  io.mem.rdData := rdWordReg
  io.mem.ack := false.B

  io.ctrl.rdByte := rdByteReg
  io.ctrl.busy := state =/= sIdle
  io.ctrl.done := state === sDone && !reqFromMem

  // csActive is true during every state that needs a chip selected.
  // Derived from the state register so it's purely combinational — no extra cycle of latency.
  val csActive = state === sCmd || state === sAddr ||
                 state === sReadWord || state === sReadByte ||
                 state === sWritePage || state === sWriteWord

  // Each CS is active-low: pulled low only when csActive AND this chip is selected.
  io.spi.cs0 := !(csActive && (deviceReg === FlashDevice.Flash))
  io.spi.cs1 := !(csActive && (deviceReg === FlashDevice.PsramA))
  io.spi.cs2 := !(csActive && (deviceReg === FlashDevice.PsramB))

  io.spi.sck := false.B
  io.spi.sd0 := shiftOut(31)
  io.spi.sd2 := true.B
  io.spi.sd3 := true.B

  def startShiftOut(value: UInt, bits: Int): Unit = {
    shiftOut := value
    bitCount := (bits - 1).U
    halfCycle := false.B
  }

  def startShiftIn(bits: Int): Unit = {
    bitCount := (bits - 1).U
    shiftIn := 0.U
    halfCycle := false.B
  }

  switch(state) {
    is(sIdle) {
      when(io.progMode && io.ctrl.start) {
        opReg := io.ctrl.op
        addrReg := io.ctrl.addr
        wrByteReg := io.ctrl.wrByte
        wrLenReg := Mux(io.ctrl.wrLen === 0.U, 256.U, Cat(0.U(1.W), io.ctrl.wrLen))
        wrIdxReg := 0.U
        reqFromMem := false.B
        deviceReg := io.ctrl.device  // latch which chip this operation targets

        when(io.ctrl.op === FlashCtrlOp.WriteEnable) {
          startShiftOut(Cat(cmdWriteEnable, 0.U(24.W)), 8)
        }.elsewhen(io.ctrl.op === FlashCtrlOp.ProgramPage) {
          startShiftOut(Cat(cmdProgram, 0.U(24.W)), 8)
        }.elsewhen(io.ctrl.op === FlashCtrlOp.SectorErase) {
          startShiftOut(Cat(cmdSectorErase, 0.U(24.W)), 8)
        }.elsewhen(io.ctrl.op === FlashCtrlOp.ReadStatus) {
          startShiftOut(Cat(cmdReadStatus, 0.U(24.W)), 8)
        }.otherwise {
          startShiftOut(Cat(cmdRead, 0.U(24.W)), 8)
        }

        state := sCmd
      }.elsewhen(!io.progMode && io.mem.rd) {
        opReg     := FlashCtrlOp.ReadWord
        addrReg   := io.mem.address(23, 0)  // lower 24 bits are the chip-internal address
        reqFromMem := true.B
        // bits [31:28] select which chip; 0x1=PSRAM A, 0x2=PSRAM B, anything else=flash
        deviceReg := MuxCase(FlashDevice.Flash, Seq(
          (io.mem.address(31, 28) === "h1".U) -> FlashDevice.PsramA,
          (io.mem.address(31, 28) === "h2".U) -> FlashDevice.PsramB
        ))
        startShiftOut(Cat(cmdRead, 0.U(24.W)), 8)
        state := sCmd
      }.elsewhen(!io.progMode && io.mem.wr) {
        // PSRAM direct write: no write-enable needed, just 0x02 + addr + 4 bytes
        opReg      := FlashCtrlOp.WriteWord
        addrReg    := io.mem.address(23, 0)
        wrWordReg  := io.mem.wrData  // capture now — wrData is only valid this cycle
        reqFromMem := true.B
        deviceReg  := MuxCase(FlashDevice.Flash, Seq(
          (io.mem.address(31, 28) === "h1".U) -> FlashDevice.PsramA,
          (io.mem.address(31, 28) === "h2".U) -> FlashDevice.PsramB
        ))
        startShiftOut(Cat(cmdProgram, 0.U(24.W)), 8)  // 0x02: same write command as flash page program
        state := sCmd
      }
    }

    is(sCmd) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1

        when(bitCount === 0.U) {
          halfCycle := false.B

          when(opReg === FlashCtrlOp.ReadWord || opReg === FlashCtrlOp.ProgramPage ||
               opReg === FlashCtrlOp.SectorErase || opReg === FlashCtrlOp.WriteWord) {
            startShiftOut(Cat(addrReg, 0.U(8.W)), 24)
            state := sAddr
          }.elsewhen(opReg === FlashCtrlOp.ReadStatus) {
            startShiftIn(8)
            state := sReadByte
          }.otherwise {
            state := sDone
          }
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sAddr) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1

        when(bitCount === 0.U) {
          halfCycle := false.B

          when(opReg === FlashCtrlOp.ReadWord) {
            startShiftIn(32)
            state := sReadWord
          }.elsewhen(opReg === FlashCtrlOp.WriteWord) {
            startShiftOut(wrWordReg, 32)  // clock out all 4 bytes MSB-first, no page logic needed
            state := sWriteWord
          }.elsewhen(opReg === FlashCtrlOp.ProgramPage) {
            startShiftOut(Cat(io.ctrl.wrPage(0), 0.U(24.W)), 8)
            wrIdxReg := 0.U
            state := sWritePage
          }.otherwise {
            state := sDone
          }
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sReadWord) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftIn := Cat(shiftIn(30, 0), io.spi.sd1)

        when(bitCount === 0.U) {
          rdWordReg := Cat(shiftIn(30, 0), io.spi.sd1)
          halfCycle := false.B
          state := sDone
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sReadByte) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftIn := Cat(shiftIn(30, 0), io.spi.sd1)

        when(bitCount === 0.U) {
          rdByteReg := Cat(shiftIn(6, 0), io.spi.sd1)
          halfCycle := false.B
          state := sDone
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sWritePage) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1

        when(bitCount === 0.U) {
          halfCycle := false.B
          when(wrIdxReg + 1.U === wrLenReg) {
            state := sDone
          }.otherwise {
            wrIdxReg := wrIdxReg + 1.U
            startShiftOut(Cat(io.ctrl.wrPage(wrIdxReg + 1.U), 0.U(24.W)), 8)
            state := sWritePage
          }
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sWriteWord) {
      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1  // advance to next bit; sd0 is always shiftOut(31)
        when(bitCount === 0.U) {
          halfCycle := false.B
          state := sDone
        }.otherwise {
          bitCount := bitCount - 1.U
          halfCycle := false.B
        }
      }
    }

    is(sDone) {
      when(reqFromMem) {
        io.mem.ack := true.B
      }
      state := sIdle
    }
  }
}

object SpiFlashController extends App {
  emitVerilog(new SpiFlashController(), Array("--target-dir", "generated"))
}
