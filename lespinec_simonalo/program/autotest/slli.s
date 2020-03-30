# TAG = slli

	.text

    #Test de 1 décalage d'une valeur nulle dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    slli x31, x1, 1

    #Test de 2 décalages d'une valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    addi x31, x1, 0x123
    slli x31, x31, 2


	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000123
	# 0000048C
	# pout_end
