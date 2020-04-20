# TAG = xori
# ce fichier de test est similaire à addi.
    .text

    #Test xori de deux valeurs nulles dans x31
    lui x31, 0x00000 #Chargement d'une valeur nulle dans x31
    lui x1, 0x00000 #Chargement d'une valeur nulle dans x1
    xori x31, x1, 0x000

    #Test xori de valeurs max dans x31
    li x1, 0xffffffff #Chargement d'une valeur maximale dans x1
    xori x31, x1, 0x7ff

    #Test xori de deux valeur quelconques dans x31
    li x1, 0x11122333 #Chargement d'une valeur quelconque dans x1
    xori x31, x1, 0x123

# max_cycle 50
# pout_start
# 00000000
# 00000000
# fffff800
# 11122210
# pout_end
