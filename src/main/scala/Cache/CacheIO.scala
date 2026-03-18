package Cache;
import chisel3._
import chisel3.util._

class CacheIO extends Bundle {
    val address = Input(UInt(32.W))
    val wrData  = Input(UInt(32.W))
    val rdData  = Output(UInt(32.W))
    val rd      = Input(Bool())
    val wr      = Input(Bool())
    val ready   = Output(Bool())
}
