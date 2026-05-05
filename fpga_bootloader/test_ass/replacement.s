.section .text
.globl _start

_start:
    # A and B should map to the same cache index
    # if the cache index uses address bits [9:2].
    li    s0, 0xe0000000      # A
    li    s1, 0xe0000400      # B = A + 0x400
    li    s2, 0xf0030000      # debug/comm output

    li    t0, 0xaaaaaaaa      # dataA
    li    t1, 0xbbbbbbbb      # dataB

    # ------------------------------------------------------------
    # Fill A, then write-hit A
    # ------------------------------------------------------------
    lw    t6, 0(s0)           # fill A line
    sw    t0, 0(s0)           # write A = 0xaaaaaaaa

    lw    t2, 0(s0)           # read A
    bne   t2, t0, fail_a      # should be 0xaaaaaaaa

    # ------------------------------------------------------------
    # Fill B, then write-hit B
    # B should replace A if they share the same index.
    # ------------------------------------------------------------
    lw    t6, 0(s1)           # fill B line, replacing A
    sw    t1, 0(s1)           # write B = 0xbbbbbbbb

    lw    t2, 0(s1)           # read B
    bne   t2, t1, fail_b      # should be 0xbbbbbbbb

    # ------------------------------------------------------------
    # Read A again.
    # If B really replaced A, this should miss and fetch backing
    # memory, so it should NOT still be cached as 0xaaaaaaaa.
    # On your flash setup, it may read 0xffffffff.
    # ------------------------------------------------------------
    lw    t3, 0(s0)           # read A again after B replaced it

    beq   t3, t0, fail_no_replace

pass:
    li    t4, 0xcace0002
    sw    t4, 0(s2)           # result0 = pass marker

    # Delay between debug writes, so CaravelDebug captures both.
    nop
    nop
    nop
    nop

    sw    t3, 0(s2)           # result1 = value read from A after replacement

done:
    j     done


fail_a:
    li    t4, 0xbad00a1
    sw    t4, 0(s2)           # result0 = fail marker

    nop
    nop
    nop
    nop

    sw    s0, 0(s2)           # result1 = A address
    j     done


fail_b:
    li    t4, 0xbad00b1
    sw    t4, 0(s2)           # result0 = fail marker

    nop
    nop
    nop
    nop

    sw    s1, 0(s2)           # result1 = B address
    j     done


fail_no_replace:
    li    t4, 0xbad00c1
    sw    t4, 0(s2)           # result0 = fail marker

    nop
    nop
    nop
    nop

    sw    t3, 0(s2)           # result1 = A value after supposed replacement
    j     done