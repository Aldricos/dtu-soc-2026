package memory

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class SpiFlashControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "SpiFlashController"

  it should "send 0x03, send the 24-bit address, and read back one 32-bit word" in {
    test(new SpiFlashController()) { dut =>
      val flashAddr = 0x001234
      val readWord = 0x89abcdefL

      dut.io.mem.address.poke(0.U)
      dut.io.mem.rd.poke(false.B)
      dut.io.mem.wr.poke(false.B)
      dut.io.mem.wrData.poke(0.U)
      dut.io.mem.wrMask.poke(0.U)
      dut.io.ctrl.start.poke(false.B)
      dut.io.ctrl.op.poke(0.U)
      dut.io.ctrl.addr.poke(0.U)
      dut.io.ctrl.wrByte.poke(0.U)
      dut.io.progMode.poke(false.B)
      dut.io.spi.sd1.poke(false.B)

      dut.clock.step()

      dut.io.mem.address.poke(flashAddr.U)
      dut.io.mem.rd.poke(true.B)
      dut.clock.step()
      dut.io.mem.rd.poke(false.B)

      var mosiBits = Vector.empty[Int]
      var readBitsDriven = 0
      var sawAck = false

      for (_ <- 0 until 300 if !sawAck) {
        val csLow = !dut.io.spi.cs0.peek().litToBoolean
        val sckHigh = dut.io.spi.sck.peek().litToBoolean

        if (csLow && sckHigh) {
          if (mosiBits.length < 32) {
            mosiBits :+= dut.io.spi.sd0.peek().litValue.toInt
            dut.io.spi.sd1.poke(false.B)
          } else {
            val bit = ((readWord >> (31 - readBitsDriven)) & 1L) == 1L
            dut.io.spi.sd1.poke(bit.B)
            readBitsDriven += 1
          }
        } else {
          dut.io.spi.sd1.poke(false.B)
        }

        if (dut.io.mem.ack.peek().litToBoolean) {
          dut.io.mem.rdData.expect(readWord.U)
          sawAck = true
        }

        dut.clock.step()
      }

      assert(sawAck, "controller never acknowledged the flash read")
      assert(readBitsDriven == 32, s"expected 32 read bits, got $readBitsDriven")

      val cmdBits = mosiBits.take(8).foldLeft(0) { case (acc, bit) => (acc << 1) | bit }
      val addrBits = mosiBits.drop(8).take(24).foldLeft(0) { case (acc, bit) => (acc << 1) | bit }

      assert(cmdBits == 0x03, f"expected read command 0x03, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected address 0x$flashAddr%06x, got 0x$addrBits%06x")
    }
  }
}
