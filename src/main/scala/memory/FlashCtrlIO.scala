package memory

import chisel3._

class FlashCtrlIO extends Bundle {
  val start = Input(Bool())
  val op = Input(UInt(3.W))
  val addr = Input(UInt(24.W))
  val wrByte = Input(UInt(8.W))

  val rdByte = Output(UInt(8.W))
  val busy = Output(Bool())
  val done = Output(Bool())
}

object FlashCtrlOp {
  val ReadWord = 0.U(3.W)
  val WriteEnable = 1.U(3.W)
  val ProgramByte = 2.U(3.W)
  val SectorErase = 3.U(3.W)
  val ReadStatus = 4.U(3.W)
}
