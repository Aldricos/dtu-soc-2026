module BindsTo_2_ScratchPadMem(
  input         clock,
  input  [31:0] io_address, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input         io_wr, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  output [31:0] io_rdData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [31:0] io_wrData, // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
  input  [3:0]  io_wrMask // @[wildcat/src/main/scala/wildcat/pipeline/ScratchPadMem.scala 13:14]
);

initial begin
  $readmemh("data2.hex", ScratchPadMem.MEM_2);
end
                      endmodule

bind ScratchPadMem BindsTo_2_ScratchPadMem BindsTo_2_ScratchPadMem_Inst(.*);