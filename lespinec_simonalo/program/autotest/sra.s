# TAG = sra

	.text

    #Test de 1 décalage d'une valeur nulle dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
	lui x2, 1 #Chargement d'une valeur nulle dans x1
    sra x31, x1, x2

    #Test de 2 décalages d'une valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur maximale dans x1
	lui x2, 2 #Chargement d'une valeur maximale dans x1
    addi x31, x1, 0x123
    sra x31, x31, x2


	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000123
	# 00000048
	# pout_end
