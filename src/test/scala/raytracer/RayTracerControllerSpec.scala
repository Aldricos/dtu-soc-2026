package raytracer

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec

class RayTracerControllerSpec extends AnyFreeSpec with ChiselScalatestTester {

  private val TOTAL = 32 * 32

  private val ADDR_START = 0x0000
  private val ADDR_BUSY  = 0x0004
  private val ADDR_NEMPT = 0x0008
  private val ADDR_PIXEL = 0x000C
  private val ADDR_MODE  = 0x0010
  private val ADDR_CAMX  = 0x1000
  private val ADDR_CAMY  = 0x1004
  private val ADDR_CAMZ  = 0x1008
  private val ADDR_SPHX  = 0x100C
  private val ADDR_SPHY  = 0x1010
  private val ADDR_SPHZ  = 0x1014
  private val ADDR_COLS  = 0x1018
  private val ADDR_ROWS  = 0x101C
  private val ADDR_SCLX  = 0x1020
  private val ADDR_SCLY  = 0x1024

  private def toFP(x: Double): Long = math.round(x * (1L << 16)) & 0xFFFFFFFFL

  private def idle(dut: RayTracerController): Unit = {
    dut.io.address.poke(0.U)
    dut.io.wr.poke(false.B)
    dut.io.rd.poke(false.B)
    dut.io.wrData.poke(0.U)
    dut.io.wrMask.poke(0.U)
  }

  private def write(dut: RayTracerController, addr: Int, data: Long): Unit = {
    dut.io.address.poke(addr.U)
    dut.io.wrData.poke(data.U)
    dut.io.wrMask.poke(0xF.U)
    dut.io.wr.poke(true.B)
    dut.io.rd.poke(false.B)
    dut.clock.step()
    dut.io.wr.poke(false.B)
    dut.io.wrData.poke(0.U)
  }

  private def readPeek(dut: RayTracerController, addr: Int): Long = {
    dut.io.address.poke(addr.U)
    dut.io.rd.poke(true.B)
    dut.io.wr.poke(false.B)
    val v = dut.io.rdData.peekInt().toLong
    v
  }

  private def readAndStep(dut: RayTracerController, addr: Int): Long = {
    val v = readPeek(dut, addr)
    dut.clock.step()
    dut.io.rd.poke(false.B)
    v
  }

  "Reset state: busy=0, notEmpty=0, drainMode=0" in {
    test(new RayTracerController) { dut =>
      idle(dut)
      dut.clock.step()
      assert(readAndStep(dut, ADDR_BUSY)  == 0L)
      assert(readAndStep(dut, ADDR_NEMPT) == 0L)
      assert(readAndStep(dut, ADDR_MODE)  == 0L)
    }
  }

  "Drain-mode toggle round-trips" in {
    test(new RayTracerController) { dut =>
      idle(dut)
      write(dut, ADDR_MODE, 1L)
      assert(readAndStep(dut, ADDR_MODE) == 1L)
      write(dut, ADDR_MODE, 0L)
      assert(readAndStep(dut, ADDR_MODE) == 0L)
    }
  }

  "Start pulse asserts busy" in {
    test(new RayTracerController) { dut =>
      idle(dut)
      dut.clock.step()
      assert(readAndStep(dut, ADDR_BUSY) == 0L)
      write(dut, ADDR_START, 1L)
      dut.clock.step()
      assert(readAndStep(dut, ADDR_BUSY) == 1L)
    }
  }

  "MMIO drain captures all 32x32 pixels" in {
    test(new RayTracerController) { dut =>
      dut.clock.setTimeout(0)
      idle(dut)
      // MMIO drain mode so byteOut is silent and CPU drains via 0x000C
      write(dut, ADDR_MODE, 1L)
      write(dut, ADDR_START, 1L)

      var captured = 0
      var cycles   = 0
      val maxCycles = TOTAL * 50 + 1000
      var done = false
      while (!done && cycles < maxCycles) {
        val ne = readPeek(dut, ADDR_NEMPT)
        dut.io.rd.poke(false.B)
        if (ne != 0L) {
          readAndStep(dut, ADDR_PIXEL)
          captured += 1
        } else {
          dut.clock.step()
        }
        cycles += 1

        if (captured == TOTAL) {
          done = (readAndStep(dut, ADDR_BUSY) == 0L) &&
                 (readAndStep(dut, ADDR_NEMPT) == 0L)
        }
      }

      assert(captured == TOTAL,
        s"captured=$captured of $TOTAL after $cycles cycles")
      assert(done, "render+drain did not complete in time")
    }
  }

  "UART drain: byteOut streams pixels when consumer is ready" in {
    test(new RayTracerController) { dut =>
      dut.clock.setTimeout(0)
      idle(dut)
      // default = UART drain
      dut.io.byteOut.ready.poke(true.B)
      write(dut, ADDR_START, 1L)

      var fired   = 0
      var cycles  = 0
      val maxCycles = TOTAL * 50 + 1000
      while (fired < TOTAL && cycles < maxCycles) {
        if (dut.io.byteOut.valid.peek().litToBoolean) fired += 1
        dut.clock.step()
        cycles += 1
      }
      assert(fired == TOTAL,
        s"byteOut fired only $fired of $TOTAL within $cycles cycles")
    }
  }

  "16x16 render: writing cols/rows/scale via MMIO drains exactly 256 pixels" in {
    val SMALL = 16 * 16
    test(new RayTracerController) { dut =>
      dut.clock.setTimeout(0)
      idle(dut)
      write(dut, ADDR_MODE, 1L)
      // 1/12 keeps the same vertical FOV at 16x16
      write(dut, ADDR_COLS, 16L)
      write(dut, ADDR_ROWS, 16L)
      write(dut, ADDR_SCLX, toFP(1.0 / 12.0))
      write(dut, ADDR_SCLY, toFP(1.0 / 12.0))
      write(dut, ADDR_START, 1L)

      var captured = 0
      var cycles   = 0
      val maxCycles = SMALL * 50 + 1000
      while (captured < SMALL && cycles < maxCycles) {
        val ne = readPeek(dut, ADDR_NEMPT)
        dut.io.rd.poke(false.B)
        if (ne != 0L) {
          readAndStep(dut, ADDR_PIXEL)
          captured += 1
        } else {
          dut.clock.step()
        }
        cycles += 1
      }
      assert(captured == SMALL,
        s"captured=$captured of $SMALL after $cycles cycles")
      var settle = 0
      while ((readPeek(dut, ADDR_BUSY) != 0L) && settle < 100) {
        dut.io.rd.poke(false.B); dut.clock.step(); settle += 1
      }
      assert(readAndStep(dut, ADDR_BUSY) == 0L, "busy should fall after 256 pixels")
    }
  }

  "MMIO read of 0x000C returns 0 when drain mode is UART" in {
    test(new RayTracerController) { dut =>
      dut.clock.setTimeout(0)
      idle(dut)
      // UART mode (default). Don't consume byteOut so the FIFO fills,
      // then read 0x000C and confirm we get 0 (not a pixel).
      dut.io.byteOut.ready.poke(false.B)
      write(dut, ADDR_START, 1L)
      for (_ <- 0 until 200) dut.clock.step()
      assert(readAndStep(dut, ADDR_NEMPT) == 1L,
        "expected FIFO to have a byte ready")
      assert(readAndStep(dut, ADDR_PIXEL) == 0L,
        "drain register should not return data when UART mode is active")
    }
  }
}
