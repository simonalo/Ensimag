# TAG = lhu

    .text
    # Test de lecture d'un demi-mot non signé
    lui x31, 0x00001

    lui   x1, %hi(v)
    addi  x1, x1, %lo(v)
    lhu   x31, 0(x1)

    lui   x1, %hi(w)
    addi  x1, x1, %lo(w)
    lhu   x31, 0(x1)

    .data
        v: .word 0x12345678
        w: .word 0x12348678


    # max_cycle 50
    # pout_start
    # 00001000
    # 00005678
    # 00008678
    # pout_end