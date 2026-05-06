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

  // ── Regression: !ackReg bug — startPending must fire on cmd write ──────────
  it should "set busy=1 immediately after writing start bit to CMD register" in {
    test(new CaravelUserProject()) { dut =>
      dut.io.in.poke(0.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)  // hold CPU in reset

      // Write start bit — busy must go high the very next read
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ReadStatus.litValue.toInt << 1) | 1)

      val status = wbRead(dut, SpiSlotBase + 12)
      assert(status == 1,
        s"BUG: busy=0 after start — startPending never set (check !ackReg inside when(ackReg))")
    }
  }

  // ── ReadWord: verify 0x03 command + 24-bit address on MOSI ─────────────────
  it should "issue a ReadWord sequence with command 0x03 and correct address" in {
    test(new CaravelUserProject()) { dut =>
      val flashAddr = 0x00abcd

      dut.io.in.poke(0.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)
      wbWrite(dut, SpiSlotBase + 0x114, 0)
      wbWrite(dut, SpiSlotBase + 4, flashAddr)
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ReadWord.litValue.toInt << 1) | 1)

      val mosiBits = collectMosiUntilCsReleases(dut, maxCycles = 500)
      val cmdBits  = mosiBits.take(8).foldLeft(0)  { case (acc, b) => (acc << 1) | b }
      val addrBits = mosiBits.drop(8).take(24).foldLeft(0) { case (acc, b) => (acc << 1) | b }

      assert(mosiBits.length == 64, s"expected 64 MOSI bits (cmd+addr+read), got ${mosiBits.length}")
      assert(cmdBits  == 0x03, f"expected ReadWord command 0x03, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected addr 0x$flashAddr%06x, got 0x$addrBits%06x")
    }
  }

  // ── WriteEnable: verify 0x06 command, no address phase ────────────────────
  it should "issue WriteEnable with command 0x06 and no address or data bytes" in {
    test(new CaravelUserProject()) { dut =>
      dut.io.in.poke(0.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)
      wbWrite(dut, SpiSlotBase + 0x114, 0)  // device = Flash
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.WriteEnable.litValue.toInt << 1) | 1)

      val mosiBits = collectMosiUntilCsReleases(dut, maxCycles = 100)
      val cmdBits  = mosiBits.take(8).foldLeft(0) { case (acc, b) => (acc << 1) | b }

      assert(cmdBits == 0x06, f"expected WriteEnable command 0x06, got 0x$cmdBits%02x")
      assert(mosiBits.length == 8, s"WriteEnable must send exactly 8 bits, got ${mosiBits.length}")
    }
  }

  // ── PSRAM CS1: verify cs1 (pin 22) goes low for PSRAM A access ────────────
  it should "assert CS1 on pin 22 (not CS0) when device is set to PSRAM A" in {
    test(new CaravelUserProject()) { dut =>
      dut.io.in.poke(0.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)
      wbWrite(dut, SpiSlotBase + 0x114, 1)  // device = PSRAM A
      wbWrite(dut, SpiSlotBase + 4, 0x000000)
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ReadWord.litValue.toInt << 1) | 1)

      var cs0WentLow  = false
      var cs1WentLow  = false

      for (_ <- 0 until 500) {
        cs0WentLow |= !outputBit(dut, 26)   // Flash CS on pin 26
        cs1WentLow |= !outputBit(dut, 22)   // PSRAM A CS on pin 22
        dut.clock.step()
      }

      assert(!cs0WentLow, "CS0 (Flash, pin 26) must NOT go low for PSRAM A transaction")
      assert(cs1WentLow,  "CS1 (PSRAM A, pin 22) must go low for PSRAM A transaction")
    }
  }

  // ── WriteEnable then ProgramPage: two-step flash write flow ───────────────
  it should "issue WriteEnable followed by ProgramPage as a two-step sequence" in {
    test(new CaravelUserProject()) { dut =>
      val flashAddr = 0x002000
      val pageBytes = Seq(0xAA, 0xBB)

      dut.io.in.poke(0.U)
      dut.wb.stb.poke(false.B)
      dut.wb.cyc.poke(false.B)
      dut.clock.step(2)

      wbWrite(dut, CommSlotBase, 1)
      wbWrite(dut, SpiSlotBase + 0x114, 0)  // Flash

      // Step 1: WriteEnable
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.WriteEnable.litValue.toInt << 1) | 1)
      val weBits  = collectMosiUntilCsReleases(dut, maxCycles = 100)
      val weCmd   = weBits.take(8).foldLeft(0) { case (acc, b) => (acc << 1) | b }
      assert(weCmd == 0x06, f"step1: expected 0x06, got 0x$weCmd%02x")

      // Step 2: ProgramPage
      wbWrite(dut, SpiSlotBase + 4,  flashAddr)
      wbWrite(dut, SpiSlotBase + 16, pageBytes.length)
      pageBytes.zipWithIndex.foreach { case (byte, i) =>
        wbWrite(dut, SpiSlotBase + 20 + i, byte)
      }
      wbWrite(dut, SpiSlotBase, (FlashCtrlOp.ProgramByte.litValue.toInt << 1) | 1)

      val ppBits = collectMosiUntilCsReleases(dut, maxCycles = 300)
      val ppCmd  = ppBits.take(8).foldLeft(0) { case (acc, b) => (acc << 1) | b }
      val ppAddr = ppBits.drop(8).take(24).foldLeft(0) { case (acc, b) => (acc << 1) | b }
      val ppData = ppBits.drop(32).grouped(8)
        .map(_.foldLeft(0) { case (acc, b) => (acc << 1) | b }).toVector

      assert(ppCmd  == 0x02,       f"step2: expected 0x02, got 0x$ppCmd%02x")
      assert(ppAddr == flashAddr,  f"step2: wrong address")
      assert(ppData == pageBytes,  s"step2: wrong data bytes")
    }
  }
}


