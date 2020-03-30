# TAG = sltu

	.text

    
    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, 0 #Chargement d'une valeur nulle dans x1
	li x2, 0 #Chargement d'une valeur nulle dans x2
    sltu x31,x1, x2 


    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, 0 #Chargement d'une valeur nulle dans x1
	li x2, 1 #Chargement de 1 dans x2
    sltu x31,x1, x2 

    #Test de deux valeurs extremes (dépacement de 32 bits)
    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, -2147483648 #Chargement de la valeur négative minimale mais qui sera considérée comme positive car de type unsigned
	li x2, 0x7FFFFFFF #Chargement de la valeur positive maximale (si c'était un signé mais du coup n'est pas le max sur les non signés)
    sltu x31, x1, x2 

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000001
	# 00000000  
	# 00000000  
	# pout_end
