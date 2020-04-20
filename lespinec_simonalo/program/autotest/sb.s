# TAG = sb

    .text
    # test d'écriture en mémoire.
    # On fait simple pour commencer :)
    # On récupère l'adresse de la donnée v

    lui x30, %hi(v)
    addi x30, x30, %lo(v)
    lui x31, 0x007f2
    sb  x31, 0(x30)
    lw x31, 0(x30)

.data
    v: .word 0x12345678

    # max_cycle 50
    # pout_start
    # 007f2000
    # 12345600
    # pout_end
