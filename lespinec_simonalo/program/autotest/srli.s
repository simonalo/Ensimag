# TAG = srli

	.text

    #Test de un décalage d'une valeur nulle
    srli x31, x0, 1

	#Test de un décalage d'une valeur maximale
    li x1, 0xffffffff 
    srli x31, x1, 1

    #Test de zéro décalages d'une valeur quelconque
	li x1, 0x12345678
    srli x31, x1, 0

	#Test de un décalages d'une valeur quelconque
	li x1, 0x23456789
    srli x31, x1, 1

	#Test de 8 décalages d'une valeur quelconque
	li x2, 0x12345678
    srli x31, x1, 8

	#Test du maximum décalages d'une valeur quelconque
	li x1, 0x12345678
    srli x31, x1, 31



	# max_cycle 500
	# pout_start
	# 00000000 
	# 7FFFFFFF 
	# 12345678
	# 11A2B3C4
	# 00234567
	# 00000000
	# pout_end
