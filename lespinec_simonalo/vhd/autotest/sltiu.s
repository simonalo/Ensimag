# TAG = sltiu

	.text

    # Comparaison de 0 et 0
	li x1, 0 #Chargement d'une valeur nulle dans x1
    sltiu x31, x0, 0x000

	# Comparaison de 0 et d'un immédiat maximum
    sltiu x31, x0, -2048

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000001
	# pout_end
