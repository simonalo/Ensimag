# TAG = auipc
	.text

    auipc x31, 0x00000 # pc est initialisé à 0x1000
    auipc x31, 0x00000 # après incrémentation, il vaut 0x1004
    auipc x31, 0x00000 # ici 0x1008
    auipc x31, 0xef459 # valeur quelconque additionnée à 0x100c

    # max_cycle 50
	# pout_start
    # 00001000
    # 00001004
    # 00001008
    # ef45a00c
	# pout_end