# TAG = slli

	.text

    #Test de un décalage d'une valeur nulle
    slli x31, x0, 0x00000001

	#Test de un décalage d'une valeur maximale
    li x1, 0xffffffff 
    slli x31, x1, 0x00000001
	
    #Test de zéro décalages d'une valeur quelconque
	li x1, 0x12345678
    slli x31, x1, 0x00000000

	#Test de un décalages d'une valeur quelconque
	li x1, 0x23456789
    slli x31, x1, 0x00000001

	#Test de 8 décalages d'une valeur quelconque
	li x2, 0x12345678
    slli x31, x1, 0x00000008

	#Test du maximum décalages d'une valeur quelconque
	li x1, 0x12345678
    slli x31, x1, 0x00000020



	# max_cycle 500
	# pout_start
	# 00000000 
	# FFFFFFFE 
	# 12345678
	# 468ACF12
	# 45678900
	# 00000000
	# pout_end
