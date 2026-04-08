module BindsTo_3_ScratchPadMem(
  input         clock,
  input  [31:0] io_address, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input         io_wr, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  output [31:0] io_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [31:0] io_wrData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [3:0]  io_wrMask // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
);

initial begin
  $readmemh("data3.hex", ScratchPadMem.MEM_3);
end
                      endmodule

bind ScratchPadMem BindsTo_3_ScratchPadMem BindsTo_3_ScratchPadMem_Inst(.*);