# TAG = lw

    .text
    # Test de lecture d'un mot
    lui x31, 0x00001

    lui   x1, %hi(v)
    addi  x1, x1, %lo(v)
    lw   x31, 0(x1)

    .data
        v: .word 0x12345678


    # max_cycle 50
    # pout_start
    # 00001000
    # 12345678
    # pout_end
