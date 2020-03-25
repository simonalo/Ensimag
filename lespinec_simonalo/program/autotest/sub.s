# TAG = sub

	.text

    #Test de soustraction de deux valeur nulle dans x31
	lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    sub x31, x31, x1

    #Test de soustraction d'une valeur nulle  et d'une valeure maximale dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    sub x31, x1, x31

    #Test de soustraction de deux valeur quelconque dans x31 pour avoir un résultat négatif
    lui x31, 0x00003 #Chargement d'une valeur nulle dans x31
	lui x1, 0x00001 #Chargement d'une valeur quelconque dans x1
    sub x31, x1, x31

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000 
	# FFFFF000
	# 00003000
	# 00006000
	# pout_end
