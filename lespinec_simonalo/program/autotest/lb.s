# TAG = lb

    .text
    # test de chargement dun mot en mémoire
    lui x31, 0
    li x30, 0x000000ff
    lui x1, 0x11110
    sb x30, 0x10(x1)
    lb x31, 0x10(x1)


    # max_cycle 50
    # pout_start
    # 00000000
    # ffffffff
    # pout_end
