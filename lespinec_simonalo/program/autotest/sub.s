# TAG = sub

	.text

	# ATTENTION : Ici les registres sont signés

    #Test de soustraction de deux valeur nulle dans x31
	li x1, 0 
	li x2, 0 
    sub x31, x31, x1

	#Test de soustraction de deux valeur maximale dans x31
	li x1, 0x7fffffff 
	lii x2, 0x7fffffff  
    sub x31, x2, x1

    #Test de soustraction d'une valeur nulle et d'une valeur maximale (résultat positif)
	li x1, 0x7fffffff 
	li x2, 0 
    sub x31, x1, x2

	#Test de soustraction d'une valeur nulle et d'une valeur maximale (résultat négatif)
	li x1, 0x7fffffff 
	li x2, 0 
    sub x31, x2, x1

    #Test de soustraction de deux valeurs quelconques (résultat positif)
	li x1, 0x12345678 
	li x2, 0x87654321
    sub x31, x2, x1

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# FFFFFFFF
	# 80000001
	# 7530ECA9
	# 8ACF1357
	# pout_end
