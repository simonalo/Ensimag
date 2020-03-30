# TAG = xor
# ce fichier de test est similaire à addi.
    .text

    #Test xor de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    lui x2,0x00000
    xor x31, x1, x2

    #Test xor d'une valeur nulle  et d'une valeure quelconque dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    lui x2, 0x00000 #chargement val nulle
    xor x31, x1, x2

    #Test xor de deux valeur quelconques dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x01112 #Chargement d'une valeur quelconque dans x1
    lui x2, 0x44438
    xor x31, x1, x2
