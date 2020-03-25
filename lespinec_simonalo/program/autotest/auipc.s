# TAG = auipc

	.text

    #Test d'addition de 0 à pc (initialisé à 0x1000)
	auipc x31, 0 

    ##Test d'addition d'un immédiat quelconque à pc (qui vaut maintenant à 0x1001)
    auipc x31, 1234

	# max_cycle 500
	# pout_start
	# 00001000 
    # 00002235
	# pout_end
