# TAG = jal

    .text
    # on teste
    lui x31, 0xbeef0  # debut programme : addr 0x1000
    jal x31, saut
    lui x31, 0x12345
saut:
    lui x31, 0x54321



    # max_cycle 50
    # pout_start
    # beef0000
    # 00001008
    # 54321000
    # pout_end

