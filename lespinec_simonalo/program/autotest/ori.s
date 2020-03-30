# TAG = ori
# ce fichier de test est similaire à addi.
    .text

    #Test ori de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    ori x31, x1, 0x000

    #Test ori d'une valeur nulle  et d'une valeure max dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    ori x31, x1, 0x000

    #Test ori de deux valeur quelconques dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x12345 #Chargement d'une valeur quelconque dans x1
    ori x31, x1, 0x143


