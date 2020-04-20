# TAG = and
# ce fichier de test est similaire à addi.
    .text

    #Test and sur deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    lui x2,0x00000
    and x31, x1, x2

    #Test and  d'une valeur nulle  et d'une valeure max  dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0xfffff #Chargement d'une valeur maximale dans x1
    lui x2, 0x00000 #chargement val nulle
    and x31, x1, x2

    #test de 2 val max
    lui x1, 0xfffff
    lui x2, 0xfffff
    and x31, x1, x2

    #Test and de deux quelconques égales dans x31
    lui x1, 0x13538 #Chargement d'une valeur quelconque dans x1
    lui x2, 0x13922
    and x31, x1, x2

# max_cycle 50
# pout_start
# 00000000
# 00000000
# 00000000
# 00000000
# FFFFF000
# 13120000
