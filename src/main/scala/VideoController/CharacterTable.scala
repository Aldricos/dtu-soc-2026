package videoController

import chisel3._
import chisel3.util._
import scala.io.Source

object CharacterRom {
  def loadFromFile(path: String): Seq[Seq[Int]] = {
    Source.fromFile(path).getLines()
      .map(_.trim)
      .filter(_.nonEmpty)
      .map { line =>
        line.split(',').map(v => Integer.decode(v.trim).toInt).toSeq
      }
      .filter(_.length == 8)
      .toSeq
  }
}

class CharacterTable extends Module {
  val io = IO(new Bundle {
    val character = Input(UInt(7.W))
    val xPos      = Input(UInt(3.W))
    val yPos      = Input(UInt(3.W))
    val pixel     = Output(Bool())
  })

  val chars = CharacterRom.loadFromFile("src/main/VideoController/characters.csv")

  val table = VecInit(chars.map { rows =>
    VecInit(rows.map(_.U(8.W)))
  })

  val row   = table(io.character)(io.yPos)
  io.pixel := row(io.xPos)  // no 7-xPos needed since bits are already flipped
}
