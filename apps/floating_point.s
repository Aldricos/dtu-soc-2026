#
# A program testing the floating point peripheral by calculating the
# golden ratio with the formula: 'phi = (sqrt(5) + 1) / 2
#
start:
    li      s0, 0xf0040000
    li      s1, 0x400F1BBD # F32 representation of 'sqrt(5)'
    li      s2, 0x3F800000 # F32 representation of '1.0'
    li      s3, 0x3F000000 # F32 representation of '0.5'

# Addition of 'sqrt(5)' and '1.0'
    li      t0, 0 # addition operation
    sw      s1, 0(s0) # store first operand
    sw      s2, 4(s0) # store second operand
    sw      t0, 8(s0) # store operation
    lw      s4, 16(s0) # load result
    beqz    s4, error

# Multiplication of result and '0.5'
    li      t0, 2 # multiplication operation
    sw      s3, 0(s0) # store first operand
    sw      s4, 4(s0) # store second operand
    sw      t0, 8(s0) # store operation
    lw      s1, 16(s0) # load result
    beqz    s1, error

# Send to Caravel using Caravel-Wildcat communication
send:
    li      s0, 0xf0030000
    sw      s1, 0(s0)

loop:
    j       loop

error:
    li      s1, 1
    j       send
