package videoController

import chisel3._
import chisel3.util._
import wishbone.WishboneIO

/**
  * TODO: write summary
  */
class VideoController extends Module {
  val io = IO(new VideoControllerIO)

  val horizontal = RegInit(0.U(log2Up(VgaConstants.H_TOTAL).W))
  val vertical = RegInit(0.U(log2Up(VgaConstants.V_TOTAL).W))

  val newLine = horizontal >= (VgaConstants.H_TOTAL - 1).U
  val newFrame = vertical >= (VgaConstants.V_TOTAL - 1).U
  horizontal := Mux(newLine, 0.U, horizontal + 1.U)
  vertical := Mux(newFrame, 0.U, Mux(newLine, vertical + 1.U, vertical))

  val hSync = horizontal < (VgaConstants.H_ACTIVE_VIDEO + VgaConstants.H_FRONT_PORCH).U || horizontal > (VgaConstants.H_ACTIVE_VIDEO + VgaConstants.H_FRONT_PORCH + VgaConstants.H_SYNC_PULSE).U
  val vSync = vertical < (VgaConstants.V_ACTIVE_VIDEO + VgaConstants.V_FRONT_PORCH).U || vertical > (VgaConstants.V_ACTIVE_VIDEO + VgaConstants.V_FRONT_PORCH + VgaConstants.V_SYNC_PULSE).U

  val videoActive = horizontal < VgaConstants.H_ACTIVE_VIDEO.U && vertical < VgaConstants.V_ACTIVE_VIDEO.U

  val terminal = Module(new Terminal)
  terminal.io.horizontal := horizontal
  terminal.io.vertical := vertical

  io.hSync := RegNext(hSync)
  io.vSync := RegNext(vSync)
  io.red := RegNext(Mux(videoActive, terminal.io.red, 0.U))
  io.green := RegNext(Mux(videoActive, terminal.io.green, 0.U))
  io.blue := RegNext(Mux(videoActive, terminal.io.blue, 0.U))
}

object VideoController extends App {
  emitVerilog(
    new VideoController(), 
    Array("--target-dir", "verilog/rtl")
  )
}
