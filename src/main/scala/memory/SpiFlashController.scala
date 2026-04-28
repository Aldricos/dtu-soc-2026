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

  val sIdle :: sCmd :: sAddr :: sReadWord :: sReadByte :: sWriteByte :: sDone :: Nil = Enum(7)
  val state = RegInit(sIdle)

  val halfCycle = RegInit(false.B) // false: SCK low, true: SCK high
  val bitCount = RegInit(0.U(6.W))

  val opReg = RegInit(FlashCtrlOp.ReadWord)
  val addrReg = Reg(UInt(24.W))
  val wrByteReg = Reg(UInt(8.W))
  val rdByteReg = RegInit(0.U(8.W))
  val rdWordReg = RegInit(0.U(32.W))
  val shiftOut = RegInit(0.U(32.W))
  val shiftIn = RegInit(0.U(32.W))
  val reqFromMem = RegInit(false.B)

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

  io.spi.cs0 := true.B
  io.spi.sck := false.B
  io.spi.sd0 := shiftOut(31)

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
        reqFromMem := false.B

        when(io.ctrl.op === FlashCtrlOp.WriteEnable) {
          startShiftOut(Cat(cmdWriteEnable, 0.U(24.W)), 8)
        }.elsewhen(io.ctrl.op === FlashCtrlOp.ProgramByte) {
          startShiftOut(Cat(cmdProgram, 0.U(24.W)), 8)
        }.elsewhen(io.ctrl.op === FlashCtrlOp.SectorErase) {
          startShiftOut(Cat(cmdSectorErase, 0.U(24.W)), 8)
        }.otherwise {
          startShiftOut(Cat(cmdReadStatus, 0.U(24.W)), 8)
        }

        state := sCmd
      }.elsewhen(!io.progMode && io.mem.rd) {
        opReg := FlashCtrlOp.ReadWord
        addrReg := io.mem.address(23, 0)
        reqFromMem := true.B
        startShiftOut(Cat(cmdRead, 0.U(24.W)), 8)
        state := sCmd
      }
    }

    is(sCmd) {
      io.spi.cs0 := false.B

      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1

        when(bitCount === 0.U) {
          halfCycle := false.B

          when(opReg === FlashCtrlOp.ReadWord || opReg === FlashCtrlOp.ProgramByte || opReg === FlashCtrlOp.SectorErase) {
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
      io.spi.cs0 := false.B

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
          }.elsewhen(opReg === FlashCtrlOp.ProgramByte) {
            startShiftOut(Cat(wrByteReg, 0.U(24.W)), 8)
            state := sWriteByte
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
      io.spi.cs0 := false.B

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
      io.spi.cs0 := false.B

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

    is(sWriteByte) {
      io.spi.cs0 := false.B

      when(!halfCycle) {
        io.spi.sck := false.B
        halfCycle := true.B
      }.otherwise {
        io.spi.sck := true.B
        shiftOut := shiftOut << 1

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
