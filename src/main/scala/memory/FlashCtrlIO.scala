package memory

import chisel3._

class FlashCtrlIO extends Bundle {
  val start = Input(Bool())
  val op = Input(UInt(3.W))
  val addr = Input(UInt(24.W))
  val wrByte = Input(UInt(8.W))
  val wrLen = Input(UInt(8.W))
  val wrPage = Input(Vec(256, UInt(8.W)))
  val device = Input(UInt(2.W))  // which chip to address: 0=flash, 1=PSRAM A, 2=PSRAM B
  val rdByte = Output(UInt(8.W))
  val busy = Output(Bool())
  val done = Output(Bool())
}

object FlashDevice {
  val Flash  = 0.U(2.W)
  val PsramA = 1.U(2.W)
  val PsramB = 2.U(2.W)
}

object FlashCtrlOp {
  val ReadWord    = 0.U(3.W)
  val WriteEnable = 1.U(3.W)
  val ProgramPage = 2.U(3.W)
  val ProgramByte = ProgramPage
  val SectorErase = 3.U(3.W)
  val ReadStatus  = 4.U(3.W)
  val WriteWord   = 5.U(3.W)  // 32-bit write via io.mem, used for PSRAM direct writes
}
