# TAG = sltiu

	.text

    
    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    sltiu x31, x1, 0x000


    lui x31, 0 #Chargement d'une valeur nulle dans x31
	lui x1, 0 #Chargement d'une valeur nulle dans x1
    sltiu x31,x1, 0xF00

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000000 
	# 00000000  
	# 00000001
	# pout_end
