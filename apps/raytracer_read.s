# Read the three readable controller regs at reset, expect all 0.
# Beacon 0xCAFE0001 on success, hang on fail.

    .text
    .globl _start
_start:
    li      s0, 0xf0050000        # raytracer base
    li      s1, 0xf0030000        # caravel comm register

    lw      t0, 4(s0)             # busy
    bnez    t0, fail
    lw      t0, 8(s0)             # notEmpty
    bnez    t0, fail
    lw      t0, 16(s0)            # drainMode
    bnez    t0, fail

    li      t0, 0xCAFE0001
    sw      t0, 0(s1)
hang:
    j       hang

fail:
hang_fail:
    j       hang_fail
