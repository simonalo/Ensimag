# TAG = srl

	.text

    #Test de un décalage d'une valeur nulle
    li x1, 0x001 
    srl x31, x0, x1

	#Test de un décalage d'une valeur maximale
	li x1, 0x001 
    li x2, 0xfffffff 
    srl x31, x2, x1

    #Test de zéro décalages d'une valeur quelconque
    li x1, 0x001
	li x2, 0x12345678
    srl x31, x2, x1

	#Test de un décalages d'une valeur quelconque
    li x1, 0x001
	li x2, 0x12345678
    srl x31, x2, x1

	#Test de 8 décalages d'une valeur quelconque
    li x1, 0x01f
	li x2, 0x12345678
    srl x31, x2, x1

	#Test du maximum décalages d'une valeur quelconque
    li x1, 0x01f
	li x2, 0x12345678
    srl x31, x2, x1



	# max_cycle 500
	# pout_start
	# 00000000 
	# 12345678
	# 01234567
	# 00000000
	# 00000000
	# pout_end
