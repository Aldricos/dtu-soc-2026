package videoController

import chisel3._
import chisel3.util._

/**
  * TODO: write summary
  */
class Terminal extends Module {
  val tilePixelWidth = 8
  val xBitWidth = log2Up(VgaConstants.H_ACTIVE_VIDEO)
  val yBitWidth = log2Up(VgaConstants.V_ACTIVE_VIDEO) - 2
  val horizontalTiles = VgaConstants.H_ACTIVE_VIDEO / tilePixelWidth
  val verticalTiles = VgaConstants.V_ACTIVE_VIDEO / tilePixelWidth

  val io = IO(new Bundle {
    val xPos = Input(UInt(xBitWidth.W))
    val yPos = Input(UInt(yBitWidth.W))
    val red = Output(UInt(2.W))
    val green = Output(UInt(2.W))
    val blue = Output(UInt(2.W))

    val address = Input(UInt(12.W))
    val wrData = Input(UInt(8.W))
    val wr = Input(Bool())
  })

  val videoBuffer = Module(new VideoBuffer)

  // video buffer write port
  videoBuffer.io.addr0 := io.address
  videoBuffer.io.din0 := io.wrData
  videoBuffer.io.we0 := io.wr

  val xTilePos = io.xPos(xBitWidth - 1, 3)
  val yTilePos = io.yPos(yBitWidth - 1, 3)
  val xCharPos = io.xPos(2, 0)
  val yCharPos = io.yPos(2, 0)

  val index = yTilePos * horizontalTiles.U + xTilePos

  // video buffer read port
  videoBuffer.io.addr1 := index
  val character = videoBuffer.io.dout1

  val characterTable = Module(new CharacterTable)
  characterTable.io.character := character
  characterTable.io.xPos := xCharPos
  characterTable.io.yPos := yCharPos

  when (character(7)) {
    io.red := character(5,4)
    io.green := character(3,2)
    io.blue := character(1,0)
  } .otherwise {
    io.red := characterTable.io.pixel ## characterTable.io.pixel
    io.green := characterTable.io.pixel ## characterTable.io.pixel
    io.blue := characterTable.io.pixel ## characterTable.io.pixel
  }
}
