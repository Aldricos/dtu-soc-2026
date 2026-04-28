import chisel3._
import chisel3.util._
import memory._
import wishbone.WishboneIO

class WishboneSpiPmod extends Module {
  val WB_ADDR_WIDTH = 4

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val ctrl = IO(Flipped(new FlashCtrlIO))
  val progMode = IO(Output(Bool()))

  val cmdReg = RegInit(0.U(4.W))
  val addrReg = RegInit(0.U(24.W))
  val dataReg = RegInit(0.U(8.W))

  val startPending = RegInit(false.B)
  val progModeReg = RegInit(false.B)

  val ackReg = RegInit(false.B)
  when(ackReg) {
    ackReg := false.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := true.B
  }

  val cmdAccess = wb.addr === 0.U
  val addrAccess = wb.addr === 4.U
  val dataAccess = wb.addr === 8.U
  val statusAccess = wb.addr === 12.U

  val busy = progModeReg || startPending || ctrl.busy

  wb.ack := ackReg
  wb.rdData := MuxCase(0.U, Seq(
    cmdAccess -> cmdReg,
    addrAccess -> addrReg,
    dataAccess -> dataReg,
    statusAccess -> busy
  ))

  when(ackReg && wb.we) {
    when(cmdAccess) {
      cmdReg := wb.wrData(3, 0)
      when(wb.wrData(0) && !busy) {
        startPending := true.B
        progModeReg := true.B
      }
    }

    when(addrAccess) {
      addrReg := wb.wrData(23, 0)
    }

    when(dataAccess) {
      dataReg := wb.wrData(7, 0)
    }
  }

  when(startPending && ctrl.busy) {
    startPending := false.B
  }

  when(ctrl.done) {
    dataReg := ctrl.rdByte
    progModeReg := false.B
  }

  ctrl.start := startPending
  ctrl.op := cmdReg(3, 1)
  ctrl.addr := addrReg
  ctrl.wrByte := dataReg

  progMode := progModeReg || startPending
}
