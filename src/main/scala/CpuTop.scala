import chisel.lib.uart._
import chisel3._
import chisel3.util.RegEnable
import wildcat.Util
import wildcat.pipeline._
import memory._
import device._
import videoController.VideoController
import raytracer.RayTracerController
import wishbone.WishboneIO
import programmable_IMEM.programmable_IMEM

/*
 * This file is a modification of the RISC-V processor Wildcat
 * for implementation in Caravel.
 *
 * This is the top-level for a three stage pipeline.
 * A copy of WildcatTop.
 *
 * Author: Martin Schoeberl (martin@jopdesign.com)
 *
 * Edited by F26 02118
 *
 */
class CpuTop(file: String, dmemNrByte: Int = 16) extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(16.W))
    val tx = Output(UInt(1.W))
    val rx = Input(UInt(1.W))
    val rayTx = Output(UInt(1.W))
    val wb = Flipped(new WishboneIO(32))
    val comReadData = Input(UInt(32.W))
    val comWriteData = Output(UInt(32.W))
    val comWriteValid = Output(Bool())
    val flash = new SpiMemIO
    val imem_sel = Input(Bool())
    val wb_2 = Flipped(new WishboneIO(32))
    val cpu_reset = Input(Bool())

    // GROUP 5 PINS
    val g5_spi_sck   = Output(Bool())
    val g5_spi_mosi  = Output(Bool())
    val g5_spi_miso  = Input(Bool())
    val g5_spi_cs0_n = Output(Bool())
    val g5_spi_cs1_n = Output(Bool())
    val g5_spi_cs2_n = Output(Bool())
  })

  val video = IO(new Bundle {
    val hSync = Output(Bool())
    val vSync = Output(Bool())
    val red = Output(UInt(2.W))
    val green = Output(UInt(2.W))
    val blue = Output(UInt(2.W))
  })

  val (memory, start) = Util.getCode(file)

  val cpu = Module(new ThreeCats())
  val dmem = Module(new DataMemory()) //val dmem = Module(new ScratchPadMem(memory, nrBytes = dmemNrByte))
  val imem = Module(new WishboneInstrRam) //val imem = Module(new InstructionROM(memory))
  val imem_2 = Module(new(programmable_IMEM))
  val imem_mux = Module(new(imem_mux))
  cpu.reset := io.cpu_reset
  imem.io.reset := io.cpu_reset
  val cache = Module(new DataCache())
  val spiMem = Module(new SpiFlashController())

  // cpu.io.imem <> imem.io.cpu  //cpu.io.imem <> imem.io
  imem.io.cpu<>imem_mux.imem_0
  imem_2.cpu_connection <> imem_mux.imem_1
  imem_2.cpu_enable := !io.cpu_reset
  imem_mux.sel <> io.imem_sel
  cpu.io.imem <> imem_mux.cpu
  imem.io.wb <> io.wb
  io.flash <> spiMem.io.spi
  io.wb_2 <> imem_2.wb

  // ------------------------------------------------
  // Memory Connections
  // ------------------------------------------------
  // Memory Registers
  val memAddrReg   = RegNext(cpu.io.dmem.address)
  // TODO: why are those signals registered? This seems wrong. Can we not just connect them directly?
  val memRdReg     = RegNext(cpu.io.dmem.rd, false.B)
  val memWrReg     = RegNext(cpu.io.dmem.wr, false.B)
  val memWrDataReg = RegNext(cpu.io.dmem.wrData)
  val memWrMaskReg = RegNext(cpu.io.dmem.wrMask)

  // Default cache CPU-side inputs
  cache.io.cpuIO.address := memAddrReg
  cache.io.cpuIO.rd      := false.B
  cache.io.cpuIO.wr      := false.B
  cache.io.cpuIO.wrData  := memWrDataReg
  cache.io.cpuIO.wrMask  := memWrMaskReg

  // Default cache backing-memory inputs
  cache.io.memIO.rdData := 0.U
  cache.io.memIO.ack    := false.B

  // Default SPI cache values
  spiMem.io.mem.address := 0.U
  spiMem.io.mem.rd      := false.B
  spiMem.io.mem.wr      := false.B
  spiMem.io.mem.wrData  := 0.U
  spiMem.io.mem.wrMask  := 0.U

  // ---------------------------------
  // GROUP 5: QSPI PMOD CONTROLLER
  val g5SpiCtrl = Module(new SpiMemoryController())

  io.g5_spi_sck   := g5SpiCtrl.io.spi.sck
  io.g5_spi_mosi  := g5SpiCtrl.io.spi.mosi
  g5SpiCtrl.io.spi.miso := io.g5_spi_miso
  io.g5_spi_cs0_n := g5SpiCtrl.io.spi.cs0_n
  io.g5_spi_cs1_n := g5SpiCtrl.io.spi.cs1_n
  io.g5_spi_cs2_n := g5SpiCtrl.io.spi.cs2_n

  // Default values
  g5SpiCtrl.io.pipecon.address := memAddrReg
  g5SpiCtrl.io.pipecon.wrData  := memWrDataReg
  g5SpiCtrl.io.pipecon.wrMask  := memWrMaskReg
  g5SpiCtrl.io.pipecon.rd      := false.B
  g5SpiCtrl.io.pipecon.wr      := false.B
  // -----------------------------------

  // Here data memory and IO stuff
  // data memory is at 0x0000_0000
  // IO is mapped ot 0xf000_0000
  // use lower bits to select IOs
  // bits 19..16 are used to select IO devices

  // UART:
  // 0xf000_0000 status:
  // bit 0 TX ready (TDE)
  // bit 1 RX data available (RDF)
  // 0xf000_0004 send and receive register

  // Cache
  // 0xe000_0000 - 0xefff_ffff

  // Address register for read multiplexing
  val memAddressReg = RegEnable(cpu.io.dmem.address, 0.U, cpu.io.dmem.rd)

  val csMem = cpu.io.dmem.address(31, 28) === 0.U

  // Default access is to data memory
  cpu.io.dmem <> dmem.io
  dmem.io.rd := csMem && cpu.io.dmem.rd
  dmem.io.wr := csMem && cpu.io.dmem.wr

  val csIO = cpu.io.dmem.address(31, 28) === 0xf.U
  val csIOReg = memAddressReg(31, 28) === 0xf.U
  val ioDecodeAddress = cpu.io.dmem.address(19,16)
  val ioDecodeAddressReg = memAddressReg(19, 16)

  // Everyone needs a UART
  val uartDevice = Module(new UartDevice(10000000, 115200))
  io.tx := uartDevice.io.txd
  uartDevice.io.rxd := io.rx

  val csUart = csIO && ioDecodeAddress === 0.U
  val muxUart = csIOReg && ioDecodeAddressReg === 0.U
  uartDevice.cpuPort <> cpu.io.dmem
  uartDevice.cpuPort.rd := csUart && cpu.io.dmem.rd
  uartDevice.cpuPort.wr := csUart && cpu.io.dmem.wr

  // We also love to have an LED to blink
  val ledDevice = Module(new LedDevice(16))
  io.led := RegNext(ledDevice.io.leds)

  val csLed = csIO && ioDecodeAddress === 1.U
  val muxLed = csIOReg && ioDecodeAddressReg === 1.U
  ledDevice.cpuPort <> cpu.io.dmem
  ledDevice.cpuPort.rd := csLed && cpu.io.dmem.rd
  ledDevice.cpuPort.wr := csLed && cpu.io.dmem.wr

  // Floating Point Peripheral
  // 0xF004_0000
  val fpp = Module(new FloatingPointPeripheral)
  val csFpp = csIO && ioDecodeAddress === 4.U
  val muxFpp = csIOReg && ioDecodeAddressReg === 4.U
  fpp.io <> cpu.io.dmem
  fpp.io.rd := csFpp && cpu.io.dmem.rd
  fpp.io.wr := csFpp && cpu.io.dmem.wr

  // TODO: move to the bottom and have all devices in one statement
  // read mux for memory and IO devices
  cpu.io.dmem.rdData := dmem.io.rdData
  when (muxUart) {
    cpu.io.dmem.rdData := uartDevice.cpuPort.rdData
  } .elsewhen(muxLed) {
    cpu.io.dmem.rdData := RegNext(ledDevice.io.leds)
  } .elsewhen(muxFpp) {
    cpu.io.dmem.rdData := fpp.io.rdData
  }
  // or reduce all ack signals
  cpu.io.dmem.ack := dmem.io.ack || uartDevice.cpuPort.ack || ledDevice.cpuPort.ack || fpp.io.ack

  // ------------------------------------------------
  // Memory
  // ------------------------------------------------
  when (memAddrReg(31, 28) === 0xe.U) { // CACHE 0xE
    // CPU -> cache
    cache.io.cpuIO.address := memAddrReg
    cache.io.cpuIO.rd      := memRdReg
    cache.io.cpuIO.wr      := memWrReg
    cache.io.cpuIO.wrData  := memWrDataReg
    cache.io.cpuIO.wrMask  := memWrMaskReg

    // cache -> spiMem
    spiMem.io.mem.address := cache.io.memIO.address
    spiMem.io.mem.rd      := cache.io.memIO.rd
    spiMem.io.mem.wr      := cache.io.memIO.wr
    spiMem.io.mem.wrData  := cache.io.memIO.wrData
    spiMem.io.mem.wrMask  := cache.io.memIO.wrMask

    // spiMem -> cache
    cache.io.memIO.rdData := spiMem.io.mem.rdData
    cache.io.memIO.ack    := spiMem.io.mem.ack

    // cache -> CPU
    cpu.io.dmem.rdData := cache.io.cpuIO.rdData
    cpu.io.dmem.ack    := cache.io.cpuIO.ack
  }

  // Video Controller
  // 0xf200_0000
  val videoController = Module(new VideoController)
  videoController.io.address := 0.U
  videoController.io.wrData := 0.U
  videoController.io.wr := false.B
  video <> videoController.video
  
  val videoAckReg = RegInit(false.B)
  videoAckReg := false.B
  when ((cpu.io.dmem.address(31, 28) === 0xf.U) && cpu.io.dmem.address(27,24) === 0x2.U) {
    videoController.io.address := cpu.io.dmem.address(11,0)
    videoController.io.wrData := cpu.io.dmem.wrData(7, 0)
    videoController.io.wr := cpu.io.dmem.wr
    videoAckReg := true.B
  }
  when (videoAckReg) {
    cpu.io.dmem.ack := true.B
  }

  //Wildcat Caravel communication 
  // 0xC000_0000 <- maybe move
  io.comWriteData := cpu.io.dmem.wrData
  io.comWriteValid := cpu.io.dmem.address(31, 28) === 0xc.U

  when (memAddressReg(31, 28) === 0xc.U){
    cpu.io.dmem.rdData := io.comReadData
    cpu.io.dmem.ack := true.B
  }

  // ------------------------------------------------
  // GROUP 5: Memory Mapping (0x4, 0x5, 0x6)
  // ------------------------------------------------
  val isG5Access = (memAddrReg(31, 28) === "h4".U) || (memAddrReg(31, 28) === "h5".U) || (memAddrReg(31, 28) === "h6".U)

  when (isG5Access) {
    g5SpiCtrl.io.pipecon.rd := memRdReg
    g5SpiCtrl.io.pipecon.wr := memWrReg

    cpu.io.dmem.rdData := g5SpiCtrl.io.pipecon.rdData
    cpu.io.dmem.ack    := g5SpiCtrl.io.pipecon.ack
  }

  // ------------------------------------------------
  // Group 4: ray-tracer accelerator + dedicated UART TX
  // ------------------------------------------------
  // The accelerator owns a streaming pixel FIFO. It exposes both an MMIO
  // drain register (0xff00_000C) and a Decoupled byte stream. We drive a
  // dedicated BufferedTx from byteOut so the bytes leave on a separate UART
  // pin (io.rayTx) without touching the CPU UART. Software picks which path
  // it wants via the controller's drain-mode register.
  val rayController = Module(new RayTracerController)
  rayController.io.address := 0.U
  rayController.io.wr      := false.B
  rayController.io.rd      := false.B
  rayController.io.wrData  := 0.U
  rayController.io.wrMask  := 0.U

  val rayTxUart = Module(new BufferedTx(10000000, 921600))
  rayTxUart.io.channel <> rayController.io.byteOut
  io.rayTx := rayTxUart.io.txd

  // Group 4: ray-tracer MMIO at 0xff00_0000
  val isRayController = memAddrReg(31, 24) === 0xff.U
  when (isRayController) {
    rayController.io.address := memAddrReg(15, 0)
    rayController.io.wr      := memWrReg
    rayController.io.rd      := memRdReg
    rayController.io.wrData  := memWrDataReg
    rayController.io.wrMask  := memWrMaskReg
    cpu.io.dmem.rdData       := rayController.io.rdData
    cpu.io.dmem.ack          := rayController.io.ack
  }
}

object CpuTop extends App {
  emitVerilog(new CpuTop(args(0)), Array("--target-dir", "generated"))
}
