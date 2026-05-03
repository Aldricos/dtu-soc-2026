package raytracer

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec

class IterSqrtSpec extends AnyFreeSpec with ChiselScalatestTester {

  private def runSqrt(dut: IterSqrt, x: BigInt): BigInt = {
    dut.io.radicand.poke(x.U(dut.W.W))
    dut.io.start.poke(true.B)
    dut.clock.step()
    dut.io.start.poke(false.B)

    var cycles = 0
    val maxCycles = dut.W + 10
    while (dut.io.busy.peek().litToBoolean && cycles < maxCycles) {
      dut.clock.step()
      cycles += 1
    }
    assert(cycles < maxCycles, s"timeout waiting for sqrt result after $cycles cycles")
    dut.io.result.peek().litValue
  }

  private def refSqrt(x: BigInt): BigInt = BigInt(x.bigInteger.sqrt())

  private def expect(dut: IterSqrt, x: BigInt): Unit = {
    val got = runSqrt(dut, x)
    val want = refSqrt(x)
    assert(got == want, s"sqrt($x) = $got, expected $want")
    // q^2 <= x < (q+1)^2
    assert(got * got <= x, s"result^2 > x for x=$x, q=$got")
    assert((got + 1) * (got + 1) > x, s"(result+1)^2 <= x for x=$x, q=$got")
  }

  "K=1 radix-2: perfect squares 0..10" in {
    test(new IterSqrt(W = 32, K = 1)) { dut =>
      for (i <- 0 to 10) expect(dut, BigInt(i) * BigInt(i))
    }
  }

  "K=4: small values (perfect and non-perfect)" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      expect(dut, BigInt(0))
      expect(dut, BigInt(1))
      expect(dut, BigInt(2))
      expect(dut, BigInt(3))
      expect(dut, BigInt(17))   // floor(sqrt) = 4
      expect(dut, BigInt(25))   // 5
      expect(dut, BigInt(99))   // 9
      expect(dut, BigInt(100))  // 10
    }
  }

  "K=4: reusable across back-to-back sqrt operations" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      expect(dut, BigInt(1234567890))
      expect(dut, BigInt(987654321))
      expect(dut, BigInt(42) * BigInt(42))
      expect(dut, BigInt(1) << 40)
    }
  }

  "K=4: full-range operands (near 2^48)" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      val maxVal = (BigInt(1) << 48) - 1
      expect(dut, maxVal)
      expect(dut, BigInt(1) << 47)
      expect(dut, (BigInt(1) << 48) - 2)
    }
  }

  "K=2 and K=6: other valid unroll factors" in {
    test(new IterSqrt(W = 48, K = 2)) { dut =>
      expect(dut, BigInt(123456789))
    }
    test(new IterSqrt(W = 48, K = 6)) { dut =>
      expect(dut, BigInt(987654321))
    }
  }

  "K=4: Q16.16-style radicand (disc << 16 as the raytracer will feed it)" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      // disc = 0.25 -> 16384 in Q16.16 -> radicand = 2^30
      // sqrt(0.25) = 0.5 -> 32768 in Q16.16
      val disc_fp  = BigInt(16384)
      val radicand = disc_fp << 16
      val got      = runSqrt(dut, radicand)
      assert(got == BigInt(32768), s"Q16.16 sqrt(0.25): got $got, expected 32768")

      // disc = 4.0 -> sqrt = 2 -> 131072 in Q16.16
      val disc_fp2  = BigInt(4) << 16
      val radicand2 = disc_fp2 << 16
      val got2      = runSqrt(dut, radicand2)
      assert(got2 == BigInt(131072), s"Q16.16 sqrt(4.0): got $got2, expected 131072")
    }
  }

  "K=4: busy stays high for exactly N cycles" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      dut.io.radicand.poke(BigInt(1000000).U)
      dut.io.start.poke(true.B)
      dut.io.busy.expect(false.B)
      dut.clock.step()
      dut.io.start.poke(false.B)

      var highCount = 0
      var guard = 0
      while (dut.io.busy.peek().litToBoolean && guard < dut.W + 5) {
        highCount += 1
        dut.clock.step()
        guard += 1
      }
      assert(highCount == dut.N, s"busy high for $highCount cycles, expected ${dut.N}")
    }
  }

  "K=4: random sweep matches BigInt reference" in {
    test(new IterSqrt(W = 48, K = 4)) { dut =>
      val rng = new scala.util.Random(seed = 0xDEADBEEFL)
      for (_ <- 0 until 60) {
        val x = BigInt(48, rng)
        expect(dut, x)
      }
    }
  }
}
