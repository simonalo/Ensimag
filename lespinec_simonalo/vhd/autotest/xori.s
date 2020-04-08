# TAG = xori
# ce fichier de test est similaire à addi.
    .text

    #Test xori de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    xori x31, x1, 0x000

    #Test xori d'une valeur nulle  et d'une valeure max dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    xori x31, x1, 0x455

    #Test xori de deux valeur quelconques dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x11122 #Chargement d'une valeur quelconque dans x1
    xori x31, x1, 0x123
