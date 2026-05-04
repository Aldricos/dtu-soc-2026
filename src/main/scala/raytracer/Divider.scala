package raytracer

import chisel3._
import chisel3.util._

/** Signed iterative divider, radix-2^K shift/subtract.
  * Truncates toward zero (matches Scala `/`). Divisor must be != 0.
  * W must be a multiple of K. Inputs must satisfy |x| < 2^(W-1).
  */
class SignedIterDivider(val W: Int = 48, val K: Int = 4) extends Module {
  require(W > 0,          s"W=$W must be positive")
  require(K > 0,          s"K=$K must be positive")
  require(K <= W,         s"K=$K must not exceed W=$W")
  require(W % K == 0,     s"W=$W must be divisible by K=$K")

  val io = IO(new Bundle {
    val start     = Input(Bool())
    val dividend  = Input(SInt(W.W))
    val divisor   = Input(SInt(W.W))
    val busy      = Output(Bool())
    val quotient  = Output(SInt(W.W))
    val remainder = Output(SInt(W.W))
  })

  val N       = W / K              // cycles per division
  val countW  = log2Up(N).max(1)

  val sIdle :: sBusy :: Nil = Enum(2)
  val state = RegInit(sIdle)
  val count = RegInit(0.U(countW.W))

  val dividendR = Reg(UInt(W.W))
  val divisorR  = Reg(UInt(W.W))
  val remR      = Reg(UInt(W.W))
  val quotR     = Reg(UInt(W.W))
  val quotSign  = Reg(Bool())
  val remSign   = Reg(Bool())

  private def sAbs(x: SInt): UInt = Mux(x < 0.S, (-x).asUInt, x.asUInt)

  switch(state) {
    is(sIdle) {
      when(io.start) {
        dividendR := sAbs(io.dividend)
        divisorR  := sAbs(io.divisor)
        quotSign  := io.dividend(W - 1) ^ io.divisor(W - 1)
        remSign   := io.dividend(W - 1)
        remR      := 0.U
        quotR     := 0.U
        count     := 0.U
        state     := sBusy
      }
    }
    is(sBusy) {
      // K bits per cycle
      var r: UInt = remR
      var a: UInt = dividendR
      var q: UInt = quotR
      for (_ <- 0 until K) {
        val nextBit  = a(W - 1)
        val rShifted = Cat(r(W - 2, 0), nextBit)
        val trial    = Cat(0.U(1.W), rShifted) - Cat(0.U(1.W), divisorR)
        val fits     = !trial(W)
        val newR     = Mux(fits, trial(W - 1, 0), rShifted)
        val newA     = Cat(a(W - 2, 0), 0.U(1.W))
        val newQ     = Cat(q(W - 2, 0), fits)

        r = newR
        a = newA
        q = newQ
      }
      remR      := r
      dividendR := a
      quotR     := q

      count := count + 1.U
      when(count === (N - 1).U) {
        state := sIdle
      }
    }
  }

  io.busy      := state === sBusy
  io.quotient  := Mux(quotSign, -quotR.asSInt, quotR.asSInt)
  io.remainder := Mux(remSign,  -remR.asSInt,  remR.asSInt)
}
