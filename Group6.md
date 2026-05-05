# Group 6: Wishbone instruction memory
**Course:** 02118 - Introduction to Chip Design (DTU)\
**Group members:** Tore Kofod Beyer (s234377)

The purpose of this project is to design a programmable instruction memory for the wildcat CPU. We achieve this using a 1kB 1RW/1R 32×256 OpenRAM memory macro, and program it using the Wishbone communication bus.

![width:500px](figures/group6/InstMem_block_diagram.svg)

The basic idea is that the RISC‑V CPU pre-built in the Caravel project connects through Wishbone to the user project space. The Wishbone bus is then passed through to the CPUTop block, where our WildCat CPU is instantiated and where the instruction memory is placed.

We can then connect the memory to the CPU using the PipeCon bundle.
## Design
### Memory macro
The design is built around a single 1kB OpenRAM macro, with one read/write port for the Wishbone connection and one read port for the CPU connection.

To instantiate the module, we do:
```scala
val ram = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())
```
And also add it to the config.json file:
```json
{
  "MACROS": {
    "sky130_sram_1kbyte_1rw1r_32x256_8": {
      "instances": {
        "wc.imem.ram": {
          "location": [
            100,
            150
          ],
          "orientation": "N"
        },
        "gds": [
          "pdk_dir::libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds"
        ],
        "lef": [
          "pdk_dir::libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"
        ],
        "nl": [
          "pdk_dir::libs.ref/sky130_sram_macros/verilog/sky130_sram_1kbyte_1rw1r_32x256_8.v"
        ],
        "lib": {
          "*": [
            "ref::$DESIGN_DIR/../../libs/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C_modified.lib"
          ]
        }
      }
    }
  }
}
```
Then add the power connections:
```json
{
  "PDN_MACRO_CONNECTIONS": [
    "wc.imem.ram vccd1 vssd1 vccd1 vssd1"
  ]
}
```
### Wishbone
For the Wishbone connections, we first need to connect the Wishbone bus in the `CaraveluserProject` module. To do this, we connect the Wishbone bus signals`cyc`, `ack` and `rdData` to the instruction memory module if the decoded part of the Wishbone address (`wb.addr(27, 20)`) matches the correct value, `2.U` in our case.
```scala 
    is(0x2.U) {
      wc.io.wb.cyc := wb.cyc
      wb.ack := wc.io.wb.ack
      wb.rdData := wc.io.wb.rdData
    }
```
Inside the instruction memory module, we know there is an active Wishbone transaction when `cyc` and `stb` are high. It is a write transaction if `we` is high, otherwise, it is a read transaction
```scala
val wbActive = io.wb.cyc && io.wb.stb
ram.io.csb0   := !(wbActive)
ram.io.web0   := !(io.wb.we && wbActive)
ram.io.addr0  := io.wb.addr(9, 2)
ram.io.din0   := io.wb.wrData
ram.io.wmask0 := io.wb.sel
```
Then we register the acknowledge signal because we need a synchronous setup. This is because the RAM is synchronous and loads the data on the next clock cycle.
```scala
val wbAck  = RegNext(wbActive, false.B)
io.wb.ack := wbAck
```
The data is not registered because there are output data registers within the OpenRAM module.
```scala
io.wb.rdData := ram.io.dout0
```

[The final design](src/main/scala/WishboneInstrRam.scala)

### CPU side
The CPU connections are a little simpler because we only need a read transaction.

Here we ensure that the chip select is disabled when the CPU is in reset:
```scala
ram.io.csb1  := !(io.cpu.rd && !io.reset)  // Active low chip select
ram.io.addr1 := io.cpu.address(9, 2) // 8-bit address for 1KB RAM
```
Again, we register the acknowledge signal:
```scala
val cpuAck  = RegInit(false.B)
cpuAck  := io.cpu.rd && !io.reset
```
We then use the data from the second data output port.
```scala 
io.cpu.rdData := ram.io.dout1
io.cpu.ack := cpuAck
```

## How to test

Two cocotb tests were created.

### Write and read test
The first test writes data to the memory module over Wishbone and reads it back over Wishbone to verify correctness. This ensures that the Wishbone interface is implemented correctly before testing the CPU connection.

[Write and read test](verilog/dv/cocotb/user_proj_tests/wb_inst_mem_test/wb_inst_mem_test.c)

### Testing to boot a program
The second test verifies that the WildCat CPU reads from the instruction memory correctly by loading a program over Wishbone and observing the output of the CPU, in this case a blinking LED.

[Boot test](verilog/dv/cocotb/user_proj_tests/wildcat_blink_test/wildcat_blink_test.c)

## Size
- 2 DFFs
- 3 AND gates
- 4 NOT gates
- 400 um x 500 um memory macro

