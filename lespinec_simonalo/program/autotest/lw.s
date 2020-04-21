# TAG = lw

    .text
    # test de chargement dun mot en mémoire
    lui x31, 0x00001
    lui x30, 0xfffff
    lui x1, 0x11110
    sw x30, 0x10(x1)
    lw x31, 0x10(x1)


    # max_cycle 50
    # pout_start
    # 00001000
    # fffff000
    # pout_end
