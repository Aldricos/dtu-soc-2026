    li s0, 0xf2000000
    li s1, 'X'
loop:
    sb s1, 0(s0)
    addi s0, s0, 1
    j loop
