# TAG = sltu

	.text

    # Comparaison de 0 et 0
    sltu x31, x0, x0 

	# Comparaison de 0 et 1
	li x1, 0x00000001 #Chargement de 1 dans x2
    sltu x31, x0, x1

    # Comparaison de deux valeurs quelconques
	li x1, 0x12345678 #Chargement de la valeur négative minimale mais qui sera considérée comme positive car de type unsigned
	li x2, 0x23456789 #Chargement de la valeur positive maximale (si c'était un signé mais du coup n'est pas le max sur les non signés)
    sltu x31, x1, x2 

	# max_cycle 500
	# pout_start
	# 00000000  
	# 00000001  
	# 00000001 
	# pout_end
