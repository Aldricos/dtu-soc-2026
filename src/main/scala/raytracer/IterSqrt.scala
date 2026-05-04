package raytracer

import chisel3._
import chisel3.util._

/** Integer sqrt, radix-2^K. Same shape as the divider so we use the same K knob.
  * W must be even and W/2 must be divisible by K.
  */
class IterSqrt(val W: Int = 48, val K: Int = 4) extends Module {
  require(W > 0 && W % 2 == 0, s"W=$W must be positive and even")
  require(K > 0,                s"K=$K must be positive")
  require((W / 2) % K == 0,     s"W/2=${W / 2} must be divisible by K=$K")

  val Nouts = W / 2           // output width
  val N     = Nouts / K       // cycles per sqrt

  val io = IO(new Bundle {
    val start    = Input(Bool())
    val radicand = Input(UInt(W.W))
    val busy     = Output(Bool())
    val result   = Output(UInt(Nouts.W))
  })

  private val countW = log2Up(N).max(1)

  val sIdle :: sBusy :: Nil = Enum(2)
  val state = RegInit(sIdle)
  val count = RegInit(0.U(countW.W))

  val xR = Reg(UInt(W.W))       // shifts left by 2 each iter
  val rR = Reg(UInt(W.W))       // running remainder
  val qR = Reg(UInt(Nouts.W))   // result, MSB first

  switch(state) {
    is(sIdle) {
      when(io.start) {
        xR    := io.radicand
        rR    := 0.U
        qR    := 0.U
        count := 0.U
        state := sBusy
      }
    }
    is(sBusy) {
      // K iterations unrolled
      var r: UInt = rR
      var x: UInt = xR
      var q: UInt = qR
      for (_ <- 0 until K) {
        val top2  = x(W - 1, W - 2)
        val rExt  = Cat(r, top2)                                          // 4r + top2
        val trial = Cat(0.U((W - Nouts).W), q, 1.U(2.W))                  // 4q + 1
        val sub   = Cat(0.U(1.W), rExt) - Cat(0.U(1.W), trial)
        val fits  = !sub(W + 2)

        val newR = Wire(UInt(W.W))
        newR := Mux(fits, sub(W + 1, 0), rExt)
        val newX = Wire(UInt(W.W))
        newX := (x << 2)
        val newQ = Wire(UInt(Nouts.W))
        newQ := (q << 1) | fits.asUInt

        r = newR
        x = newX
        q = newQ
      }
      rR := r
      xR := x
      qR := q

      count := count + 1.U
      when(count === (N - 1).U) {
        state := sIdle
      }
    }
  }

  io.busy   := state === sBusy
  io.result := qR
}
