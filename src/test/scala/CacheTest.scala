import chisel3._
import chiseltest._
import chiseltest.simulator.VerilatorBackendAnnotation
import chiseltest.simulator.VerilatorFlags
import chiseltest.simulator.WriteVcdAnnotation
import memory.DataCache
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class CacheTest extends AnyFreeSpec with Matchers with ChiselScalatestTester {
  "write, read miss-fill, and second read hit after init" in {
    test(new DataCache)
      .withAnnotations(Seq(
        VerilatorBackendAnnotation,
        VerilatorFlags(Seq("--no-timing")),
        WriteVcdAnnotation
      )) { dut =>

      val backingMem = scala.collection.mutable.Map[BigInt, BigInt]()

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

      def serviceMemory(): Unit = {
          val memRd = dut.io.memIO.rd.peek().litToBoolean
          val memWr = dut.io.memIO.wr.peek().litToBoolean

          val memAddr = dut.io.memIO.address.peek().litValue
          val memWrData = dut.io.memIO.wrData.peek().litValue
          val memWrMask = dut.io.memIO.wrMask.peek().litValue

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

      def stepWithMemory(n: Int): Unit = {
        for (_ <- 0 until n) {
          serviceMemory()
          dut.clock.step()
        }
      }

      def waitForCpuAck(maxCycles: Int = 50): Unit = {
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

      def cpuRead(addr: UInt): BigInt = {
        dut.io.cpuIO.address.poke(addr)
        dut.io.cpuIO.rd.poke(true.B)
        dut.io.cpuIO.wr.poke(false.B)

        // Request is one-cycle pulse
        serviceMemory()
        dut.clock.step()
        dut.io.cpuIO.rd.poke(false.B)

        var cycles = 0
        var seenAck = false

        while (!seenAck && cycles < 50) {
          serviceMemory()

          if (dut.io.cpuIO.ack.peek().litToBoolean) {
            seenAck = true
          } else {
            dut.clock.step()
            cycles += 1
          }
        }

        assert(seenAck, "CPU ack was not seen")

        val value = dut.io.cpuIO.rdData.peek().litValue

        stepWithMemory(2)

        value
      }

      // ------------------------------------------------------------
      // Initial defaults
      // ------------------------------------------------------------
      dut.io.cpuIO.address.poke(0.U)
      dut.io.cpuIO.rd.poke(false.B)
      dut.io.cpuIO.wr.poke(false.B)
      dut.io.cpuIO.wrData.poke(0.U)
      dut.io.cpuIO.wrMask.poke("b0000".U)

      dut.io.memIO.ack.poke(false.B)
      dut.io.memIO.rdData.poke(0.U)

      // ------------------------------------------------------------
      // Wait for metadata init
      // ------------------------------------------------------------
      stepWithMemory(300)

      val addr = "he0000000".U(32.W)
      val data = BigInt("DEADBEEF", 16)

      // ------------------------------------------------------------
      // Write one word through CPU side
      // ------------------------------------------------------------
      dut.io.cpuIO.address.poke(addr)
      dut.io.cpuIO.wrData.poke(data.U(32.W))
      dut.io.cpuIO.wrMask.poke("b1111".U)
      dut.io.cpuIO.wr.poke(true.B)
      dut.io.cpuIO.rd.poke(false.B)

      stepWithMemory(1)

      dut.io.cpuIO.wr.poke(false.B)
      dut.io.cpuIO.wrMask.poke("b0000".U)

      waitForCpuAck()

      stepWithMemory(1)

      // ------------------------------------------------------------
      // First read: should return DEADBEEF.
      // Since write miss does not allocate, this probably misses and fills cache.
      // ------------------------------------------------------------
      val firstRead = cpuRead(addr)
      assert(firstRead == data)

      backingMem(BigInt(0)) = BigInt("CAFEBABE", 16)

      val secondRead = cpuRead(addr)
      assert(
        secondRead == data,
        s"Second read got 0x${secondRead.toString(16)}, expected cached 0x${data.toString(16)}"
      )
    }
  }


}