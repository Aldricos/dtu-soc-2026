package raytracer

import chisel3._
import chisel3.util._
import FixedPoint.{lit, mul, floorInt}

/** Ray tracer accelerator. 8-bit grayscale output, runtime camera/sphere/shape.
  * Per-pixel FSM time-multiplexes one IterSqrt and two SignedIterDividers.
  * Sphere has fixed radius R=1.
  */
class RayTracerAccelerator(
  val maxCols: Int = 4096,
  val maxRows: Int = 4096,
  val K:       Int = 4
) extends Module {
  require(maxCols > 0 && maxRows > 0, "maxCols and maxRows must be positive")
  require(maxCols <= 4096 && maxRows <= 4096, "col/row counters are 12-bit; max 4096")

  val FpW = FixedPoint.W    // 32
  val FpF = FixedPoint.F    // 16

  // dividend gets widened by F bits so the quotient stays in Q16.16
  val DivW = FpW + FpF      // 48

  // grayscale palette (placeholder values)
  val charSky              = 0x00.U(8.W)
  val charFloorDark        = 0x40.U(8.W)
  val charFloorLight       = 0xC0.U(8.W)
  val charSphereSky        = 0x20.U(8.W)
  val charSphereFloorDark  = 0x60.U(8.W)
  val charSphereFloorLight = 0xA0.U(8.W)

  val io = IO(new Bundle {
    val start = Input(Bool())
    val busy  = Output(Bool())
    val camX  = Input(SInt(FpW.W))
    val camY  = Input(SInt(FpW.W))
    val camZ  = Input(SInt(FpW.W))
    // sampled at psInitRender. caller must keep cols/rows in [1, max]
    val cols    = Input(UInt(13.W))
    val rows    = Input(UInt(13.W))
    val scaleX  = Input(SInt(FpW.W))
    val scaleY  = Input(SInt(FpW.W))
    val sphereX = Input(SInt(FpW.W))
    val sphereY = Input(SInt(FpW.W))
    val sphereZ = Input(SInt(FpW.W))
    // raster-order pixel stream
    val pixel = Decoupled(UInt(8.W))
  })

  // FSM. sDone first so it encodes as 0 (matches the all-zeros init Verilator
  // gives us under RANDOMIZE_REG_INIT before reset has fired).
  val sDone :: sRunning :: Nil = Enum(2)
  val state = RegInit(sDone)
  val (psInitRender :: psRowInit :: psWaitRowDiv :: psSetup ::
       psWaitSqrt   :: psWaitDiv1 :: psComputeRefl :: psStartDiv2 ::
       psWaitDiv2   :: psFinishRefl :: psWrite :: Nil) = Enum(11)
  val pstate = RegInit(psInitRender)

  val col = RegInit(0.U(12.W))
  val row = RegInit(0.U(12.W))

  // shared math units
  val sqrt = Module(new IterSqrt(W = DivW, K = K))
  val div1 = Module(new SignedIterDivider(W = DivW, K = K))
  val div2 = Module(new SignedIterDivider(W = DivW, K = K))

  // defaults; overridden where we actually fire the op
  sqrt.io.start    := false.B
  sqrt.io.radicand := 0.U
  div1.io.start    := false.B
  div1.io.dividend := 0.S
  div1.io.divisor  := 1.S
  div2.io.start    := false.B
  div2.io.dividend := 0.S
  div2.io.divisor  := 1.S

  // RegInit (not bare Reg) on the datapath so they come up zero in sim
  // instead of X — protects the dividers/sqrt from a phantom pre-reset render.

  // per-render regs (set in psInitRender)
  val camXReg    = RegInit(0.S(FpW.W))
  val camYReg    = RegInit(0.S(FpW.W))
  val camZReg    = RegInit(0.S(FpW.W))
  val ocXReg     = RegInit(0.S(FpW.W))
  val ocYReg     = RegInit(0.S(FpW.W))
  val ocZReg     = RegInit(0.S(FpW.W))
  val cScalarReg = RegInit(0.S(FpW.W))
  val negCamYReg = RegInit(0.S(FpW.W))
  val colsReg    = RegInit(0.U(13.W))
  val rowsReg    = RegInit(0.U(13.W))
  val midColReg  = RegInit(0.U(12.W))
  val midRowReg  = RegInit(0.U(12.W))
  val scaleXReg  = RegInit(0.S(FpW.W))
  val scaleYReg  = RegInit(0.S(FpW.W))

  // per-row
  val ocYdyRowReg  = RegInit(0.S(FpW.W))
  val tFloorRowReg = RegInit(0.S(FpW.W))

  // per-pixel
  val sReg          = RegInit(0.S(FpW.W))
  val tSphereReg    = RegInit(0.S(FpW.W))
  val hitXReg       = RegInit(0.S(FpW.W))
  val hitYReg       = RegInit(0.S(FpW.W))
  val hitZReg       = RegInit(0.S(FpW.W))
  val rdirXReg      = RegInit(0.S(FpW.W))
  val rdirYReg      = RegInit(0.S(FpW.W))
  val rdirZReg      = RegInit(0.S(FpW.W))
  val tReflFloorReg = RegInit(0.S(FpW.W))
  val charReg       = RegInit(charSky)

  // sign-extend Q16.16 -> DivW (divisor)
  private def wideSignSInt(x: SInt): SInt = {
    val w = Wire(SInt(DivW.W)); w := x; w
  }
  // shift-left by F (dividend), so quotient is back in Q16.16
  private def wideShiftSInt(x: SInt): SInt = {
    val w = Wire(SInt(DivW.W)); w := (x << FpF).asSInt; w
  }
  // narrow back to Q16.16
  private def narrowFp(x: SInt): SInt = {
    val w = Wire(SInt(FpW.W)); w := x; w
  }

  // small int -> Q16.16
  private def intToFp(x: SInt): SInt = (x << FpF).asSInt

  // stage 1 (always live)
  val colSigned = (col.zext - midColReg.zext).asSInt
  val rowSigned = (midRowReg.zext - row.zext).asSInt
  val dx    = mul(intToFp(colSigned), scaleXReg)
  val dy    = mul(intToFp(rowSigned), scaleYReg)
  val dxSq  = mul(dx, dx)
  val dySq  = mul(dy, dy)
  val valid = row > midRowReg

  val ocXdx = mul(ocXReg, dx)
  val k     = Wire(SInt(FpW.W)); k := dxSq + dySq
  val A     = Wire(SInt(FpW.W)); A := k + lit(1.0)
  val hPart = Wire(SInt(FpW.W)); hPart := ocZReg + ocXdx
  val h     = Wire(SInt(FpW.W)); h := hPart + ocYdyRowReg
  val hSq      = mul(h, h)
  val AcScalar = mul(A, cScalarReg)
  val disc     = Wire(SInt(FpW.W)); disc := hSq - AcScalar
  val sphereHit = disc >= 0.S

  // primary ray (no sphere)
  val floorHitX = Wire(SInt(FpW.W)); floorHitX := camXReg + mul(tFloorRowReg, dx)
  val floorHitZ = Wire(SInt(FpW.W)); floorHitZ := camZReg + tFloorRowReg
  val fxF = floorInt(floorHitX)
  val fzF = floorInt(floorHitZ)
  val floorChar   = Mux((fxF + fzF).asUInt(0) === 1.U, charFloorLight, charFloorDark)
  val primaryChar = Mux(valid, floorChar, charSky)

  io.busy        := (state === sRunning)
  io.pixel.bits  := charReg
  io.pixel.valid := (state === sRunning) && (pstate === psWrite)

  when (state === sDone) {
    when (io.start) {
      state  := sRunning
      pstate := psInitRender
      col    := 0.U
      row    := 0.U
    }
  }

  when (state === sRunning) {
    switch (pstate) {
      is (psInitRender) {
        // latch all the per-render inputs and precompute scalars
        camXReg := io.camX
        camYReg := io.camY
        camZReg := io.camZ
        colsReg   := io.cols
        rowsReg   := io.rows
        midColReg := (io.cols >> 1)
        midRowReg := (io.rows >> 1)
        scaleXReg := io.scaleX
        scaleYReg := io.scaleY

        // oc = cam - sphere
        val ocXNew = Wire(SInt(FpW.W)); ocXNew := io.camX - io.sphereX
        val ocYNew = Wire(SInt(FpW.W)); ocYNew := io.camY - io.sphereY
        val ocZNew = Wire(SInt(FpW.W)); ocZNew := io.camZ - io.sphereZ
        ocXReg := ocXNew
        ocYReg := ocYNew
        ocZReg := ocZNew

        val ocXSq = mul(ocXNew, ocXNew)
        val ocYSq = mul(ocYNew, ocYNew)
        val ocZSq = mul(ocZNew, ocZNew)
        val sumSq = Wire(SInt(FpW.W)); sumSq := ocXSq + ocYSq + ocZSq
        cScalarReg := sumSq - lit(1.0)

        negCamYReg := 0.S(FpW.W) - io.camY

        pstate := psRowInit
      }

      is (psRowInit) {
        ocYdyRowReg := mul(ocYReg, dy)

        // skip the divide if dy >= 0; tFloor only matters below the horizon (dy < 0)
        when (valid) {
          div1.io.dividend := wideShiftSInt(negCamYReg)
          div1.io.divisor  := wideSignSInt(dy)
          div1.io.start    := true.B
          pstate           := psWaitRowDiv
        } .otherwise {
          tFloorRowReg := 0.S
          pstate       := psSetup
        }
      }

      is (psWaitRowDiv) {
        when (!div1.io.busy) {
          tFloorRowReg := narrowFp(div1.io.quotient)
          pstate       := psSetup
        }
      }

      is (psSetup) {
        when (sphereHit) {
          // widen by F so sqrt result is in Q16.16
          sqrt.io.radicand := (disc.asUInt << FpF)
          sqrt.io.start    := true.B
          pstate           := psWaitSqrt
        } .otherwise {
          charReg := primaryChar
          pstate  := psWrite
        }
      }

      is (psWaitSqrt) {
        when (!sqrt.io.busy) {
          val sNow = Wire(SInt(FpW.W))
          sNow := sqrt.io.result.zext
          sReg := sNow

          // tSphere = -(h + s) / A
          val tNum = Wire(SInt(FpW.W))
          tNum := 0.S(FpW.W) - (h + sNow)
          div1.io.dividend := wideShiftSInt(tNum)
          div1.io.divisor  := wideSignSInt(A)
          div1.io.start    := true.B
          pstate := psWaitDiv1
        }
      }

      is (psWaitDiv1) {
        when (!div1.io.busy) {
          tSphereReg := narrowFp(div1.io.quotient)
          pstate     := psComputeRefl
        }
      }

      is (psComputeRefl) {
        // reflection geometry from registered tSphere/s
        val tS = tSphereReg
        val sV = sReg

        val hitX = Wire(SInt(FpW.W)); hitX := camXReg + mul(tS, dx)
        val hitY = Wire(SInt(FpW.W)); hitY := camYReg + mul(tS, dy)
        val hitZ = Wire(SInt(FpW.W)); hitZ := camZReg + tS   // D.z = 1

        val twoS  = Wire(SInt(FpW.W)); twoS  := (sV << 1).asSInt
        val twoSt = mul(twoS, tS)
        val bigK  = Wire(SInt(FpW.W)); bigK  := lit(1.0) + twoSt

        val rdirX = Wire(SInt(FpW.W)); rdirX := mul(bigK, dx) + mul(twoS, ocXReg)
        val rdirY = Wire(SInt(FpW.W)); rdirY := mul(bigK, dy) + mul(twoS, ocYReg)
        val rdirZ = Wire(SInt(FpW.W)); rdirZ := bigK           + mul(twoS, ocZReg)

        hitXReg  := hitX
        hitYReg  := hitY
        hitZReg  := hitZ
        rdirXReg := rdirX
        rdirYReg := rdirY
        rdirZReg := rdirZ

        when (rdirY < 0.S) {
          pstate := psStartDiv2
        } .otherwise {
          charReg := charSphereSky
          pstate  := psWrite
        }
      }

      is (psStartDiv2) {
        // guard against div by zero
        val rdirYSafe = Mux(rdirYReg === 0.S, lit(-1.0), rdirYReg)
        val negHitY   = Wire(SInt(FpW.W)); negHitY := 0.S(FpW.W) - hitYReg
        div2.io.dividend := wideShiftSInt(negHitY)
        div2.io.divisor  := wideSignSInt(rdirYSafe)
        div2.io.start    := true.B
        pstate := psWaitDiv2
      }

      is (psWaitDiv2) {
        when (!div2.io.busy) {
          tReflFloorReg := narrowFp(div2.io.quotient)
          pstate        := psFinishRefl
        }
      }

      is (psFinishRefl) {
        val tR = tReflFloorReg
        val reflHitX = Wire(SInt(FpW.W)); reflHitX := hitXReg + mul(tR, rdirXReg)
        val reflHitZ = Wire(SInt(FpW.W)); reflHitZ := hitZReg + mul(tR, rdirZReg)
        val rFx = floorInt(reflHitX)
        val rFz = floorInt(reflHitZ)
        val parity = (rFx + rFz).asUInt(0)
        charReg := Mux(parity === 1.U, charSphereFloorLight, charSphereFloorDark)
        pstate  := psWrite
      }

      is (psWrite) {
        // wait for the FIFO to take the byte before advancing
        when (io.pixel.ready) {
          when (col === (colsReg - 1.U)) {
            col := 0.U
            when (row === (rowsReg - 1.U)) {
              state := sDone
            } .otherwise {
              row    := row + 1.U
              pstate := psRowInit
            }
          } .otherwise {
            col    := col + 1.U
            pstate := psSetup
          }
        }
      }
    }
  }
}

object RayTracerAccelerator extends App {
  emitVerilog(new RayTracerAccelerator, Array("--target-dir", "verilog/rtl"))
}
