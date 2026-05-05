lui   s0, 0xe0000        # cache base
lui   s1, 0xf0030        # debug/comm base
li    s2, 0x12345678     # base pattern
li    s3, 8              # number of words

# write loop
for i = 0..7:
    addr = 0xe0000000 + 4*i
    lw dummy, 0(addr)        # fill cache line first
    sw 0x12345678+i, 0(addr)

# read/verify loop
for i = 0..7:
    got = lw addr
    expected = 0x12345678+i
    if got != expected:
        report bad00001 and failing address

# pass
report cace0001 and checksum