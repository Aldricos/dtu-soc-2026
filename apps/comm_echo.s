#
# Echo on the Caravel-Wildcat communication
#
loop:
    li      x1, 0xc0000000
    lw      x2, 0(x1)
    sw      x2, 0(x1)
    j       loop
