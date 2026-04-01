## Integrate Wildcat in Caravel
Import the 3-stage wildcat using
```scala
    import wildcat.pipeline._
```
in `CaravelUserProject`

Compile binary (example "Blink"):
```bash
    make -C wildcat/ app APP=asm/apps/blink.s
```

A binary file will be created
```txt
    "wildcat/a.out"
```

Initiate the wildcat as a module and make the relevant I/O connections. Ex
```Scala
val wc = Module(new WildcatTop("wildcat/a.out"))
val led = wc.io.led
val tx = wc.io.tx
wc.io.rx := false.B //Tentative
```

Run the CaravelUserProject
```shell
sbt "runMain CaravelUserProject"
```


## Project Idea
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
### Cache
Data focused cache, which enables extra memory, 
and fetching from SPI-based off-chip memory 
if it is a miss (refilling the cache)

Small cache FSM:
- `idle`
- `miss`
- `refill`

In `idle`:
- if request is a hit, serve immediately
- if miss, latch request and start memory fetch

In `missWait`:
- hold CPU stalled
- wait for off-chip controller

When refill completes:
- update cache arrays
- provide `rdData`
- return to `idle`

## Makefile
added:
```make
##### INTEGRATING WILDCAT MAKEFILE #####
UNAME := $(shell uname)
ifeq ($(UNAME),Darwin)
# assuming tools are installed with Mac Homebrew
export CROSS=riscv64-elf-
else
export CROSS=riscv64-unknown-elf-
endif
APP=apps/blink.s

chisel-generate:
	$(CROSS)as -march rv32ia_zicsr $(APP) -o a.o
	$(CROSS)ld -m elf32lriscv -T wildcat/link.ld a.o -o a.out
	sbt "runMain CaravelUserProject"

chisel-test:
	sbt test
```

for the wildcat integration, to compile assembly files

