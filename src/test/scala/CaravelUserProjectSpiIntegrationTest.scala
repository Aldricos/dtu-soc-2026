import chisel3._
import chiseltest._
import memory._
import org.scalatest.flatspec.AnyFlatSpec

class CaravelUserProjectSpiIntegrationTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "CaravelUserProject SPI integration"

  private val SpiSlotBase = 0x00600000
  private val CommSlotBase = 0x00400000

  private def outputBit(dut: CaravelUserProject, idx: Int): Boolean =
    ((dut.io.out.peek().litValue >> idx) & 1) == 1

  private def inputWordWithBit28(bit: Boolean): BigInt =
    if (bit) BigInt(1) << 28 else BigInt(0)

  private def wbWrite(dut: CaravelUserProject, addr: Int, data: Int): Unit = {
    dut.wb.addr.poke(addr.U)
    dut.wb.wrData.poke(data.U)
    dut.wb.we.poke(true.B)
    dut.wb.sel.poke(15.U)
    dut.wb.stb.poke(true.B)
    dut.wb.cyc.poke(true.B)

    dut.clock.step()
    dut.wb.ack.expect(true.B)
    dut.clock.step()

    dut.wb.stb.poke(false.B)
    dut.wb.cyc.poke(false.B)
    dut.wb.we.poke(false.B)
    dut.clock.step()
    dut.wb.ack.expect(false.B)
  }

  private def wbRead(dut: CaravelUserProject, addr: Int): BigInt = {
    dut.wb.addr.poke(addr.U)
    dut.wb.we.poke(false.B)
    dut.wb.sel.poke(15.U)
    dut.wb.stb.poke(true.B)
    dut.wb.cyc.poke(true.B)

    dut.clock.step()
    dut.wb.ack.expect(true.B)
    val value = dut.wb.rdData.peek().litValue

    dut.wb.stb.poke(false.B)
    dut.wb.cyc.poke(false.B)
    dut.clock.step()
    dut.wb.ack.expect(false.B)
    value
  }

  private def collectMosiUntilCsReleases(
      dut: CaravelUserProject,
      maxCycles: Int = 300
  ): Vector[Int] = {
    var mosiBits = Vector.empty[Int]
    var seenSelected = false
    var done = false

    for (_ <- 0 until maxCycles if !done) {
      val csLow = !outputBit(dut, 26)
      val sckHigh = outputBit(dut, 29)

      if (csLow) {
        seenSelected = true
      }

      if (csLow && sckHigh) {
        mosiBits :+= (if (outputBit(dut, 27)) 1 else 0)
      }

      if (seenSelected && !csLow) {
        done = true
      } else {
        dut.clock.step()
      }
    }

    assert(seenSelected, "SPI CS0 on pin 26 never went low")
    assert(done, "SPI transaction never completed")
    mosiBits
  }

  private def collectMosiAndDriveMisoUntilCsReleases(
      dut: CaravelUserProject,
      responseByte: Int,
      maxCycles: Int = 200
  ): Vector[Int] = {
    var mosiBits = Vector.empty[Int]
    var responseBitsDriven = 0
    var seenSelected = false
    var done = false

    dut.io.in.poke(0.U)

    for (_ <- 0 until maxCycles if !done) {
      val csLow = !outputBit(dut, 26)
      val sckHigh = outputBit(dut, 29)

      if (csLow) {
        seenSelected = true
      }

      if (csLow && sckHigh) {
        if (mosiBits.length < 8) {
          mosiBits :+= (if (outputBit(dut, 27)) 1 else 0)
          dut.io.in.poke(0.U)
        } else {
          val bit = ((responseByte >> (7 - responseBitsDriven)) & 1) == 1
          dut.io.in.poke(inputWordWithBit28(bit).U)
          responseBitsDriven += 1
        }
      } else {
        dut.io.in.poke(0.U)
      }

      if (seenSelected && !csLow) {
        done = true
      } else {
        dut.clock.step()
      }
    }

    assert(seenSelected, "SPI CS0 on pin 26 never went low")
    assert(done, "SPI status transaction never completed")
    assert(responseBitsDriven == 8, s"expected 8 driven status bits, got $responseBitsDriven")
    mosiBits
  }

  it should "issue a page-program sequence on pins 26 to 29 from Wishbone slot 0x6" in {
    test(new CaravelUserProject()) { dut =>
      val flashAddr = 0x001234
      val pageBytes = Seq(0x11, 0x22, 0x33, 0x44)

      dut.io.in.poke(0.U)
      dut.wb.addr.poke(0.U)
      dut.wb.wrData.poke(0.U)
      dut.wb.we.poke(false.B)
      dut.wb.sel.poke(15.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      // Hold the Wildcat CPU in reset so only the Wishbone-driven SPI traffic is active.
      wbWrite(dut, CommSlotBase, 1)

      wbWrite(dut, SpiSlotBase + 4, flashAddr)
      wbWrite(dut, SpiSlotBase + 16, pageBytes.length)
      pageBytes.zipWithIndex.foreach { case (byte, i) =>
        wbWrite(dut, SpiSlotBase + 20 + i, byte)
      }
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ProgramByte.litValue.toInt << 1) | 1)

      val mosiBits = collectMosiUntilCsReleases(dut)
      val cmdBits = mosiBits.take(8).foldLeft(0) { case (acc, bit) => (acc << 1) | bit }
      val addrBits = mosiBits.drop(8).take(24).foldLeft(0) { case (acc, bit) => (acc << 1) | bit }
      val dataBits = mosiBits.drop(32).grouped(8).map(_.foldLeft(0) { case (acc, bit) => (acc << 1) | bit }).toVector

      assert(cmdBits == 0x02, f"expected program command 0x02, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected address 0x$flashAddr%06x, got 0x$addrBits%06x")
      assert(dataBits == pageBytes, s"expected data bytes ${pageBytes.mkString(",")}, got ${dataBits.mkString(",")}")
      assert(mosiBits.length == 64, s"expected 64 MOSI bits, got ${mosiBits.length}")
    }
  }

  it should "issue read-status on pins 26 to 29 and return the byte through Wishbone slot 0x6" in {
    test(new CaravelUserProject()) { dut =>
      val statusByte = 0xa5

      dut.io.in.poke(0.U)
      dut.wb.addr.poke(0.U)
      dut.wb.wrData.poke(0.U)
      dut.wb.we.poke(false.B)
      dut.wb.sel.poke(15.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ReadStatus.litValue.toInt << 1) | 1)

      val mosiBits = collectMosiAndDriveMisoUntilCsReleases(dut, statusByte)
      val cmdBits = mosiBits.take(8).foldLeft(0) { case (acc, bit) => (acc << 1) | bit }

      assert(cmdBits == 0x05, f"expected read-status command 0x05, got 0x$cmdBits%02x")
      assert(wbRead(dut, SpiSlotBase + 8) == statusByte)
    }
  }
}
