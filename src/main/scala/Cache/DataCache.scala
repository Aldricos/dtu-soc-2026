package Cache

import chisel3._
import chisel3.util._

class DataCache(numLines: Int) extends Module {
  val BIT_WIDTH   = 32
  val INDEX_BITS  = log2Ceil(numLines)
  val OFFSET_BITS = 2
  val TAG_BITS    = BIT_WIDTH - INDEX_BITS - OFFSET_BITS

  val io = IO(new Bundle {
    val cpuIO = Flipped(new CacheIO)
    val memIO = new CacheIO
  })

  val validArray = RegInit(VecInit(Seq.fill(numLines)(false.B)))
  val tagArray   = Reg(Vec(numLines, UInt(TAG_BITS.W)))
  val dataArray  = Reg(Vec(numLines, UInt(BIT_WIDTH.W)))

  val sIdle :: sMiss :: Nil = Enum(2)
  val state = RegInit(sIdle)

  val missAddrReg  = Reg(UInt(BIT_WIDTH.W))
  val missIndexReg = Reg(UInt(INDEX_BITS.W))
  val missTagReg   = Reg(UInt(TAG_BITS.W))

  val index = io.cpuIO.address(OFFSET_BITS + INDEX_BITS - 1, OFFSET_BITS)
  val tag   = io.cpuIO.address(BIT_WIDTH - 1, OFFSET_BITS + INDEX_BITS)

  val hit = validArray(index) && (tagArray(index) === tag)

  io.cpuIO.rdData := 0.U
  io.cpuIO.ready  := false.B

  io.memIO.address := 0.U
  io.memIO.rd      := false.B
  io.memIO.wr      := false.B
  io.memIO.wrData  := 0.U
  io.memIO.ready   := false.B // only if CacheIO defines ready as Output here

  switch(state) {
    is(sIdle) {
      when(io.cpuIO.rd) {
        when(hit) {
          io.cpuIO.rdData := dataArray(index)
          io.cpuIO.ready  := true.B
        }.otherwise {
          missAddrReg  := io.cpuIO.address
          missIndexReg := index
          missTagReg   := tag

          io.memIO.address := io.cpuIO.address
          io.memIO.rd      := true.B

          state := sMiss
        }
      }.otherwise {
        io.cpuIO.ready := true.B
      }
    }

    is(sMiss) {
      io.memIO.address := missAddrReg
      io.memIO.rd      := true.B

      when(io.memIO.ready) {
        dataArray(missIndexReg)  := io.memIO.rdData
        tagArray(missIndexReg)   := missTagReg
        validArray(missIndexReg) := true.B

        io.cpuIO.rdData := io.memIO.rdData
        io.cpuIO.ready  := true.B
        state := sIdle
      }
    }
  }
}