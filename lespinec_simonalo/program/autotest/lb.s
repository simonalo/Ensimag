# TAG = lb

    .data
    nul : .word 0 #00000000
    negatif : .word -8 #FFFFFFF8
    positif : .word  3 #00000003

    .text

    # On charge l'adresse du mot dans un registre puis on lit ce qu'il y a à cette adresse
    la x1, nul
    lb x31, (x30)

    la x1, negatif
    lb x31, (x30)

    la x1, positif
    lb x31, (x30)

    # max_cycle 50
    # pout_start
    # 00000000
    # FFFFFFF8
    # 00000003
    # pout_end