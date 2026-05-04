package raytracer

import chisel3._

// Q16.16 fixed-point helpers
object FixedPoint {
  val W = 32
  val F = 16

  def toBig(x: Double): BigInt = BigInt(math.round(x * (1L << F)))

  def lit(x: Double): SInt = toBig(x).S(W.W)

  // (a * b) >> F, truncated to W bits
  def mul(a: SInt, b: SInt): SInt = {
    val prod = a * b
    val narrow = Wire(SInt(W.W))
    narrow := (prod >> F)
    narrow
  }

  // arithmetic shift right is floor for signed
  def floorInt(x: SInt): SInt = {
    val narrow = Wire(SInt((W - F).W))
    narrow := (x >> F)
    narrow
  }
}
