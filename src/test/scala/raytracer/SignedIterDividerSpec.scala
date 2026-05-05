package raytracer

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec

class SignedIterDividerSpec extends AnyFreeSpec with ChiselScalatestTester {

  private def runDivide(dut: SignedIterDivider,
                        a: BigInt,
                        b: BigInt): (BigInt, BigInt) = {
    dut.io.dividend.poke(a.S(dut.W.W))
    dut.io.divisor.poke(b.S(dut.W.W))
    dut.io.start.poke(true.B)
    dut.clock.step()
    dut.io.start.poke(false.B)

    var cycles = 0
    val maxCycles = dut.W + 10
    while (dut.io.busy.peek().litToBoolean && cycles < maxCycles) {
      dut.clock.step()
      cycles += 1
    }
    assert(cycles < maxCycles, s"timeout waiting for divide result after $cycles cycles")

    (dut.io.quotient.peek().litValue, dut.io.remainder.peek().litValue)
  }

  // BigInt / and % truncate toward zero, same as our divider
  private def expect(dut: SignedIterDivider, a: BigInt, b: BigInt): Unit = {
    val (q, r) = runDivide(dut, a, b)
    val expQ = a / b
    val expR = a % b
    assert(q == expQ, s"quotient $q != $expQ for $a / $b")
    assert(r == expR, s"remainder $r != $expR for $a % $b")
    assert(q * b + r == a, s"identity broken: $q * $b + $r != $a")
  }

  "K=1 radix-2: small positive values" in {
    test(new SignedIterDivider(W = 32, K = 1)) { dut =>
      expect(dut, 100, 7)
      expect(dut, 1, 1)
      expect(dut, 0, 5)
      expect(dut, 12345, 67)
    }
  }

  "K=4: small positive values match Scala BigInt" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      expect(dut, 100, 7)
      expect(dut, 1, 1)
      expect(dut, 0, 5)
      expect(dut, 1000000, 1234)
    }
  }

  "K=4: all four sign combinations" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      expect(dut,  100,  7)
      expect(dut, -100,  7)
      expect(dut,  100, -7)
      expect(dut, -100, -7)
      // truncation, not floor: -7/2 = -3 rem -1
      expect(dut,  -7,  2)
      expect(dut,   7, -2)
      expect(dut,  -7, -2)
    }
  }

  "K=4: divider is reusable for back-to-back operations" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      expect(dut, 42, 6)
      expect(dut, 999, 3)
      expect(dut, -77, 11)
      expect(dut, 1234567, 89)
    }
  }

  "K=6: non-power-of-two radix still divides W=48 evenly" in {
    test(new SignedIterDivider(W = 48, K = 6)) { dut =>
      expect(dut,  12345678,  99)
      expect(dut, -12345678,  99)
      expect(dut,  12345678, -99)
    }
  }

  "K=8 and K=12: other valid configurations" in {
    test(new SignedIterDivider(W = 48, K = 8)) { dut =>
      expect(dut, 987654321, 12345)
    }
    test(new SignedIterDivider(W = 48, K = 12)) { dut =>
      expect(dut, 987654321, 12345)
    }
  }

  "K=4: operands sized like the raytracer's widened Q16.16 inputs" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      // (a << 16) / b, both Q16.16
      val aFP  = (BigDecimal(3.0) * BigDecimal(1L << 16)).toBigInt
      val bFP  = (BigDecimal(1.125) * BigDecimal(1L << 16)).toBigInt
      val dividend = aFP << 16
      expect(dut, dividend, bFP)

      // -0.5 / 0.25 = -2.0
      val cFP  = (BigDecimal(-0.5)  * BigDecimal(1L << 16)).toBigInt
      val dFP  = (BigDecimal( 0.25) * BigDecimal(1L << 16)).toBigInt
      expect(dut, cFP << 16, dFP)
    }
  }

  "K=4: random sweep matches BigInt reference" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      val rng = new scala.util.Random(seed = 0xC0FFEE)
      for (_ <- 0 until 60) {
        val sign   = if (rng.nextBoolean()) BigInt(1) else BigInt(-1)
        val magA   = BigInt(40, rng)
        val a      = magA * sign
        var b      = BigInt(24, rng) * (if (rng.nextBoolean()) BigInt(1) else BigInt(-1))
        if (b == 0) b = 1
        expect(dut, a, b)
      }
    }
  }

  "K=4: busy high during the division, falls exactly once" in {
    test(new SignedIterDivider(W = 48, K = 4)) { dut =>
      dut.io.dividend.poke(123456.S)
      dut.io.divisor.poke(7.S)
      dut.io.start.poke(true.B)
      dut.io.busy.expect(false.B)
      dut.clock.step()
      dut.io.start.poke(false.B)

      val N = dut.W / dut.K
      var highCount = 0
      var guard = 0
      while (dut.io.busy.peek().litToBoolean && guard < dut.W + 5) {
        highCount += 1
        dut.clock.step()
        guard += 1
      }
      assert(highCount == N, s"busy was high for $highCount cycles, expected $N")
      dut.io.quotient.expect((123456 / 7).S)
    }
  }
}
