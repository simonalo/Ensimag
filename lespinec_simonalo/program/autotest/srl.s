# TAG = srl

	.text

    #Test de un décalage d'une valeur nulle
    li x1, 0x00000001 
    srl x31, x0, x1

	#Test de un décalage d'une valeur maximale
	li x1, 0x00000001
    li x2, 0xffffffff 
    srl x31, x2, x1

    #Test de zéro décalages d'une valeur quelconque
	li x2, 0x12345678
    srl x31, x2, x0

	#Test de un décalages d'une valeur quelconque
    li x1, 0x00000001
	li x2, 0x23456789
    srl x31, x2, x1

	#Test du maximum décalages d'une valeur quelconque
    li x1, 0x0000000f
	li x2, 0x12345678
    srl x31, x2, x1


	# max_cycle 500
	# pout_start
	# 00000000 
	# 7FFFFFFF 
	# 12345678
	# 11A2B3C4
	# 00000000
	# pout_end
