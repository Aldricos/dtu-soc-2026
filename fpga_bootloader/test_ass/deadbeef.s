lui   t0, 0xe0000        # t0 = 0xe0000000

lw    t6, 0(t0)          # fill cache line first

lui   t1, 0xdeadc
addi  t1, t1, -273       # t1 = 0xdeadbeef

sw    t1, 0(t0)          # write hit should update cached copy

lw    t2, 0(t0)          # first read
lw    t3, 0(t0)          # second read

lui   t4, 0xf0030
sw    t2, 0(t4)

nop
nop
nop
nop

sw    t3, 0(t4)

done:
j done