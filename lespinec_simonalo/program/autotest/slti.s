# TAG = slti

	.text

    # Comparaison de 0 et 0
    slti x31, x0, 0x00000000

	# Comparaison de 0 et 1
    slti x31, x0, 0x00000001

	# max_cycle 500
	# pout_start
	# 00000000  
	# 00000001
	# pout_end
