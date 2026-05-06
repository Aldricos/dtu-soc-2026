# Group 3: Booting From Wishbone

In this project, we developed an additional instruction memory (RAM) and designed
the means to switch between two different memories for instructions.

![Block diagram of the boot-from-Wishbone design](figures/group3/BlockDiagram.svg)

By using this design, we can program the Wildcat in the user project through the
Caravel management core. This can be done in two ways:

1. Write a program for the Caravel management core, stored in the flash within
   Caravel, and use it to program the Wildcat core.
2. Drive the UART connection from Caravel, then use the management core to read
   from UART and write to the Wildcat instruction memory.

## Design Details

Three components were designed to make the previous booting scenarios possible.

### 1. Programmable_IMEM

`Programmable_IMEM` is the instruction RAM used to boot the Wildcat. As seen in
the design picture, it has one interface connected to Wishbone so it can be
written from the management core. It also has another interface, named `PipeCon`,
to communicate with Wildcat.

Inside this module, a 1 KB OpenRAM memory module is used. The memory has one
read/write port for Wishbone and one read port for the interface with the
Wildcat CPU.

Instantiation of the memory module is shown below:

```scala
val mem = Module(new sky130_sram_1kbyte_1rw1r_32x256_8())
```

Later, the macro placement and voltage pins of the memory are implemented in
`openlane/CaravelUserProject/config.json`:

```json
"wc.imem_2.mem": {
  "location": [
    1100,
    150
  ],
  "orientation": "N"
}
```

```text
"wc.imem_2.mem vccd1 vssd1 vccd1 vssd1",
```

To connect this memory to Wishbone, an additional Wishbone interface is added to
the `CpuTop` module under the name `wb_2`:

```scala
val wb_2 = Flipped(new WishboneIO(32))
```

This Wishbone interface is connected to a switch inside
`CaravelUserProject.scala` as shown below:

```scala
is(0x3.U) {
  wc.io.wb_2.cyc := wb.cyc
  wb.ack := wc.io.wb_2.ack
  wb.rdData := wc.io.wb_2.rdData
}
```

### 2. comm_controller

We needed a module to drive the reset of the Wildcat after the programming of
IMEM is finished, ensuring that the booting process runs smoothly. To do so, we
designed a module called `comm_controller`.

This module has a Wishbone interface to connect to the management core. Within
the module, there is a 32-bit register with an initial value of `0`. The LSB of
this register is used as a reset for Wildcat, and the first bit of this register
is used for the multiplexer explained later.

### 3. IMEM_mux

To select between the two instruction memories, a multiplexer was designed. This
multiplexer has two `PipeCon` inputs and one `PipeCon` output. The two inputs are
connected to the `PipeCon` interfaces of the two instruction RAMs, and the output
is connected to the CPU.

The select signal of this multiplexer is connected to `comm_controller`. With
this design, the user can choose between the two instruction RAMs. If one RAM has
an issue in the layout process, the other one can still be used.

## How to Use

To use this instruction RAM, add two defines in the C file of your test:

```c
#define IMEM_ADDR  (0x300000 >> 2)
#define RESET_ADDR (0x400000 >> 2)
```

To use the Caravel management core, include the provided APIs:

```c
#include <firmware_apis.h>
```

To enable Wishbone communication between the management core and
`User_Project_Wrapper`, call this function before any data transfer:

```c
User_enableIF();
```

At the start of the booting process, the Wildcat reset should be driven high.
Also, based on which RAM you want to use, write the second bit of the
`comm_controller` to either `1` or `0`.

Writing to these addresses is possible with the function below:

```c
USER_writeWord(3, RESET_ADDR);
```

Afterwards, write your program to the instruction RAM with a `for` loop similar
to this:

```c
for (i = 0; i < 6; i++) {
  USER_writeWord(boot_program[i], IMEM_ADDR + i);
}
```

After finishing the write, drive the Wildcat reset low. The booting process is
then finished.

## Test

To test the booting process, the Wildcat blinking program was used. See the test
at this path:

```text
verilog/dv/cocotb/user_proj_tests/imem_2_boot
```

Furthermore, a UART boot program is also tested with this system. We used the
UART in Caravel and drove it in simulation with Cocotb to test the booting
process.

The code for this test can be seen in the repository below:

```text
verilog/dv/cocotb/user_proj_tests/imem_uart_boot
```

## Area

The reported area unit is `um^2`.

### 1. Programmable_IMEM

Area: `81.3280 um^2` of standard-cell logic, plus one `400 x 500 um` SRAM macro.

Cell count: 8 cells total.

Cells used:

- `2 x sky130_fd_sc_hd__dfxtp_2`: positive-edge D flip-flops. These store the
  local control state, such as the acknowledge signal.
- `2 x sky130_fd_sc_hd__nand2_2`: 2-input NAND gates used in the control logic.
- `1 x sky130_fd_sc_hd__and3b_2`: 3-input AND gate with one inverted input, used
  to combine control conditions compactly.
- `1 x sky130_fd_sc_hd__and4bb_2`: 4-input AND gate with two inverted inputs,
  also used in control decoding.
- `1 x sky130_fd_sc_hd__inv_2`: inverter, used to flip a Boolean control signal.
- `1 x sky130_sram_1kbyte_1rw1r_32x256_8`: the 1 KB OpenRAM macro itself,
  providing one read/write port and one read port.

### 2. comm_controller

Area: `1328.7744 um^2`.

Cell count: 100 cells total.

Cells used:

- `33 x sky130_fd_sc_hd__dfxtp_2`: positive-edge D flip-flops. These implement
  the 32-bit control register plus the acknowledge register.
- `32 x sky130_fd_sc_hd__a31o_2`: complex AND-OR gates. These combine several
  conditions into one expression efficiently.
- `32 x sky130_fd_sc_hd__o211a_2`: complex OR-AND gates. These are also used for
  compact control and register update logic.
- `1 x sky130_fd_sc_hd__and4bb_2`: 4-input AND gate with two inverted inputs,
  used in address or write-condition decoding.
- `1 x sky130_fd_sc_hd__inv_2`: inverter.
- `1 x sky130_fd_sc_hd__nand3_2`: 3-input NAND gate.

### 3. IMEM_mux

Area: `375.3600 um^2`.

Cell count: 34 cells total.

Cells used:

- `33 x sky130_fd_sc_hd__mux2_1`: 2-to-1 multiplexers. These select whether the
  CPU sees signals from instruction memory 0 or instruction memory 1.
- `1 x sky130_fd_sc_hd__inv_2`: inverter, used to generate the opposite of the
  select signal so one memory is enabled while the other is disabled.
