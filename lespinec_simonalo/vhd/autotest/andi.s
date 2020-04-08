# TAG = andi
# ce fichier de test est similaire à addi.
    .text

    #Test andi  deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    andi x31, x1, 0x0000

    #Test andi d'une valeur nulle  et d'une valeure max dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    andi x31, x1, 0x0000

    #Test andi de deux valeur quelconques dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x14561 #Chargement d'une valeur quelconque dans x1
    andi x31, x1, 0x0112


