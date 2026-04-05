#
# Blink an LED
#
# When ignoring the address decoding, this blinks an LED with just 3 instructions: addi, sw, and bnez.
#
    li      x4, 0xf0010000
    li      x3, 1
    sw      x3, 0(x4)

loop:
	sw      x3, 0(x4)
    addi    x3, x3, 1
    j loop
