# TAG = sll

	.text

    #Test de 1 décalage d'une valeur nulle dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    addi x2, x1, 0x001 #Chargement de 1 dans x2
    srlli x31, x1, x2

    #Test de 2 décalages d'une valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    addi x2, x1, 0x002 #Chargement de 2 dans x2
    addi x31, x1, 0x123
    srlli x31, x31, x2


	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000123
	# 0000048C
	# pout_end