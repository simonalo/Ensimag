# TAG = jalr

    .text
    # on teste
    lui x31, 0x00001
    addi  x31, x31, 0x020
    lui x1, 0x00001
    addi x1, x1, 0x024
    lui x31, 0xbeef0  #  addr 0x1010
    jalr x31, -4(x1) # addr 0x1014
    lui x30, 0x33333 # 0x1018
    lui x31, 0x12345 # 0x101C
    lui x31, 0x54321 # 0x1020

    # max_cycle 50
    # pout_start
    # 00001000
    # 00001020
    # beef0000
    # 00001018
    # 54321000
    # pout_end

