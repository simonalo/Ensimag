# TAG = auipc

	.text

    #Test d'addition de 0 à pc (initialisé à 0x1000 et qui vaut 0x1004 après)
	auipc x31, 0 

    #Test d'addition d'un immédiat quelconque à pc (qui vaut maintenant à 0x1008 après avoir décodé auipc)
    auipc x31, 0x1230

	# max_cycle 500
	# pout_start
	# 00001004 
    # 00002238
	# pout_end
