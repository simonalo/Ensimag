# TAG = add

    .text

    #Test d'addition de deux valeurs (dont une nulle)dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
    lui x1, 0 #Chargement d'une valeur nulle dans x1
    lui x2,5
    add x31, x1, x2

    #Test d'addition d'une valeur nulle  et d'une valeure maximale dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
    lui x1, 0x1f #Chargement d'une valeur maximale dans x1
    lui x2, 0 #chargement val nulle
    add x31, x1, x2

    #Test d'addition de deux valeur quelconque dans x31
    lui x31, 0 #Chargement d'une valeur nulle dans x31
    lui x1, 0x12 #Chargement d'une valeur quelconque dans x1
    lui x2, 0x17
    add x31, x1, x2

