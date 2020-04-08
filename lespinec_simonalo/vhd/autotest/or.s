# TAG = or
# ce fichier de test est similaire à addi.
    .text

    #Test or de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    lui x2,0x00000
    or x31, x1, x2

    #Test or d'une valeur nulle  et d'une valeure max  dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    lui x2, 0x00000 #chargement val nulle
    or x31, x1, x2

    #Test or de deux valeur égales dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x13333 #Chargement d'une valeur quelconque dans x1
    lui x2, 0x14455
    or x31, x1, x2


