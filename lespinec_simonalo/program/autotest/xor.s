# TAG = xor
# ce fichier de test est similaire à addi.
    .text

    #Test xor de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    lui x2,0x00000
    xor x31, x1, x2

    #Test xor de 2 valeurs max dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    lui x2, 0xfffff
    xor x31, x1, x2

    #Test xor de deux valeur quelconques dans x31
    lui x1, 0x01112 #Chargement d'une valeur quelconque dans x1
    lui x2, 0x44438
    xor x31, x1, x2


# max_cycle 50
# pout_start
# 00000000
# 00000000
# 00000000
# 4552A000
