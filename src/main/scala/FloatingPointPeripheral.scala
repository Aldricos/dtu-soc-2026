// FloatingPointPeripheral is a memory mapped peripheral allowing
// arithmetic operation on 32-bit floating points adhering to the IEEE 754 standard
// It supports operations
//   0: addition
//   1: subtraction
//   2: multiplication
// With rounding modes:
//   0: round to nearest, tie to even
//   1: round to nearest, tie away from zero
//   2: round towards positive infinity
//   3: round towards negative infinity
//   4: round towards zero
//
// FloatingPointPeripheral and FloatingPointUnit is part of
// the bachelor project of Sebastian Tobias Holdt (s235475) at DTU
//

import chisel3._
import chisel3.util._
import floatingPointUnit.FloatingPointUnit

class FloatingPointPeripheral extends Module {
  val io = IO(new Bundle {
    val address = Input(UInt(16.W))
    val wr = Input(Bool())
    val rd = Input(Bool())
    val wrData = Input(UInt(32.W))
    val wrMask = Input(UInt(4.W))
    val rdData = Output(UInt(32.W))
    val ack = Output(Bool())
  })

  val input1 = RegInit(0.U(32.W))
  val input2 = RegInit(0.U(32.W))
  val operation = RegInit(0.U(2.W))
  val roundingMode = RegInit(0.U(3.W))
  val output = RegInit(0.U(32.W))
  val flags = RegInit(0.U(5.W))

  val fpu = Module(new FloatingPointUnit)
  fpu.io.input1 := input1
  fpu.io.input2 := input2
  fpu.io.operation := operation
  fpu.io.roundingMode := roundingMode
  output := fpu.io.output
  flags := fpu.io.flags.overflow ## fpu.io.flags.underflow ## fpu.io.flags.zero ## fpu.io.flags.inexact ## fpu.io.flags.nan

  val ackReg = RegInit(false.B)
  ackReg := false.B

  when (io.wr) {
    switch (io.address) {
      is ("x0".U) { input1 := io.wrData }
      is ("x4".U) { input2 := io.wrData }
      is ("x8".U) { operation := io.wrData }
      is ("xC".U) { roundingMode := io.wrData }
    }
    ackReg := true.B
  }

  val rdDataReg = RegInit(0.U(32.W))
  rdDataReg := 0.U

  when (io.rd) {
    switch (io.address) {
      is ("x00".U) { rdDataReg := input1 }
      is ("x04".U) { rdDataReg := input2 }
      is ("x08".U) { rdDataReg := operation }
      is ("x0C".U) { rdDataReg := roundingMode }
      is ("x10".U) { rdDataReg := output }
      is ("x14".U) { rdDataReg := flags }
    }
    ackReg := true.B
  }

  io.rdData := rdDataReg
  io.ack := ackReg
}
