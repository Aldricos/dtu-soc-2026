/*
 * This file is an extension of the RISC-V Wildcat
 * implementation in Caravel.
 *
 * This is the I/O connections that should
 * allow for communication between CPU and Memory
 *
 * Author: Group 0 (Mads, Filippo, Bertram & Mathias)
 */

package cache;
import chisel3._
import chisel3.util._

class CacheIO extends Bundle {
    val address = Input(UInt(32.W))
    val wrData  = Input(UInt(32.W))
    val rdData  = Output(UInt(32.W))
    val rd      = Input(Bool())
    val wr      = Input(Bool())
    val stall   = Output(Bool())
}
