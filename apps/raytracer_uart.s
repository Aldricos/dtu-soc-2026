# Render a 2x2 frame in UART drain mode (rayTx pin, 115200 baud).
# Beacon caravel after start so the tb starts watching the pin.

    .text
    .globl _start
_start:
    li      s0, 0xf0050000        # raytracer base
    li      s1, 0xf0030000        # caravel comm register

    # drain mode = UART
    sw      x0, 16(s0)            # 0x0010

    # cols = 2, rows = 2 (4 bytes total)
    li      t0, 2
    li      t1, 0x1018
    add     t1, t1, s0
    sw      t0, 0(t1)
    li      t1, 0x101C
    add     t1, t1, s0
    sw      t0, 0(t1)

    # pulse start
    li      t0, 1
    sw      t0, 0(s0)             # 0x0000

    # tell caravel "rendering started, watch rayTx now"
    li      t0, 0xCAFE0001
    sw      t0, 0(s1)

hang:
    j       hang
