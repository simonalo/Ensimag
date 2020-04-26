# TAG = sub

	.text

    #Test de soustraction de deux valeur nulle dans x31
	li x1, 0 
	li x2, 0 
    mul x31, x1, x2

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x00000001
	li x2, 0x00000001
    sub x31, x2, x1

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x00000003
	li x2, 0x00000002
    sub x31, x2, x1

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x0000F000
	li x2, 0x00000002
    sub x31, x2, x1

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000001 
	# 00000006 
	# 0000E000
	# pout_end
