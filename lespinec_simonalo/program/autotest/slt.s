# TAG = slt

	.text

    
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
	lui x2, 0 #Chargement d'une valeur nulle dans x2
    slt x31,x1, x2 


    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
	lui x2, 1 #Chargement de 1 dans x2
    slt x31,x1, x2 

    #Test de deux valeurs extremes (dépacement de 32 bits)
    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, 0xFFFFFFFF #Chargement de la valeur négative maximale
	li x2, 0x7FFFFFFF #Chargement de la valeur négative minimale
    slt x31,x1, x2 

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000001
	# 00000000  
	# 00000001  
	# pout_end
