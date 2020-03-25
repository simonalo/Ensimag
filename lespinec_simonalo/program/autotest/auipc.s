# TAG = auipc

	.text

    #Test d'addition de 0 à pc (initialisé à 0x1000 et qui vaut 0x1004 après)
	auipc x31, 0 

	# max_cycle 500
	# pout_start
	# 00001004 
	# pout_end
