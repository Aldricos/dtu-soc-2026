#
# Echo on the Caravel-Wildcat communication
#
loop:
    li      x1, 0xf0030000
    lw      x2, 0(x1)
    addi    x2, x2, 1
    sw      x2, 0(x1)
    j       loop
