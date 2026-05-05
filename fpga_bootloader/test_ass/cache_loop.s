.section .text
.globl _start

_start:
    # Cache base
    li    s0, 0xe0000000

    # Number of words to test
    li    s1, 16

    # Initial data pattern
    li    s2, 0x12345678

    # Communication MMIO
    li    s3, 0xf0030000

    # ------------------------------------------------------------
    # Write loop
    # for i = 0..15:
    #   addr = 0xe0000000 + 4*i
    #   data = 0x12345678 + i
    #   store data
    # ------------------------------------------------------------
    li    t0, 0              # i = 0

write_loop:
    slli  t1, t0, 2          # offset = i * 4
    add   t2, s0, t1         # addr = base + offset
    add   t3, s2, t0         # data = pattern + i
    sw    t3, 0(t2)

    addi  t0, t0, 1
    blt   t0, s1, write_loop

    # ------------------------------------------------------------
    # Read/verify loop
    # ------------------------------------------------------------
    li    t0, 0              # i = 0

read_loop:
    slli  t1, t0, 2
    add   t2, s0, t1         # addr
    add   t3, s2, t0         # expected

    lw    t4, 0(t2)          # got

    bne   t4, t3, fail

    addi  t0, t0, 1
    blt   t0, s1, read_loop

pass:
    li    t5, 0xcace0001
    sw    t5, 0(s3)

    li    t5, 0x00000000
    sw    t5, 0(s3)

done:
    j     done

fail:
    # result0 = 0xbad00001
    # result1 = failing address
    li    t5, 0xbad00001
    sw    t5, 0(s3)

    sw    t2, 0(s3)

fail_done:
    j     fail_done