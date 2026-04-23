import chisel3._
import chisel3.util._
import wishbone.WishboneIO

/**
  * Wishbone LukeClock peripheral with 3 registers:
  * - input register at address 0x0 (read-only)
  * - output register at address 0x4 (read-write)
  * - oeb register at address 0x8 (read-write) (1 = input, 0 = output)
  *
  * @param n number of GPIO pins (must be <= 32)
  */

/**
  * Wishbone LukeClock peripheral:
  * - config register at address 0x0 (read-only)
  */
class WishboneLukeClock extends Module {

  // we only need 4 bits to address the 3 registers (input, output, oeb)
  val WB_ADDR_WIDTH = 4

  val wb = IO(Flipped(new WishboneIO(WB_ADDR_WIDTH)))
  val io = IO(new Bundle {
    val hSyncOut = Output(false.B)
    val vSyncOut = Output(false.B)
    val redOut = Output(0.U(2.W))
    val greenOut = Output(0.U(2.W))
    val blueOut = Output(0.U(2.W))
  })

  // registers to hold the output and oeb values
  val configReg = RegInit(0.U(32.W))

  // wishbone acknowledge register
  val ackReg = RegInit(0.B)
  when(ackReg) {
    ackReg := 0.B
  }.elsewhen(wb.cyc && wb.stb) {
    ackReg := 1.B
  }

  // address decoding for the registers
  val configAccess = wb.addr === 0.U

  // wishbone bus response logic
  wb.ack := ackReg
  wb.rdData := MuxCase(0.U, Seq(
    configAccess -> configReg
  ))

  // wishbone write logic
  when(ackReg && wb.we) {
    when(configAccess) { configReg := wb.wrData(7, 0) }
  }

  // Config register definitiona
  //configReg(1) ## configReg(0) // Select of the time clock source (switches)
  // 00: internal 25.175 MHz
  // 01: internal 25MHz
  // 10: external 32768 Hz
  // 11: external 1 Hz
  //configReg(2) // Input with 1Hz frequency
  //configReg(3) // Input with 32768Hz frequency
  //configReg(4) // Plus
  //configReg(5) // Minus
  //configReg(7) ## configReg(6) // Select set mode
  // 00: clear seconds (plus: clear seconds, minus: clear seconds)
  // 01: set minutes (plus: clear increase minutes, minus: decrease minutes)
  // 10: set hours (plus: increase hours, minus: decrease hours)
  // 11: switch layout/colour (plus: change layout, minus: change colours)

  val tClkSelectIn = configReg(1,0)
  val tClk1HzIn = configReg(2)
  val tClk32kHzIn = configReg(3)
  val plusIn = configReg(4)
  val minusIn = configReg(5)
  val SetSelIn = configReg(7,6)

  ////////////////////////////////////
  //VGA CONTROLLER
  ////////////////////////////////////
  //VGA parameters
  val VGA_H_DISPLAY_SIZE = 200//800//640
  val VGA_V_DISPLAY_SIZE = 150//600//480
  val VGA_H_FRONT_PORCH_SIZE = 10//40//16
  val VGA_H_SYNC_PULSE_SIZE = 32//128//96
  val VGA_H_BACK_PORCH_SIZE = 22//88//48
  val VGA_V_FRONT_PORCH_SIZE = 1//10
  val VGA_V_SYNC_PULSE_SIZE = 4//2
  val VGA_V_BACK_PORCH_SIZE = 23//33

  val counterXReg = RegInit(0.U(10.W))
  val counterYReg = RegInit(0.U(10.W))


  when(counterXReg === (VGA_H_DISPLAY_SIZE + VGA_H_FRONT_PORCH_SIZE + VGA_H_SYNC_PULSE_SIZE + VGA_H_BACK_PORCH_SIZE - 1).U) {
    counterXReg := 0.U
    when(counterYReg === (VGA_V_DISPLAY_SIZE + VGA_V_FRONT_PORCH_SIZE + VGA_V_SYNC_PULSE_SIZE + VGA_V_BACK_PORCH_SIZE - 1).U) {
      counterYReg := 0.U
    }.otherwise {
      counterYReg := counterYReg + 1.U
    }
  }.otherwise {
    counterXReg := counterXReg + 1.U
  }

  val hSync = (counterXReg >= (VGA_H_DISPLAY_SIZE + VGA_H_FRONT_PORCH_SIZE).U && (counterXReg < (VGA_H_DISPLAY_SIZE + VGA_H_FRONT_PORCH_SIZE + VGA_H_SYNC_PULSE_SIZE).U)) // active for 96 cycles of the CounterX
  val vSync = (counterYReg >= (VGA_V_DISPLAY_SIZE + VGA_V_FRONT_PORCH_SIZE).U && (counterYReg < (VGA_V_DISPLAY_SIZE + VGA_V_FRONT_PORCH_SIZE + VGA_V_SYNC_PULSE_SIZE).U)) // active for 2 cycles of the CounterY
  io.hSyncOut := RegNext(hSync)
  io.vSyncOut := RegNext(vSync)

  val inDisplayArea = (counterXReg < VGA_H_DISPLAY_SIZE.U) && (counterYReg < VGA_V_DISPLAY_SIZE.U)
  val pixelX = counterXReg
  val pixelY = counterYReg(8,0)

  val vSyncReg = RegInit(false.B)
  vSyncReg := vSync
  val newFrame = vSync && (!vSyncReg)


  ////////////////////////////////////
  // CLOCK
  ////////////////////////////////////
  val newDay = WireDefault(false.B)

  //Generate control commands
  val plusInReg = RegInit(false.B)
  plusInReg := plusIn
  val plusReqReg = RegInit(false.B)
  val plus = WireDefault(false.B)
  when(plusIn && (!plusInReg)) {
    plusReqReg := true.B
  }.elsewhen(plusReqReg && newFrame) {
    plus := true.B
    plusReqReg := false.B
  }

  val minusInReg = RegInit(false.B)
  minusInReg := minusIn
  val minusReqReg = RegInit(false.B)
  val minus = WireDefault(false.B)
  when(minusIn && (!minusInReg)) {
    minusReqReg := true.B
  }.elsewhen(minusReqReg && newFrame) {
    minus := true.B
    minusReqReg := false.B
  }

  // Generate 1CC pulse at 1 Hz based on selected source (tClkPulse)
  val tClk1HzInReg = RegInit(false.B)
  tClk1HzInReg := tClk1HzIn
  val tClkPulse1Hz = tClk1HzIn && (!tClk1HzInReg)
  val tClk32kHzInReg = RegInit(false.B)
  tClk32kHzInReg := tClk32kHzIn
  val tClkPulse32kHzEn = tClk32kHzIn && (!tClk32kHzInReg)

  val tClkPulse10MHzA = WireDefault(false.B)
  val tClkPulse10MHzB = WireDefault(false.B)
  val tClkPulse32kHz = WireDefault(false.B)
  val tClkPulse = WireDefault(false.B)

  val cntReg = RegInit(0.U(25.W))
  val cntRegPlusOne = cntReg + 1.U
  switch(tClkSelectIn) {
    is(0.U) {
      // 00: internal 10 MHz
      when(SetSelIn === 0.U && (plus || minus)) {
        cntReg := 0.U
      }.elsewhen(cntReg >= (10000000 - 1).U) {
        cntReg := 0.U
        tClkPulse10MHzA := true.B
      }.otherwise {
        cntReg := cntRegPlusOne
      }
      tClkPulse := tClkPulse10MHzA
    }
    is(1.U) {
      // 01: internal 10MHz
      when(SetSelIn === 0.U && (plus || minus)) {
        cntReg := 0.U
      }.elsewhen(cntReg >= (10000000 - 1).U) {
        cntReg := 0.U
        tClkPulse10MHzB := true.B
      }.otherwise{
        cntReg := cntRegPlusOne
      }
      tClkPulse := tClkPulse10MHzB
    }
    is(2.U) {
      // 10: external 32768Hz
      when(SetSelIn === 0.U && (plus || minus)) {
        cntReg := 0.U
      }.elsewhen(tClkPulse32kHzEn){
        when(cntReg >= (32768 - 1).U) { //32768
          cntReg := 0.U
          tClkPulse32kHz := true.B
        }.otherwise {
          cntReg := cntRegPlusOne
        }
      }
      tClkPulse := tClkPulse32kHz
    }
    is(3.U) {
      // 11: external 1 Hz
      cntReg := 0.U
      tClkPulse := tClkPulse1Hz
    }
  }

  val tClkReqReg = RegInit(false.B)
  val tClk = WireDefault(false.B)
  when(tClkPulse) {
    tClkReqReg := true.B
  } .elsewhen (tClkReqReg && newFrame){
    tClk := true.B
    tClkReqReg := false.B
  }

  val hourDecReg = RegInit(0.U(2.W)) // 0 - 2
  val hourUniReg = RegInit(0.U(4.W)) // 0 - 9

  val minuteDecReg = RegInit(0.U(3.W)) // 0 - 5
  val minuteUniReg = RegInit(0.U(4.W)) // 0 - 9

  val secondDecReg = RegInit(0.U(3.W)) // 0 - 5
  val secondUniReg = RegInit(0.U(4.W)) // 0 - 9


  when(plus){
    when(SetSelIn === 2.U){
      //set hours
      hourUniReg := hourUniReg + 1.U
      when(hourUniReg === 9.U && (hourDecReg === 0.U || hourDecReg === 1.U)) {
        hourUniReg := 0.U
        hourDecReg := hourDecReg + 1.U
      }.elsewhen(hourUniReg === 3.U && hourDecReg === 2.U) {
        hourUniReg := 3.U
        hourDecReg := 2.U
      }
    }.elsewhen(SetSelIn === 1.U){
      //set minutes
      minuteUniReg := minuteUniReg + 1.U
      when(minuteUniReg === 9.U && minuteDecReg =/= 5.U) {
        minuteUniReg := 0.U
        minuteDecReg := minuteDecReg + 1.U
      }.elsewhen(minuteUniReg === 9.U && minuteDecReg === 5.U) {
        minuteUniReg := 9.U
        minuteDecReg := 5.U
      }
    }.elsewhen(SetSelIn === 0.U){
      // set seconds
      secondUniReg := 0.U
      secondDecReg := 0.U
    }

  }.elsewhen(minus){
    when(SetSelIn === 2.U){
      //set hours
      when(hourUniReg === 0.U && hourDecReg === 0.U) {
        hourUniReg := 0.U
        hourDecReg := 0.U
      } .otherwise {
        hourUniReg := hourUniReg - 1.U
        when(hourUniReg === 0.U) {
          hourUniReg := 9.U
          hourDecReg := hourDecReg - 1.U
        }
      }

    }.elsewhen(SetSelIn === 1.U){
      //set minutes
      when(minuteUniReg === 0.U && minuteDecReg === 0.U) {
        minuteUniReg := 0.U
        minuteDecReg := 0.U
      }.otherwise {
        minuteUniReg := minuteUniReg - 1.U
        when(minuteUniReg === 0.U) {
          minuteUniReg := 9.U
          minuteDecReg := minuteDecReg - 1.U
        }
      }
    }.elsewhen(SetSelIn === 0.U) {
      // set seconds
      secondUniReg := 0.U
      secondDecReg := 0.U
    }

  }.elsewhen(tClk) {
    secondUniReg := secondUniReg + 1.U
    //newDay := true.B
    when(secondUniReg === 9.U) {
      secondUniReg := 0.U
      secondDecReg := secondDecReg + 1.U
      when(secondDecReg === 5.U) {
        secondDecReg := 0.U
        minuteUniReg := minuteUniReg + 1.U
        when(minuteUniReg === 9.U) {
          minuteUniReg := 0.U
          minuteDecReg := minuteDecReg + 1.U
          when(minuteDecReg === 5.U) {
            minuteDecReg := 0.U
            hourUniReg := hourUniReg + 1.U
            when(hourUniReg === 9.U && (hourDecReg === 0.U || hourDecReg === 1.U)) {
              hourUniReg := 0.U
              hourDecReg := hourDecReg + 1.U
            }.elsewhen(hourUniReg === 3.U && hourDecReg === 2.U) {
              hourUniReg := 0.U
              hourDecReg := 0.U
              newDay := true.B
            }
          }
        }
      }
    }
  }

  ////////////////////////////////////
  // LFSR - 6-bit Fibonacci modified Linear Feedback Shift Register (LFSR)
  ////////////////////////////////////
  val lfsrReg = RegInit(VecInit(Seq.fill(18)(false.B)))
  val lfsrEn = newDay ||
    (SetSelIn === 3.U && minus) ||
    lfsrReg.asUInt(5,0) === 0.U ||
    lfsrReg.asUInt(5,0) === 63.U ||
    lfsrReg.asUInt(11,6) === 0.U ||
    lfsrReg.asUInt(11,6) === 63.U ||
    lfsrReg.asUInt(17,12) === 0.U ||
    lfsrReg.asUInt(17,12) === 63.U ||
    lfsrReg.asUInt(5,0) === lfsrReg.asUInt(11,6) ||
    lfsrReg.asUInt(5,0) === lfsrReg.asUInt(17,12) ||
    lfsrReg.asUInt(11,6) === lfsrReg.asUInt(17,12)

  when(lfsrEn){
    for (i <- 1 until 18) {
      lfsrReg(i) := lfsrReg(i - 1)
    }
    when(lfsrReg.asUInt === 0.U) {
      lfsrReg(0) := true.B
    } otherwise{
      lfsrReg(0) := lfsrReg(17) ^ lfsrReg(10)
    }
  }


  ////////////////////////////////////
  // GRAPHIC ENGINE
  ////////////////////////////////////

  val GE_HOUR_DEC_X_MIN =   3
  val GE_HOUR_DEC_X_MAX =   3 + 28
  val GE_HOUR_UNI_X_MIN =   3 + 28 + 3
  val GE_HOUR_UNI_X_MAX =   3 + 28 + 3 + 28
  val GE_MINUTE_DEC_X_MIN = 3 + 28 + 3 + 28 + 6
  val GE_MINUTE_DEC_X_MAX = 3 + 28 + 3 + 28 + 6 + 28
  val GE_MINUTE_UNI_X_MIN = 3 + 28 + 3 + 28 + 6 + 28 + 3
  val GE_MINUTE_UNI_X_MAX = 3 + 28 + 3 + 28 + 6 + 28 + 3 + 28
  val GE_SECOND_DEC_X_MIN = 3 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 6
  val GE_SECOND_DEC_X_MAX = 3 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 6 + 28
  val GE_SECOND_UNI_X_MIN = 3 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 6 + 28 + 3
  val GE_SECOND_UNI_X_MAX = 3 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 6 + 28 + 3 + 28

  val GE_B3_Y_MIN = 13
  val GE_B3_Y_MAX = 13 + 28
  val GE_B2_Y_MIN = 13 + 28 + 3
  val GE_B2_Y_MAX = 13 + 28 + 3 + 28
  val GE_B1_Y_MIN = 13 + 28 + 3 + 28 + 3
  val GE_B1_Y_MAX = 13 + 28 + 3 + 28 + 3 + 28
  val GE_B0_Y_MIN = 13 + 28 + 3 + 28 + 3 + 28 + 3
  val GE_B0_Y_MAX = 13 + 28 + 3 + 28 + 3 + 28 + 3 + 28

  val GE_HLINE_M_S_Y = 13 + 28 + 3 + 28 + 3 + 28 + 3 + 28 + 4
  val GE_HLINE_S_Y =   13 + 28 + 3 + 28 + 3 + 28 + 3 + 28 + 4 + 4


  val inHourDecXArea = pixelX > GE_HOUR_DEC_X_MIN.U && pixelX < GE_HOUR_DEC_X_MAX.U
  val inHourUniXArea = pixelX > GE_HOUR_UNI_X_MIN.U && pixelX < GE_HOUR_UNI_X_MAX.U
  val inMinuteDecXArea = pixelX > GE_MINUTE_DEC_X_MIN.U && pixelX < GE_MINUTE_DEC_X_MAX.U
  val inMinuteUniXArea = pixelX > GE_MINUTE_UNI_X_MIN.U && pixelX < GE_MINUTE_UNI_X_MAX.U
  val inSecondDecXArea = pixelX > GE_SECOND_DEC_X_MIN.U && pixelX < GE_SECOND_DEC_X_MAX.U
  val inSecondUniXArea = pixelX > GE_SECOND_UNI_X_MIN.U && pixelX < GE_SECOND_UNI_X_MAX.U

  val inB3YArea = pixelY > GE_B3_Y_MIN.U && pixelY < GE_B3_Y_MAX.U
  val inB2YArea = pixelY > GE_B2_Y_MIN.U && pixelY < GE_B2_Y_MAX.U
  val inB1YArea = pixelY > GE_B1_Y_MIN.U && pixelY < GE_B1_Y_MAX.U
  val inB0YArea = pixelY > GE_B0_Y_MIN.U && pixelY < GE_B0_Y_MAX.U

  val inXEdge_R3 =
    pixelX === (GE_HOUR_UNI_X_MIN + 1).U || pixelX === (GE_HOUR_UNI_X_MAX - 1).U ||
      pixelX === (GE_MINUTE_UNI_X_MIN + 1).U || pixelX === (GE_MINUTE_UNI_X_MAX - 1).U ||
      pixelX === (GE_SECOND_UNI_X_MIN + 1).U || pixelX === (GE_SECOND_UNI_X_MAX - 1).U

  val inXEdge_R2 =
    pixelX === (GE_MINUTE_DEC_X_MIN + 1).U || pixelX === (GE_MINUTE_DEC_X_MAX - 1).U ||
      pixelX === (GE_SECOND_DEC_X_MIN + 1).U || pixelX === (GE_SECOND_DEC_X_MAX - 1).U ||
      inXEdge_R3

  val inXEdge_R1_R0 =
    pixelX === (GE_HOUR_DEC_X_MIN + 1).U || pixelX === (GE_HOUR_DEC_X_MAX - 1).U ||
      inXEdge_R2

  val inEdgeV =
    (inB3YArea && inXEdge_R3) ||
      (inB2YArea && inXEdge_R2) ||
      ((inB1YArea || inB0YArea) && inXEdge_R1_R0)

  val inYEdge_C5 =
    pixelY === (GE_B1_Y_MIN + 1).U || pixelY === (GE_B1_Y_MAX - 1).U ||
      pixelY === (GE_B0_Y_MIN + 1).U || pixelY === (GE_B0_Y_MAX - 1).U

  val inYEdge_C3_C1 =
    pixelY === (GE_B2_Y_MIN + 1).U || pixelY === (GE_B2_Y_MAX - 1).U ||
      inYEdge_C5

  val inYEdge_C4_C2_C0 =
    pixelY === (GE_B3_Y_MIN + 1).U || pixelY === (GE_B3_Y_MAX - 1).U ||
      inYEdge_C3_C1

  val inEdgeH =
    (inHourDecXArea && inYEdge_C5) ||
      ((inMinuteDecXArea || inSecondDecXArea) && inYEdge_C3_C1) ||
      ((inHourUniXArea || inMinuteUniXArea || inSecondUniXArea) && inYEdge_C4_C2_C0)

  val inLineMS = pixelY === GE_HLINE_M_S_Y.U && ((pixelX > GE_MINUTE_DEC_X_MIN.U && pixelX < GE_MINUTE_UNI_X_MAX.U) || (pixelX > GE_SECOND_DEC_X_MIN.U && pixelX < GE_SECOND_UNI_X_MAX.U))
  val inLineS = pixelY === GE_HLINE_S_Y.U && (pixelX > GE_SECOND_DEC_X_MIN.U && pixelX < GE_SECOND_UNI_X_MAX.U)

  val inOuterEdge = pixelX === 0.U || pixelX === 199.U || pixelY === 0.U || pixelY === 149.U

  val GE_DOTS_X =  3 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 6 + 28 + 3 + 28 + 4

  val GE_DOTS_1_Y_MIN = 13
  val GE_DOTS_1_Y_MAX = 13 + 2
  val GE_DOTS_2_Y_MIN = 13 + 2 + 1
  val GE_DOTS_2_Y_MAX = 13 + 2 + 1 + 2
  val GE_DOTS_3_Y_MIN = 13 + 2 + 1 + 2 + 2
  val GE_DOTS_3_Y_MAX = 13 + 2 + 1 + 2 + 2 + 2
  val GE_DOTS_4_Y_MIN = 13 + 2 + 1 + 2 + 2 + 2 + 2
  val GE_DOTS_4_Y_MAX = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_5_Y_MIN = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_5_Y_MAX = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_6_Y_MIN = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_6_Y_MAX = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_7_Y_MIN = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_7_Y_MAX = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2
  val GE_DOTS_8_Y_MIN = 13 + 2 + 1 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 2 + 1
  val GE_DOTS_8_Y_MAX = 13 + 28

  val GE_DOTS_9_Y_MIN =  13 + 28 + 3
  val GE_DOTS_9_Y_MAX =  13 + 28 + 3 + 6
  val GE_DOTS_10_Y_MIN = 13 + 28 + 3 + 6 + 2
  val GE_DOTS_10_Y_MAX = 13 + 28 + 3 + 6 + 2 + 5
  val GE_DOTS_11_Y_MIN = 13 + 28 + 3 + 6 + 2 + 5 + 2
  val GE_DOTS_11_Y_MAX = 13 + 28 + 3 + 6 + 2 + 5 + 2 + 5
  val GE_DOTS_12_Y_MIN = 13 + 28 + 3 + 6 + 2 + 5 + 2 + 5 + 2
  val GE_DOTS_12_Y_MAX = 13 + 28 + 3 + 28

  val GE_DOTS_13_Y_MIN = 13 + 28 + 3 + 28 + 3
  val GE_DOTS_13_Y_MAX = 13 + 28 + 3 + 28 + 3 + 13
  val GE_DOTS_14_Y_MIN = 13 + 28 + 3 + 28 + 3 + 13 + 2
  val GE_DOTS_14_Y_MAX = 13 + 28 + 3 + 28 + 3 + 28

  val GE_DOTS_15_Y_MIN = 13 + 28 + 3 + 28 + 3 + 28 + 3
  val GE_DOTS_15_Y_MAX = 13 + 28 + 3 + 28 + 3 + 28 + 3 + 28

  val inDots =
    pixelX === GE_DOTS_X.U &&
      (pixelY > GE_DOTS_1_Y_MIN.U && pixelY < GE_DOTS_1_Y_MAX.U ||
        pixelY > GE_DOTS_2_Y_MIN.U && pixelY < GE_DOTS_2_Y_MAX.U ||
        pixelY > GE_DOTS_3_Y_MIN.U && pixelY < GE_DOTS_3_Y_MAX.U ||
        pixelY > GE_DOTS_4_Y_MIN.U && pixelY < GE_DOTS_4_Y_MAX.U ||
        pixelY > GE_DOTS_5_Y_MIN.U && pixelY < GE_DOTS_5_Y_MAX.U ||
        pixelY > GE_DOTS_6_Y_MIN.U && pixelY < GE_DOTS_6_Y_MAX.U ||
        pixelY > GE_DOTS_7_Y_MIN.U && pixelY < GE_DOTS_7_Y_MAX.U ||
        pixelY > GE_DOTS_8_Y_MIN.U && pixelY < GE_DOTS_8_Y_MAX.U ||
        pixelY > GE_DOTS_9_Y_MIN.U && pixelY < GE_DOTS_9_Y_MAX.U ||
        pixelY > GE_DOTS_10_Y_MIN.U && pixelY < GE_DOTS_10_Y_MAX.U ||
        pixelY > GE_DOTS_11_Y_MIN.U && pixelY < GE_DOTS_11_Y_MAX.U ||
        pixelY > GE_DOTS_12_Y_MIN.U && pixelY < GE_DOTS_12_Y_MAX.U ||
        pixelY > GE_DOTS_13_Y_MIN.U && pixelY < GE_DOTS_13_Y_MAX.U ||
        pixelY > GE_DOTS_14_Y_MIN.U && pixelY < GE_DOTS_14_Y_MAX.U ||
        pixelY > GE_DOTS_15_Y_MIN.U && pixelY < GE_DOTS_15_Y_MAX.U)

  val Red = WireDefault(0.U(2.W))
  val Green = WireDefault(0.U(2.W))
  val Blue = WireDefault(0.U(2.W))

  val modeReg = RegInit(0.U(2.W))
  when(SetSelIn === 3.U && plus){
    modeReg := modeReg + 1.U
  }

  val inEdge = WireDefault(false.B)
  switch(modeReg) {
    is(0.U) {
      inEdge := inEdgeV || inEdgeH || inLineMS || inLineS || inDots || inOuterEdge
    }
    is(1.U) {
      inEdge := inEdgeV || inEdgeH || inDots || inOuterEdge
    }
    is(2.U) {
      inEdge := inEdgeV || inEdgeH || inLineMS || inLineS || inDots
    }
    is(3.U) {
      inEdge := inEdgeV || inEdgeH || inDots
    }
  }


  when(inDisplayArea) {
    when(inEdge){
      Red := 3.U
      Green := 3.U
      Blue := 3.U
    } .elsewhen(
      (hourDecReg(1) && inHourDecXArea && inB1YArea) ||
        (hourDecReg(0) && inHourDecXArea && inB0YArea) ||
        (hourUniReg(3) && inHourUniXArea && inB3YArea) ||
        (hourUniReg(2) && inHourUniXArea && inB2YArea) ||
        (hourUniReg(1) && inHourUniXArea && inB1YArea) ||
        (hourUniReg(0) && inHourUniXArea && inB0YArea)
    ) {
      Red := lfsrReg.asUInt(1,0)
      Green := lfsrReg.asUInt(3,2)
      Blue := lfsrReg.asUInt(5,4)
    } .elsewhen(
      (minuteDecReg(2) && inMinuteDecXArea && inB2YArea) ||
        (minuteDecReg(1) && inMinuteDecXArea && inB1YArea) ||
        (minuteDecReg(0) && inMinuteDecXArea && inB0YArea) ||
        (minuteUniReg(3) && inMinuteUniXArea && inB3YArea) ||
        (minuteUniReg(2) && inMinuteUniXArea && inB2YArea) ||
        (minuteUniReg(1) && inMinuteUniXArea && inB1YArea) ||
        (minuteUniReg(0) && inMinuteUniXArea && inB0YArea)
    ) {
      Red := lfsrReg.asUInt(7, 6)
      Green := lfsrReg.asUInt(9, 8)
      Blue := lfsrReg.asUInt(11, 10)
    } .elsewhen(
      (secondDecReg(2) && inSecondDecXArea && inB2YArea) ||
        (secondDecReg(1) && inSecondDecXArea && inB1YArea) ||
        (secondDecReg(0) && inSecondDecXArea && inB0YArea) ||
        (secondUniReg(3) && inSecondUniXArea && inB3YArea) ||
        (secondUniReg(2) && inSecondUniXArea && inB2YArea) ||
        (secondUniReg(1) && inSecondUniXArea && inB1YArea) ||
        (secondUniReg(0) && inSecondUniXArea && inB0YArea)
    ) {
      Red := lfsrReg.asUInt(13, 12)
      Green := lfsrReg.asUInt(15, 14)
      Blue := lfsrReg.asUInt(17, 16)
    }.otherwise {
      Red := 0.U
      Green := 0.U
      Blue := 0.U
    }
  }.otherwise {
    //Out of displayed area --> black
    Red := 0.U
    Green := 0.U
    Blue := 0.U
  }

  io.redOut := RegNext(Red)
  io.greenOut := RegNext(Green)
  io.blueOut := RegNext(Blue)

} //module