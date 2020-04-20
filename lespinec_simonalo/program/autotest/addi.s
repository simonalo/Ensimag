# TAG = addi

	.text

    #Test d'addition d'un registre nul et d'un immédiat nul
    lui x1, 0
    addi x31, x1, 0

    #Test d'addition d'un registre de valeur maximale et d'un immédiat nul
	lui x1, 0xfffff
    addi x31, x1, 0

    #Test d'addition d'un registre nul et d'un immédiat de valeur maximale
    addi x31, x0, 0x7FF

	#Test d'addition d'un registre nul et d'un immédiat de valeur minimale
    #addi x31, x0, -0x800

	#Test d'addition d'un registre  et d'un immédiat pour obtenir la valeur maximale
	li x1, 0xffffff00
    addi x31, x1, 0x0ff

	#Test d'addition d'un registre  et d'un immédiat de valeur quelconques
	li x1, 0x12345678
    addi x31, x1, 0x291

	# max_cycle 500
	# pout_start
	# 00000000
	# FFFFF000
	# 000007FF
	# FFFFFFFF
	# 12345909
