# TAG = sw

    .text
    # test d'écriture en mémoire.
    # On fait simple pour commencer :)
    # On récupère l'adresse de la donnée v
    lui   x1, %hi(v)
    addi  x1, x1, %lo(v)
    addi x30, x0, 0x7ff
    sw   x30, 0(x1)
    lw   x31, 0(x1)

    .data
v: .word 0x0bada55, 0xdeadbeef


    # max_cycle 50
    # pout_start
    # 000007ff
    # pout_end
