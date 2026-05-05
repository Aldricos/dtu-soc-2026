lui  x5, 0xe0000        # x5 = 0xE0000000

lw   x7, 0(x5)          # read A once, likely fills cache line A

lui  x6, 0x12345
addi x6, x6, 0x678      # x6 = 0x12345678

sw   x6, 0(x5)          # write A; if line is cached, this updates cache too

addi x8, x5, 1024       # x8 = 0xE0000400
lw   x9, 0(x8)          # read B; same cache index, different tag, should evict A

lw   x10, 0(x5)         # read A again; should miss and fetch from backing memory

beq  x10, x6, success   # if backing memory has value, success

fail:
addi x11, x0, 0         # result = 0
jal  x0, report

success:
addi x11, x0, 1         # result = 1

report:
lui  x29, 0xf0030
sw   x11, 0(x29)        # write result to 0xF0030000

loop:
jal  x0, loop