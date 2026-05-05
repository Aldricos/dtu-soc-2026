# Group 0
___
### SPI
Add a memory controller module between CPU and
external memory, and use a handshake so the
CPU can wait for slower memory.

1. Add handshake support to Wildcat data memory interface
2. Decode address inside `WildcatTop`
3. Create an "Off-Chip Memory Controller" module
4. Start with a fake SPI backend initially
5. Add the SPI FSM (finite state-machine)

##### SPI I/O connections
- SCLK is an output 
- MOSI is an output
- CS is an output
- MISO is an input

Where
- `oeb = 0` for `SCLK`, `MOSI`, `CS`
- `oeb = 1` for `MISO`

This means that 4 pads should be reserved for the memory control
___
## Data Cache

The cache is a simple data cache placed between the processor and the external/backing memory connected via SPI. 
The cache is intended to reduce repeated memory accesses for recently read data while keeping the implementation small and easy to verify.

### Cache Organization

The cache is implemented as a direct-mapped cache with 256 entries. Each entry stores one 32-bit word.

CPU addresses in the cached memory region use the range:

```text
0xe000_0000 - 0xefff_ffff
```

Internally, the cache strips the upper memory-map nibble and uses the lower 28 bits as the local address:
```text
localAddr = cpuAddr[27:0]
```

The address is divided as follows:
```text
offset = localAddr[1:0]
index  = localAddr[9:2]
tag    = localAddr[27:10]
```

Each cache entry has associated metadata containing a valid bit and a tag. 
A cache hit occurs when the selected entry is valid and its stored tag matches the requested tag.

### SRAM Port Usage

The data and metadata memories are implemented using 1RW1R SRAM macros.  
However, the cache only uses port0 for both reads and writes. The read-only port, port1, is not used; it is disabled and its address is tied to zero.

This simplifies the routing and avoids using the extra read-only SRAM port. All metadata reads, data reads, cache fills, and cache updates are therefore performed through port0.


### Cache Policy
The cache uses the following policy:
```text
Read policy:        read-allocate
Write policy:       write-through
Write miss policy:  no-write-allocate
Replacement:        direct-mapped replacement
Line size:          one 32-bit word
```
On a read hit, the cache returns the stored word directly. 
On a read miss, the word is fetched from backing memory, written into the cache, and returned to the CPU.

On a write hit, the cache writes the value to backing memory and updates the cached copy. 
On a write miss, the cache writes the value to backing memory but does not allocate a cache entry. 
This keeps backing memory consistent while avoiding cache pollution from write-only data.

Byte-masked writes are supported. 
The selected bytes are updated in backing memory, and if the write hits in the cache, the cached word is updated with the same mask.

### Physical Implementation
The `DataCache` module was hardened as a standalone macro using OpenLane.

![DataCache hardened layout](figures/Cache_Layout.png)

The hardened macro has a die size of 700 µm × 1100 µm, and a reported utilization of 53.8%.

### Testing
#### Software Test
The cache is tested using Chisel tests with a software backing-memory model. The tests verify the main cache-policy behavior:

| Test                  | Purpose                                                                                        |
| --------------------- | ---------------------------------------------------------------------------------------------- |
| Read miss fills cache | Verifies that a first read fetches from backing memory and later reads return the cached value |
| Write-through update  | Verifies that CPU writes are forwarded to backing memory                                       |
| Byte-mask write       | Verifies that masked writes update only selected bytes in backing memory                       |
| Different indices     | Verifies that different cache indices can hold independent cached words                        |
| Conflict replacement  | Verifies that two addresses with the same index but different tags replace each other          |
| Repeated cached reads | Verifies that repeated reads to a cached word return the cached value                          |
| Write hit update      | Verifies that a write hit updates both backing memory and the cached copy                      |

#### Hardware Test (FPGA)
The cache was also tested on the FPGA using a UART-based debug interface.
The PC sends 64-bit debug commands over UART in the format:
```text
w<32-bit address><32-bit data>
```
These commands are used to hold the CPU in reset, load a small RISC-V test program into instruction memory, and then release reset so the CPU executes the program.

The CPU reports test results by writing to the communication MMIO address:
```text
0xf003_0000
```

The FPGA debug wrapper latches the first two 32-bit values written by the CPU and returns them over UART when the PC sends:
```text
r
```

The hardware tests verify that the cache works in the complete FPGA system, including the processor, cache, SPI-backed memory path, instruction loading, and debug readback.

| Test                       | Purpose                                                                                        | Expected UART result                |
| -------------------------- | ---------------------------------------------------------------------------------------------- | ----------------------------------- |
| Single address cached read | Fills one cache line, writes `0xdeadbeef`, then performs two reads through the cache           | `deadbeefdeadbeef`                  |
| Multiple address loop      | Writes and verifies several consecutive cached addresses                                       | `cace000100000000`                  |
| Conflict replacement       | Accesses `0xe000_0000` and `0xe000_0400`, which map to the same cache index but different tags | `cace0002ffffffff`                  |
| VGA cache output           | Reads character values through the cache and writes them to the VGA character buffer           | Expected characters shown on screen |

The UART tests are automated using a small Python script (`fpga_bootloader/FpgaUart.py`). The script reads a text file containing one debug command per line, sends each command over the serial port, and finally enters a loop where it repeatedly sends `r` to read back the latest latched test result. Small character and line delays are used to avoid dropping commands during UART transmission.

A typical command file first writes `1` to the reset/control register, then writes the test program into instruction memory, and finally writes `0` to the reset/control register to start the CPU:

```text
w0040000000000001   # hold CPU in reset
w00200000...        # program instruction memory
...
w0040000000000000   # release CPU reset
```