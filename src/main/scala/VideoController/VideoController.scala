package videoController

import chisel3._
import chisel3.util._

/**
  * TODO: write summary
  */
class VideoController extends Module {
  val io = IO(new Bundle {
    val address = Input(UInt(12.W))
    val wrData = Input(UInt(8.W))
    val wr = Input(Bool())

    val video = Output(UInt(8.W))
  })

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
  terminal.io.xPos := horizontal
  terminal.io.yPos := vertical
  terminal.io.address := io.address
  terminal.io.wrData := io.wrData
  terminal.io.wr := io.wr

  val red = Mux(videoActive, terminal.io.red, 0.U)
  val green = Mux(videoActive, terminal.io.green, 0.U)
  val blue = Mux(videoActive, terminal.io.blue, 0.U)

  io.video := RegNext(RegNext(hSync ## vSync) ## red ## green ## blue)
}

object VideoController extends App {
  emitVerilog(
    new VideoController(), 
    Array("--target-dir", "verilog/rtl")
  )
}
