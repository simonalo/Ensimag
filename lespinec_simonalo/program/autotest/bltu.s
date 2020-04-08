# TAG = bltu

    .text
    lui x30, 0xfffff
    lui x31, 11
    bltu x30, x31, saut1
    lui x31, 1
saut1:
    lui x30, 0xf0000
    lui x31, 3
    bltu x31, x30, saut2
    lui x31,4
saut2:
    lui x31, 0xff000
    lui x30, 0xff000
    bltu x30, x31, saut3
    lui x31, 7
saut3:
    lui x31, 8

    # max_cycle 50
    # pout_start
    # 0000B000
    # 00001000
    # 00003000
    # ff000000
    # 00007000
    # 00008000
    # pout_end
