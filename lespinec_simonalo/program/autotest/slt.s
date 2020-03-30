# TAG = slt

	.text

    #Test de 1 décalage d'une valeur nulle dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
	lui x1, 0 #Chargement d'une valeur nulle dans x2
    slt x31,x1, x2 

    #Test de 2 décalages d'une valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
	lui x1, 1 #Chargement de 1 dans x2
    slt x31,x1, x2 


	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000001
	# pout_end
