import chisel3._
import chisel3.util._

class PipeConSlaveIO(val addrWidth: Int = 32) extends Bundle {
  val address = Input(UInt(addrWidth.W))
  val rd      = Input(Bool())
  val wr      = Input(Bool())
  val wrData  = Input(UInt(32.W))
  val wrMask  = Input(UInt(4.W))
  val rdData  = Output(UInt(32.W))
  val ack     = Output(Bool())
}

class Group5SpiPhysicalIO extends Bundle {
  val sck   = Output(Bool())
  val mosi  = Output(Bool())
  val miso  = Input(Bool())
  val cs0_n = Output(Bool()) // Flash
  val cs1_n = Output(Bool()) // PSRAM A
  val cs2_n = Output(Bool()) // PSRAM B
}

class SpiMemoryController extends Module {
  val io = IO(new Bundle {
    val pipecon = new PipeConSlaveIO(32)
    val spi     = new Group5SpiPhysicalIO()
  })


  val sIdle :: sDoTransfer :: sCsToggle :: sDone :: Nil = Enum(4)
  val state     = RegInit(sIdle)
  val nextState = RegInit(sIdle)

  // sckPhase: false = about to do rising edge, true = about to do falling edge
  val sckPhase       = RegInit(false.B)

  val shiftReg       = RegInit(0.U(72.W))
  val readData       = RegInit(0.U(32.W))
  val bitsToTransfer = RegInit(0.U(7.W))
  val delayCnt       = RegInit(0.U(5.W))

  val addrReg        = RegInit(0.U(24.W))
  val dataReg        = RegInit(0.U(32.W))

  val isFlashErase   = RegInit(false.B)
  val isFlashUnlock  = RegInit(false.B)

  val spiSckReg  = RegInit(false.B)
  val spiMosiReg = RegInit(false.B)
  val spiCs0nReg = RegInit(true.B)
  val spiCs1nReg = RegInit(true.B)
  val spiCs2nReg = RegInit(true.B)

  io.spi.sck   := spiSckReg
  io.spi.mosi  := spiMosiReg
  io.spi.cs0_n := spiCs0nReg
  io.spi.cs1_n := spiCs1nReg
  io.spi.cs2_n := spiCs2nReg

  io.pipecon.ack    := false.B
  io.pipecon.rdData := readData

  switch(state) {
    is(sIdle) {
      spiCs0nReg := true.B
      spiCs1nReg := true.B
      spiCs2nReg := true.B
      spiSckReg  := false.B
      sckPhase   := false.B
      delayCnt   := 0.U

      when(io.pipecon.rd || io.pipecon.wr) {

        // Drop bits 1 and 0, and replace them with "00"
        // This guarantees we always fetch a 32-bit aligned word
        val wordAlignedAddr = Cat(io.pipecon.address(23, 2), "b00".U(2.W))

        addrReg       := wordAlignedAddr
        dataReg       := io.pipecon.wrData
        readData      := 0.U

        isFlashErase  := (io.pipecon.address(31, 24) === "h41".U)
        isFlashUnlock := (io.pipecon.address(31, 24) === "h43".U)

        val isFlash  = io.pipecon.address(31, 28) === "h4".U
        val isPsramA = io.pipecon.address(31, 28) === "h5".U
        val isPsramB = io.pipecon.address(31, 28) === "h6".U

        val isFlashWriteOrErase = io.pipecon.wr && (io.pipecon.address(31, 24) === "h40".U || io.pipecon.address(31, 24) === "h41".U || io.pipecon.address(31, 24) === "h43".U)

        when(isFlashWriteOrErase) {
          // WREN (0x06)
          spiMosiReg     := false.B
          shiftReg       := Cat("h06".U(8.W)(6, 0), 0.U(65.W))
          bitsToTransfer := 8.U
          nextState      := sCsToggle
        } .elsewhen(io.pipecon.rd && io.pipecon.address(31, 24) === "h42".U) {
          // Read Status (0x05)
          spiMosiReg     := false.B
          shiftReg       := Cat("h05".U(8.W)(6, 0), 0.U(65.W))
          bitsToTransfer := 16.U
          nextState      := sDone
        } .elsewhen(io.pipecon.rd) {
          // FAST READ (0x0B)
          val cmd = "h0B".U(8.W)
          spiMosiReg     := cmd(7)
          // USE WORD-ALIGNED ADDRESS
          shiftReg       := Cat(cmd(6, 0), wordAlignedAddr, 0.U(8.W), 0.U(33.W))
          bitsToTransfer := 72.U
          nextState      := sDone
        } .otherwise {
          // PAGE PROGRAM (0x02)
          val cmd = "h02".U(8.W)
          spiMosiReg     := cmd(7)
          // USE WORD-ALIGNED ADDRESS
          shiftReg       := Cat(cmd(6, 0), wordAlignedAddr, io.pipecon.wrData, 0.U(9.W))
          bitsToTransfer := 64.U
          nextState      := sDone
        }

        when(isFlash)  { spiCs0nReg := false.B }
        when(isPsramA) { spiCs1nReg := false.B }
        when(isPsramB) { spiCs2nReg := false.B }
        state := sDoTransfer
      }
    }

    is(sDoTransfer) {
      // Toggle sckPhase every system clock — gives 5MHz SCK at 10MHz sys-clk
      sckPhase := !sckPhase
      when(!sckPhase) {
        // ---- Rising edge ----
        spiSckReg := true.B
        when(bitsToTransfer <= 32.U) {
          readData := Cat(readData(30, 0), io.spi.miso)
        }
      } .otherwise {
        // ---- Falling edge ----
        spiSckReg := false.B
        when(bitsToTransfer === 1.U) {
          // Last bit just clocked — move to next state
          state    := nextState
          sckPhase := false.B
        } .otherwise {
          spiMosiReg     := shiftReg(71)
          shiftReg       := Cat(shiftReg(70, 0), 0.U(1.W))
          bitsToTransfer := bitsToTransfer - 1.U
        }
      }
    }

    is(sCsToggle) {
      spiCs0nReg := true.B
      delayCnt   := delayCnt + 1.U

      // Hold CS high for 20 system clock cycles (~2µs at 10MHz)
      // Flash tSHSL (CS high time between commands) minimum = 50ns — satisfied
      when(delayCnt === 19.U) {
        spiCs0nReg := false.B
        delayCnt   := 0.U
        sckPhase   := false.B

        when(isFlashErase) {
          spiMosiReg     := false.B
          shiftReg       := Cat("h20".U(8.W)(6, 0), addrReg, 0.U(41.W))
          bitsToTransfer := 32.U
        } .elsewhen(isFlashUnlock) {
          spiMosiReg     := false.B
          shiftReg       := Cat("h01".U(8.W)(6, 0), dataReg(7, 0), 0.U(57.W))
          bitsToTransfer := 16.U
        } .otherwise {
          spiMosiReg     := false.B
          shiftReg       := Cat("h02".U(8.W)(6, 0), addrReg, dataReg, 0.U(9.W))
          bitsToTransfer := 64.U
        }
        nextState := sDone
        state     := sDoTransfer
      }
    }

    is(sDone) {
      spiCs0nReg     := true.B
      spiCs1nReg     := true.B
      spiCs2nReg     := true.B
      spiSckReg      := false.B
      io.pipecon.ack := true.B
      state          := sIdle
    }
  }
}