# TAG = addi

	.text

    #Test d'addition de deux valeur nulle dans x31
	lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    addi x31, x1, 0

    #Test d'addition d'une valeur nulle  et d'une valeure maximale dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    addi x31, x1, 0

    #Test d'addition de deux valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0x12345 #Chargement d'une valeur nulle dans x1
    addi x31, x1, 0x678

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000 
	# FFFFF000
	# 00000000 
	# 12345678
	# pout_end
