# TAG = bne

    .text
    lui x30, 11
    lui x31, 10
    bne x30, x31, saut1
    lui x31, 1
saut1:
    lui x31, 2
    lui x30, 2
    bne x30, x31, saut2
    lui x31,4
saut2:
    lui x31,5
    # max_cycle 50
    # pout_start
    # 0000A000
    # 00002000
    # 00004000
    # 00005000
    # pout_end
