# TAG = mulh

	.text

    #Test de soustraction de deux valeur nulle dans x31
	li x1, 0 
	li x2, 0 
    mulh x31, x1, x2

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x00000001
	li x2, 0x00000001
    mulh x31, x2, x1

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x00000003
	li x2, 0x00000002
    mulh x31, x2, x1

    #Test de soustraction de deux valeur maximale dans x31
	li x1, 0xF0000000
	li x2, 0x20000000
    mulh x31, x2, x1

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0xF0000000
	li x2, 0xE0000000
    mulh x31, x2, x1

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000
	# 00000001
	# 00000001
	# pout_end