# TAG = srl

	.text

    #Test de 1 décalage d'une valeur nulle dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    srl x31, x1, 0x01

    #Test de 2 décalages d'une valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0x12345 #Chargement d'une valeur maximale dans x1
    addi x31, x1, 0x678
    srl x31, x31, 0x02



	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 12345678
	# 00123456
