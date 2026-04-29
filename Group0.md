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
TBD
