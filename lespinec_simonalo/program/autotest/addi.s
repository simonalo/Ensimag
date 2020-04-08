# TAG = addi

	.text

    #Test d'addition d'un registre nul et d'un immédiat nul
    addi x31, x0, 0

    #Test d'addition d'un registre de valeur maximale et d'un immédiat nul
	li x1, 0xffffffff #Chargement d'une valeur maximale dans x1
    addi x31, x1, 0

    #Test d'addition d'un registre nul et d'un immédiat de valeur maximale
    addi x31, x0, 0x7FF

	#Test d'addition d'un registre nul et d'un immédiat de valeur minimale
    addi x31, x0, 0x800

	#Test d'addition d'un registre  et d'un immédiat pour obtenir la valeur maximale
	li x1, 0xffffff00 #Chargement d'une valeur maximale dans x1
    addi x31, x1, 0x0ff

	#Test d'addition d'un registre  et d'un immédiat de valeur quelconques
	li x1, 0x12345678 #Chargement d'une valeur maximale dans x1
    addi x31, x1, 291

	#Test d'addition d'un registre  et d'un immédiat (négatif) de valeur quelconques
	li x1, 0x12345678 #Chargement d'une valeur maximale dans x1
    addi x31, x1, 291

	# max_cycle 500
	# pout_start
	# 00000000 
	# FFFFFFFF
	# 000007FF
	# FFFFF800
	# FFFFFFFF 
	# 1234579B
	# pout_end
