# TAG = sltiu

	.text

    
    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, 0 #Chargement d'une valeur nulle dans x1
    sltiu x31, x1, 0x000


    li x31, 0 #Chargement d'une valeur nulle dans x31
	li x1, 0 #Chargement d'une valeur nulle dans x1
    sltiu x31,x1, -2048

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000001
	# pout_end