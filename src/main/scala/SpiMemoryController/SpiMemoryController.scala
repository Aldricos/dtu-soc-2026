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

  val DIVIDER_RATIO = 8 // Safe 12.5MHz

  val sIdle :: sDoTransfer :: sCsToggle :: sDone :: Nil = Enum(4)
  val state     = RegInit(sIdle)
  val nextState = RegInit(sIdle)

  val clkDiv         = RegInit(0.U(8.W))
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

  val tick     = (clkDiv === (DIVIDER_RATIO - 1).U)
  val halfTick = (clkDiv === ((DIVIDER_RATIO / 2) - 1).U)
  clkDiv := Mux(tick, 0.U, clkDiv + 1.U)

  switch(state) {
    is(sIdle) {
      spiCs0nReg := true.B
      spiCs1nReg := true.B
      spiCs2nReg := true.B
      spiSckReg  := false.B
      clkDiv     := 0.U
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
      when(halfTick) {
        spiSckReg := true.B
        when(bitsToTransfer <= 32.U) {
          readData := Cat(readData(30, 0), io.spi.miso)
        }
      }
      when(tick) {
        spiSckReg := false.B
        when(bitsToTransfer === 1.U) {
          state := nextState
        } .otherwise {
          spiMosiReg     := shiftReg(71)
          shiftReg       := Cat(shiftReg(70, 0), 0.U(1.W))
          bitsToTransfer := bitsToTransfer - 1.U
        }
      }
    }

    is(sCsToggle) {
      spiCs0nReg := true.B
      when(clkDiv === 20.U) {
        spiCs0nReg := false.B
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
        clkDiv    := 0.U
        state     := sDoTransfer
      } .otherwise {
        clkDiv := clkDiv + 1.U
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