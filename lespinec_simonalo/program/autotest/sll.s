# TAG = sll

	.text

    #Test de un décalage d'une valeur nulle
    li x1, 0x00000001 
    sll x31, x0, x1

	#Test de un décalage d'une valeur maximale
	li x1, 0x00000001 
    li x2, 0xffffffff 
    sll x31, x2, x1

    #Test de zéro décalages d'une valeur quelconque
	li x2, 0x12345678
    sll x31, x2, x0

	#Test de un décalages d'une valeur quelconque
    li x1, 0x00000001
	li x2, 0x23456789
    sll x31, x2, x1

	#Test de 8 décalages d'une valeur quelconque
    li x1, 0x00000008
	li x2, 0x12345678
    sll x31, x2, x1

	#Test du maximum décalages d'une valeur quelconque
    li x1, 0x0000001f
	li x2, 0x12345678
    sll x31, x2, x1



	# max_cycle 500
	# pout_start
	# 00000000 
	# FFFFFFFE
	# 12345678
	# 468ACF12
	# 34567800
	# 00000000
	# pout_end
