# Group 5: QSPI PMOD Memory Controller

**Course:** 02118 - Introduction to Chip Design (DTU)  
**Target:** SkyWater 130nm ASIC Tapeout via Efabless/ChipFoundry (Caravel Framework)

## 1. Introduction
As part of the SoC design project, Group 5 was tasked with expanding the memory capabilities of 
the **Wildcat RISC-V CPU**. We designed a custom **SPI Memory Controller** to bridge the internal 
CPU bus to an external QSPI PMOD board.

The external board features:
* **1x 16MB Winbond W25Q128JV Flash** (Non-volatile storage)
* **2x 8MB APMemory APS6404L-3SQR PSRAMs** (Volatile working memory)

Our hardware controller successfully translates 32-bit parallel memory requests into 1-bit serial 
SPI transactions, managing chip selects, clock generation, and the timing requirements of Flash memory 
making the external chips behave exactly like internal RAM to the CPU.

---

## 2. System Architecture & Design

Our controller uses the 10MHz system clock and acts as a bridge between the internal **PipeCon** bus 
(used by the Wildcat CPU) and the external **SPI** interface.

### The "Single-Block" FSM
The core of our design is a Single-Block Finite State Machine (FSM) written in **Chisel**. 
Every output signal (`SCK`, `MOSI`, `CS_n`) is driven directly by a register (D-Flip-Flop) rather 
than combinational logic.

### Internal FSM States
The controller executes transactions using a 4-state machine:

1. **`sIdle` (Standby & Decoding):**
    * Waits for a `rd` (read) or `wr` (write) signal from the PipeCon bus.
    * Intercepts the 32-bit CPU address and forces it to be word-aligned.
    * Decodes the target chip (Flash, PSRAM A, or PSRAM B) and pulls the corresponding `CS_n` pin LOW.
    * Pre-loads the 72-bit `shiftReg` with the correct SPI command, address, and data payload, then transitions to `sDoTransfer`.
2. **`sDoTransfer` (The Shifting Engine):**
    * Acts as a bidirectional SerDes (Serializer/Deserializer).
    * Generates the SPI clock (`SCK`).
    * On the **falling edge** of `SCK`, it shifts the next bit out to the `MOSI` pin and decrements the `bitsToTransfer` counter.
    * On the **rising edge** of `SCK`, it samples the incoming `MISO` pin and accumulates the payload into the `readData` register.
3. **`sCsToggle` (Flash Multi-Transaction Handler):**
    * Used specifically for Flash Erase (`0x20`) and Write (`0x02`) commands, which legally require a Write Enable (`0x06`) command to be sent first.
    * This state automatically pulls `CS_n` HIGH for ~200ns to satisfy the Flash memory's `tSHSL` (CS Deselect Time) constraint, locking in the `0x06` command.
    * It then pulls `CS_n` LOW again, pre-loads the actual Erase/Write payload into the shift register, and jumps back to `sDoTransfer`.
4. **`sDone` (Acknowledge):**
    * Pulls all `CS_n` pins HIGH to put the memory chips back to sleep.
    * Asserts the `ack` signal to the CPU and presents the assembled 32-bit `rdData` payload.
    * Instantly returns to `sIdle` for the next transaction.

### Fast Read Support
Our controller implements the **`0x0B` Fast Read** command. For every read transaction, the hardware a
utomatically shifts out the 8-bit command, the 24-bit address, and exactly 8 "Dummy Cycles" to give 
the memory chips time to fetch the data before sampling the `MISO` line for the 32-bit payload.


## 3. How the Controller Works (Hardware Abstraction)

### Word-Aligned Addressing
The RISC-V architecture issues 32-bit word-aligned memory requests, but the external memory chips 
are byte-addressable. To prevent the CPU from fetching misaligned bytes, our controller intercepts the 
incoming PipeCon address, forcibly strips the bottom two bits (replacing them with `00`), and drops the 
top 8 bits to form a pure 24-bit physical SPI address.

### The Flash Translation Layer ("Magic Addresses")
Flash memory is notoriously difficult to write to. It requires a Write Enable command (`0x06`), 
a 4KB Sector Erase command (`0x20`) which takes ~45ms, and polling a Status Register (`0x05`) to know 
when it is finished.

To prevent writing a massively complex and slow hardware FSM to handle this, we implemented
a **Hardware Flash Translation Layer** using Memory-Mapped I/O (MMIO). We split the `0x4000_0000` 
address space into "Magic Addresses." When the software writes to a specific address, our hardware 
automatically injects the correct SPI prefixes.

| CPU Address Range | Target Chip | Hardware Action Executed by Controller |
| :--- | :--- | :--- |
| `0x40xx_xxxx` | **Flash (W25Q128)** | Standard Fast Read (`0x0B`) & Page Program (`0x02`) |
| `0x41xx_xxxx` | **Flash (W25Q128)** | **Magic Erase:** Sends `WREN` (0x06) + `Sector Erase` (0x20) |
| `0x42xx_xxxx` | **Flash (W25Q128)** | **Magic Status:** Sends `Read Status` (0x05) to poll the BUSY bit |
| `0x43xx_xxxx` | **Flash (W25Q128)** | **Magic Unlock:** Writes `0x00` to clear Block Protect bits (0x01) |
| `0x50xx_xxxx` | **PSRAM A (APS6404L)** | Standard Fast Read (`0x0B`) & Write (`0x02`) |
| `0x60xx_xxxx` | **PSRAM B (APS6404L)** | Standard Fast Read (`0x0B`) & Write (`0x02`) |

---

## 4. SoC Integration

The controller is instantiated inside `CpuTop.scala` alongside the Wildcat CPU.

An internal address multiplexer (the Bus Interconnect) checks the top 4 bits of the CPU's 
memory request. If the address starts with `0x4`, `0x5`, or `0x6`, the interconnect routes the `PipeCon` 
signals exclusively to our SPI controller, bypassing the internal Data Cache entirely.

The physical SPI signals are routed up to `CaravelUserProject.scala`, where they are mapped to 
the Caravel boundary pads `uio[21:16]`.

---

## 5. How to Test

### FPGA Prototyping (Pre-Silicon Validation)
Before migrating to Chisel, the state machine was written in SystemVerilog and 
stress-tested on an **Artix-7 100T FPGA** (Nexys A7). We built a custom 100MHz automated 
tester (`fpga_tester_top.sv`) that ran millions of back-to-back Read/Write/Verify transactions 
against the physical PMOD board. This validated our SPI timing, clock division logic, and handling of 
physical signal integrity limits (EMI) on PMOD jumpers.

### Full-Chip Cocotb Simulation
We built a suite of standalone Python/C testbenches to verify the controller within 
the Caravel SoC environment.

**Running the tests:**
```bash
cf verify test_flash_read
cf verify test_flash_page_prog
cf verify test_flash_sec_erase
cf verify test_psram_a
cf verify test_psram_b
```

---

## 6. Physical Design Results (Area and Timing)

The design was hardened into a physical GDSII macro using the **LibreLane** ASIC flow.
