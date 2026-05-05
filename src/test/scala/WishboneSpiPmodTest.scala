import chisel3._
import chiseltest._
import memory._
import org.scalatest.flatspec.AnyFlatSpec

class WishboneSpiPmodTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "WishboneSpiPmod"

  private def init(dut: WishboneSpiPmod): Unit = {
    dut.wb.addr.poke(0.U)
    dut.wb.wrData.poke(0.U)
    dut.wb.we.poke(false.B)
    dut.wb.sel.poke(15.U)
    dut.wb.stb.poke(false.B)
    dut.wb.cyc.poke(false.B)

    dut.ctrl.rdByte.poke(0.U)
    dut.ctrl.busy.poke(false.B)
    dut.ctrl.done.poke(false.B)
  }

  private def wbWrite(dut: WishboneSpiPmod, addr: Int, data: Int): Unit = {
    dut.wb.addr.poke(addr.U)
    dut.wb.wrData.poke(data.U)
    dut.wb.we.poke(true.B)
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

  private def wbRead(dut: WishboneSpiPmod, addr: Int): BigInt = {
    dut.wb.addr.poke(addr.U)
    dut.wb.we.poke(false.B)
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

  it should "store ADDR and DATA registers and forward them to the control port" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      wbWrite(dut, 4, 0x001234)
      wbWrite(dut, 8, 0xab)

      assert(wbRead(dut, 4) == 0x001234)
      assert(wbRead(dut, 8) == 0xab)
      dut.ctrl.addr.expect(0x001234.U)
      dut.ctrl.wrByte.expect(0xab.U)
    }
  }

  it should "store a page buffer and length for page-program commands" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      wbWrite(dut, 16, 4)
      wbWrite(dut, 20, 0x11)
      wbWrite(dut, 21, 0x22)
      wbWrite(dut, 22, 0x33)
      wbWrite(dut, 23, 0x44)

      assert(wbRead(dut, 16) == 4)
      assert(wbRead(dut, 20) == 0x11)
      assert(wbRead(dut, 21) == 0x22)
      assert(wbRead(dut, 22) == 0x33)
      assert(wbRead(dut, 23) == 0x44)

      dut.ctrl.wrLen.expect(4.U)
      dut.ctrl.wrPage(0).expect(0x11.U)
      dut.ctrl.wrPage(1).expect(0x22.U)
      dut.ctrl.wrPage(2).expect(0x33.U)
      dut.ctrl.wrPage(3).expect(0x44.U)
    }
  }

  it should "raise progMode and drive ctrl.start/op when CMD start is written" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      wbWrite(dut, 4, 0x00cafe)
      wbWrite(dut, 8, 0x5a)
      wbWrite(dut, 0, ((FlashCtrlOp.ProgramByte.litValue.toInt << 1) | 1))

      dut.progMode.expect(true.B)
      dut.ctrl.start.expect(true.B)
      dut.ctrl.op.expect(FlashCtrlOp.ProgramByte)
      dut.ctrl.addr.expect(0x00cafe.U)
      dut.ctrl.wrByte.expect(0x5a.U)

      dut.ctrl.busy.poke(true.B)
      dut.clock.step()
      dut.ctrl.start.expect(false.B)
      dut.progMode.expect(true.B)

      dut.ctrl.busy.poke(false.B)
      dut.ctrl.done.poke(true.B)
      dut.clock.step()
      dut.progMode.expect(false.B)
      dut.ctrl.done.poke(false.B)
    }
  }

  it should "copy ctrl.rdByte into DATA when a control operation completes" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      wbWrite(dut, 0, ((FlashCtrlOp.ReadStatus.litValue.toInt << 1) | 1))
      dut.progMode.expect(true.B)
      dut.ctrl.op.expect(FlashCtrlOp.ReadStatus)

      dut.ctrl.busy.poke(true.B)
      dut.clock.step()
      dut.ctrl.start.expect(false.B)

      dut.ctrl.busy.poke(false.B)
      dut.ctrl.rdByte.poke(0xa5.U)
      dut.ctrl.done.poke(true.B)
      dut.clock.step()
      dut.ctrl.done.poke(false.B)

      dut.progMode.expect(false.B)
      assert(wbRead(dut, 8) == 0xa5)
    }
  }

  it should "store the device register and forward it to ctrl.device" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      // default is flash (0)
      assert(wbRead(dut, 276) == FlashDevice.Flash.litValue)
      dut.ctrl.device.expect(FlashDevice.Flash)

      // select PSRAM A
      wbWrite(dut, 276, FlashDevice.PsramA.litValue.toInt)
      assert(wbRead(dut, 276) == FlashDevice.PsramA.litValue)
      dut.ctrl.device.expect(FlashDevice.PsramA)

      // select PSRAM B
      wbWrite(dut, 276, FlashDevice.PsramB.litValue.toInt)
      assert(wbRead(dut, 276) == FlashDevice.PsramB.litValue)
      dut.ctrl.device.expect(FlashDevice.PsramB)
    }
  }

  it should "report busy through STATUS while a command is pending or active" in {
    test(new WishboneSpiPmod()) { dut =>
      init(dut)

      assert(wbRead(dut, 12) == 0)

      wbWrite(dut, 0, ((FlashCtrlOp.WriteEnable.litValue.toInt << 1) | 1))
      assert(wbRead(dut, 12) == 1)

      dut.ctrl.busy.poke(true.B)
      dut.clock.step()
      assert(wbRead(dut, 12) == 1)

      dut.ctrl.busy.poke(false.B)
      dut.ctrl.done.poke(true.B)
      dut.clock.step()
      dut.ctrl.done.poke(false.B)

      assert(wbRead(dut, 12) == 0)
    }
  }
}
