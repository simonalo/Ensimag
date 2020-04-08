# TAG = slt

	.text

    # Comparaison de 0 et 0
    slt x31, x0, x0

	# Comparaison de 0 et de 1
	li x1, 1
    slt x31, x0, x1

    # Comparaison de deux valeurs extremes
	li x1, -2147483648 #Chargement de la valeur négative minimale
	li x2, 0x7FFFFFFF #Chargement de la valeur positive maximale
    slt x31, x1, x2 

	# max_cycle 500
	# pout_start
	# 00000000  
	# 00000001 
	# 00000001  
	# pout_end
