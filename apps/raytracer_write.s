# Hit every writable controller register so any broken write path stalls
# the cpu and times out the test. Drain mode also gets a 0->1->0 readback.
# No `start` pulse -- that's the integration test's job. Beacon on success.

    .text
    .globl _start
_start:
    li      s0, 0xf0050000        # raytracer base
    li      s1, 0xf0030000        # caravel comm register

    # ---- drainMode roundtrip ----
    li      t0, 1
    sw      t0, 16(s0)            # drainMode = 1
    lw      t1, 16(s0)
    bne     t0, t1, fail

    li      t0, 0
    sw      t0, 16(s0)            # drainMode = 0
    lw      t1, 16(s0)
    bne     t0, t1, fail

    # ---- write-only registers: all share the same controller decoder, so
    # if any one address didn't ack the firmware would stall on that sw.
    # Use a recognizable pattern so a failure shows up clearly in waves.
    li      t2, 0x12345678

    li      t1, 0x1000            # camX
    add     t1, t1, s0
    sw      t2, 0(t1)
    li      t1, 0x1004            # camY
    add     t1, t1, s0
    sw      t2, 0(t1)
    li      t1, 0x1008            # camZ
    add     t1, t1, s0
    sw      t2, 0(t1)

    li      t1, 0x100C            # sphereX
    add     t1, t1, s0
    sw      t2, 0(t1)
    li      t1, 0x1010            # sphereY
    add     t1, t1, s0
    sw      t2, 0(t1)
    li      t1, 0x1014            # sphereZ
    add     t1, t1, s0
    sw      t2, 0(t1)

    li      t0, 4
    li      t1, 0x1018            # cols
    add     t1, t1, s0
    sw      t0, 0(t1)
    li      t1, 0x101C            # rows
    add     t1, t1, s0
    sw      t0, 0(t1)

    li      t1, 0x1020            # scaleX
    add     t1, t1, s0
    sw      t2, 0(t1)
    li      t1, 0x1024            # scaleY
    add     t1, t1, s0
    sw      t2, 0(t1)

    li      t0, 0xCAFE0001
    sw      t0, 0(s1)
hang:
    j       hang

fail:
hang_fail:
    j       hang_fail
