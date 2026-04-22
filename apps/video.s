#
# Write "Hello, world!" in the video buffer. 
#
    li s0, 0xf2000000

hello:
    li s1, 'H'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'e'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'l'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'l'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'o'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, ','
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, ' '
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'w'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'o'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'r'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'l'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, 'd'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, '!'
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    li s1, ' '
    sw s1, 0(s0)
    addi s0, s0, 1
    call delay

    j hello

delay:
    li      t0, 0xff
loop_0:
    li      t1, 0x7ff
loop_1:
    addi	t1, t1, -1
    bnez	t1, loop_1
    addi	t0, t0, -1
    bnez	t0, loop_0
    ret
