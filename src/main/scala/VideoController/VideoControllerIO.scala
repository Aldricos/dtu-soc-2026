package videoController

import chisel3._
import chisel3.util._

class VideoControllerIO extends Bundle {
  val red = Output(UInt(2.W))
  val green = Output(UInt(2.W))
  val blue = Output(UInt(2.W))
  val hSync = Output(Bool())
  val vSync = Output(Bool())
}
