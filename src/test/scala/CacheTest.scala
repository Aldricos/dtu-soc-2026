import chisel3._
import chiseltest._
import chiseltest.simulator.VerilatorBackendAnnotation
import chiseltest.simulator.VerilatorFlags
import memory.DataCache
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class CacheTest extends AnyFreeSpec with Matchers with ChiselScalatestTester {

  def withCacheTest(testName: String)(body: DataCache => Unit): Unit = {
    testName in {
      test(new DataCache)
        .withAnnotations(Seq(
          VerilatorBackendAnnotation,
          VerilatorFlags(Seq("--no-timing"))
        )) { dut =>
          body(dut)
        }
    }
  }

  def applyMask(old: BigInt, data: BigInt, mask: BigInt): BigInt = {
    var result = old

    for (i <- 0 until 4) {
      if (((mask >> i) & 1) == 1) {
        val byteMask = BigInt(0xff) << (8 * i)
        result = (result & ~byteMask) | (data & byteMask)
      }
    }

    result & BigInt("ffffffff", 16)
  }

  def backingAddr(cpuAddr: BigInt): BigInt = {
    cpuAddr & BigInt("0fffffff", 16)
  }

  class CacheHarness(dut: DataCache) {
    val backingMem = scala.collection.mutable.Map[BigInt, BigInt]()

    var memReadCount = 0
    var memWriteCount = 0

    private var prevMemRd = false
    private var prevMemWr = false

    def serviceMemory(): Unit = {
      val memRd = dut.io.memIO.rd.peek().litToBoolean
      val memWr = dut.io.memIO.wr.peek().litToBoolean

      val memAddr = dut.io.memIO.address.peek().litValue
      val memWrData = dut.io.memIO.wrData.peek().litValue
      val memWrMask = dut.io.memIO.wrMask.peek().litValue

      if (memRd && !prevMemRd) {
        memReadCount += 1
      }

      if (memWr && !prevMemWr) {
        memWriteCount += 1
      }

      prevMemRd = memRd
      prevMemWr = memWr

      if (memWr) {
        val old = backingMem.getOrElse(memAddr, BigInt(0))
        backingMem(memAddr) = applyMask(old, memWrData, memWrMask)
      }

      val readData =
        if (memRd) backingMem.getOrElse(memAddr, BigInt(0))
        else BigInt(0)

      dut.io.memIO.ack.poke((memRd || memWr).B)
      dut.io.memIO.rdData.poke(readData.U(32.W))
    }

    def step(n: Int): Unit = {
      for (_ <- 0 until n) {
        serviceMemory()
        dut.clock.step()
      }
    }

    def init(): Unit = {
      dut.io.cpuIO.address.poke(0.U)
      dut.io.cpuIO.rd.poke(false.B)
      dut.io.cpuIO.wr.poke(false.B)
      dut.io.cpuIO.wrData.poke(0.U)
      dut.io.cpuIO.wrMask.poke("b0000".U)

      dut.io.memIO.ack.poke(false.B)
      dut.io.memIO.rdData.poke(0.U)

      step(300)
    }

    def waitForCpuAck(maxCycles: Int = 100): Unit = {
      var cycles = 0

      while (cycles < maxCycles) {
        serviceMemory()

        if (dut.io.cpuIO.ack.peek().litToBoolean) {
          return
        }

        dut.clock.step()
        cycles += 1
      }

      assert(false, s"CPU ack was not seen within $maxCycles cycles")
    }

    def cpuRead(addr: BigInt): BigInt = {
      dut.io.cpuIO.address.poke(addr.U(32.W))
      dut.io.cpuIO.rd.poke(true.B)
      dut.io.cpuIO.wr.poke(false.B)
      dut.io.cpuIO.wrData.poke(0.U)
      dut.io.cpuIO.wrMask.poke(0.U)

      waitForCpuAck()

      val value = dut.io.cpuIO.rdData.peek().litValue

      dut.io.cpuIO.rd.poke(false.B)
      step(2)

      value
    }

    def cpuWrite(addr: BigInt, data: BigInt, mask: BigInt = 0xf): Unit = {
      dut.io.cpuIO.address.poke(addr.U(32.W))
      dut.io.cpuIO.rd.poke(false.B)
      dut.io.cpuIO.wr.poke(true.B)
      dut.io.cpuIO.wrData.poke(data.U(32.W))
      dut.io.cpuIO.wrMask.poke(mask.U(4.W))

      waitForCpuAck()

      dut.io.cpuIO.wr.poke(false.B)
      dut.io.cpuIO.wrMask.poke(0.U)

      step(2)
    }

    def setBacking(cpuAddr: BigInt, data: BigInt): Unit = {
      backingMem(backingAddr(cpuAddr)) = data & BigInt("ffffffff", 16)
    }

    def getBacking(cpuAddr: BigInt): BigInt = {
      backingMem.getOrElse(backingAddr(cpuAddr), BigInt(0))
    }

    def expectRead(addr: BigInt, expected: BigInt): Unit = {
      val got = cpuRead(addr)
      assert(
        got == expected,
        s"Read from 0x${addr.toString(16)} got 0x${got.toString(16)}, expected 0x${expected.toString(16)}"
      )
    }
  }

  withCacheTest("read miss fills cache and second read hits cached value") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000000", 16)
    val data = BigInt("deadbeef", 16)

    h.setBacking(addr, data)

    // First read: should miss/fill and return backing value.
    h.expectRead(addr, data)

    // Change backing memory. If the second read really hits cache,
    // it should still return the old cached value.
    h.setBacking(addr, BigInt("cafebabe", 16))

    // Second read should return cached DEADBEEF, not CAFEBABE.
    h.expectRead(addr, data)
  }

  withCacheTest("write-through write updates backing memory and later read returns written data") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000000", 16)
    val data = BigInt("deadbeef", 16)

    val writesBefore = h.memWriteCount

    h.cpuWrite(addr, data)

    assert(
      h.memWriteCount == writesBefore + 1,
      s"CPU write should cause one backing-memory write"
    )

    assert(
      h.getBacking(addr) == data,
      s"Backing memory should contain written data"
    )

    h.expectRead(addr, data)
  }

  withCacheTest("byte-mask write updates only selected bytes in backing memory") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000000", 16)

    h.setBacking(addr, BigInt("11223344", 16))

    h.cpuWrite(
      addr = addr,
      data = BigInt("deadbeef", 16),
      mask = BigInt("0101", 2)
    )

    // mask 0101 updates byte 0 and byte 2:
    //
    // old  = 0x11_22_33_44
    // data = 0xde_ad_be_ef
    //
    // byte 0 -> ef
    // byte 1 -> 33
    // byte 2 -> ad
    // byte 3 -> 11
    //
    // result = 0x11_ad_33_ef
    val expected = BigInt("11ad33ef", 16)

    assert(
      h.getBacking(addr) == expected,
      s"Masked write produced 0x${h.getBacking(addr).toString(16)}, expected 0x${expected.toString(16)}"
    )
  }

  withCacheTest("different cache indices can both be cached") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr0 = BigInt("e0000000", 16) // index 0
    val addr1 = BigInt("e0000004", 16) // index 1

    val data0 = BigInt("aaaabbbb", 16)
    val data1 = BigInt("ccccdddd", 16)

    // Put initial values in backing memory
    h.setBacking(addr0, data0)
    h.setBacking(addr1, data1)

    // First reads should miss and fill cache lines index 0 and index 1
    h.expectRead(addr0, data0)
    h.expectRead(addr1, data1)

    // Change backing memory after cache fill
    h.setBacking(addr0, BigInt("11111111", 16))
    h.setBacking(addr1, BigInt("22222222", 16))

    // If both lines are cached, these should still return old cached values
    h.expectRead(addr0, data0)
    h.expectRead(addr1, data1)
  }

  withCacheTest("same index different tag causes conflict miss and replacement") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addrA = BigInt("e0000000", 16) // index 0, tag 0
    val addrB = BigInt("e0000400", 16) // index 0, tag 1 because bit 10 changes

    val dataA = BigInt("aaaaaaaa", 16)
    val dataB = BigInt("bbbbbbbb", 16)

    h.setBacking(addrA, dataA)
    h.setBacking(addrB, dataB)

    h.expectRead(addrA, dataA)
    val readsAfterA = h.memReadCount

    h.expectRead(addrB, dataB)
    val readsAfterB = h.memReadCount

    assert(
      readsAfterB == readsAfterA + 1,
      s"Different tag with same index should miss and access backing memory"
    )

    // Change backing memory for addrA.
    // Since addrB replaced addrA in direct-mapped cache, reading addrA again
    // should miss and fetch the new backing value.
    val newDataA = BigInt("cccccccc", 16)
    h.setBacking(addrA, newDataA)

    h.expectRead(addrA, newDataA)

    assert(
      h.memReadCount == readsAfterB + 1,
      s"Reading addrA after addrB conflict should miss again"
    )
  }

  withCacheTest("repeated reads to same cached line return cached value") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000010", 16)
    val data = BigInt("12345678", 16)

    h.setBacking(addr, data)

    // First read fills cache
    h.expectRead(addr, data)

    // Change backing memory after fill
    h.setBacking(addr, BigInt("deadbeef", 16))

    // Repeated reads should still return cached original value
    for (_ <- 0 until 5) {
      h.expectRead(addr, data)
    }
  }

  withCacheTest("write hit updates cached copy and backing memory") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000000", 16)

    val oldData = BigInt("11111111", 16)
    val newData = BigInt("22222222", 16)

    // Put old value in backing memory
    h.setBacking(addr, oldData)

    // First read fills cache with oldData
    h.expectRead(addr, oldData)

    // Write same address.
    // Since line is cached, this should be a write hit:
    // - update backing memory
    // - update cached copy
    h.cpuWrite(addr, newData)

    // Check write-through behavior
    assert(
      h.getBacking(addr) == newData,
      s"Backing memory got 0x${h.getBacking(addr).toString(16)}, expected 0x${newData.toString(16)}"
    )

    // Change backing memory after the write.
    // If cache was updated by write hit, read should still return newData.
    h.setBacking(addr, BigInt("33333333", 16))

    h.expectRead(addr, newData)
  }

  withCacheTest("masked write hit updates selected bytes in cache and backing memory") { dut =>
    val h = new CacheHarness(dut)
    h.init()

    val addr = BigInt("e0000000", 16)

    h.setBacking(addr, BigInt("11223344", 16))

    // Fill cache.
    h.expectRead(addr, BigInt("11223344", 16))

    // Masked write hit.
    h.cpuWrite(
      addr = addr,
      data = BigInt("deadbeef", 16),
      mask = BigInt("0101", 2)
    )

    val expected = BigInt("11ad33ef", 16)

    // Backing memory should be updated.
    assert(h.getBacking(addr) == expected)

    // Now corrupt backing memory.
    h.setBacking(addr, BigInt("aaaaaaaa", 16))

    // If cache was updated correctly, read should return cached masked result.
    h.expectRead(addr, expected)
  }
}