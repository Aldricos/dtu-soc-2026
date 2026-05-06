package raytracer

import chisel3._
import chisel3.util._

/** MMIO wrapper around the raytracer + pixel FIFO.
  *
  * In CpuTop this controller is mounted at base 0xf005_0000.
  *
  * Memory map (byte offsets):
  *   0x0000 W : start (bit 0)
  *   0x0004 R : busy
  *   0x0008 R : fifo not-empty
  *   0x000C R : next pixel byte (MMIO drain mode)
  *   0x0010 RW: drain mode (0 = UART byteOut, 1 = MMIO via 0x000C)
  *   0x1000 W : CamX     (Q16.16)  default 0.0
  *   0x1004 W : CamY                default 1.0
  *   0x1008 W : CamZ                default -3.0
  *   0x100C W : SphereX  (Q16.16)  default 0.0
  *   0x1010 W : SphereY             default 1.0
  *   0x1014 W : SphereZ             default 0.0
  *   0x1018 W : Cols     (13 bits) default 32
  *   0x101C W : Rows     (13 bits) default 32
  *   0x1020 W : ScaleX   (Q16.16)  default 1/24
  *   0x1024 W : ScaleY              default 1/24
  *
  * Defaults match the original 32x32 scene so old code keeps working.
  */
class RayTracerController extends Module {
  val io = IO(new Bundle {
    val address = Input(UInt(16.W))
    val wr      = Input(Bool())
    val rd      = Input(Bool())
    val wrData  = Input(UInt(32.W))
    val wrMask  = Input(UInt(4.W))
    val rdData  = Output(UInt(32.W))
    val ack     = Output(Bool())
    val byteOut = Decoupled(UInt(8.W))
  })

  val rt = Module(new RayTracerAccelerator)
  val pf = Module(new PixelFifo)
  pf.io.enq <> rt.io.pixel

  val camXReg = RegInit(FixedPoint.lit(0.0))
  val camYReg = RegInit(FixedPoint.lit(1.0))
  val camZReg = RegInit(FixedPoint.lit(-3.0))
  val sphXReg = RegInit(FixedPoint.lit(0.0))
  val sphYReg = RegInit(FixedPoint.lit(1.0))
  val sphZReg = RegInit(FixedPoint.lit(0.0))
  val colsReg = RegInit(32.U(13.W))
  val rowsReg = RegInit(32.U(13.W))
  val sclXReg = RegInit(FixedPoint.lit(1.0 / 24.0))
  val sclYReg = RegInit(FixedPoint.lit(1.0 / 24.0))
  rt.io.camX    := camXReg
  rt.io.camY    := camYReg
  rt.io.camZ    := camZReg
  rt.io.sphereX := sphXReg
  rt.io.sphereY := sphYReg
  rt.io.sphereZ := sphZReg
  rt.io.cols    := colsReg
  rt.io.rows    := rowsReg
  rt.io.scaleX  := sclXReg
  rt.io.scaleY  := sclYReg

  val drainModeMmio = RegInit(false.B)

  val isStart    = io.address === 0x0000.U
  val isBusy     = io.address === 0x0004.U
  val isNotEmpty = io.address === 0x0008.U
  val isPixel    = io.address === 0x000C.U
  val isMode     = io.address === 0x0010.U
  val isCamX     = io.address === 0x1000.U
  val isCamY     = io.address === 0x1004.U
  val isCamZ     = io.address === 0x1008.U
  val isSphX     = io.address === 0x100C.U
  val isSphY     = io.address === 0x1010.U
  val isSphZ     = io.address === 0x1014.U
  val isCols     = io.address === 0x1018.U
  val isRows     = io.address === 0x101C.U
  val isSclX     = io.address === 0x1020.U
  val isSclY     = io.address === 0x1024.U

  // start is a pulse: caller drives wr for one cycle
  rt.io.start := io.wr && isStart && io.wrData(0)

  io.rdData := 0.U
  when (io.rd) {
    when (isBusy)         { io.rdData := rt.io.busy.asUInt }
    .elsewhen(isNotEmpty) { io.rdData := pf.io.deq.valid.asUInt }
    .elsewhen(isPixel)    { io.rdData := Mux(pf.io.deq.valid, pf.io.deq.bits, 0.U) }
    .elsewhen(isMode)     { io.rdData := drainModeMmio.asUInt }
  }

  when (io.wr) {
    when (isCamX) { camXReg := io.wrData.asSInt }
    when (isCamY) { camYReg := io.wrData.asSInt }
    when (isCamZ) { camZReg := io.wrData.asSInt }
    when (isSphX) { sphXReg := io.wrData.asSInt }
    when (isSphY) { sphYReg := io.wrData.asSInt }
    when (isSphZ) { sphZReg := io.wrData.asSInt }
    when (isCols) { colsReg := io.wrData(12, 0) }
    when (isRows) { rowsReg := io.wrData(12, 0) }
    when (isSclX) { sclXReg := io.wrData.asSInt }
    when (isSclY) { sclYReg := io.wrData.asSInt }
    when (isMode) { drainModeMmio := io.wrData(0) }
  }

  io.ack := io.rd || io.wr

  // drain mux: UART side or MMIO read of 0x000C
  io.byteOut.bits  := pf.io.deq.bits
  io.byteOut.valid := pf.io.deq.valid && !drainModeMmio
  pf.io.deq.ready := Mux(drainModeMmio,
                         io.rd && isPixel && pf.io.deq.valid,
                         io.byteOut.ready)
}

object RayTracerController extends App {
  emitVerilog(new RayTracerController, Array("--target-dir", "verilog/rtl"))
}
