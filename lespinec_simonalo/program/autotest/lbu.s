# TAG = lbu

    .text
    # Test de lecture d'un octet non signé
    lui x31, 0x00001

    lui   x1, %hi(v)
    addi  x1, x1, %lo(v)
    lbu   x31, 0(x1)

    lui   x1, %hi(w)
    addi  x1, x1, %lo(w)
    lbu   x31, 0(x1)

    .data
        v: .word 0x12345678
        w: .word 0x12345688


    # max_cycle 50
    # pout_start
    # 00001000
    # 00000078
    # 00000088
    # pout_end