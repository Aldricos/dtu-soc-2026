module Csr(
  input  [11:0] io_address, // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 14:14]
  output [31:0] io_data // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 14:14]
);
  wire [31:0] _GEN_0 = 12'hf12 == io_address ? 32'h2f : 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 48:12 19:25]
  wire [31:0] _GEN_1 = 12'hb81 == io_address ? 32'h0 : _GEN_0; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 45:12]
  wire [31:0] _GEN_2 = 12'hb01 == io_address ? 32'h0 : _GEN_1; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 42:12]
  wire [31:0] _GEN_3 = 12'hb80 == io_address ? 32'h0 : _GEN_2; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 39:12]
  wire [31:0] _GEN_4 = 12'hb00 == io_address ? 32'h0 : _GEN_3; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 36:12]
  wire [31:0] _GEN_5 = 12'hc81 == io_address ? 32'h4 : _GEN_4; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 33:12]
  wire [31:0] _GEN_6 = 12'hc01 == io_address ? 32'h3 : _GEN_5; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 30:12]
  wire [31:0] _GEN_7 = 12'hc80 == io_address ? 32'h2 : _GEN_6; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 27:12]
  assign io_data = 12'hc00 == io_address ? 32'h1 : _GEN_7; // @[wildcat/src/main/scala/wildcat/pipeline/Csr.scala 22:22 24:12]
endmodule
module ThreeCats(
  input         clock,
  input         reset,
  output [31:0] io_imem_address, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input  [31:0] io_imem_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input         io_imem_ack, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [31:0] io_dmem_address, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output        io_dmem_rd, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output        io_dmem_wr, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  input  [31:0] io_dmem_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [31:0] io_dmem_wrData, // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
  output [3:0]  io_dmem_wrMask // @[wildcat/src/main/scala/wildcat/pipeline/Wildcat.scala 18:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regs [0:31]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_rs1Val_MPORT_en; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_rs1Val_MPORT_addr; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_rs1Val_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_rs2Val_MPORT_en; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_rs2Val_MPORT_addr; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_rs2Val_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [31:0] regs_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire [4:0] regs_MPORT_addr; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_MPORT_mask; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  wire  regs_MPORT_en; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  reg  regs_rs1Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs1Val_MPORT_addr_pipe_0;
  reg  regs_rs2Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs2Val_MPORT_addr_pipe_0;
  wire [11:0] csr_io_address; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 64:19]
  wire [31:0] csr_io_data; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 64:19]
  reg  exFwdReg_valid; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [4:0] exFwdReg_wbDest; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [31:0] exFwdReg_wbData; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
  reg [31:0] pcReg; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
  wire [31:0] _pcNext_T_1 = pcReg + 32'h4; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 40:62]
  reg [2:0] decExReg_func3; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  _doBranch_T = 3'h0 == decExReg_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  reg [4:0] decExReg_rs1; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [31:0] decExReg_rs1Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire [31:0] v1 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 122:15]
  reg [4:0] decExReg_rs2; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [31:0] decExReg_rs2Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire [31:0] v2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 123:15]
  wire  _doBranch_T_1 = 3'h1 == decExReg_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire  _doBranch_T_2 = 3'h4 == decExReg_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire [31:0] _doBranch_res_T_2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 163:20]
  wire [31:0] _doBranch_res_T_3 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 163:33]
  wire  _doBranch_T_3 = 3'h5 == decExReg_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20]
  wire  _GEN_247 = 3'h7 == decExReg_func3 & v1 >= v2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 172:13 154:9]
  wire  _GEN_248 = 3'h6 == decExReg_func3 ? v1 < v2 : _GEN_247; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 169:13]
  wire  _GEN_249 = 3'h5 == decExReg_func3 ? $signed(_doBranch_res_T_2) >= $signed(_doBranch_res_T_3) : _GEN_248; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 166:13]
  wire  _GEN_250 = 3'h4 == decExReg_func3 ? $signed(_doBranch_res_T_2) < $signed(_doBranch_res_T_3) : _GEN_249; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 163:13]
  wire  _GEN_251 = 3'h1 == decExReg_func3 ? v1 != v2 : _GEN_250; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 160:13]
  wire  doBranch_res = 3'h0 == decExReg_func3 ? v1 == v2 : _GEN_251; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 155:20 157:13]
  reg  decExReg_decOut_isBranch; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg  decExReg_decOut_isJal; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg  decExReg_decOut_isJalr; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg  decExReg_valid; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  doBranch = (doBranch_res & decExReg_decOut_isBranch | decExReg_decOut_isJal | decExReg_decOut_isJalr) &
    decExReg_valid; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 148:130]
  reg  decExReg_decOut_isLoad; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  _T_14 = ~doBranch; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 152:34]
  reg [1:0] decExReg_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  _res_T_7 = 2'h0 == decExReg_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_1 = io_dmem_rdData[7] ? 24'hffffff : 24'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 290:24]
  wire [31:0] _res_res_T_3 = {_res_res_T_1,io_dmem_rdData[7:0]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 290:38]
  wire  _res_T_8 = 2'h1 == decExReg_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_5 = io_dmem_rdData[15] ? 24'hffffff : 24'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 293:24]
  wire [31:0] _res_res_T_7 = {_res_res_T_5,io_dmem_rdData[15:8]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 293:39]
  wire  _res_T_9 = 2'h2 == decExReg_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_9 = io_dmem_rdData[23] ? 24'hffffff : 24'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 296:24]
  wire [31:0] _res_res_T_11 = {_res_res_T_9,io_dmem_rdData[23:16]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 296:39]
  wire  _res_T_10 = 2'h3 == decExReg_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24]
  wire [23:0] _res_res_T_13 = io_dmem_rdData[31] ? 24'hffffff : 24'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 300:24]
  wire [31:0] _res_res_T_15 = {_res_res_T_13,io_dmem_rdData[31:24]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 300:39]
  wire [31:0] _GEN_253 = 2'h3 == decExReg_memLow ? _res_res_T_15 : io_dmem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24 300:17 285:9]
  wire [31:0] _GEN_254 = 2'h2 == decExReg_memLow ? _res_res_T_11 : _GEN_253; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24 296:17]
  wire [31:0] _GEN_255 = 2'h1 == decExReg_memLow ? _res_res_T_7 : _GEN_254; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24 293:17]
  wire [31:0] _GEN_256 = 2'h0 == decExReg_memLow ? _res_res_T_3 : _GEN_255; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 288:24 290:17]
  wire [15:0] _res_res_T_17 = io_dmem_rdData[15] ? 16'hffff : 16'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 307:24]
  wire [31:0] _res_res_T_19 = {_res_res_T_17,io_dmem_rdData[15:0]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 307:39]
  wire [15:0] _res_res_T_21 = io_dmem_rdData[31] ? 16'hffff : 16'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 310:24]
  wire [31:0] _res_res_T_23 = {_res_res_T_21,io_dmem_rdData[31:16]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 310:39]
  wire [31:0] _GEN_257 = _res_T_9 ? _res_res_T_23 : io_dmem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 305:24 310:17 285:9]
  wire [31:0] _GEN_258 = _res_T_7 ? _res_res_T_19 : _GEN_257; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 305:24 307:17]
  wire [31:0] _GEN_259 = _res_T_10 ? {{24'd0}, io_dmem_rdData[31:24]} : io_dmem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 315:24 326:17 285:9]
  wire [31:0] _GEN_260 = _res_T_9 ? {{24'd0}, io_dmem_rdData[23:16]} : _GEN_259; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 315:24 323:17]
  wire [31:0] _GEN_261 = _res_T_8 ? {{24'd0}, io_dmem_rdData[15:8]} : _GEN_260; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 315:24 320:17]
  wire [31:0] _GEN_262 = _res_T_7 ? {{24'd0}, io_dmem_rdData[7:0]} : _GEN_261; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 315:24 317:17]
  wire [31:0] _GEN_263 = _res_T_9 ? {{16'd0}, io_dmem_rdData[31:16]} : io_dmem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 331:24 336:17 285:9]
  wire [31:0] _GEN_264 = _res_T_7 ? {{16'd0}, io_dmem_rdData[15:0]} : _GEN_263; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 331:24 333:17]
  wire [31:0] _GEN_265 = _doBranch_T_3 ? _GEN_264 : io_dmem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 286:19 285:9]
  wire [31:0] _GEN_266 = _doBranch_T_2 ? _GEN_262 : _GEN_265; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  wire [31:0] _GEN_267 = _doBranch_T_1 ? _GEN_258 : _GEN_266; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  wire [31:0] res_res_1 = _doBranch_T ? _GEN_256 : _GEN_267; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 286:19]
  reg  decExReg_decOut_isCssrw; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [31:0] decExReg_csrVal; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg  decExReg_decOut_isAuiPc; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [31:0] decExReg_pc; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [31:0] decExReg_decOut_imm; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire [31:0] _res_T_5 = $signed(decExReg_pc) + $signed(decExReg_decOut_imm); // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 132:55]
  reg  decExReg_decOut_isLui; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg [3:0] decExReg_decOut_aluOp; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  reg  decExReg_decOut_isImm; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire [31:0] val2 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 126:17]
  wire [31:0] res_res__9 = v1 & val2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 271:24]
  wire [31:0] res_res__8 = v1 | val2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 272:23]
  wire [31:0] res_res__7 = $signed(_doBranch_res_T_2) >>> val2[4:0]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 276:44]
  wire [31:0] res_res__6 = v1 >> val2[4:0]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 275:24]
  wire [31:0] res_res__5 = v1 ^ val2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 273:24]
  wire [31:0] res_res__4 = {{31'd0}, v1 < val2}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 268:19 278:20]
  wire [31:0] _res_res_3_T_1 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 277:36]
  wire [31:0] res_res__3 = {{31'd0}, $signed(_doBranch_res_T_2) < $signed(_res_res_3_T_1)}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 268:19 277:19]
  wire [62:0] _GEN_0 = {{31'd0}, v1}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 274:25]
  wire [62:0] _res_res_2_T_1 = _GEN_0 << val2[4:0]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 274:25]
  wire [31:0] res_res__2 = _res_res_2_T_1[31:0]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 268:19 274:19]
  wire [31:0] res_res__1 = v1 - val2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 270:24]
  wire [31:0] res_res__0 = v1 + val2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 269:24]
  wire [31:0] _GEN_233 = 4'h1 == decExReg_decOut_aluOp ? res_res__1 : res_res__0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_234 = 4'h2 == decExReg_decOut_aluOp ? res_res__2 : _GEN_233; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_235 = 4'h3 == decExReg_decOut_aluOp ? res_res__3 : _GEN_234; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_236 = 4'h4 == decExReg_decOut_aluOp ? res_res__4 : _GEN_235; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_237 = 4'h5 == decExReg_decOut_aluOp ? res_res__5 : _GEN_236; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_238 = 4'h6 == decExReg_decOut_aluOp ? res_res__6 : _GEN_237; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_239 = 4'h7 == decExReg_decOut_aluOp ? res_res__7 : _GEN_238; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_240 = 4'h8 == decExReg_decOut_aluOp ? res_res__8 : _GEN_239; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_241 = 4'h9 == decExReg_decOut_aluOp ? res_res__9 : _GEN_240; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_242 = decExReg_decOut_isLui ? decExReg_decOut_imm : _GEN_241; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 128:31 127:7 129:9]
  wire [31:0] _GEN_243 = decExReg_decOut_isAuiPc ? _res_T_5 : _GEN_242; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 131:33 132:9]
  wire [31:0] _GEN_244 = decExReg_decOut_isCssrw ? decExReg_csrVal : _GEN_243; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 134:33 135:9]
  wire [31:0] res = decExReg_decOut_isLoad & ~doBranch ? res_res_1 : _GEN_244; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 152:45 153:9]
  wire [31:0] branchTarget = decExReg_decOut_isJalr ? res : _res_T_5; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 144:16 145:32 146:18]
  wire [31:0] _pcNext_T_2 = doBranch ? branchTarget : _pcNext_T_1; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 40:31]
  wire [31:0] instr = ~io_imem_ack ? 32'h33 : io_imem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 50:23 51:11 49:26]
  reg [31:0] pcRegReg; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 56:25]
  reg [31:0] instrReg; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 57:25]
  reg [4:0] rs1Val_REG; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 208:31]
  wire [31:0] rs1Val = rs1Val_REG == 5'h0 ? 32'h0 : regs_rs1Val_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 208:23]
  reg [4:0] rs2Val_REG; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 209:31]
  wire [31:0] rs2Val = rs2Val_REG == 5'h0 ? 32'h0 : regs_rs2Val_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 209:23]
  reg [4:0] decExReg_rd; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  _T_1 = decExReg_rd != 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 210:24]
  reg  decExReg_decOut_rfWrite; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
  wire  wrEna = decExReg_valid & decExReg_decOut_rfWrite; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 149:27]
  wire  _T_2 = wrEna & decExReg_rd != 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 210:18]
  wire  _T_13 = decExReg_decOut_isJal | decExReg_decOut_isJalr; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 140:30]
  wire [31:0] _wbData_T_1 = decExReg_pc + 32'h4; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 141:27]
  wire [31:0] wbData = decExReg_decOut_isJal | decExReg_decOut_isJalr ? _wbData_T_1 : res; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 139:10 140:57 141:12]
  wire [6:0] decOut_opcode = instrReg[6:0]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 17:29]
  wire [2:0] decOut_func3 = instrReg[14:12]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 18:28]
  wire  _GEN_78 = decOut_func3 == 3'h0 ? 1'h0 : 1'h1; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 87:30 90:26]
  wire  _GEN_87 = 7'h73 == decOut_opcode ? _GEN_78 : 7'h2f == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
  wire  _GEN_90 = 7'h67 == decOut_opcode | 7'h73 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 80:26]
  wire  _GEN_92 = 7'h67 == decOut_opcode | _GEN_87; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 82:24]
  wire  _GEN_94 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_78; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_97 = 7'h6f == decOut_opcode ? 3'h5 : {{2'd0}, _GEN_90}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 75:26]
  wire  _GEN_98 = 7'h6f == decOut_opcode | _GEN_92; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 76:24]
  wire  _GEN_100 = 7'h6f == decOut_opcode ? 1'h0 : 7'h67 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_102 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_94; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_105 = 7'h17 == decOut_opcode ? 3'h4 : _GEN_97; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 70:26]
  wire  _GEN_106 = 7'h17 == decOut_opcode | _GEN_98; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 71:24]
  wire  _GEN_108 = 7'h17 == decOut_opcode ? 1'h0 : 7'h6f == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_109 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_100; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_111 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_102; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_114 = 7'h37 == decOut_opcode ? 3'h4 : _GEN_105; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 65:26]
  wire  _GEN_115 = 7'h37 == decOut_opcode | _GEN_106; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 66:24]
  wire  _GEN_117 = 7'h37 == decOut_opcode ? 1'h0 : 7'h17 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_118 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_108; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_119 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_109; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_121 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_111; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_124 = 7'h23 == decOut_opcode ? 3'h2 : _GEN_114; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 61:26]
  wire  _GEN_126 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_115; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 29:20 37:20]
  wire  _GEN_127 = 7'h23 == decOut_opcode ? 1'h0 : 7'h37 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 22:18 37:20]
  wire  _GEN_128 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_117; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_129 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_118; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_130 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_119; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_132 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_121; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_135 = 7'h3 == decOut_opcode ? 3'h1 : _GEN_124; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 56:26]
  wire  _GEN_136 = 7'h3 == decOut_opcode | _GEN_126; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 57:24]
  wire  _GEN_138 = 7'h3 == decOut_opcode ? 1'h0 : 7'h23 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire  _GEN_139 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_127; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 22:18 37:20]
  wire  _GEN_140 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_128; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20 37:20]
  wire  _GEN_141 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_129; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18 37:20]
  wire  _GEN_142 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_130; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_144 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_132; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20 37:20]
  wire [2:0] _GEN_147 = 7'h63 == decOut_opcode ? 3'h3 : _GEN_135; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 51:26]
  wire  _GEN_148 = 7'h63 == decOut_opcode | _GEN_142; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 52:22]
  wire  _GEN_150 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_136; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 29:20 37:20]
  wire  _GEN_151 = 7'h63 == decOut_opcode ? 1'h0 : 7'h3 == decOut_opcode; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19 37:20]
  wire  _GEN_152 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_138; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire [2:0] _GEN_161 = 7'h33 == decOut_opcode ? 3'h0 : _GEN_147; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 45:26]
  wire  _GEN_162 = 7'h33 == decOut_opcode | _GEN_150; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 46:24]
  wire  _GEN_164 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_148; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 21:18 37:20]
  wire  _GEN_166 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_151; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19 37:20]
  wire  _GEN_167 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_152; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire [2:0] decOut_instrType = 7'h13 == decOut_opcode ? 3'h1 : _GEN_161; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 39:26]
  wire  decOut_isImm = 7'h13 == decOut_opcode | _GEN_164; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 40:22]
  wire  decOut_rfWrite = 7'h13 == decOut_opcode | _GEN_162; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20 41:24]
  wire  decOut_isLoad = 7'h13 == decOut_opcode ? 1'h0 : _GEN_166; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19 37:20]
  wire  decOut_isStore = 7'h13 == decOut_opcode ? 1'h0 : _GEN_167; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 25:20 37:20]
  wire [6:0] decOut_decOut_aluOp_func7 = instrReg[31:25]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 113:28]
  wire  _decOut_decOut_aluOp_T = 3'h0 == decOut_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_5 = decOut_opcode != 7'h13 & decOut_opcode != 7'h67 & decOut_decOut_aluOp_func7 != 7'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 119:55]
  wire  _decOut_decOut_aluOp_T_6 = 3'h1 == decOut_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_7 = 3'h2 == decOut_func3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire [2:0] _GEN_193 = decOut_decOut_aluOp_func7 == 7'h0 ? 3'h6 : 3'h7; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 136:29 137:17 139:17]
  wire [3:0] _GEN_194 = 3'h7 == decOut_func3 ? 4'h9 : 4'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19 146:15 115:28]
  wire [3:0] _GEN_195 = 3'h6 == decOut_func3 ? 4'h8 : _GEN_194; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19 143:15]
  wire [3:0] _GEN_196 = 3'h5 == decOut_func3 ? {{1'd0}, _GEN_193} : _GEN_195; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
  wire [3:0] _GEN_197 = 3'h4 == decOut_func3 ? 4'h5 : _GEN_196; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19 133:15]
  wire [3:0] _GEN_198 = 3'h3 == decOut_func3 ? 4'h4 : _GEN_197; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19 130:15]
  wire [11:0] _decOut_decOut_imm_imm_T_1 = instrReg[31:20]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 181:32]
  wire [19:0] _decOut_decOut_imm_imm_T_3 = instrReg[31] ? 20'hfffff : 20'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 184:21]
  wire [31:0] _decOut_decOut_imm_imm_T_6 = {_decOut_decOut_imm_imm_T_3,instrReg[31:20]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 184:67]
  wire [31:0] _decOut_decOut_imm_imm_T_13 = {_decOut_decOut_imm_imm_T_3,decOut_decOut_aluOp_func7,instrReg[11:7]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 187:89]
  wire [18:0] _decOut_decOut_imm_imm_T_15 = instrReg[31] ? 19'h7ffff : 19'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 190:21]
  wire [30:0] _decOut_decOut_imm_imm_T_23 = {_decOut_decOut_imm_imm_T_15,instrReg[7],instrReg[30:25],instrReg[11:8],1'h0
    }; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 190:119]
  wire [31:0] _decOut_decOut_imm_imm_T_27 = {instrReg[31:12],12'h0}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 193:55]
  wire [10:0] _decOut_decOut_imm_imm_T_29 = instrReg[31] ? 11'h7ff : 11'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 196:21]
  wire [30:0] _decOut_decOut_imm_imm_T_37 = {_decOut_decOut_imm_imm_T_29,instrReg[19:12],instrReg[20],instrReg[30:21],1'h0
    }; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 196:121]
  wire [30:0] _GEN_202 = 3'h5 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_37) : $signed({{19{
    _decOut_decOut_imm_imm_T_1[11]}},_decOut_decOut_imm_imm_T_1}); // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23 196:13 181:9]
  wire [31:0] _GEN_203 = 3'h4 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_27) : $signed({{1{_GEN_202[30]}},
    _GEN_202}); // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23 193:13]
  wire [31:0] _GEN_204 = 3'h3 == decOut_instrType ? $signed({{1{_decOut_decOut_imm_imm_T_23[30]}},
    _decOut_decOut_imm_imm_T_23}) : $signed(_GEN_203); // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23 190:13]
  wire [31:0] _GEN_205 = 3'h2 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_13) : $signed(_GEN_204); // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23 187:13]
  wire [31:0] decOut_decOut_imm_imm = 3'h1 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_6) : $signed(_GEN_205)
    ; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23 184:13]
  wire [4:0] decEx_rs1 = instrReg[19:15]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 86:24]
  wire [4:0] decEx_rs2 = instrReg[24:20]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 87:24]
  wire [31:0] data = _T_2 & decExReg_rd == decEx_rs2 ? wbData : rs2Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 96:17]
  wire [31:0] _memAddress_T = _T_2 & decExReg_rd == decEx_rs1 ? wbData : rs1Val; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 98:29]
  wire [31:0] memAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 98:50]
  wire [1:0] decEx_memLow = memAddress[1:0]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 99:29]
  wire [31:0] _wrData_T_6 = {data[7:0],data[7:0],data[7:0],data[7:0]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 349:58]
  wire  _GEN_208 = 2'h0 == decEx_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_209 = 2'h1 == decEx_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_210 = 2'h2 == decEx_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire  _GEN_211 = 2'h3 == decEx_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 350:{24,24} 346:25]
  wire [31:0] _wrData_T_9 = {data[15:0],data[15:0]}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 353:31]
  wire  _GEN_214 = _GEN_208 ? 1'h0 : _GEN_210; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 354:24 346:25]
  wire [31:0] _GEN_219 = _decOut_decOut_aluOp_T_6 ? _wrData_T_9 : data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19 353:16 345:29]
  wire  _GEN_220 = _decOut_decOut_aluOp_T_6 ? _GEN_208 : _decOut_decOut_aluOp_T_7; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  _GEN_222 = _decOut_decOut_aluOp_T_6 ? _GEN_214 : _decOut_decOut_aluOp_T_7; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire [31:0] wrData = _decOut_decOut_aluOp_T ? _wrData_T_6 : _GEN_219; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19 349:16]
  wire  wrMask_0 = _decOut_decOut_aluOp_T ? _GEN_208 : _GEN_220; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_1 = _decOut_decOut_aluOp_T ? _GEN_209 : _GEN_220; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_2 = _decOut_decOut_aluOp_T ? _GEN_210 : _GEN_222; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire  wrMask_3 = _decOut_decOut_aluOp_T ? _GEN_211 : _GEN_222; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 347:19]
  wire [3:0] _wr_T = {wrMask_3,wrMask_2,wrMask_1,wrMask_0}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 369:21]
  wire  wr = |_wr_T; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 369:28]
  wire [31:0] decEx_csrVal = csr_io_data; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 70:19 91:16]
  Csr csr ( // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 64:19]
    .io_address(csr_io_address),
    .io_data(csr_io_data)
  );
  assign regs_rs1Val_MPORT_en = regs_rs1Val_MPORT_en_pipe_0;
  assign regs_rs1Val_MPORT_addr = regs_rs1Val_MPORT_addr_pipe_0;
  assign regs_rs1Val_MPORT_data = regs[regs_rs1Val_MPORT_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  assign regs_rs2Val_MPORT_en = regs_rs2Val_MPORT_en_pipe_0;
  assign regs_rs2Val_MPORT_addr = regs_rs2Val_MPORT_addr_pipe_0;
  assign regs_rs2Val_MPORT_data = regs[regs_rs2Val_MPORT_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
  assign regs_MPORT_data = _T_13 ? _wbData_T_1 : res;
  assign regs_MPORT_addr = decExReg_rd;
  assign regs_MPORT_mask = 1'h1;
  assign regs_MPORT_en = wrEna & _T_1;
  assign io_imem_address = ~io_imem_ack ? pcReg : _pcNext_T_2; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 50:23 52:12 40:27]
  assign io_dmem_address = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 98:50]
  assign io_dmem_rd = decOut_isLoad & _T_14; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 106:22]
  assign io_dmem_wr = decOut_isStore & _T_14 & wr; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 104:14 109:37 112:16]
  assign io_dmem_wrData = decOut_isStore & _T_14 ? wrData : data; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 103:18 109:37 111:20]
  assign io_dmem_wrMask = decOut_isStore & _T_14 ? _wr_T : 4'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 105:18 109:37 113:20]
  assign csr_io_address = instrReg[31:20]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 65:29]
  always @(posedge clock) begin
    if (regs_MPORT_en & regs_MPORT_mask) begin
      regs[regs_MPORT_addr] <= regs_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 206:29]
    end
    regs_rs1Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs1Val_MPORT_addr_pipe_0 <= instr[19:15];
    end
    regs_rs2Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs2Val_MPORT_addr_pipe_0 <= instr[24:20];
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_valid <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else begin
      exFwdReg_valid <= _T_2; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 158:18]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_wbDest <= 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else begin
      exFwdReg_wbDest <= decExReg_rd; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 159:19]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
      exFwdReg_wbData <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 36:25]
    end else if (decExReg_decOut_isJal | decExReg_decOut_isJalr) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 140:57]
      exFwdReg_wbData <= _wbData_T_1; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 141:12]
    end else if (decExReg_decOut_isLoad & ~doBranch) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 152:45]
      if (_doBranch_T) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 286:19]
        exFwdReg_wbData <= _GEN_256;
      end else begin
        exFwdReg_wbData <= _GEN_267;
      end
    end else if (decExReg_decOut_isCssrw) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 134:33]
      exFwdReg_wbData <= decExReg_csrVal; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 135:9]
    end else begin
      exFwdReg_wbData <= _GEN_243;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
      pcReg <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 39:22]
    end else if (!(~io_imem_ack)) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 50:23]
      if (doBranch) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 40:31]
        if (decExReg_decOut_isJalr) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 145:32]
          pcReg <= res; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 146:18]
        end else begin
          pcReg <= _res_T_5; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 144:16]
        end
      end else begin
        pcReg <= _pcNext_T_1;
      end
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_func3 <= 3'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_func3 <= decOut_func3; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_rs1 <= 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_rs1 <= decEx_rs1; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_rs1Val <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (rs1Val_REG == 5'h0) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 208:23]
      decExReg_rs1Val <= 32'h0;
    end else begin
      decExReg_rs1Val <= regs_rs1Val_MPORT_data;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_rs2 <= 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_rs2 <= decEx_rs2; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_rs2Val <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (rs2Val_REG == 5'h0) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 209:23]
      decExReg_rs2Val <= 32'h0;
    end else begin
      decExReg_rs2Val <= regs_rs2Val_MPORT_data;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isBranch <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isBranch <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 26:21]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isBranch <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 26:21]
    end else begin
      decExReg_decOut_isBranch <= 7'h63 == decOut_opcode;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isJal <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 27:18]
    end else begin
      decExReg_decOut_isJal <= _GEN_141;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isJalr <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 28:19]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 28:19]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 28:19]
    end else begin
      decExReg_decOut_isJalr <= _GEN_142;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_valid <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_valid <= _T_14; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isLoad <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 24:19]
    end else begin
      decExReg_decOut_isLoad <= 7'h3 == decOut_opcode;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_memLow <= 2'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_memLow <= decEx_memLow; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isCssrw <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 31:20]
    end else begin
      decExReg_decOut_isCssrw <= _GEN_144;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_csrVal <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_csrVal <= decEx_csrVal; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isAuiPc <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 23:20]
    end else begin
      decExReg_decOut_isAuiPc <= _GEN_140;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_pc <= 32'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_pc <= pcRegReg; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_imm <= 32'sh0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (3'h1 == decOut_instrType) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23]
      decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_6; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 184:13]
    end else if (3'h2 == decOut_instrType) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23]
      decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_13; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 187:13]
    end else if (3'h3 == decOut_instrType) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 182:23]
      decExReg_decOut_imm <= {{1{_decOut_decOut_imm_imm_T_23[30]}},_decOut_decOut_imm_imm_T_23}; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 190:13]
    end else begin
      decExReg_decOut_imm <= _GEN_203;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isLui <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 22:18]
    end else if (7'h33 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 22:18]
    end else if (7'h63 == decOut_opcode) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 22:18]
    end else begin
      decExReg_decOut_isLui <= _GEN_139;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_aluOp <= 4'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else if (3'h0 == decOut_func3) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
      decExReg_decOut_aluOp <= {{3'd0}, _decOut_decOut_aluOp_T_5};
    end else if (3'h1 == decOut_func3) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
      decExReg_decOut_aluOp <= 4'h2; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 124:15]
    end else if (3'h2 == decOut_func3) begin // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 116:19]
      decExReg_decOut_aluOp <= 4'h3; // @[wildcat/src/main/scala/wildcat/pipeline/Functions.scala 127:15]
    end else begin
      decExReg_decOut_aluOp <= _GEN_198;
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_isImm <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_decOut_isImm <= decOut_isImm; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    pcRegReg <= pcReg; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 56:25]
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 57:25]
      instrReg <= 32'h33; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 57:25]
    end else if (doBranch) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 58:18]
      instrReg <= 32'h33;
    end else if (~io_imem_ack) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 50:23]
      instrReg <= 32'h33; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 51:11]
    end else begin
      instrReg <= io_imem_rdData; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 49:26]
    end
    rs1Val_REG <= instr[19:15]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 59:18]
    rs2Val_REG <= instr[24:20]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 60:18]
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_rd <= 5'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_rd <= instrReg[11:7]; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
    if (reset) begin // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
      decExReg_decOut_rfWrite <= 1'h0; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 118:25]
    end else begin
      decExReg_decOut_rfWrite <= decOut_rfWrite; // @[wildcat/src/main/scala/wildcat/pipeline/ThreeCats.scala 119:12]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regs[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_rs1Val_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  regs_rs1Val_MPORT_addr_pipe_0 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  regs_rs2Val_MPORT_en_pipe_0 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  regs_rs2Val_MPORT_addr_pipe_0 = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  exFwdReg_valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  exFwdReg_wbDest = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  exFwdReg_wbData = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  pcReg = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  decExReg_func3 = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  decExReg_rs1 = _RAND_10[4:0];
  _RAND_11 = {1{`RANDOM}};
  decExReg_rs1Val = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  decExReg_rs2 = _RAND_12[4:0];
  _RAND_13 = {1{`RANDOM}};
  decExReg_rs2Val = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  decExReg_decOut_isBranch = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  decExReg_decOut_isJal = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  decExReg_decOut_isJalr = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  decExReg_valid = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  decExReg_decOut_isLoad = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  decExReg_memLow = _RAND_19[1:0];
  _RAND_20 = {1{`RANDOM}};
  decExReg_decOut_isCssrw = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  decExReg_csrVal = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  decExReg_decOut_isAuiPc = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  decExReg_pc = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  decExReg_decOut_imm = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  decExReg_decOut_isLui = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  decExReg_decOut_aluOp = _RAND_26[3:0];
  _RAND_27 = {1{`RANDOM}};
  decExReg_decOut_isImm = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  pcRegReg = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  instrReg = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  rs1Val_REG = _RAND_30[4:0];
  _RAND_31 = {1{`RANDOM}};
  rs2Val_REG = _RAND_31[4:0];
  _RAND_32 = {1{`RANDOM}};
  decExReg_rd = _RAND_32[4:0];
  _RAND_33 = {1{`RANDOM}};
  decExReg_decOut_rfWrite = _RAND_33[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ScratchPadMem(
  input         clock,
  input  [31:0] io_address, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input         io_wr, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  output [31:0] io_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [31:0] io_wrData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [3:0]  io_wrMask // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] MEM [0:3]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire  MEM_io_rdData_MPORT_3_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire [1:0] MEM_io_rdData_MPORT_3_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire [7:0] MEM_io_rdData_MPORT_3_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire [7:0] MEM_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire [1:0] MEM_MPORT_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire  MEM_MPORT_mask; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  wire  MEM_MPORT_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  reg  MEM_io_rdData_MPORT_3_en_pipe_0;
  reg [1:0] MEM_io_rdData_MPORT_3_addr_pipe_0;
  reg [7:0] MEM_1 [0:3]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire  MEM_1_io_rdData_MPORT_2_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire [1:0] MEM_1_io_rdData_MPORT_2_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire [7:0] MEM_1_io_rdData_MPORT_2_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire [7:0] MEM_1_MPORT_1_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire [1:0] MEM_1_MPORT_1_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire  MEM_1_MPORT_1_mask; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  wire  MEM_1_MPORT_1_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  reg  MEM_1_io_rdData_MPORT_2_en_pipe_0;
  reg [1:0] MEM_1_io_rdData_MPORT_2_addr_pipe_0;
  reg [7:0] MEM_2 [0:3]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire  MEM_2_io_rdData_MPORT_1_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire [1:0] MEM_2_io_rdData_MPORT_1_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire [7:0] MEM_2_io_rdData_MPORT_1_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire [7:0] MEM_2_MPORT_2_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire [1:0] MEM_2_MPORT_2_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire  MEM_2_MPORT_2_mask; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  wire  MEM_2_MPORT_2_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  reg  MEM_2_io_rdData_MPORT_1_en_pipe_0;
  reg [1:0] MEM_2_io_rdData_MPORT_1_addr_pipe_0;
  reg [7:0] MEM_3 [0:3]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire  MEM_3_io_rdData_MPORT_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire [1:0] MEM_3_io_rdData_MPORT_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire [7:0] MEM_3_io_rdData_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire [7:0] MEM_3_MPORT_3_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire [1:0] MEM_3_MPORT_3_addr; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire  MEM_3_MPORT_3_mask; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  wire  MEM_3_MPORT_3_en; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  reg  MEM_3_io_rdData_MPORT_en_pipe_0;
  reg [1:0] MEM_3_io_rdData_MPORT_addr_pipe_0;
  wire [23:0] _io_rdData_T_10 = {MEM_3_io_rdData_MPORT_data,MEM_2_io_rdData_MPORT_1_data,MEM_1_io_rdData_MPORT_2_data}; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 60:40]
  assign MEM_io_rdData_MPORT_3_en = MEM_io_rdData_MPORT_3_en_pipe_0;
  assign MEM_io_rdData_MPORT_3_addr = MEM_io_rdData_MPORT_3_addr_pipe_0;
  assign MEM_io_rdData_MPORT_3_data = MEM[MEM_io_rdData_MPORT_3_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
  assign MEM_MPORT_data = io_wrData[7:0];
  assign MEM_MPORT_addr = io_address[3:2];
  assign MEM_MPORT_mask = 1'h1;
  assign MEM_MPORT_en = io_wrMask[0] & io_wr;
  assign MEM_1_io_rdData_MPORT_2_en = MEM_1_io_rdData_MPORT_2_en_pipe_0;
  assign MEM_1_io_rdData_MPORT_2_addr = MEM_1_io_rdData_MPORT_2_addr_pipe_0;
  assign MEM_1_io_rdData_MPORT_2_data = MEM_1[MEM_1_io_rdData_MPORT_2_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
  assign MEM_1_MPORT_1_data = io_wrData[15:8];
  assign MEM_1_MPORT_1_addr = io_address[3:2];
  assign MEM_1_MPORT_1_mask = 1'h1;
  assign MEM_1_MPORT_1_en = io_wrMask[1] & io_wr;
  assign MEM_2_io_rdData_MPORT_1_en = MEM_2_io_rdData_MPORT_1_en_pipe_0;
  assign MEM_2_io_rdData_MPORT_1_addr = MEM_2_io_rdData_MPORT_1_addr_pipe_0;
  assign MEM_2_io_rdData_MPORT_1_data = MEM_2[MEM_2_io_rdData_MPORT_1_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
  assign MEM_2_MPORT_2_data = io_wrData[23:16];
  assign MEM_2_MPORT_2_addr = io_address[3:2];
  assign MEM_2_MPORT_2_mask = 1'h1;
  assign MEM_2_MPORT_2_en = io_wrMask[2] & io_wr;
  assign MEM_3_io_rdData_MPORT_en = MEM_3_io_rdData_MPORT_en_pipe_0;
  assign MEM_3_io_rdData_MPORT_addr = MEM_3_io_rdData_MPORT_addr_pipe_0;
  assign MEM_3_io_rdData_MPORT_data = MEM_3[MEM_3_io_rdData_MPORT_addr]; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
  assign MEM_3_MPORT_3_data = io_wrData[31:24];
  assign MEM_3_MPORT_3_addr = io_address[3:2];
  assign MEM_3_MPORT_3_mask = 1'h1;
  assign MEM_3_MPORT_3_en = io_wrMask[3] & io_wr;
  assign io_rdData = {_io_rdData_T_10,MEM_io_rdData_MPORT_3_data}; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 61:40]
  always @(posedge clock) begin
    if (MEM_MPORT_en & MEM_MPORT_mask) begin
      MEM[MEM_MPORT_addr] <= MEM_MPORT_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 16:16]
    end
    MEM_io_rdData_MPORT_3_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_io_rdData_MPORT_3_addr_pipe_0 <= io_address[3:2];
    end
    if (MEM_1_MPORT_1_en & MEM_1_MPORT_1_mask) begin
      MEM_1[MEM_1_MPORT_1_addr] <= MEM_1_MPORT_1_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 17:16]
    end
    MEM_1_io_rdData_MPORT_2_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_1_io_rdData_MPORT_2_addr_pipe_0 <= io_address[3:2];
    end
    if (MEM_2_MPORT_2_en & MEM_2_MPORT_2_mask) begin
      MEM_2[MEM_2_MPORT_2_addr] <= MEM_2_MPORT_2_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 18:16]
    end
    MEM_2_io_rdData_MPORT_1_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_2_io_rdData_MPORT_1_addr_pipe_0 <= io_address[3:2];
    end
    if (MEM_3_MPORT_3_en & MEM_3_MPORT_3_mask) begin
      MEM_3[MEM_3_MPORT_3_addr] <= MEM_3_MPORT_3_data; // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 19:16]
    end
    MEM_3_io_rdData_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_3_io_rdData_MPORT_addr_pipe_0 <= io_address[3:2];
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    MEM[initvar] = _RAND_0[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    MEM_1[initvar] = _RAND_3[7:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    MEM_2[initvar] = _RAND_6[7:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    MEM_3[initvar] = _RAND_9[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  MEM_io_rdData_MPORT_3_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  MEM_io_rdData_MPORT_3_addr_pipe_0 = _RAND_2[1:0];
  _RAND_4 = {1{`RANDOM}};
  MEM_1_io_rdData_MPORT_2_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  MEM_1_io_rdData_MPORT_2_addr_pipe_0 = _RAND_5[1:0];
  _RAND_7 = {1{`RANDOM}};
  MEM_2_io_rdData_MPORT_1_en_pipe_0 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  MEM_2_io_rdData_MPORT_1_addr_pipe_0 = _RAND_8[1:0];
  _RAND_10 = {1{`RANDOM}};
  MEM_3_io_rdData_MPORT_en_pipe_0 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  MEM_3_io_rdData_MPORT_addr_pipe_0 = _RAND_11[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InstructionROM(
  input         clock,
  input         reset,
  input  [31:0] io_address, // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 10:14]
  output [31:0] io_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 10:14]
  output        io_ack // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 10:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] addrReg; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 13:20]
  wire [31:0] _GEN_1 = 5'h1 == addrReg[6:2] ? 32'h18000ef : 32'hf0000237; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_2 = 5'h2 == addrReg[6:2] ? 32'h34000ef : _GEN_1; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_3 = 5'h3 == addrReg[6:2] ? 32'hff9ff06f : _GEN_2; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_4 = 5'h4 == addrReg[6:2] ? 32'h100e13 : _GEN_3; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_5 = 5'h5 == addrReg[6:2] ? 32'h73 : _GEN_4; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_6 = 5'h6 == addrReg[6:2] ? 32'h63 : _GEN_5; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_7 = 5'h7 == addrReg[6:2] ? 32'h22183 : _GEN_6; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_8 = 5'h8 == addrReg[6:2] ? 32'h13 : _GEN_7; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_9 = 5'h9 == addrReg[6:2] ? 32'h21f193 : _GEN_8; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_10 = 5'ha == addrReg[6:2] ? 32'h13 : _GEN_9; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_11 = 5'hb == addrReg[6:2] ? 32'hfe0188e3 : _GEN_10; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_12 = 5'hc == addrReg[6:2] ? 32'h13 : _GEN_11; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_13 = 5'hd == addrReg[6:2] ? 32'h422103 : _GEN_12; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_14 = 5'he == addrReg[6:2] ? 32'h8067 : _GEN_13; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_15 = 5'hf == addrReg[6:2] ? 32'h22183 : _GEN_14; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_16 = 5'h10 == addrReg[6:2] ? 32'h13 : _GEN_15; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_17 = 5'h11 == addrReg[6:2] ? 32'h11f193 : _GEN_16; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_18 = 5'h12 == addrReg[6:2] ? 32'h13 : _GEN_17; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_19 = 5'h13 == addrReg[6:2] ? 32'hfe0188e3 : _GEN_18; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_20 = 5'h14 == addrReg[6:2] ? 32'h13 : _GEN_19; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  wire [31:0] _GEN_21 = 5'h15 == addrReg[6:2] ? 32'h222223 : _GEN_20; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  reg  firstReg; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 21:25]
  assign io_rdData = 5'h16 == addrReg[6:2] ? 32'h8067 : _GEN_21; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 16:{13,13}]
  assign io_ack = ~firstReg; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 23:13]
  always @(posedge clock) begin
    addrReg <= io_address; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 14:11]
    firstReg <= reset; // @[wildcat/src/main/scala/wildcat/pipeline/InstructionROM.scala 21:{25,25} 22:12]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  addrReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  firstReg = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DataCache(
  input   clock,
  input   reset
);
  wire  dataRam_clk; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire  dataRam_rst_n; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire  dataRam_en; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire  dataRam_we; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire [3:0] dataRam_wmask; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire [7:0] dataRam_addr; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire [31:0] dataRam_wdata; // @[src/main/scala/cache/DataCache.scala 40:23]
  wire [31:0] dataRam_rdata; // @[src/main/scala/cache/DataCache.scala 40:23]
  OpenRamSP_256x32 dataRam ( // @[src/main/scala/cache/DataCache.scala 40:23]
    .clk(dataRam_clk),
    .rst_n(dataRam_rst_n),
    .en(dataRam_en),
    .we(dataRam_we),
    .wmask(dataRam_wmask),
    .addr(dataRam_addr),
    .wdata(dataRam_wdata),
    .rdata(dataRam_rdata)
  );
  assign dataRam_clk = clock; // @[src/main/scala/cache/DataCache.scala 41:20]
  assign dataRam_rst_n = ~reset; // @[src/main/scala/cache/DataCache.scala 42:23]
  assign dataRam_en = 1'h0; // @[src/main/scala/cache/DataCache.scala 71:17]
  assign dataRam_we = 1'h0; // @[src/main/scala/cache/DataCache.scala 71:17]
  assign dataRam_wmask = 4'h0; // @[src/main/scala/cache/DataCache.scala 71:17 46:20]
  assign dataRam_addr = 8'h0; // @[src/main/scala/cache/DataCache.scala 71:17]
  assign dataRam_wdata = 32'h0; // @[src/main/scala/cache/DataCache.scala 71:17 48:20]
endmodule
module Tx(
  input   clock,
  input   reset,
  output  io_channel_ready, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
  input   io_channel_valid // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 22:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [19:0] cntReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
  reg [3:0] bitsReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 33:31]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 42:26]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 53:22]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 33:40]
  always @(posedge clock) begin
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
      cntReg <= 20'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 30:23]
    end else if (_io_channel_ready_T) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 36:24]
      cntReg <= 20'h363; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 38:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 53:12]
    end
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
      bitsReg <= 4'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 31:24]
    end else if (_io_channel_ready_T) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 36:24]
      if (bitsReg != 4'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 39:27]
        bitsReg <= _bitsReg_T_1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 42:15]
      end else if (io_channel_valid) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 44:30]
        bitsReg <= 4'hb; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 46:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cntReg = _RAND_0[19:0];
  _RAND_1 = {1{`RANDOM}};
  bitsReg = _RAND_1[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input   clock,
  input   reset,
  output  io_in_ready, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  input   io_in_valid, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  input   io_out_ready, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
  output  io_out_valid // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 110:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
  wire  _io_in_ready_T = ~stateReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 119:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 123:23 125:16 116:25]
  assign io_in_ready = ~stateReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 119:27]
  assign io_out_valid = stateReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 120:28]
  always @(posedge clock) begin
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
      stateReg <= 1'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 116:25]
    end else if (_io_in_ready_T) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 122:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 128:24]
      stateReg <= 1'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 129:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input   clock,
  input   reset,
  output  io_channel_ready, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
  input   io_channel_valid // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 139:14]
);
  wire  tx_clock; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_reset; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_io_channel_ready; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  tx_io_channel_valid; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
  wire  buf__clock; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__reset; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_in_ready; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_in_valid; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_out_ready; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  wire  buf__io_out_valid; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
  Tx tx ( // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 143:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid)
  );
  Buffer buf_ ( // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 144:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid)
  );
  assign io_channel_ready = buf__io_in_ready; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 146:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 147:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 146:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 147:17]
endmodule
module Rx(
  input        clock,
  input        reset,
  input        io_channel_ready, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 66:14]
  output       io_channel_valid, // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 66:14]
  output [7:0] io_channel_bits // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 66:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] shiftReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 78:25]
  reg [19:0] cntReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 79:23]
  reg [3:0] bitsReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 80:24]
  reg  valReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 81:23]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 84:22]
  wire [7:0] _shiftReg_T_1 = {1'h0,shiftReg[7:1]}; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 87:20]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 88:24]
  wire  _GEN_0 = bitsReg == 4'h1 | valReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 90:27 91:14 81:23]
  assign io_channel_valid = valReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 103:20]
  assign io_channel_bits = shiftReg; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 102:19]
  always @(posedge clock) begin
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 78:25]
      shiftReg <= 8'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 78:25]
    end else if (!(cntReg != 20'h0)) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 85:31]
        shiftReg <= _shiftReg_T_1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 87:14]
      end
    end
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 79:23]
      cntReg <= 20'h363; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 79:23]
    end else if (cntReg != 20'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 83:24]
      cntReg <= _cntReg_T_1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 84:12]
    end else if (bitsReg != 4'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 85:31]
      cntReg <= 20'h363; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 86:12]
    end
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 80:24]
      bitsReg <= 4'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 80:24]
    end else if (!(cntReg != 20'h0)) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 85:31]
        bitsReg <= _bitsReg_T_1; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 88:13]
      end
    end
    if (reset) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 81:23]
      valReg <= 1'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 81:23]
    end else if (valReg & io_channel_ready) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 98:36]
      valReg <= 1'h0; // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 99:12]
    end else if (!(cntReg != 20'h0)) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[wildcat/ip-contributions/src/main/scala/chisel/lib/uart/Uart.scala 85:31]
        valReg <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  valReg = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CpuTop(
  input         clock,
  input         reset,
  output [15:0] io_led // @[src/main/scala/CpuTop.scala 22:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire  cpu_clock; // @[src/main/scala/CpuTop.scala 31:19]
  wire  cpu_reset; // @[src/main/scala/CpuTop.scala 31:19]
  wire [31:0] cpu_io_imem_address; // @[src/main/scala/CpuTop.scala 31:19]
  wire [31:0] cpu_io_imem_rdData; // @[src/main/scala/CpuTop.scala 31:19]
  wire  cpu_io_imem_ack; // @[src/main/scala/CpuTop.scala 31:19]
  wire [31:0] cpu_io_dmem_address; // @[src/main/scala/CpuTop.scala 31:19]
  wire  cpu_io_dmem_rd; // @[src/main/scala/CpuTop.scala 31:19]
  wire  cpu_io_dmem_wr; // @[src/main/scala/CpuTop.scala 31:19]
  wire [31:0] cpu_io_dmem_rdData; // @[src/main/scala/CpuTop.scala 31:19]
  wire [31:0] cpu_io_dmem_wrData; // @[src/main/scala/CpuTop.scala 31:19]
  wire [3:0] cpu_io_dmem_wrMask; // @[src/main/scala/CpuTop.scala 31:19]
  wire  dmem_clock; // @[src/main/scala/CpuTop.scala 34:20]
  wire [31:0] dmem_io_address; // @[src/main/scala/CpuTop.scala 34:20]
  wire  dmem_io_wr; // @[src/main/scala/CpuTop.scala 34:20]
  wire [31:0] dmem_io_rdData; // @[src/main/scala/CpuTop.scala 34:20]
  wire [31:0] dmem_io_wrData; // @[src/main/scala/CpuTop.scala 34:20]
  wire [3:0] dmem_io_wrMask; // @[src/main/scala/CpuTop.scala 34:20]
  wire  imem_clock; // @[src/main/scala/CpuTop.scala 35:20]
  wire  imem_reset; // @[src/main/scala/CpuTop.scala 35:20]
  wire [31:0] imem_io_address; // @[src/main/scala/CpuTop.scala 35:20]
  wire [31:0] imem_io_rdData; // @[src/main/scala/CpuTop.scala 35:20]
  wire  imem_io_ack; // @[src/main/scala/CpuTop.scala 35:20]
  wire  cache_clock; // @[src/main/scala/CpuTop.scala 36:21]
  wire  cache_reset; // @[src/main/scala/CpuTop.scala 36:21]
  wire  tx_clock; // @[src/main/scala/CpuTop.scala 54:18]
  wire  tx_reset; // @[src/main/scala/CpuTop.scala 54:18]
  wire  tx_io_channel_ready; // @[src/main/scala/CpuTop.scala 54:18]
  wire  tx_io_channel_valid; // @[src/main/scala/CpuTop.scala 54:18]
  wire  rx_clock; // @[src/main/scala/CpuTop.scala 55:18]
  wire  rx_reset; // @[src/main/scala/CpuTop.scala 55:18]
  wire  rx_io_channel_ready; // @[src/main/scala/CpuTop.scala 55:18]
  wire  rx_io_channel_valid; // @[src/main/scala/CpuTop.scala 55:18]
  wire [7:0] rx_io_channel_bits; // @[src/main/scala/CpuTop.scala 55:18]
  reg [1:0] uartStatusReg; // @[src/main/scala/CpuTop.scala 64:30]
  reg [31:0] memAddressReg; // @[src/main/scala/CpuTop.scala 65:30]
  wire [31:0] _GEN_0 = memAddressReg[3:0] == 4'h4 ? {{24'd0}, rx_io_channel_bits} : dmem_io_rdData; // @[src/main/scala/CpuTop.scala 38:15 69:46 70:26]
  wire  _GEN_1 = memAddressReg[3:0] == 4'h4 & cpu_io_dmem_rd; // @[src/main/scala/CpuTop.scala 61:23 69:46 71:27]
  wire [31:0] _GEN_2 = memAddressReg[3:0] == 4'h0 ? {{30'd0}, uartStatusReg} : _GEN_0; // @[src/main/scala/CpuTop.scala 67:40 68:26]
  wire  _GEN_3 = memAddressReg[3:0] == 4'h0 ? 1'h0 : _GEN_1; // @[src/main/scala/CpuTop.scala 61:23 67:40]
  reg [7:0] ledReg; // @[src/main/scala/CpuTop.scala 76:23]
  wire  _T_16 = cpu_io_dmem_address[19:16] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4; // @[src/main/scala/CpuTop.scala 78:46]
  wire  _GEN_9 = cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr & _T_16; // @[src/main/scala/CpuTop.scala 60:23 77:68]
  reg [7:0] io_led_REG; // @[src/main/scala/CpuTop.scala 87:39]
  ThreeCats cpu ( // @[src/main/scala/CpuTop.scala 31:19]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_imem_address(cpu_io_imem_address),
    .io_imem_rdData(cpu_io_imem_rdData),
    .io_imem_ack(cpu_io_imem_ack),
    .io_dmem_address(cpu_io_dmem_address),
    .io_dmem_rd(cpu_io_dmem_rd),
    .io_dmem_wr(cpu_io_dmem_wr),
    .io_dmem_rdData(cpu_io_dmem_rdData),
    .io_dmem_wrData(cpu_io_dmem_wrData),
    .io_dmem_wrMask(cpu_io_dmem_wrMask)
  );
  ScratchPadMem dmem ( // @[src/main/scala/CpuTop.scala 34:20]
    .clock(dmem_clock),
    .io_address(dmem_io_address),
    .io_wr(dmem_io_wr),
    .io_rdData(dmem_io_rdData),
    .io_wrData(dmem_io_wrData),
    .io_wrMask(dmem_io_wrMask)
  );
  InstructionROM imem ( // @[src/main/scala/CpuTop.scala 35:20]
    .clock(imem_clock),
    .reset(imem_reset),
    .io_address(imem_io_address),
    .io_rdData(imem_io_rdData),
    .io_ack(imem_io_ack)
  );
  DataCache cache ( // @[src/main/scala/CpuTop.scala 36:21]
    .clock(cache_clock),
    .reset(cache_reset)
  );
  BufferedTx tx ( // @[src/main/scala/CpuTop.scala 54:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid)
  );
  Rx rx ( // @[src/main/scala/CpuTop.scala 55:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  assign io_led = {8'h80,io_led_REG}; // @[src/main/scala/CpuTop.scala 87:29]
  assign cpu_clock = clock;
  assign cpu_reset = reset;
  assign cpu_io_imem_rdData = imem_io_rdData; // @[src/main/scala/CpuTop.scala 39:15]
  assign cpu_io_imem_ack = imem_io_ack; // @[src/main/scala/CpuTop.scala 39:15]
  assign cpu_io_dmem_rdData = memAddressReg[31:28] == 4'hf & memAddressReg[19:16] == 4'h0 ? _GEN_2 : dmem_io_rdData; // @[src/main/scala/CpuTop.scala 38:15 66:74]
  assign dmem_clock = clock;
  assign dmem_io_address = cpu_io_dmem_address; // @[src/main/scala/CpuTop.scala 38:15]
  assign dmem_io_wr = cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr ? 1'h0 : cpu_io_dmem_wr; // @[src/main/scala/CpuTop.scala 38:15 77:68 84:16]
  assign dmem_io_wrData = cpu_io_dmem_wrData; // @[src/main/scala/CpuTop.scala 38:15]
  assign dmem_io_wrMask = cpu_io_dmem_wrMask; // @[src/main/scala/CpuTop.scala 38:15]
  assign imem_clock = clock;
  assign imem_reset = reset;
  assign imem_io_address = cpu_io_imem_address; // @[src/main/scala/CpuTop.scala 39:15]
  assign cache_clock = clock;
  assign cache_reset = reset;
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr & _T_16; // @[src/main/scala/CpuTop.scala 60:23 77:68]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_channel_ready = memAddressReg[31:28] == 4'hf & memAddressReg[19:16] == 4'h0 & _GEN_3; // @[src/main/scala/CpuTop.scala 61:23 66:74]
  always @(posedge clock) begin
    uartStatusReg <= {rx_io_channel_valid,tx_io_channel_ready}; // @[src/main/scala/CpuTop.scala 64:51]
    memAddressReg <= cpu_io_dmem_address; // @[src/main/scala/CpuTop.scala 65:30]
    if (reset) begin // @[src/main/scala/CpuTop.scala 76:23]
      ledReg <= 8'h0; // @[src/main/scala/CpuTop.scala 76:23]
    end else if (cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[src/main/scala/CpuTop.scala 77:68]
      if (!(cpu_io_dmem_address[19:16] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[src/main/scala/CpuTop.scala 78:84]
        if (cpu_io_dmem_address[19:16] == 4'h1) begin // @[src/main/scala/CpuTop.scala 81:54]
          ledReg <= cpu_io_dmem_wrData[7:0]; // @[src/main/scala/CpuTop.scala 82:14]
        end
      end
    end
    io_led_REG <= ledReg; // @[src/main/scala/CpuTop.scala 87:39]
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_9 & ~reset) begin
          $fwrite(32'h80000002," %c %d\n",cpu_io_dmem_wrData[7:0],cpu_io_dmem_wrData[7:0]); // @[src/main/scala/CpuTop.scala 79:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  uartStatusReg = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  memAddressReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  ledReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  io_led_REG = _RAND_3[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DecoupledGcd(
  input         clock,
  input         reset,
  output        input_ready, // @[src/main/scala/WishboneGcd.scala 72:17]
  input         input_valid, // @[src/main/scala/WishboneGcd.scala 72:17]
  input  [15:0] input_bits_value1, // @[src/main/scala/WishboneGcd.scala 72:17]
  input  [15:0] input_bits_value2, // @[src/main/scala/WishboneGcd.scala 72:17]
  input         output_ready, // @[src/main/scala/WishboneGcd.scala 73:18]
  output        output_valid, // @[src/main/scala/WishboneGcd.scala 73:18]
  output [15:0] output_bits_gcd // @[src/main/scala/WishboneGcd.scala 73:18]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] x; // @[src/main/scala/WishboneGcd.scala 77:24]
  reg [15:0] y; // @[src/main/scala/WishboneGcd.scala 78:24]
  reg  busy; // @[src/main/scala/WishboneGcd.scala 79:28]
  reg  resultValid; // @[src/main/scala/WishboneGcd.scala 80:28]
  wire [15:0] _x_T_1 = x - y; // @[src/main/scala/WishboneGcd.scala 88:14]
  wire [15:0] _y_T_1 = y - x; // @[src/main/scala/WishboneGcd.scala 90:14]
  wire  _T_1 = x == 16'h0; // @[src/main/scala/WishboneGcd.scala 92:12]
  wire  _GEN_10 = input_valid | ~busy; // @[src/main/scala/WishboneGcd.scala 109:23 82:15 src/main/scala/chisel3/util/Decoupled.scala 88:20]
  wire  _GEN_15 = input_valid | busy; // @[src/main/scala/WishboneGcd.scala 109:23 115:12 79:28]
  assign input_ready = busy ? ~busy : _GEN_10; // @[src/main/scala/WishboneGcd.scala 82:15 86:15]
  assign output_valid = resultValid; // @[src/main/scala/WishboneGcd.scala 83:16]
  assign output_bits_gcd = _T_1 ? y : x; // @[src/main/scala/WishboneGcd.scala 93:23 94:25 96:25]
  always @(posedge clock) begin
    if (busy) begin // @[src/main/scala/WishboneGcd.scala 86:15]
      if (x > y) begin // @[src/main/scala/WishboneGcd.scala 87:17]
        x <= _x_T_1; // @[src/main/scala/WishboneGcd.scala 88:9]
      end
    end else if (input_valid) begin // @[src/main/scala/WishboneGcd.scala 109:23]
      x <= input_bits_value1; // @[src/main/scala/WishboneGcd.scala 111:9]
    end
    if (busy) begin // @[src/main/scala/WishboneGcd.scala 86:15]
      if (!(x > y)) begin // @[src/main/scala/WishboneGcd.scala 87:17]
        y <= _y_T_1; // @[src/main/scala/WishboneGcd.scala 90:9]
      end
    end else if (input_valid) begin // @[src/main/scala/WishboneGcd.scala 109:23]
      y <= input_bits_value2; // @[src/main/scala/WishboneGcd.scala 112:9]
    end
    if (reset) begin // @[src/main/scala/WishboneGcd.scala 79:28]
      busy <= 1'h0; // @[src/main/scala/WishboneGcd.scala 79:28]
    end else if (busy) begin // @[src/main/scala/WishboneGcd.scala 86:15]
      if (x == 16'h0 | y == 16'h0) begin // @[src/main/scala/WishboneGcd.scala 92:34]
        if (output_ready & resultValid) begin // @[src/main/scala/WishboneGcd.scala 103:41]
          busy <= 1'h0; // @[src/main/scala/WishboneGcd.scala 104:14]
        end
      end
    end else begin
      busy <= _GEN_15;
    end
    if (reset) begin // @[src/main/scala/WishboneGcd.scala 80:28]
      resultValid <= 1'h0; // @[src/main/scala/WishboneGcd.scala 80:28]
    end else if (busy) begin // @[src/main/scala/WishboneGcd.scala 86:15]
      if (x == 16'h0 | y == 16'h0) begin // @[src/main/scala/WishboneGcd.scala 92:34]
        if (output_ready & resultValid) begin // @[src/main/scala/WishboneGcd.scala 103:41]
          resultValid <= 1'h0; // @[src/main/scala/WishboneGcd.scala 105:21]
        end else begin
          resultValid <= 1'h1; // @[src/main/scala/WishboneGcd.scala 101:19]
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  x = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  y = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  busy = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  resultValid = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WishboneGcd(
  input         clock,
  input         reset,
  input  [2:0]  wb_addr, // @[src/main/scala/WishboneGcd.scala 24:14]
  input  [31:0] wb_wrData, // @[src/main/scala/WishboneGcd.scala 24:14]
  output [31:0] wb_rdData, // @[src/main/scala/WishboneGcd.scala 24:14]
  input         wb_we, // @[src/main/scala/WishboneGcd.scala 24:14]
  input         wb_stb, // @[src/main/scala/WishboneGcd.scala 24:14]
  output        wb_ack, // @[src/main/scala/WishboneGcd.scala 24:14]
  input         wb_cyc // @[src/main/scala/WishboneGcd.scala 24:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  gcd_clock; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  gcd_reset; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  gcd_input_ready; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  gcd_input_valid; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire [15:0] gcd_input_bits_value1; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire [15:0] gcd_input_bits_value2; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  gcd_output_ready; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  gcd_output_valid; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire [15:0] gcd_output_bits_gcd; // @[src/main/scala/WishboneGcd.scala 36:19]
  wire  dataAccess = wb_addr == 3'h0; // @[src/main/scala/WishboneGcd.scala 26:28]
  wire  statusAccess = wb_addr == 3'h4; // @[src/main/scala/WishboneGcd.scala 27:30]
  reg  ackReg; // @[src/main/scala/WishboneGcd.scala 29:23]
  wire  _GEN_0 = wb_cyc & wb_stb | ackReg; // @[src/main/scala/WishboneGcd.scala 32:32 33:12 29:23]
  wire  _wb_ack_T = wb_we ? gcd_input_ready : gcd_output_valid; // @[src/main/scala/WishboneGcd.scala 45:49]
  wire [1:0] _wb_rdData_T = {gcd_input_ready,gcd_output_valid}; // @[src/main/scala/WishboneGcd.scala 46:50]
  wire [15:0] _wb_rdData_T_1 = statusAccess ? {{14'd0}, _wb_rdData_T} : gcd_output_bits_gcd; // @[src/main/scala/WishboneGcd.scala 46:19]
  DecoupledGcd gcd ( // @[src/main/scala/WishboneGcd.scala 36:19]
    .clock(gcd_clock),
    .reset(gcd_reset),
    .input_ready(gcd_input_ready),
    .input_valid(gcd_input_valid),
    .input_bits_value1(gcd_input_bits_value1),
    .input_bits_value2(gcd_input_bits_value2),
    .output_ready(gcd_output_ready),
    .output_valid(gcd_output_valid),
    .output_bits_gcd(gcd_output_bits_gcd)
  );
  assign wb_rdData = {{16'd0}, _wb_rdData_T_1}; // @[src/main/scala/WishboneGcd.scala 46:13]
  assign wb_ack = ackReg & (statusAccess | _wb_ack_T); // @[src/main/scala/WishboneGcd.scala 45:20]
  assign gcd_clock = clock;
  assign gcd_reset = reset;
  assign gcd_input_valid = ackReg & wb_we & dataAccess; // @[src/main/scala/WishboneGcd.scala 38:38]
  assign gcd_input_bits_value1 = wb_wrData[15:0]; // @[src/main/scala/WishboneGcd.scala 39:37]
  assign gcd_input_bits_value2 = wb_wrData[31:16]; // @[src/main/scala/WishboneGcd.scala 40:37]
  assign gcd_output_ready = ackReg & ~wb_we & dataAccess; // @[src/main/scala/WishboneGcd.scala 42:40]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/WishboneGcd.scala 29:23]
      ackReg <= 1'h0; // @[src/main/scala/WishboneGcd.scala 29:23]
    end else if (ackReg) begin // @[src/main/scala/WishboneGcd.scala 30:16]
      ackReg <= 1'h0; // @[src/main/scala/WishboneGcd.scala 31:12]
    end else begin
      ackReg <= _GEN_0;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ackReg = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CharacterTable(
  input  [6:0] io_character, // @[src/main/scala/VideoController/CharacterTable.scala 21:14]
  input  [2:0] io_xPos, // @[src/main/scala/VideoController/CharacterTable.scala 21:14]
  input  [2:0] io_yPos, // @[src/main/scala/VideoController/CharacterTable.scala 21:14]
  output       io_pixel // @[src/main/scala/VideoController/CharacterTable.scala 21:14]
);
  wire  inRange = io_character >= 7'h21 & io_character <= 7'h7e; // @[src/main/scala/VideoController/CharacterTable.scala 35:38]
  wire [6:0] index = io_character - 7'h21; // @[src/main/scala/VideoController/CharacterTable.scala 36:28]
  wire [7:0] _GEN_1 = 7'h0 == index & 3'h1 == io_yPos ? 8'h18 : 8'h0; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_2 = 7'h0 == index & 3'h2 == io_yPos ? 8'h3c : _GEN_1; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_3 = 7'h0 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_2; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_4 = 7'h0 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_3; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_5 = 7'h0 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_4; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_6 = 7'h0 == index & 3'h6 == io_yPos ? 8'h0 : _GEN_5; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_7 = 7'h0 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_6; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_8 = 7'h1 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_7; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_9 = 7'h1 == index & 3'h1 == io_yPos ? 8'h6c : _GEN_8; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_10 = 7'h1 == index & 3'h2 == io_yPos ? 8'h6c : _GEN_9; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_11 = 7'h1 == index & 3'h3 == io_yPos ? 8'h28 : _GEN_10; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_12 = 7'h1 == index & 3'h4 == io_yPos ? 8'h0 : _GEN_11; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_13 = 7'h1 == index & 3'h5 == io_yPos ? 8'h0 : _GEN_12; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_14 = 7'h1 == index & 3'h6 == io_yPos ? 8'h0 : _GEN_13; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_15 = 7'h1 == index & 3'h7 == io_yPos ? 8'h0 : _GEN_14; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_16 = 7'h2 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_15; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_17 = 7'h2 == index & 3'h1 == io_yPos ? 8'h6c : _GEN_16; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_18 = 7'h2 == index & 3'h2 == io_yPos ? 8'h6c : _GEN_17; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_19 = 7'h2 == index & 3'h3 == io_yPos ? 8'hfe : _GEN_18; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_20 = 7'h2 == index & 3'h4 == io_yPos ? 8'h6c : _GEN_19; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_21 = 7'h2 == index & 3'h5 == io_yPos ? 8'hfe : _GEN_20; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_22 = 7'h2 == index & 3'h6 == io_yPos ? 8'h6c : _GEN_21; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_23 = 7'h2 == index & 3'h7 == io_yPos ? 8'h6c : _GEN_22; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_24 = 7'h3 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_23; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_25 = 7'h3 == index & 3'h1 == io_yPos ? 8'h10 : _GEN_24; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_26 = 7'h3 == index & 3'h2 == io_yPos ? 8'h78 : _GEN_25; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_27 = 7'h3 == index & 3'h3 == io_yPos ? 8'h4 : _GEN_26; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_28 = 7'h3 == index & 3'h4 == io_yPos ? 8'h38 : _GEN_27; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_29 = 7'h3 == index & 3'h5 == io_yPos ? 8'h40 : _GEN_28; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_30 = 7'h3 == index & 3'h6 == io_yPos ? 8'h3c : _GEN_29; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_31 = 7'h3 == index & 3'h7 == io_yPos ? 8'h10 : _GEN_30; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_32 = 7'h4 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_31; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_33 = 7'h4 == index & 3'h1 == io_yPos ? 8'h6 : _GEN_32; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_34 = 7'h4 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_33; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_35 = 7'h4 == index & 3'h3 == io_yPos ? 8'h30 : _GEN_34; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_36 = 7'h4 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_35; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_37 = 7'h4 == index & 3'h5 == io_yPos ? 8'hc : _GEN_36; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_38 = 7'h4 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_37; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_39 = 7'h4 == index & 3'h7 == io_yPos ? 8'h60 : _GEN_38; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_40 = 7'h5 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_39; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_41 = 7'h5 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_40; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_42 = 7'h5 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_41; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_43 = 7'h5 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_42; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_44 = 7'h5 == index & 3'h4 == io_yPos ? 8'h14 : _GEN_43; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_45 = 7'h5 == index & 3'h5 == io_yPos ? 8'ha6 : _GEN_44; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_46 = 7'h5 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_45; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_47 = 7'h5 == index & 3'h7 == io_yPos ? 8'hfc : _GEN_46; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_48 = 7'h6 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_47; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_49 = 7'h6 == index & 3'h1 == io_yPos ? 8'h18 : _GEN_48; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_50 = 7'h6 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_49; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_51 = 7'h6 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_50; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_52 = 7'h6 == index & 3'h4 == io_yPos ? 8'hc : _GEN_51; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_53 = 7'h6 == index & 3'h5 == io_yPos ? 8'h0 : _GEN_52; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_54 = 7'h6 == index & 3'h6 == io_yPos ? 8'h0 : _GEN_53; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_55 = 7'h6 == index & 3'h7 == io_yPos ? 8'h0 : _GEN_54; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_56 = 7'h7 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_55; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_57 = 7'h7 == index & 3'h1 == io_yPos ? 8'h6 : _GEN_56; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_58 = 7'h7 == index & 3'h2 == io_yPos ? 8'hc : _GEN_57; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_59 = 7'h7 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_58; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_60 = 7'h7 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_59; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_61 = 7'h7 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_60; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_62 = 7'h7 == index & 3'h6 == io_yPos ? 8'hc : _GEN_61; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_63 = 7'h7 == index & 3'h7 == io_yPos ? 8'h6 : _GEN_62; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_64 = 7'h8 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_63; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_65 = 7'h8 == index & 3'h1 == io_yPos ? 8'h60 : _GEN_64; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_66 = 7'h8 == index & 3'h2 == io_yPos ? 8'h30 : _GEN_65; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_67 = 7'h8 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_66; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_68 = 7'h8 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_67; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_69 = 7'h8 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_68; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_70 = 7'h8 == index & 3'h6 == io_yPos ? 8'h30 : _GEN_69; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_71 = 7'h8 == index & 3'h7 == io_yPos ? 8'h60 : _GEN_70; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_72 = 7'h9 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_71; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_73 = 7'h9 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_72; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_74 = 7'h9 == index & 3'h2 == io_yPos ? 8'h6c : _GEN_73; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_75 = 7'h9 == index & 3'h3 == io_yPos ? 8'h38 : _GEN_74; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_76 = 7'h9 == index & 3'h4 == io_yPos ? 8'hfe : _GEN_75; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_77 = 7'h9 == index & 3'h5 == io_yPos ? 8'h38 : _GEN_76; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_78 = 7'h9 == index & 3'h6 == io_yPos ? 8'h6c : _GEN_77; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_79 = 7'h9 == index & 3'h7 == io_yPos ? 8'h0 : _GEN_78; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_80 = 7'ha == index & 3'h0 == io_yPos ? 8'h0 : _GEN_79; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_81 = 7'ha == index & 3'h1 == io_yPos ? 8'h0 : _GEN_80; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_82 = 7'ha == index & 3'h2 == io_yPos ? 8'h10 : _GEN_81; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_83 = 7'ha == index & 3'h3 == io_yPos ? 8'h10 : _GEN_82; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_84 = 7'ha == index & 3'h4 == io_yPos ? 8'h7c : _GEN_83; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_85 = 7'ha == index & 3'h5 == io_yPos ? 8'h10 : _GEN_84; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_86 = 7'ha == index & 3'h6 == io_yPos ? 8'h10 : _GEN_85; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_87 = 7'ha == index & 3'h7 == io_yPos ? 8'h0 : _GEN_86; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_88 = 7'hb == index & 3'h0 == io_yPos ? 8'h0 : _GEN_87; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_89 = 7'hb == index & 3'h1 == io_yPos ? 8'h0 : _GEN_88; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_90 = 7'hb == index & 3'h2 == io_yPos ? 8'h0 : _GEN_89; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_91 = 7'hb == index & 3'h3 == io_yPos ? 8'h0 : _GEN_90; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_92 = 7'hb == index & 3'h4 == io_yPos ? 8'hc : _GEN_91; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_93 = 7'hb == index & 3'h5 == io_yPos ? 8'hc : _GEN_92; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_94 = 7'hb == index & 3'h6 == io_yPos ? 8'hc : _GEN_93; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_95 = 7'hb == index & 3'h7 == io_yPos ? 8'h6 : _GEN_94; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_96 = 7'hc == index & 3'h0 == io_yPos ? 8'h0 : _GEN_95; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_97 = 7'hc == index & 3'h1 == io_yPos ? 8'h0 : _GEN_96; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_98 = 7'hc == index & 3'h2 == io_yPos ? 8'h0 : _GEN_97; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_99 = 7'hc == index & 3'h3 == io_yPos ? 8'h0 : _GEN_98; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_100 = 7'hc == index & 3'h4 == io_yPos ? 8'h3c : _GEN_99; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_101 = 7'hc == index & 3'h5 == io_yPos ? 8'h0 : _GEN_100; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_102 = 7'hc == index & 3'h6 == io_yPos ? 8'h0 : _GEN_101; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_103 = 7'hc == index & 3'h7 == io_yPos ? 8'h0 : _GEN_102; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_104 = 7'hd == index & 3'h0 == io_yPos ? 8'h0 : _GEN_103; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_105 = 7'hd == index & 3'h1 == io_yPos ? 8'h0 : _GEN_104; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_106 = 7'hd == index & 3'h2 == io_yPos ? 8'h0 : _GEN_105; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_107 = 7'hd == index & 3'h3 == io_yPos ? 8'h0 : _GEN_106; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_108 = 7'hd == index & 3'h4 == io_yPos ? 8'h0 : _GEN_107; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_109 = 7'hd == index & 3'h5 == io_yPos ? 8'h0 : _GEN_108; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_110 = 7'hd == index & 3'h6 == io_yPos ? 8'h6 : _GEN_109; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_111 = 7'hd == index & 3'h7 == io_yPos ? 8'h6 : _GEN_110; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_112 = 7'he == index & 3'h0 == io_yPos ? 8'h0 : _GEN_111; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_113 = 7'he == index & 3'h1 == io_yPos ? 8'h0 : _GEN_112; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_114 = 7'he == index & 3'h2 == io_yPos ? 8'h60 : _GEN_113; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_115 = 7'he == index & 3'h3 == io_yPos ? 8'h30 : _GEN_114; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_116 = 7'he == index & 3'h4 == io_yPos ? 8'h18 : _GEN_115; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_117 = 7'he == index & 3'h5 == io_yPos ? 8'hc : _GEN_116; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_118 = 7'he == index & 3'h6 == io_yPos ? 8'h6 : _GEN_117; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_119 = 7'he == index & 3'h7 == io_yPos ? 8'h0 : _GEN_118; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_120 = 7'hf == index & 3'h0 == io_yPos ? 8'h0 : _GEN_119; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_121 = 7'hf == index & 3'h1 == io_yPos ? 8'h3c : _GEN_120; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_122 = 7'hf == index & 3'h2 == io_yPos ? 8'h66 : _GEN_121; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_123 = 7'hf == index & 3'h3 == io_yPos ? 8'h76 : _GEN_122; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_124 = 7'hf == index & 3'h4 == io_yPos ? 8'h6e : _GEN_123; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_125 = 7'hf == index & 3'h5 == io_yPos ? 8'h66 : _GEN_124; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_126 = 7'hf == index & 3'h6 == io_yPos ? 8'h66 : _GEN_125; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_127 = 7'hf == index & 3'h7 == io_yPos ? 8'h3c : _GEN_126; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_128 = 7'h10 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_127; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_129 = 7'h10 == index & 3'h1 == io_yPos ? 8'h18 : _GEN_128; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_130 = 7'h10 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_129; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_131 = 7'h10 == index & 3'h3 == io_yPos ? 8'h1c : _GEN_130; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_132 = 7'h10 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_131; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_133 = 7'h10 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_132; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_134 = 7'h10 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_133; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_135 = 7'h10 == index & 3'h7 == io_yPos ? 8'h7e : _GEN_134; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_136 = 7'h11 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_135; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_137 = 7'h11 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_136; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_138 = 7'h11 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_137; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_139 = 7'h11 == index & 3'h3 == io_yPos ? 8'h60 : _GEN_138; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_140 = 7'h11 == index & 3'h4 == io_yPos ? 8'h30 : _GEN_139; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_141 = 7'h11 == index & 3'h5 == io_yPos ? 8'hc : _GEN_140; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_142 = 7'h11 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_141; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_143 = 7'h11 == index & 3'h7 == io_yPos ? 8'h7e : _GEN_142; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_144 = 7'h12 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_143; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_145 = 7'h12 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_144; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_146 = 7'h12 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_145; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_147 = 7'h12 == index & 3'h3 == io_yPos ? 8'h60 : _GEN_146; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_148 = 7'h12 == index & 3'h4 == io_yPos ? 8'h38 : _GEN_147; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_149 = 7'h12 == index & 3'h5 == io_yPos ? 8'h60 : _GEN_148; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_150 = 7'h12 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_149; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_151 = 7'h12 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_150; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_152 = 7'h13 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_151; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_153 = 7'h13 == index & 3'h1 == io_yPos ? 8'h30 : _GEN_152; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_154 = 7'h13 == index & 3'h2 == io_yPos ? 8'h38 : _GEN_153; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_155 = 7'h13 == index & 3'h3 == io_yPos ? 8'h34 : _GEN_154; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_156 = 7'h13 == index & 3'h4 == io_yPos ? 8'h32 : _GEN_155; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_157 = 7'h13 == index & 3'h5 == io_yPos ? 8'h7e : _GEN_156; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_158 = 7'h13 == index & 3'h6 == io_yPos ? 8'h30 : _GEN_157; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_159 = 7'h13 == index & 3'h7 == io_yPos ? 8'h30 : _GEN_158; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_160 = 7'h14 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_159; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_161 = 7'h14 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_160; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_162 = 7'h14 == index & 3'h2 == io_yPos ? 8'h6 : _GEN_161; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_163 = 7'h14 == index & 3'h3 == io_yPos ? 8'h3e : _GEN_162; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_164 = 7'h14 == index & 3'h4 == io_yPos ? 8'h60 : _GEN_163; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_165 = 7'h14 == index & 3'h5 == io_yPos ? 8'h60 : _GEN_164; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_166 = 7'h14 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_165; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_167 = 7'h14 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_166; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_168 = 7'h15 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_167; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_169 = 7'h15 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_168; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_170 = 7'h15 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_169; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_171 = 7'h15 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_170; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_172 = 7'h15 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_171; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_173 = 7'h15 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_172; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_174 = 7'h15 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_173; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_175 = 7'h15 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_174; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_176 = 7'h16 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_175; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_177 = 7'h16 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_176; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_178 = 7'h16 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_177; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_179 = 7'h16 == index & 3'h3 == io_yPos ? 8'h30 : _GEN_178; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_180 = 7'h16 == index & 3'h4 == io_yPos ? 8'h30 : _GEN_179; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_181 = 7'h16 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_180; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_182 = 7'h16 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_181; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_183 = 7'h16 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_182; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_184 = 7'h17 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_183; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_185 = 7'h17 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_184; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_186 = 7'h17 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_185; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_187 = 7'h17 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_186; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_188 = 7'h17 == index & 3'h4 == io_yPos ? 8'h3c : _GEN_187; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_189 = 7'h17 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_188; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_190 = 7'h17 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_189; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_191 = 7'h17 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_190; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_192 = 7'h18 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_191; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_193 = 7'h18 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_192; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_194 = 7'h18 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_193; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_195 = 7'h18 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_194; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_196 = 7'h18 == index & 3'h4 == io_yPos ? 8'h7c : _GEN_195; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_197 = 7'h18 == index & 3'h5 == io_yPos ? 8'h60 : _GEN_196; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_198 = 7'h18 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_197; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_199 = 7'h18 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_198; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_200 = 7'h19 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_199; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_201 = 7'h19 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_200; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_202 = 7'h19 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_201; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_203 = 7'h19 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_202; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_204 = 7'h19 == index & 3'h4 == io_yPos ? 8'h0 : _GEN_203; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_205 = 7'h19 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_204; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_206 = 7'h19 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_205; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_207 = 7'h19 == index & 3'h7 == io_yPos ? 8'h0 : _GEN_206; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_208 = 7'h1a == index & 3'h0 == io_yPos ? 8'h0 : _GEN_207; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_209 = 7'h1a == index & 3'h1 == io_yPos ? 8'h0 : _GEN_208; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_210 = 7'h1a == index & 3'h2 == io_yPos ? 8'h18 : _GEN_209; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_211 = 7'h1a == index & 3'h3 == io_yPos ? 8'h18 : _GEN_210; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_212 = 7'h1a == index & 3'h4 == io_yPos ? 8'h0 : _GEN_211; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_213 = 7'h1a == index & 3'h5 == io_yPos ? 8'h18 : _GEN_212; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_214 = 7'h1a == index & 3'h6 == io_yPos ? 8'h18 : _GEN_213; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_215 = 7'h1a == index & 3'h7 == io_yPos ? 8'hc : _GEN_214; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_216 = 7'h1b == index & 3'h0 == io_yPos ? 8'h0 : _GEN_215; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_217 = 7'h1b == index & 3'h1 == io_yPos ? 8'h60 : _GEN_216; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_218 = 7'h1b == index & 3'h2 == io_yPos ? 8'h30 : _GEN_217; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_219 = 7'h1b == index & 3'h3 == io_yPos ? 8'h18 : _GEN_218; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_220 = 7'h1b == index & 3'h4 == io_yPos ? 8'hc : _GEN_219; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_221 = 7'h1b == index & 3'h5 == io_yPos ? 8'h18 : _GEN_220; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_222 = 7'h1b == index & 3'h6 == io_yPos ? 8'h30 : _GEN_221; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_223 = 7'h1b == index & 3'h7 == io_yPos ? 8'h60 : _GEN_222; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_224 = 7'h1c == index & 3'h0 == io_yPos ? 8'h0 : _GEN_223; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_225 = 7'h1c == index & 3'h1 == io_yPos ? 8'h0 : _GEN_224; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_226 = 7'h1c == index & 3'h2 == io_yPos ? 8'h0 : _GEN_225; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_227 = 7'h1c == index & 3'h3 == io_yPos ? 8'h3c : _GEN_226; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_228 = 7'h1c == index & 3'h4 == io_yPos ? 8'h0 : _GEN_227; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_229 = 7'h1c == index & 3'h5 == io_yPos ? 8'h3c : _GEN_228; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_230 = 7'h1c == index & 3'h6 == io_yPos ? 8'h0 : _GEN_229; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_231 = 7'h1c == index & 3'h7 == io_yPos ? 8'h0 : _GEN_230; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_232 = 7'h1d == index & 3'h0 == io_yPos ? 8'h0 : _GEN_231; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_233 = 7'h1d == index & 3'h1 == io_yPos ? 8'h6 : _GEN_232; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_234 = 7'h1d == index & 3'h2 == io_yPos ? 8'hc : _GEN_233; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_235 = 7'h1d == index & 3'h3 == io_yPos ? 8'h18 : _GEN_234; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_236 = 7'h1d == index & 3'h4 == io_yPos ? 8'h30 : _GEN_235; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_237 = 7'h1d == index & 3'h5 == io_yPos ? 8'h18 : _GEN_236; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_238 = 7'h1d == index & 3'h6 == io_yPos ? 8'hc : _GEN_237; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_239 = 7'h1d == index & 3'h7 == io_yPos ? 8'h6 : _GEN_238; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_240 = 7'h1e == index & 3'h0 == io_yPos ? 8'h0 : _GEN_239; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_241 = 7'h1e == index & 3'h1 == io_yPos ? 8'h3c : _GEN_240; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_242 = 7'h1e == index & 3'h2 == io_yPos ? 8'h66 : _GEN_241; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_243 = 7'h1e == index & 3'h3 == io_yPos ? 8'h60 : _GEN_242; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_244 = 7'h1e == index & 3'h4 == io_yPos ? 8'h38 : _GEN_243; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_245 = 7'h1e == index & 3'h5 == io_yPos ? 8'h18 : _GEN_244; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_246 = 7'h1e == index & 3'h6 == io_yPos ? 8'h0 : _GEN_245; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_247 = 7'h1e == index & 3'h7 == io_yPos ? 8'h18 : _GEN_246; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_248 = 7'h1f == index & 3'h0 == io_yPos ? 8'h0 : _GEN_247; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_249 = 7'h1f == index & 3'h1 == io_yPos ? 8'h1c : _GEN_248; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_250 = 7'h1f == index & 3'h2 == io_yPos ? 8'h22 : _GEN_249; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_251 = 7'h1f == index & 3'h3 == io_yPos ? 8'h3a : _GEN_250; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_252 = 7'h1f == index & 3'h4 == io_yPos ? 8'h1a : _GEN_251; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_253 = 7'h1f == index & 3'h5 == io_yPos ? 8'h42 : _GEN_252; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_254 = 7'h1f == index & 3'h6 == io_yPos ? 8'h3c : _GEN_253; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_255 = 7'h1f == index & 3'h7 == io_yPos ? 8'h0 : _GEN_254; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_256 = 7'h20 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_255; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_257 = 7'h20 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_256; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_258 = 7'h20 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_257; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_259 = 7'h20 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_258; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_260 = 7'h20 == index & 3'h4 == io_yPos ? 8'h7e : _GEN_259; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_261 = 7'h20 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_260; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_262 = 7'h20 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_261; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_263 = 7'h20 == index & 3'h7 == io_yPos ? 8'h66 : _GEN_262; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_264 = 7'h21 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_263; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_265 = 7'h21 == index & 3'h1 == io_yPos ? 8'h3e : _GEN_264; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_266 = 7'h21 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_265; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_267 = 7'h21 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_266; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_268 = 7'h21 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_267; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_269 = 7'h21 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_268; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_270 = 7'h21 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_269; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_271 = 7'h21 == index & 3'h7 == io_yPos ? 8'h3e : _GEN_270; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_272 = 7'h22 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_271; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_273 = 7'h22 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_272; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_274 = 7'h22 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_273; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_275 = 7'h22 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_274; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_276 = 7'h22 == index & 3'h4 == io_yPos ? 8'h6 : _GEN_275; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_277 = 7'h22 == index & 3'h5 == io_yPos ? 8'h6 : _GEN_276; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_278 = 7'h22 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_277; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_279 = 7'h22 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_278; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_280 = 7'h23 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_279; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_281 = 7'h23 == index & 3'h1 == io_yPos ? 8'h3e : _GEN_280; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_282 = 7'h23 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_281; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_283 = 7'h23 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_282; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_284 = 7'h23 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_283; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_285 = 7'h23 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_284; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_286 = 7'h23 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_285; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_287 = 7'h23 == index & 3'h7 == io_yPos ? 8'h3e : _GEN_286; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_288 = 7'h24 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_287; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_289 = 7'h24 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_288; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_290 = 7'h24 == index & 3'h2 == io_yPos ? 8'h6 : _GEN_289; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_291 = 7'h24 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_290; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_292 = 7'h24 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_291; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_293 = 7'h24 == index & 3'h5 == io_yPos ? 8'h6 : _GEN_292; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_294 = 7'h24 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_293; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_295 = 7'h24 == index & 3'h7 == io_yPos ? 8'h7e : _GEN_294; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_296 = 7'h25 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_295; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_297 = 7'h25 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_296; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_298 = 7'h25 == index & 3'h2 == io_yPos ? 8'h6 : _GEN_297; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_299 = 7'h25 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_298; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_300 = 7'h25 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_299; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_301 = 7'h25 == index & 3'h5 == io_yPos ? 8'h6 : _GEN_300; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_302 = 7'h25 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_301; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_303 = 7'h25 == index & 3'h7 == io_yPos ? 8'h6 : _GEN_302; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_304 = 7'h26 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_303; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_305 = 7'h26 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_304; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_306 = 7'h26 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_305; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_307 = 7'h26 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_306; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_308 = 7'h26 == index & 3'h4 == io_yPos ? 8'h6 : _GEN_307; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_309 = 7'h26 == index & 3'h5 == io_yPos ? 8'h76 : _GEN_308; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_310 = 7'h26 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_309; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_311 = 7'h26 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_310; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_312 = 7'h27 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_311; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_313 = 7'h27 == index & 3'h1 == io_yPos ? 8'h66 : _GEN_312; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_314 = 7'h27 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_313; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_315 = 7'h27 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_314; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_316 = 7'h27 == index & 3'h4 == io_yPos ? 8'h7e : _GEN_315; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_317 = 7'h27 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_316; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_318 = 7'h27 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_317; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_319 = 7'h27 == index & 3'h7 == io_yPos ? 8'h66 : _GEN_318; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_320 = 7'h28 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_319; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_321 = 7'h28 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_320; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_322 = 7'h28 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_321; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_323 = 7'h28 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_322; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_324 = 7'h28 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_323; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_325 = 7'h28 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_324; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_326 = 7'h28 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_325; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_327 = 7'h28 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_326; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_328 = 7'h29 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_327; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_329 = 7'h29 == index & 3'h1 == io_yPos ? 8'h78 : _GEN_328; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_330 = 7'h29 == index & 3'h2 == io_yPos ? 8'h30 : _GEN_329; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_331 = 7'h29 == index & 3'h3 == io_yPos ? 8'h30 : _GEN_330; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_332 = 7'h29 == index & 3'h4 == io_yPos ? 8'h30 : _GEN_331; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_333 = 7'h29 == index & 3'h5 == io_yPos ? 8'h36 : _GEN_332; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_334 = 7'h29 == index & 3'h6 == io_yPos ? 8'h36 : _GEN_333; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_335 = 7'h29 == index & 3'h7 == io_yPos ? 8'h1c : _GEN_334; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_336 = 7'h2a == index & 3'h0 == io_yPos ? 8'h0 : _GEN_335; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_337 = 7'h2a == index & 3'h1 == io_yPos ? 8'h66 : _GEN_336; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_338 = 7'h2a == index & 3'h2 == io_yPos ? 8'h36 : _GEN_337; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_339 = 7'h2a == index & 3'h3 == io_yPos ? 8'h1e : _GEN_338; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_340 = 7'h2a == index & 3'h4 == io_yPos ? 8'he : _GEN_339; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_341 = 7'h2a == index & 3'h5 == io_yPos ? 8'h1e : _GEN_340; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_342 = 7'h2a == index & 3'h6 == io_yPos ? 8'h36 : _GEN_341; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_343 = 7'h2a == index & 3'h7 == io_yPos ? 8'h66 : _GEN_342; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_344 = 7'h2b == index & 3'h0 == io_yPos ? 8'h0 : _GEN_343; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_345 = 7'h2b == index & 3'h1 == io_yPos ? 8'h6 : _GEN_344; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_346 = 7'h2b == index & 3'h2 == io_yPos ? 8'h6 : _GEN_345; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_347 = 7'h2b == index & 3'h3 == io_yPos ? 8'h6 : _GEN_346; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_348 = 7'h2b == index & 3'h4 == io_yPos ? 8'h6 : _GEN_347; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_349 = 7'h2b == index & 3'h5 == io_yPos ? 8'h6 : _GEN_348; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_350 = 7'h2b == index & 3'h6 == io_yPos ? 8'h6 : _GEN_349; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_351 = 7'h2b == index & 3'h7 == io_yPos ? 8'h7e : _GEN_350; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_352 = 7'h2c == index & 3'h0 == io_yPos ? 8'h0 : _GEN_351; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_353 = 7'h2c == index & 3'h1 == io_yPos ? 8'hc6 : _GEN_352; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_354 = 7'h2c == index & 3'h2 == io_yPos ? 8'hee : _GEN_353; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_355 = 7'h2c == index & 3'h3 == io_yPos ? 8'hfe : _GEN_354; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_356 = 7'h2c == index & 3'h4 == io_yPos ? 8'hd6 : _GEN_355; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_357 = 7'h2c == index & 3'h5 == io_yPos ? 8'hc6 : _GEN_356; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_358 = 7'h2c == index & 3'h6 == io_yPos ? 8'hc6 : _GEN_357; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_359 = 7'h2c == index & 3'h7 == io_yPos ? 8'hc6 : _GEN_358; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_360 = 7'h2d == index & 3'h0 == io_yPos ? 8'h0 : _GEN_359; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_361 = 7'h2d == index & 3'h1 == io_yPos ? 8'hc6 : _GEN_360; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_362 = 7'h2d == index & 3'h2 == io_yPos ? 8'hce : _GEN_361; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_363 = 7'h2d == index & 3'h3 == io_yPos ? 8'hde : _GEN_362; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_364 = 7'h2d == index & 3'h4 == io_yPos ? 8'hf6 : _GEN_363; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_365 = 7'h2d == index & 3'h5 == io_yPos ? 8'he6 : _GEN_364; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_366 = 7'h2d == index & 3'h6 == io_yPos ? 8'hc6 : _GEN_365; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_367 = 7'h2d == index & 3'h7 == io_yPos ? 8'hc6 : _GEN_366; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_368 = 7'h2e == index & 3'h0 == io_yPos ? 8'h0 : _GEN_367; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_369 = 7'h2e == index & 3'h1 == io_yPos ? 8'h3c : _GEN_368; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_370 = 7'h2e == index & 3'h2 == io_yPos ? 8'h66 : _GEN_369; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_371 = 7'h2e == index & 3'h3 == io_yPos ? 8'h66 : _GEN_370; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_372 = 7'h2e == index & 3'h4 == io_yPos ? 8'h66 : _GEN_371; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_373 = 7'h2e == index & 3'h5 == io_yPos ? 8'h66 : _GEN_372; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_374 = 7'h2e == index & 3'h6 == io_yPos ? 8'h66 : _GEN_373; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_375 = 7'h2e == index & 3'h7 == io_yPos ? 8'h3c : _GEN_374; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_376 = 7'h2f == index & 3'h0 == io_yPos ? 8'h0 : _GEN_375; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_377 = 7'h2f == index & 3'h1 == io_yPos ? 8'h3e : _GEN_376; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_378 = 7'h2f == index & 3'h2 == io_yPos ? 8'h66 : _GEN_377; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_379 = 7'h2f == index & 3'h3 == io_yPos ? 8'h66 : _GEN_378; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_380 = 7'h2f == index & 3'h4 == io_yPos ? 8'h66 : _GEN_379; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_381 = 7'h2f == index & 3'h5 == io_yPos ? 8'h3e : _GEN_380; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_382 = 7'h2f == index & 3'h6 == io_yPos ? 8'h6 : _GEN_381; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_383 = 7'h2f == index & 3'h7 == io_yPos ? 8'h6 : _GEN_382; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_384 = 7'h30 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_383; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_385 = 7'h30 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_384; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_386 = 7'h30 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_385; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_387 = 7'h30 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_386; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_388 = 7'h30 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_387; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_389 = 7'h30 == index & 3'h5 == io_yPos ? 8'h76 : _GEN_388; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_390 = 7'h30 == index & 3'h6 == io_yPos ? 8'h3c : _GEN_389; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_391 = 7'h30 == index & 3'h7 == io_yPos ? 8'h60 : _GEN_390; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_392 = 7'h31 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_391; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_393 = 7'h31 == index & 3'h1 == io_yPos ? 8'h3e : _GEN_392; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_394 = 7'h31 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_393; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_395 = 7'h31 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_394; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_396 = 7'h31 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_395; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_397 = 7'h31 == index & 3'h5 == io_yPos ? 8'h1e : _GEN_396; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_398 = 7'h31 == index & 3'h6 == io_yPos ? 8'h36 : _GEN_397; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_399 = 7'h31 == index & 3'h7 == io_yPos ? 8'h66 : _GEN_398; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_400 = 7'h32 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_399; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_401 = 7'h32 == index & 3'h1 == io_yPos ? 8'h3c : _GEN_400; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_402 = 7'h32 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_401; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_403 = 7'h32 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_402; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_404 = 7'h32 == index & 3'h4 == io_yPos ? 8'h3c : _GEN_403; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_405 = 7'h32 == index & 3'h5 == io_yPos ? 8'h60 : _GEN_404; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_406 = 7'h32 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_405; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_407 = 7'h32 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_406; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_408 = 7'h33 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_407; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_409 = 7'h33 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_408; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_410 = 7'h33 == index & 3'h2 == io_yPos ? 8'h5a : _GEN_409; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_411 = 7'h33 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_410; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_412 = 7'h33 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_411; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_413 = 7'h33 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_412; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_414 = 7'h33 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_413; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_415 = 7'h33 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_414; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_416 = 7'h34 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_415; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_417 = 7'h34 == index & 3'h1 == io_yPos ? 8'h66 : _GEN_416; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_418 = 7'h34 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_417; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_419 = 7'h34 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_418; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_420 = 7'h34 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_419; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_421 = 7'h34 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_420; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_422 = 7'h34 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_421; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_423 = 7'h34 == index & 3'h7 == io_yPos ? 8'h7c : _GEN_422; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_424 = 7'h35 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_423; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_425 = 7'h35 == index & 3'h1 == io_yPos ? 8'h66 : _GEN_424; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_426 = 7'h35 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_425; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_427 = 7'h35 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_426; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_428 = 7'h35 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_427; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_429 = 7'h35 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_428; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_430 = 7'h35 == index & 3'h6 == io_yPos ? 8'h3c : _GEN_429; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_431 = 7'h35 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_430; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_432 = 7'h36 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_431; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_433 = 7'h36 == index & 3'h1 == io_yPos ? 8'hc6 : _GEN_432; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_434 = 7'h36 == index & 3'h2 == io_yPos ? 8'hc6 : _GEN_433; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_435 = 7'h36 == index & 3'h3 == io_yPos ? 8'hc6 : _GEN_434; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_436 = 7'h36 == index & 3'h4 == io_yPos ? 8'hd6 : _GEN_435; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_437 = 7'h36 == index & 3'h5 == io_yPos ? 8'hfe : _GEN_436; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_438 = 7'h36 == index & 3'h6 == io_yPos ? 8'hee : _GEN_437; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_439 = 7'h36 == index & 3'h7 == io_yPos ? 8'hc6 : _GEN_438; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_440 = 7'h37 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_439; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_441 = 7'h37 == index & 3'h1 == io_yPos ? 8'hc6 : _GEN_440; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_442 = 7'h37 == index & 3'h2 == io_yPos ? 8'hc6 : _GEN_441; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_443 = 7'h37 == index & 3'h3 == io_yPos ? 8'h6c : _GEN_442; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_444 = 7'h37 == index & 3'h4 == io_yPos ? 8'h38 : _GEN_443; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_445 = 7'h37 == index & 3'h5 == io_yPos ? 8'h6c : _GEN_444; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_446 = 7'h37 == index & 3'h6 == io_yPos ? 8'hc6 : _GEN_445; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_447 = 7'h37 == index & 3'h7 == io_yPos ? 8'hc6 : _GEN_446; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_448 = 7'h38 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_447; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_449 = 7'h38 == index & 3'h1 == io_yPos ? 8'h66 : _GEN_448; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_450 = 7'h38 == index & 3'h2 == io_yPos ? 8'h66 : _GEN_449; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_451 = 7'h38 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_450; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_452 = 7'h38 == index & 3'h4 == io_yPos ? 8'h3c : _GEN_451; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_453 = 7'h38 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_452; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_454 = 7'h38 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_453; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_455 = 7'h38 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_454; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_456 = 7'h39 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_455; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_457 = 7'h39 == index & 3'h1 == io_yPos ? 8'h7e : _GEN_456; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_458 = 7'h39 == index & 3'h2 == io_yPos ? 8'h60 : _GEN_457; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_459 = 7'h39 == index & 3'h3 == io_yPos ? 8'h30 : _GEN_458; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_460 = 7'h39 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_459; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_461 = 7'h39 == index & 3'h5 == io_yPos ? 8'hc : _GEN_460; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_462 = 7'h39 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_461; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_463 = 7'h39 == index & 3'h7 == io_yPos ? 8'h7e : _GEN_462; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_464 = 7'h3a == index & 3'h0 == io_yPos ? 8'h0 : _GEN_463; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_465 = 7'h3a == index & 3'h1 == io_yPos ? 8'h78 : _GEN_464; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_466 = 7'h3a == index & 3'h2 == io_yPos ? 8'h18 : _GEN_465; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_467 = 7'h3a == index & 3'h3 == io_yPos ? 8'h18 : _GEN_466; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_468 = 7'h3a == index & 3'h4 == io_yPos ? 8'h18 : _GEN_467; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_469 = 7'h3a == index & 3'h5 == io_yPos ? 8'h18 : _GEN_468; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_470 = 7'h3a == index & 3'h6 == io_yPos ? 8'h18 : _GEN_469; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_471 = 7'h3a == index & 3'h7 == io_yPos ? 8'h78 : _GEN_470; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_472 = 7'h3b == index & 3'h0 == io_yPos ? 8'h0 : _GEN_471; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_473 = 7'h3b == index & 3'h1 == io_yPos ? 8'h0 : _GEN_472; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_474 = 7'h3b == index & 3'h2 == io_yPos ? 8'h6 : _GEN_473; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_475 = 7'h3b == index & 3'h3 == io_yPos ? 8'hc : _GEN_474; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_476 = 7'h3b == index & 3'h4 == io_yPos ? 8'h18 : _GEN_475; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_477 = 7'h3b == index & 3'h5 == io_yPos ? 8'h30 : _GEN_476; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_478 = 7'h3b == index & 3'h6 == io_yPos ? 8'h60 : _GEN_477; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_479 = 7'h3b == index & 3'h7 == io_yPos ? 8'h0 : _GEN_478; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_480 = 7'h3c == index & 3'h0 == io_yPos ? 8'h0 : _GEN_479; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_481 = 7'h3c == index & 3'h1 == io_yPos ? 8'h1e : _GEN_480; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_482 = 7'h3c == index & 3'h2 == io_yPos ? 8'h18 : _GEN_481; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_483 = 7'h3c == index & 3'h3 == io_yPos ? 8'h18 : _GEN_482; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_484 = 7'h3c == index & 3'h4 == io_yPos ? 8'h18 : _GEN_483; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_485 = 7'h3c == index & 3'h5 == io_yPos ? 8'h18 : _GEN_484; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_486 = 7'h3c == index & 3'h6 == io_yPos ? 8'h18 : _GEN_485; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_487 = 7'h3c == index & 3'h7 == io_yPos ? 8'h1e : _GEN_486; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_488 = 7'h3d == index & 3'h0 == io_yPos ? 8'h0 : _GEN_487; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_489 = 7'h3d == index & 3'h1 == io_yPos ? 8'h10 : _GEN_488; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_490 = 7'h3d == index & 3'h2 == io_yPos ? 8'h28 : _GEN_489; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_491 = 7'h3d == index & 3'h3 == io_yPos ? 8'h44 : _GEN_490; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_492 = 7'h3d == index & 3'h4 == io_yPos ? 8'h82 : _GEN_491; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_493 = 7'h3d == index & 3'h5 == io_yPos ? 8'h0 : _GEN_492; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_494 = 7'h3d == index & 3'h6 == io_yPos ? 8'h0 : _GEN_493; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_495 = 7'h3d == index & 3'h7 == io_yPos ? 8'h0 : _GEN_494; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_496 = 7'h3e == index & 3'h0 == io_yPos ? 8'h0 : _GEN_495; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_497 = 7'h3e == index & 3'h1 == io_yPos ? 8'h0 : _GEN_496; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_498 = 7'h3e == index & 3'h2 == io_yPos ? 8'h0 : _GEN_497; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_499 = 7'h3e == index & 3'h3 == io_yPos ? 8'h0 : _GEN_498; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_500 = 7'h3e == index & 3'h4 == io_yPos ? 8'h0 : _GEN_499; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_501 = 7'h3e == index & 3'h5 == io_yPos ? 8'h0 : _GEN_500; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_502 = 7'h3e == index & 3'h6 == io_yPos ? 8'h0 : _GEN_501; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_503 = 7'h3e == index & 3'h7 == io_yPos ? 8'hfe : _GEN_502; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_504 = 7'h3f == index & 3'h0 == io_yPos ? 8'h0 : _GEN_503; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_505 = 7'h3f == index & 3'h1 == io_yPos ? 8'h30 : _GEN_504; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_506 = 7'h3f == index & 3'h2 == io_yPos ? 8'h30 : _GEN_505; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_507 = 7'h3f == index & 3'h3 == io_yPos ? 8'h60 : _GEN_506; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_508 = 7'h3f == index & 3'h4 == io_yPos ? 8'h0 : _GEN_507; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_509 = 7'h3f == index & 3'h5 == io_yPos ? 8'h0 : _GEN_508; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_510 = 7'h3f == index & 3'h6 == io_yPos ? 8'h0 : _GEN_509; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_511 = 7'h3f == index & 3'h7 == io_yPos ? 8'h0 : _GEN_510; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_512 = 7'h40 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_511; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_513 = 7'h40 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_512; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_514 = 7'h40 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_513; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_515 = 7'h40 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_514; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_516 = 7'h40 == index & 3'h4 == io_yPos ? 8'h60 : _GEN_515; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_517 = 7'h40 == index & 3'h5 == io_yPos ? 8'h7c : _GEN_516; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_518 = 7'h40 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_517; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_519 = 7'h40 == index & 3'h7 == io_yPos ? 8'h7c : _GEN_518; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_520 = 7'h41 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_519; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_521 = 7'h41 == index & 3'h1 == io_yPos ? 8'h6 : _GEN_520; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_522 = 7'h41 == index & 3'h2 == io_yPos ? 8'h6 : _GEN_521; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_523 = 7'h41 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_522; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_524 = 7'h41 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_523; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_525 = 7'h41 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_524; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_526 = 7'h41 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_525; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_527 = 7'h41 == index & 3'h7 == io_yPos ? 8'h3e : _GEN_526; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_528 = 7'h42 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_527; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_529 = 7'h42 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_528; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_530 = 7'h42 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_529; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_531 = 7'h42 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_530; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_532 = 7'h42 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_531; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_533 = 7'h42 == index & 3'h5 == io_yPos ? 8'h6 : _GEN_532; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_534 = 7'h42 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_533; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_535 = 7'h42 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_534; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_536 = 7'h43 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_535; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_537 = 7'h43 == index & 3'h1 == io_yPos ? 8'h60 : _GEN_536; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_538 = 7'h43 == index & 3'h2 == io_yPos ? 8'h60 : _GEN_537; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_539 = 7'h43 == index & 3'h3 == io_yPos ? 8'h60 : _GEN_538; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_540 = 7'h43 == index & 3'h4 == io_yPos ? 8'h7c : _GEN_539; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_541 = 7'h43 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_540; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_542 = 7'h43 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_541; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_543 = 7'h43 == index & 3'h7 == io_yPos ? 8'h7c : _GEN_542; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_544 = 7'h44 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_543; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_545 = 7'h44 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_544; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_546 = 7'h44 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_545; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_547 = 7'h44 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_546; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_548 = 7'h44 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_547; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_549 = 7'h44 == index & 3'h5 == io_yPos ? 8'h7e : _GEN_548; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_550 = 7'h44 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_549; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_551 = 7'h44 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_550; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_552 = 7'h45 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_551; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_553 = 7'h45 == index & 3'h1 == io_yPos ? 8'h38 : _GEN_552; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_554 = 7'h45 == index & 3'h2 == io_yPos ? 8'h6c : _GEN_553; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_555 = 7'h45 == index & 3'h3 == io_yPos ? 8'hc : _GEN_554; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_556 = 7'h45 == index & 3'h4 == io_yPos ? 8'hc : _GEN_555; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_557 = 7'h45 == index & 3'h5 == io_yPos ? 8'h3e : _GEN_556; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_558 = 7'h45 == index & 3'h6 == io_yPos ? 8'hc : _GEN_557; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_559 = 7'h45 == index & 3'h7 == io_yPos ? 8'hc : _GEN_558; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_560 = 7'h46 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_559; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_561 = 7'h46 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_560; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_562 = 7'h46 == index & 3'h2 == io_yPos ? 8'h7c : _GEN_561; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_563 = 7'h46 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_562; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_564 = 7'h46 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_563; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_565 = 7'h46 == index & 3'h5 == io_yPos ? 8'h7c : _GEN_564; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_566 = 7'h46 == index & 3'h6 == io_yPos ? 8'h60 : _GEN_565; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_567 = 7'h46 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_566; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_568 = 7'h47 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_567; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_569 = 7'h47 == index & 3'h1 == io_yPos ? 8'h6 : _GEN_568; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_570 = 7'h47 == index & 3'h2 == io_yPos ? 8'h6 : _GEN_569; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_571 = 7'h47 == index & 3'h3 == io_yPos ? 8'h6 : _GEN_570; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_572 = 7'h47 == index & 3'h4 == io_yPos ? 8'h3e : _GEN_571; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_573 = 7'h47 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_572; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_574 = 7'h47 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_573; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_575 = 7'h47 == index & 3'h7 == io_yPos ? 8'h66 : _GEN_574; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_576 = 7'h48 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_575; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_577 = 7'h48 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_576; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_578 = 7'h48 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_577; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_579 = 7'h48 == index & 3'h3 == io_yPos ? 8'h0 : _GEN_578; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_580 = 7'h48 == index & 3'h4 == io_yPos ? 8'h18 : _GEN_579; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_581 = 7'h48 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_580; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_582 = 7'h48 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_581; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_583 = 7'h48 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_582; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_584 = 7'h49 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_583; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_585 = 7'h49 == index & 3'h1 == io_yPos ? 8'h30 : _GEN_584; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_586 = 7'h49 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_585; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_587 = 7'h49 == index & 3'h3 == io_yPos ? 8'h30 : _GEN_586; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_588 = 7'h49 == index & 3'h4 == io_yPos ? 8'h30 : _GEN_587; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_589 = 7'h49 == index & 3'h5 == io_yPos ? 8'h36 : _GEN_588; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_590 = 7'h49 == index & 3'h6 == io_yPos ? 8'h36 : _GEN_589; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_591 = 7'h49 == index & 3'h7 == io_yPos ? 8'h1c : _GEN_590; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_592 = 7'h4a == index & 3'h0 == io_yPos ? 8'h0 : _GEN_591; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_593 = 7'h4a == index & 3'h1 == io_yPos ? 8'h6 : _GEN_592; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_594 = 7'h4a == index & 3'h2 == io_yPos ? 8'h6 : _GEN_593; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_595 = 7'h4a == index & 3'h3 == io_yPos ? 8'h66 : _GEN_594; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_596 = 7'h4a == index & 3'h4 == io_yPos ? 8'h36 : _GEN_595; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_597 = 7'h4a == index & 3'h5 == io_yPos ? 8'h1e : _GEN_596; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_598 = 7'h4a == index & 3'h6 == io_yPos ? 8'h36 : _GEN_597; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_599 = 7'h4a == index & 3'h7 == io_yPos ? 8'h66 : _GEN_598; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_600 = 7'h4b == index & 3'h0 == io_yPos ? 8'h0 : _GEN_599; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_601 = 7'h4b == index & 3'h1 == io_yPos ? 8'h18 : _GEN_600; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_602 = 7'h4b == index & 3'h2 == io_yPos ? 8'h18 : _GEN_601; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_603 = 7'h4b == index & 3'h3 == io_yPos ? 8'h18 : _GEN_602; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_604 = 7'h4b == index & 3'h4 == io_yPos ? 8'h18 : _GEN_603; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_605 = 7'h4b == index & 3'h5 == io_yPos ? 8'h18 : _GEN_604; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_606 = 7'h4b == index & 3'h6 == io_yPos ? 8'h18 : _GEN_605; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_607 = 7'h4b == index & 3'h7 == io_yPos ? 8'h18 : _GEN_606; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_608 = 7'h4c == index & 3'h0 == io_yPos ? 8'h0 : _GEN_607; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_609 = 7'h4c == index & 3'h1 == io_yPos ? 8'h0 : _GEN_608; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_610 = 7'h4c == index & 3'h2 == io_yPos ? 8'h0 : _GEN_609; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_611 = 7'h4c == index & 3'h3 == io_yPos ? 8'hc6 : _GEN_610; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_612 = 7'h4c == index & 3'h4 == io_yPos ? 8'hee : _GEN_611; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_613 = 7'h4c == index & 3'h5 == io_yPos ? 8'hfe : _GEN_612; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_614 = 7'h4c == index & 3'h6 == io_yPos ? 8'hd6 : _GEN_613; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_615 = 7'h4c == index & 3'h7 == io_yPos ? 8'hd6 : _GEN_614; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_616 = 7'h4d == index & 3'h0 == io_yPos ? 8'h0 : _GEN_615; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_617 = 7'h4d == index & 3'h1 == io_yPos ? 8'h0 : _GEN_616; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_618 = 7'h4d == index & 3'h2 == io_yPos ? 8'h0 : _GEN_617; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_619 = 7'h4d == index & 3'h3 == io_yPos ? 8'h3e : _GEN_618; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_620 = 7'h4d == index & 3'h4 == io_yPos ? 8'h7e : _GEN_619; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_621 = 7'h4d == index & 3'h5 == io_yPos ? 8'h66 : _GEN_620; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_622 = 7'h4d == index & 3'h6 == io_yPos ? 8'h66 : _GEN_621; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_623 = 7'h4d == index & 3'h7 == io_yPos ? 8'h66 : _GEN_622; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_624 = 7'h4e == index & 3'h0 == io_yPos ? 8'h0 : _GEN_623; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_625 = 7'h4e == index & 3'h1 == io_yPos ? 8'h0 : _GEN_624; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_626 = 7'h4e == index & 3'h2 == io_yPos ? 8'h0 : _GEN_625; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_627 = 7'h4e == index & 3'h3 == io_yPos ? 8'h3c : _GEN_626; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_628 = 7'h4e == index & 3'h4 == io_yPos ? 8'h66 : _GEN_627; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_629 = 7'h4e == index & 3'h5 == io_yPos ? 8'h66 : _GEN_628; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_630 = 7'h4e == index & 3'h6 == io_yPos ? 8'h66 : _GEN_629; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_631 = 7'h4e == index & 3'h7 == io_yPos ? 8'h3c : _GEN_630; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_632 = 7'h4f == index & 3'h0 == io_yPos ? 8'h0 : _GEN_631; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_633 = 7'h4f == index & 3'h1 == io_yPos ? 8'h0 : _GEN_632; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_634 = 7'h4f == index & 3'h2 == io_yPos ? 8'h3e : _GEN_633; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_635 = 7'h4f == index & 3'h3 == io_yPos ? 8'h66 : _GEN_634; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_636 = 7'h4f == index & 3'h4 == io_yPos ? 8'h66 : _GEN_635; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_637 = 7'h4f == index & 3'h5 == io_yPos ? 8'h3e : _GEN_636; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_638 = 7'h4f == index & 3'h6 == io_yPos ? 8'h6 : _GEN_637; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_639 = 7'h4f == index & 3'h7 == io_yPos ? 8'h6 : _GEN_638; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_640 = 7'h50 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_639; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_641 = 7'h50 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_640; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_642 = 7'h50 == index & 3'h2 == io_yPos ? 8'h3c : _GEN_641; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_643 = 7'h50 == index & 3'h3 == io_yPos ? 8'h36 : _GEN_642; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_644 = 7'h50 == index & 3'h4 == io_yPos ? 8'h36 : _GEN_643; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_645 = 7'h50 == index & 3'h5 == io_yPos ? 8'h3c : _GEN_644; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_646 = 7'h50 == index & 3'h6 == io_yPos ? 8'hb0 : _GEN_645; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_647 = 7'h50 == index & 3'h7 == io_yPos ? 8'hf0 : _GEN_646; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_648 = 7'h51 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_647; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_649 = 7'h51 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_648; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_650 = 7'h51 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_649; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_651 = 7'h51 == index & 3'h3 == io_yPos ? 8'h3e : _GEN_650; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_652 = 7'h51 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_651; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_653 = 7'h51 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_652; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_654 = 7'h51 == index & 3'h6 == io_yPos ? 8'h6 : _GEN_653; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_655 = 7'h51 == index & 3'h7 == io_yPos ? 8'h6 : _GEN_654; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_656 = 7'h52 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_655; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_657 = 7'h52 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_656; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_658 = 7'h52 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_657; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_659 = 7'h52 == index & 3'h3 == io_yPos ? 8'h7c : _GEN_658; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_660 = 7'h52 == index & 3'h4 == io_yPos ? 8'h2 : _GEN_659; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_661 = 7'h52 == index & 3'h5 == io_yPos ? 8'h3c : _GEN_660; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_662 = 7'h52 == index & 3'h6 == io_yPos ? 8'h40 : _GEN_661; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_663 = 7'h52 == index & 3'h7 == io_yPos ? 8'h3e : _GEN_662; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_664 = 7'h53 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_663; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_665 = 7'h53 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_664; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_666 = 7'h53 == index & 3'h2 == io_yPos ? 8'h18 : _GEN_665; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_667 = 7'h53 == index & 3'h3 == io_yPos ? 8'h18 : _GEN_666; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_668 = 7'h53 == index & 3'h4 == io_yPos ? 8'h7e : _GEN_667; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_669 = 7'h53 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_668; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_670 = 7'h53 == index & 3'h6 == io_yPos ? 8'h18 : _GEN_669; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_671 = 7'h53 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_670; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_672 = 7'h54 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_671; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_673 = 7'h54 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_672; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_674 = 7'h54 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_673; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_675 = 7'h54 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_674; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_676 = 7'h54 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_675; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_677 = 7'h54 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_676; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_678 = 7'h54 == index & 3'h6 == io_yPos ? 8'h66 : _GEN_677; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_679 = 7'h54 == index & 3'h7 == io_yPos ? 8'h7c : _GEN_678; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_680 = 7'h55 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_679; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_681 = 7'h55 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_680; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_682 = 7'h55 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_681; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_683 = 7'h55 == index & 3'h3 == io_yPos ? 8'h0 : _GEN_682; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_684 = 7'h55 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_683; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_685 = 7'h55 == index & 3'h5 == io_yPos ? 8'h66 : _GEN_684; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_686 = 7'h55 == index & 3'h6 == io_yPos ? 8'h3c : _GEN_685; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_687 = 7'h55 == index & 3'h7 == io_yPos ? 8'h18 : _GEN_686; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_688 = 7'h56 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_687; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_689 = 7'h56 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_688; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_690 = 7'h56 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_689; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_691 = 7'h56 == index & 3'h3 == io_yPos ? 8'hc6 : _GEN_690; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_692 = 7'h56 == index & 3'h4 == io_yPos ? 8'hd6 : _GEN_691; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_693 = 7'h56 == index & 3'h5 == io_yPos ? 8'hd6 : _GEN_692; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_694 = 7'h56 == index & 3'h6 == io_yPos ? 8'hd6 : _GEN_693; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_695 = 7'h56 == index & 3'h7 == io_yPos ? 8'h7c : _GEN_694; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_696 = 7'h57 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_695; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_697 = 7'h57 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_696; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_698 = 7'h57 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_697; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_699 = 7'h57 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_698; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_700 = 7'h57 == index & 3'h4 == io_yPos ? 8'h3c : _GEN_699; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_701 = 7'h57 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_700; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_702 = 7'h57 == index & 3'h6 == io_yPos ? 8'h3c : _GEN_701; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_703 = 7'h57 == index & 3'h7 == io_yPos ? 8'h66 : _GEN_702; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_704 = 7'h58 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_703; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_705 = 7'h58 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_704; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_706 = 7'h58 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_705; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_707 = 7'h58 == index & 3'h3 == io_yPos ? 8'h66 : _GEN_706; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_708 = 7'h58 == index & 3'h4 == io_yPos ? 8'h66 : _GEN_707; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_709 = 7'h58 == index & 3'h5 == io_yPos ? 8'h7c : _GEN_708; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_710 = 7'h58 == index & 3'h6 == io_yPos ? 8'h60 : _GEN_709; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_711 = 7'h58 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_710; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_712 = 7'h59 == index & 3'h0 == io_yPos ? 8'h0 : _GEN_711; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_713 = 7'h59 == index & 3'h1 == io_yPos ? 8'h0 : _GEN_712; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_714 = 7'h59 == index & 3'h2 == io_yPos ? 8'h0 : _GEN_713; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_715 = 7'h59 == index & 3'h3 == io_yPos ? 8'h3c : _GEN_714; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_716 = 7'h59 == index & 3'h4 == io_yPos ? 8'h30 : _GEN_715; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_717 = 7'h59 == index & 3'h5 == io_yPos ? 8'h18 : _GEN_716; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_718 = 7'h59 == index & 3'h6 == io_yPos ? 8'hc : _GEN_717; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_719 = 7'h59 == index & 3'h7 == io_yPos ? 8'h3c : _GEN_718; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_720 = 7'h5a == index & 3'h0 == io_yPos ? 8'h0 : _GEN_719; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_721 = 7'h5a == index & 3'h1 == io_yPos ? 8'h70 : _GEN_720; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_722 = 7'h5a == index & 3'h2 == io_yPos ? 8'h18 : _GEN_721; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_723 = 7'h5a == index & 3'h3 == io_yPos ? 8'h18 : _GEN_722; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_724 = 7'h5a == index & 3'h4 == io_yPos ? 8'hc : _GEN_723; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_725 = 7'h5a == index & 3'h5 == io_yPos ? 8'h18 : _GEN_724; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_726 = 7'h5a == index & 3'h6 == io_yPos ? 8'h18 : _GEN_725; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_727 = 7'h5a == index & 3'h7 == io_yPos ? 8'h70 : _GEN_726; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_728 = 7'h5b == index & 3'h0 == io_yPos ? 8'h0 : _GEN_727; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_729 = 7'h5b == index & 3'h1 == io_yPos ? 8'h18 : _GEN_728; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_730 = 7'h5b == index & 3'h2 == io_yPos ? 8'h18 : _GEN_729; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_731 = 7'h5b == index & 3'h3 == io_yPos ? 8'h18 : _GEN_730; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_732 = 7'h5b == index & 3'h4 == io_yPos ? 8'h0 : _GEN_731; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_733 = 7'h5b == index & 3'h5 == io_yPos ? 8'h18 : _GEN_732; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_734 = 7'h5b == index & 3'h6 == io_yPos ? 8'h18 : _GEN_733; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_735 = 7'h5b == index & 3'h7 == io_yPos ? 8'h18 : _GEN_734; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_736 = 7'h5c == index & 3'h0 == io_yPos ? 8'h0 : _GEN_735; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_737 = 7'h5c == index & 3'h1 == io_yPos ? 8'he : _GEN_736; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_738 = 7'h5c == index & 3'h2 == io_yPos ? 8'h18 : _GEN_737; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_739 = 7'h5c == index & 3'h3 == io_yPos ? 8'h18 : _GEN_738; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_740 = 7'h5c == index & 3'h4 == io_yPos ? 8'h30 : _GEN_739; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_741 = 7'h5c == index & 3'h5 == io_yPos ? 8'h18 : _GEN_740; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_742 = 7'h5c == index & 3'h6 == io_yPos ? 8'h18 : _GEN_741; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_743 = 7'h5c == index & 3'h7 == io_yPos ? 8'he : _GEN_742; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_744 = 7'h5d == index & 3'h0 == io_yPos ? 8'h0 : _GEN_743; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_745 = 7'h5d == index & 3'h1 == io_yPos ? 8'h0 : _GEN_744; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_746 = 7'h5d == index & 3'h2 == io_yPos ? 8'h0 : _GEN_745; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_747 = 7'h5d == index & 3'h3 == io_yPos ? 8'h5c : _GEN_746; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_748 = 7'h5d == index & 3'h4 == io_yPos ? 8'h36 : _GEN_747; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_749 = 7'h5d == index & 3'h5 == io_yPos ? 8'h0 : _GEN_748; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_750 = 7'h5d == index & 3'h6 == io_yPos ? 8'h0 : _GEN_749; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _GEN_751 = 7'h5d == index & 3'h7 == io_yPos ? 8'h0 : _GEN_750; // @[src/main/scala/VideoController/CharacterTable.scala 39:{29,29}]
  wire [7:0] _io_pixel_T = _GEN_751 >> io_xPos; // @[src/main/scala/VideoController/CharacterTable.scala 39:29]
  assign io_pixel = inRange & _io_pixel_T[0]; // @[src/main/scala/VideoController/CharacterTable.scala 39:23]
endmodule
module Terminal(
  input  [9:0] io_xPos, // @[src/main/scala/VideoController/Terminal.scala 17:14]
  input  [8:0] io_yPos, // @[src/main/scala/VideoController/Terminal.scala 17:14]
  output [1:0] io_red, // @[src/main/scala/VideoController/Terminal.scala 17:14]
  output [1:0] io_green, // @[src/main/scala/VideoController/Terminal.scala 17:14]
  output [1:0] io_blue // @[src/main/scala/VideoController/Terminal.scala 17:14]
);
  wire [6:0] characterTable_io_character; // @[src/main/scala/VideoController/Terminal.scala 33:30]
  wire [2:0] characterTable_io_xPos; // @[src/main/scala/VideoController/Terminal.scala 33:30]
  wire [2:0] characterTable_io_yPos; // @[src/main/scala/VideoController/Terminal.scala 33:30]
  wire  characterTable_io_pixel; // @[src/main/scala/VideoController/Terminal.scala 33:30]
  wire [6:0] xTilePos = io_xPos[9:3]; // @[src/main/scala/VideoController/Terminal.scala 25:25]
  wire [5:0] yTilePos = io_yPos[8:3]; // @[src/main/scala/VideoController/Terminal.scala 26:25]
  wire [12:0] _character_T = yTilePos * 7'h50; // @[src/main/scala/VideoController/Terminal.scala 31:25]
  wire [12:0] _GEN_3 = {{6'd0}, xTilePos}; // @[src/main/scala/VideoController/Terminal.scala 31:45]
  wire [12:0] _character_T_2 = _character_T + _GEN_3; // @[src/main/scala/VideoController/Terminal.scala 31:45]
  wire [7:0] character = _character_T_2[7:0]; // @[src/main/scala/VideoController/Terminal.scala 30:23 31:13]
  wire [1:0] _io_red_T_1 = {characterTable_io_pixel,characterTable_io_pixel}; // @[src/main/scala/VideoController/Terminal.scala 43:39]
  CharacterTable characterTable ( // @[src/main/scala/VideoController/Terminal.scala 33:30]
    .io_character(characterTable_io_character),
    .io_xPos(characterTable_io_xPos),
    .io_yPos(characterTable_io_yPos),
    .io_pixel(characterTable_io_pixel)
  );
  assign io_red = character[7] ? character[5:4] : _io_red_T_1; // @[src/main/scala/VideoController/Terminal.scala 38:23 39:12 43:12]
  assign io_green = character[7] ? character[3:2] : _io_red_T_1; // @[src/main/scala/VideoController/Terminal.scala 38:23 40:14 44:14]
  assign io_blue = character[7] ? character[1:0] : _io_red_T_1; // @[src/main/scala/VideoController/Terminal.scala 38:23 41:13 45:13]
  assign characterTable_io_character = character[6:0]; // @[src/main/scala/VideoController/Terminal.scala 34:31]
  assign characterTable_io_xPos = io_xPos[2:0]; // @[src/main/scala/VideoController/Terminal.scala 27:25]
  assign characterTable_io_yPos = io_yPos[2:0]; // @[src/main/scala/VideoController/Terminal.scala 28:25]
endmodule
module VideoController(
  input        clock,
  input        reset,
  output [1:0] io_red, // @[src/main/scala/VideoController/VideoController.scala 11:14]
  output [1:0] io_green, // @[src/main/scala/VideoController/VideoController.scala 11:14]
  output [1:0] io_blue, // @[src/main/scala/VideoController/VideoController.scala 11:14]
  output       io_hSync, // @[src/main/scala/VideoController/VideoController.scala 11:14]
  output       io_vSync // @[src/main/scala/VideoController/VideoController.scala 11:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  wire [9:0] terminal_io_xPos; // @[src/main/scala/VideoController/VideoController.scala 26:24]
  wire [8:0] terminal_io_yPos; // @[src/main/scala/VideoController/VideoController.scala 26:24]
  wire [1:0] terminal_io_red; // @[src/main/scala/VideoController/VideoController.scala 26:24]
  wire [1:0] terminal_io_green; // @[src/main/scala/VideoController/VideoController.scala 26:24]
  wire [1:0] terminal_io_blue; // @[src/main/scala/VideoController/VideoController.scala 26:24]
  reg [9:0] horizontal; // @[src/main/scala/VideoController/VideoController.scala 13:27]
  reg [9:0] vertical; // @[src/main/scala/VideoController/VideoController.scala 14:25]
  wire  newLine = horizontal >= 10'h31f; // @[src/main/scala/VideoController/VideoController.scala 16:28]
  wire  newFrame = vertical >= 10'h20b; // @[src/main/scala/VideoController/VideoController.scala 17:27]
  wire [9:0] _horizontal_T_1 = horizontal + 10'h1; // @[src/main/scala/VideoController/VideoController.scala 18:46]
  wire [9:0] _vertical_T_1 = vertical + 10'h1; // @[src/main/scala/VideoController/VideoController.scala 19:56]
  wire  videoActive = horizontal < 10'h280 & vertical < 10'h1e0; // @[src/main/scala/VideoController/VideoController.scala 24:64]
  reg  io_hSync_REG; // @[src/main/scala/VideoController/VideoController.scala 30:22]
  reg  io_vSync_REG; // @[src/main/scala/VideoController/VideoController.scala 31:22]
  reg [1:0] io_red_REG; // @[src/main/scala/VideoController/VideoController.scala 32:20]
  reg [1:0] io_green_REG; // @[src/main/scala/VideoController/VideoController.scala 33:22]
  reg [1:0] io_blue_REG; // @[src/main/scala/VideoController/VideoController.scala 34:21]
  Terminal terminal ( // @[src/main/scala/VideoController/VideoController.scala 26:24]
    .io_xPos(terminal_io_xPos),
    .io_yPos(terminal_io_yPos),
    .io_red(terminal_io_red),
    .io_green(terminal_io_green),
    .io_blue(terminal_io_blue)
  );
  assign io_red = io_red_REG; // @[src/main/scala/VideoController/VideoController.scala 32:10]
  assign io_green = io_green_REG; // @[src/main/scala/VideoController/VideoController.scala 33:12]
  assign io_blue = io_blue_REG; // @[src/main/scala/VideoController/VideoController.scala 34:11]
  assign io_hSync = io_hSync_REG; // @[src/main/scala/VideoController/VideoController.scala 30:12]
  assign io_vSync = io_vSync_REG; // @[src/main/scala/VideoController/VideoController.scala 31:12]
  assign terminal_io_xPos = horizontal; // @[src/main/scala/VideoController/VideoController.scala 27:20]
  assign terminal_io_yPos = vertical[8:0]; // @[src/main/scala/VideoController/VideoController.scala 28:20]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/VideoController/VideoController.scala 13:27]
      horizontal <= 10'h0; // @[src/main/scala/VideoController/VideoController.scala 13:27]
    end else if (newLine) begin // @[src/main/scala/VideoController/VideoController.scala 18:20]
      horizontal <= 10'h0;
    end else begin
      horizontal <= _horizontal_T_1;
    end
    if (reset) begin // @[src/main/scala/VideoController/VideoController.scala 14:25]
      vertical <= 10'h0; // @[src/main/scala/VideoController/VideoController.scala 14:25]
    end else if (newFrame) begin // @[src/main/scala/VideoController/VideoController.scala 19:18]
      vertical <= 10'h0;
    end else if (newLine) begin // @[src/main/scala/VideoController/VideoController.scala 19:37]
      vertical <= _vertical_T_1;
    end
    io_hSync_REG <= horizontal < 10'h290 | horizontal > 10'h2f0; // @[src/main/scala/VideoController/VideoController.scala 21:89]
    io_vSync_REG <= vertical < 10'h1eb | vertical > 10'h1ed; // @[src/main/scala/VideoController/VideoController.scala 22:87]
    if (videoActive) begin // @[src/main/scala/VideoController/VideoController.scala 32:24]
      io_red_REG <= terminal_io_red;
    end else begin
      io_red_REG <= 2'h0;
    end
    if (videoActive) begin // @[src/main/scala/VideoController/VideoController.scala 33:26]
      io_green_REG <= terminal_io_green;
    end else begin
      io_green_REG <= 2'h0;
    end
    if (videoActive) begin // @[src/main/scala/VideoController/VideoController.scala 34:25]
      io_blue_REG <= terminal_io_blue;
    end else begin
      io_blue_REG <= 2'h0;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  horizontal = _RAND_0[9:0];
  _RAND_1 = {1{`RANDOM}};
  vertical = _RAND_1[9:0];
  _RAND_2 = {1{`RANDOM}};
  io_hSync_REG = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  io_vSync_REG = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  io_red_REG = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  io_green_REG = _RAND_5[1:0];
  _RAND_6 = {1{`RANDOM}};
  io_blue_REG = _RAND_6[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CaravelTop(
  input         clock,
  input         reset,
  input  [27:0] wb_addr, // @[src/main/scala/CaravelTop.scala 21:14]
  input  [31:0] wb_wrData, // @[src/main/scala/CaravelTop.scala 21:14]
  output [31:0] wb_rdData, // @[src/main/scala/CaravelTop.scala 21:14]
  input         wb_we, // @[src/main/scala/CaravelTop.scala 21:14]
  input  [3:0]  wb_sel, // @[src/main/scala/CaravelTop.scala 21:14]
  input         wb_stb, // @[src/main/scala/CaravelTop.scala 21:14]
  output        wb_ack, // @[src/main/scala/CaravelTop.scala 21:14]
  input         wb_cyc, // @[src/main/scala/CaravelTop.scala 21:14]
  input  [37:0] io_in, // @[src/main/scala/CaravelTop.scala 22:14]
  output [37:0] io_out, // @[src/main/scala/CaravelTop.scala 22:14]
  output [37:0] io_oeb // @[src/main/scala/CaravelTop.scala 22:14]
);
  wire  wc_clock; // @[src/main/scala/CaravelTop.scala 28:18]
  wire  wc_reset; // @[src/main/scala/CaravelTop.scala 28:18]
  wire [15:0] wc_io_led; // @[src/main/scala/CaravelTop.scala 28:18]
  wire  gcd_clock; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  gcd_reset; // @[src/main/scala/CaravelTop.scala 44:19]
  wire [2:0] gcd_wb_addr; // @[src/main/scala/CaravelTop.scala 44:19]
  wire [31:0] gcd_wb_wrData; // @[src/main/scala/CaravelTop.scala 44:19]
  wire [31:0] gcd_wb_rdData; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  gcd_wb_we; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  gcd_wb_stb; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  gcd_wb_ack; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  gcd_wb_cyc; // @[src/main/scala/CaravelTop.scala 44:19]
  wire  vc_clock; // @[src/main/scala/CaravelTop.scala 48:18]
  wire  vc_reset; // @[src/main/scala/CaravelTop.scala 48:18]
  wire [1:0] vc_io_red; // @[src/main/scala/CaravelTop.scala 48:18]
  wire [1:0] vc_io_green; // @[src/main/scala/CaravelTop.scala 48:18]
  wire [1:0] vc_io_blue; // @[src/main/scala/CaravelTop.scala 48:18]
  wire  vc_io_hSync; // @[src/main/scala/CaravelTop.scala 48:18]
  wire  vc_io_vSync; // @[src/main/scala/CaravelTop.scala 48:18]
  wire [23:0] _io_out_T_5 = {wc_io_led,vc_io_hSync,vc_io_vSync,vc_io_red,vc_io_green,vc_io_blue}; // @[src/main/scala/CaravelTop.scala 49:75]
  wire  _GEN_0 = 8'h1 == wb_addr[27:20] & wb_cyc; // @[src/main/scala/CaravelTop.scala 46:14 55:57 60:18]
  wire  _GEN_1 = gcd_wb_ack; // @[src/main/scala/CaravelTop.scala 45:10 55:57 61:14]
  wire [31:0] _GEN_2 = gcd_wb_rdData; // @[src/main/scala/CaravelTop.scala 45:10 55:57 62:17]
  CpuTop wc ( // @[src/main/scala/CaravelTop.scala 28:18]
    .clock(wc_clock),
    .reset(wc_reset),
    .io_led(wc_io_led)
  );
  WishboneGcd gcd ( // @[src/main/scala/CaravelTop.scala 44:19]
    .clock(gcd_clock),
    .reset(gcd_reset),
    .wb_addr(gcd_wb_addr),
    .wb_wrData(gcd_wb_wrData),
    .wb_rdData(gcd_wb_rdData),
    .wb_we(gcd_wb_we),
    .wb_stb(gcd_wb_stb),
    .wb_ack(gcd_wb_ack),
    .wb_cyc(gcd_wb_cyc)
  );
  VideoController vc ( // @[src/main/scala/CaravelTop.scala 48:18]
    .clock(vc_clock),
    .reset(vc_reset),
    .io_red(vc_io_red),
    .io_green(vc_io_green),
    .io_blue(vc_io_blue),
    .io_hSync(vc_io_hSync),
    .io_vSync(vc_io_vSync)
  );
  assign wb_rdData = 8'h0 == wb_addr[27:20] ? gcd_wb_rdData : _GEN_2; // @[src/main/scala/CaravelTop.scala 45:10 55:57]
  assign wb_ack = 8'h0 == wb_addr[27:20] ? gcd_wb_ack : _GEN_1; // @[src/main/scala/CaravelTop.scala 45:10 55:57]
  assign io_out = {{14'd0}, _io_out_T_5}; // @[src/main/scala/CaravelTop.scala 49:10]
  assign io_oeb = 38'h0; // @[src/main/scala/CaravelTop.scala 50:10]
  assign wc_clock = clock;
  assign wc_reset = reset;
  assign gcd_clock = clock;
  assign gcd_reset = reset;
  assign gcd_wb_addr = wb_addr[2:0]; // @[src/main/scala/CaravelTop.scala 45:10]
  assign gcd_wb_wrData = wb_wrData; // @[src/main/scala/CaravelTop.scala 45:10]
  assign gcd_wb_we = wb_we; // @[src/main/scala/CaravelTop.scala 45:10]
  assign gcd_wb_stb = wb_stb; // @[src/main/scala/CaravelTop.scala 45:10]
  assign gcd_wb_cyc = 8'h0 == wb_addr[27:20] ? 1'h0 : _GEN_0; // @[src/main/scala/CaravelTop.scala 46:14 55:57]
  assign vc_clock = clock;
  assign vc_reset = reset;
endmodule
