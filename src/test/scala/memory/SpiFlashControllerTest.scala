package memory

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class SpiFlashControllerTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "SpiFlashController"

  private def init(dut: SpiFlashController): Unit = {
    dut.io.mem.address.poke(0.U)
    dut.io.mem.rd.poke(false.B)
    dut.io.mem.wr.poke(false.B)
    dut.io.mem.wrData.poke(0.U)
    dut.io.mem.wrMask.poke(0.U)
    dut.io.ctrl.start.poke(false.B)
    dut.io.ctrl.op.poke(0.U)
    dut.io.ctrl.addr.poke(0.U)
    dut.io.ctrl.wrByte.poke(0.U)
    dut.io.ctrl.wrLen.poke(0.U)
    for (i <- 0 until 256) {
      dut.io.ctrl.wrPage(i).poke(0.U)
    }
    dut.io.ctrl.device.poke(FlashDevice.Flash)  // all existing tests target flash
    dut.io.progMode.poke(false.B)
    dut.io.spi.sd1.poke(false.B)
  }

  private def pokePage(dut: SpiFlashController, bytes: Seq[Int]): Unit = {
    dut.io.ctrl.wrLen.poke(bytes.length.U)
    for (i <- 0 until 256) {
      val value = if (i < bytes.length) bytes(i) else 0
      dut.io.ctrl.wrPage(i).poke(value.U)
    }
  }

  private def bitsToInt(bits: Seq[Int]): Int =
    bits.foldLeft(0) { case (acc, bit) => (acc << 1) | bit }

  // bitsToInt overflows for full 32-bit values — use this for data word comparisons
  private def bitsToLong(bits: Seq[Int]): Long =
    bits.foldLeft(0L) { case (acc, bit) => (acc << 1) | bit }

  // Generalised read helper: csActive is re-evaluated each cycle so any CS pin can be passed.
  // Drives sd1 with readWord bits and waits for io.mem.ack.
  private def collectMosiAndReadUntilAck(
      dut: SpiFlashController,
      csActive: => Boolean,  // e.g. !dut.io.spi.cs1.peek().litToBoolean
      readWord: Long,
      maxCycles: Int = 300
  ): (Vector[Int], Int) = {
    var mosiBits = Vector.empty[Int]
    var readBitsDriven = 0
    var sawAck = false

    for (_ <- 0 until maxCycles if !sawAck) {
      val isSelected = csActive
      val sckHigh    = dut.io.spi.sck.peek().litToBoolean

      if (isSelected && sckHigh) {
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

    assert(sawAck, "controller never acknowledged the read")
    (mosiBits, readBitsDriven)
  }

  // Write helper: no MISO driving, just collects MOSI bits and waits for ack.
  private def collectMosiUntilWriteAck(
      dut: SpiFlashController,
      csActive: => Boolean,
      maxCycles: Int = 300
  ): Vector[Int] = {
    var mosiBits = Vector.empty[Int]
    var sawAck   = false

    for (_ <- 0 until maxCycles if !sawAck) {
      val isSelected = csActive
      val sckHigh    = dut.io.spi.sck.peek().litToBoolean

      if (isSelected && sckHigh) {
        mosiBits :+= dut.io.spi.sd0.peek().litValue.toInt
      }

      if (dut.io.mem.ack.peek().litToBoolean) {
        sawAck = true
      }

      dut.clock.step()
    }

    assert(sawAck, "controller never acknowledged the write")
    mosiBits
  }

  private def collectMosiUntilMemAck(
      dut: SpiFlashController,
      readWord: Long
  ): (Vector[Int], Int) = {
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
    (mosiBits, readBitsDriven)
  }

  private def collectMosiUntilCtrlDone(
      dut: SpiFlashController,
      maxCycles: Int = 200
  ): Vector[Int] = {
    var mosiBits = Vector.empty[Int]
    var sawDone = false

    for (_ <- 0 until maxCycles if !sawDone) {
      val csLow = !dut.io.spi.cs0.peek().litToBoolean
      val sckHigh = dut.io.spi.sck.peek().litToBoolean

      if (csLow && sckHigh) {
        mosiBits :+= dut.io.spi.sd0.peek().litValue.toInt
      }

      if (dut.io.ctrl.done.peek().litToBoolean) {
        sawDone = true
      }

      dut.clock.step()
    }

    assert(sawDone, "controller never signalled ctrl.done")
    mosiBits
  }

  private def collectMosiAndDriveStatusUntilDone(
      dut: SpiFlashController,
      statusByte: Int
  ): Vector[Int] = {
    var mosiBits = Vector.empty[Int]
    var statusBitsDriven = 0
    var sawDone = false

    for (_ <- 0 until 100 if !sawDone) {
      val csLow = !dut.io.spi.cs0.peek().litToBoolean
      val sckHigh = dut.io.spi.sck.peek().litToBoolean

      if (csLow && sckHigh) {
        if (mosiBits.length < 8) {
          mosiBits :+= dut.io.spi.sd0.peek().litValue.toInt
          dut.io.spi.sd1.poke(false.B)
        } else {
          val bit = ((statusByte >> (7 - statusBitsDriven)) & 1) == 1
          dut.io.spi.sd1.poke(bit.B)
          statusBitsDriven += 1
        }
      } else {
        dut.io.spi.sd1.poke(false.B)
      }

      if (dut.io.ctrl.done.peek().litToBoolean) {
        dut.io.ctrl.rdByte.expect(statusByte.U)
        sawDone = true
      }

      dut.clock.step()
    }

    assert(sawDone, "controller never signalled ctrl.done for read-status")
    assert(statusBitsDriven == 8, s"expected 8 status bits, got $statusBitsDriven")
    mosiBits
  }

  it should "send 0x03, send the 24-bit address, and read back one 32-bit word" in {
    test(new SpiFlashController()) { dut =>
      val flashAddr = 0x001234
      val readWord = 0x89abcdefL

      init(dut)

      dut.clock.step()

      dut.io.mem.address.poke(flashAddr.U)
      dut.io.mem.rd.poke(true.B)
      dut.clock.step()
      dut.io.mem.rd.poke(false.B)

      val (mosiBits, readBitsDriven) = collectMosiUntilMemAck(dut, readWord)
      assert(readBitsDriven == 32, s"expected 32 read bits, got $readBitsDriven")

      val cmdBits = bitsToInt(mosiBits.take(8))
      val addrBits = bitsToInt(mosiBits.drop(8).take(24))

      assert(cmdBits == 0x03, f"expected read command 0x03, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected address 0x$flashAddr%06x, got 0x$addrBits%06x")
    }
  }

  it should "ignore cache reads while progMode is asserted" in {
    test(new SpiFlashController()) { dut =>
      init(dut)
      dut.io.progMode.poke(true.B)
      dut.io.mem.address.poke(0x001234.U)
      dut.io.mem.rd.poke(true.B)

      dut.clock.step(20)

      dut.io.mem.ack.expect(false.B)
      dut.io.ctrl.busy.expect(false.B)
      dut.io.spi.cs0.expect(true.B)
      dut.io.spi.sck.expect(false.B)
    }
  }

  it should "send write-enable command from the control port" in {
    test(new SpiFlashController()) { dut =>
      init(dut)
      dut.io.progMode.poke(true.B)
      dut.io.ctrl.op.poke(FlashCtrlOp.WriteEnable)
      dut.io.ctrl.start.poke(true.B)
      dut.clock.step()
      dut.io.ctrl.start.poke(false.B)

      val mosiBits = collectMosiUntilCtrlDone(dut)
      val cmdBits = bitsToInt(mosiBits.take(8))

      assert(cmdBits == 0x06, f"expected write-enable command 0x06, got 0x$cmdBits%02x")
      assert(mosiBits.length == 8, s"expected 8 MOSI bits, got ${mosiBits.length}")
      dut.io.mem.ack.expect(false.B)
    }
  }

  it should "send read-status command and capture the returned status byte" in {
    test(new SpiFlashController()) { dut =>
      val statusByte = 0xa5

      init(dut)
      dut.io.progMode.poke(true.B)
      dut.io.ctrl.op.poke(FlashCtrlOp.ReadStatus)
      dut.io.ctrl.start.poke(true.B)
      dut.clock.step()
      dut.io.ctrl.start.poke(false.B)

      val mosiBits = collectMosiAndDriveStatusUntilDone(dut, statusByte)
      val cmdBits = bitsToInt(mosiBits.take(8))

      assert(cmdBits == 0x05, f"expected read-status command 0x05, got 0x$cmdBits%02x")
      assert(mosiBits.length == 8, s"expected 8 command MOSI bits, got ${mosiBits.length}")
    }
  }

  it should "send page-program command, address, and one data byte from the control port" in {
    test(new SpiFlashController()) { dut =>
      val flashAddr = 0x00cafe
      val pageBytes = Seq(0x5a, 0x11, 0x22, 0x33)

      init(dut)
      dut.io.progMode.poke(true.B)
      dut.io.ctrl.op.poke(FlashCtrlOp.ProgramByte)
      dut.io.ctrl.addr.poke(flashAddr.U)
      dut.io.ctrl.wrByte.poke(pageBytes.head.U)
      pokePage(dut, pageBytes)
      dut.io.ctrl.start.poke(true.B)
      dut.clock.step()
      dut.io.ctrl.start.poke(false.B)

      val mosiBits = collectMosiUntilCtrlDone(dut, maxCycles = 160)
      val cmdBits = bitsToInt(mosiBits.take(8))
      val addrBits = bitsToInt(mosiBits.drop(8).take(24))
      val dataBits = mosiBits.drop(32).grouped(8).map(bitsToInt).toVector

      assert(cmdBits == 0x02, f"expected program command 0x02, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected address 0x$flashAddr%06x, got 0x$addrBits%06x")
      assert(dataBits == pageBytes, s"expected data bytes ${pageBytes.mkString(",")}, got ${dataBits.mkString(",")}")
      assert(mosiBits.length == 64, s"expected 64 MOSI bits, got ${mosiBits.length}")
    }
  }

  it should "assert CS1 not CS0 and send read command to PSRAM A at address 0x1xxxxxxx" in {
    test(new SpiFlashController()) { dut =>
      val fullAddr = 0x10001234  // bits[31:28]=0x1 selects PSRAM A; chip-internal addr = 0x001234
      val readWord = 0xcafebabeL

      init(dut)
      dut.clock.step()

      dut.io.mem.address.poke(fullAddr.U)
      dut.io.mem.rd.poke(true.B)
      dut.clock.step()
      dut.io.mem.rd.poke(false.B)

      val (mosiBits, readBitsDriven) = collectMosiAndReadUntilAck(
        dut,
        csActive = !dut.io.spi.cs1.peek().litToBoolean,  // watch CS1
        readWord = readWord
      )

      // CS0 (flash) must never drop during a PSRAM transaction
      dut.io.spi.cs0.expect(true.B)

      assert(readBitsDriven == 32, s"expected 32 read bits driven, got $readBitsDriven")
      assert(bitsToInt(mosiBits.take(8))   == 0x03,   f"expected read cmd 0x03, got 0x${bitsToInt(mosiBits.take(8))}%02x")
      assert(bitsToInt(mosiBits.drop(8).take(24)) == (fullAddr & 0xffffff),
             f"expected addr 0x${fullAddr & 0xffffff}%06x, got 0x${bitsToInt(mosiBits.drop(8).take(24))}%06x")
    }
  }

  it should "assert CS2 not CS0/CS1 and send read command to PSRAM B at address 0x2xxxxxxx" in {
    test(new SpiFlashController()) { dut =>
      val fullAddr = 0x20005678  // bits[31:28]=0x2 selects PSRAM B
      val readWord = 0xdeadbeefL

      init(dut)
      dut.clock.step()

      dut.io.mem.address.poke(fullAddr.U)
      dut.io.mem.rd.poke(true.B)
      dut.clock.step()
      dut.io.mem.rd.poke(false.B)

      val (mosiBits, _) = collectMosiAndReadUntilAck(
        dut,
        csActive = !dut.io.spi.cs2.peek().litToBoolean,  // watch CS2
        readWord = readWord
      )

      dut.io.spi.cs0.expect(true.B)
      dut.io.spi.cs1.expect(true.B)

      assert(bitsToInt(mosiBits.take(8)) == 0x03, f"expected read cmd 0x03, got 0x${bitsToInt(mosiBits.take(8))}%02x")
      assert(bitsToInt(mosiBits.drop(8).take(24)) == (fullAddr & 0xffffff))
    }
  }

  it should "write a word to PSRAM A via io.mem.wr: CS1 asserted, cmd 0x02, address, then 32-bit data" in {
    test(new SpiFlashController()) { dut =>
      val fullAddr  = 0x10001234
      val writeData = 0xaabbccddL  // Long to avoid sign issues when comparing

      init(dut)
      dut.clock.step()

      dut.io.mem.address.poke(fullAddr.U)
      dut.io.mem.wrData.poke(writeData.U)
      dut.io.mem.wr.poke(true.B)
      dut.clock.step()
      dut.io.mem.wr.poke(false.B)

      val mosiBits = collectMosiUntilWriteAck(
        dut,
        csActive = !dut.io.spi.cs1.peek().litToBoolean
      )

      dut.io.spi.cs0.expect(true.B)  // flash never selected

      // 8 cmd + 24 addr + 32 data = 64 bits
      assert(mosiBits.length == 64, s"expected 64 MOSI bits, got ${mosiBits.length}")
      assert(bitsToInt(mosiBits.take(8))           == 0x02, "expected write cmd 0x02")
      assert(bitsToInt(mosiBits.drop(8).take(24))  == (fullAddr & 0xffffff), "wrong address")
      assert(bitsToLong(mosiBits.drop(32).take(32)) == writeData, "wrong write data")
    }
  }

  it should "send sector-erase command and address from the control port" in {
    test(new SpiFlashController()) { dut =>
      val flashAddr = 0x003000

      init(dut)
      dut.io.progMode.poke(true.B)
      dut.io.ctrl.op.poke(FlashCtrlOp.SectorErase)
      dut.io.ctrl.addr.poke(flashAddr.U)
      dut.io.ctrl.start.poke(true.B)
      dut.clock.step()
      dut.io.ctrl.start.poke(false.B)

      val mosiBits = collectMosiUntilCtrlDone(dut)
      val cmdBits = bitsToInt(mosiBits.take(8))
      val addrBits = bitsToInt(mosiBits.drop(8).take(24))

      assert(cmdBits == 0x20, f"expected sector-erase command 0x20, got 0x$cmdBits%02x")
      assert(addrBits == flashAddr, f"expected address 0x$flashAddr%06x, got 0x$addrBits%06x")
      assert(mosiBits.length == 32, s"expected 32 MOSI bits, got ${mosiBits.length}")
    }
  }
}
