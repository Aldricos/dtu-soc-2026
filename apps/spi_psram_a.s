.section .text
.global _start

_start:
    # Load the address for PSRAM A (0x5000_0000) into register x2
    lui x2, 0x50000

loop:
    lw x3, 0(x2)

    # Jump back and read again
    j loop