import chisel3._
import soc.PipeCon

class imem_mux extends Module {
  val sel = IO(Input(Bool()))
  val cpu = IO(new PipeCon(32))
  val imem_0 = IO(Flipped(new PipeCon(32)))
  val imem_1 = IO(Flipped(new PipeCon(32)))

  imem_0.address := cpu.address
  imem_0.rd := cpu.rd && !sel
  imem_0.wr := cpu.wr && !sel
  imem_0.wrData := cpu.wrData
  imem_0.wrMask := cpu.wrMask

  imem_1.address := cpu.address
  imem_1.rd := cpu.rd && sel
  imem_1.wr := cpu.wr && sel
  imem_1.wrData := cpu.wrData
  imem_1.wrMask := cpu.wrMask

  cpu.rdData := Mux(sel, imem_1.rdData, imem_0.rdData)
  cpu.ack := Mux(sel, imem_1.ack, imem_0.ack)
}
