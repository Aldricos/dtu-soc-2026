# Render a 2x2 frame in MMIO drain mode, OR the 4 pixels together,
# beacon back to caravel: 0xCAFE_<count><accum>

    .text
    .globl _start
_start:
    li      s0, 0xf0050000        # raytracer base
    li      s1, 0xf0030000        # caravel comm register

    # drain mode = MMIO
    li      t0, 1
    sw      t0, 16(s0)            # 0x0010

    # cols = 2, rows = 2
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

    # wait for busy == 0
wait_busy:
    lw      t1, 4(s0)             # 0x0004
    bnez    t1, wait_busy

    # drain up to 4 pixels into s3 (OR-accum), count in s4
    li      s2, 4                 # remaining
    li      s3, 0                 # accumulator
    li      s4, 0                 # count drained
drain:
    # poll non-empty
poll_ne:
    lw      t1, 8(s0)             # 0x0008
    beqz    t1, poll_ne
    # read pixel
    lw      t1, 12(s0)            # 0x000C
    andi    t1, t1, 0xff
    or      s3, s3, t1
    addi    s4, s4, 1
    addi    s2, s2, -1
    bnez    s2, drain

    # pack result: 0xCAFE0000 | (count << 8) | accum
    li      t0, 0xCAFE0000
    slli    t1, s4, 8
    or      t0, t0, t1
    or      t0, t0, s3

    # send to Caravel
    sw      t0, 0(s1)

hang:
    j       hang
