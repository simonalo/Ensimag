/*
uint8_t res8;
uint32_t res;

uint32_t somme(void)
{
    uint32_t i;
    uint32_t res = 0;
    for (i = 1; i <= 10; i++) {
        res = res + i;
    }
    return res;
}

uint32_t sommeMem(void)
{
    uint32_t i;
    for (i = 1; i <= 10; i++) {
        res = res + i;
    }
    return res;
}

uint8_t somme8(void)
{
    uint8_t i;
    res8 = 0;
    for (i = 1; i <= 24; i++) {
        res8 = res8 + i;
    }
    return res8;
}
*/
    .text
    .globl somme
somme:
/* Contexte: on propose de mettre les variables i et res, respectivement dans les
 * registres t0 (soit x5) et t1 (soit x6).
    On stocke de plus la oconstante 10 dans t2 (soitt x7) */

    /*uint32_t i = 1;*/
    lui t0, 1
    /*uint32_t res = 0;*/
    lui t1 0
    /*uint32_t cst = 10;*/
    lui t2 10

    /*for (i = 1; i <= 10; i++) {*/
for_somme:
    beq t0, t2, fin
    /* res = res + i; */
    add t1, t1, t0
    /* } */
    j for_somme
    /*return res;*/
fin_somme:
    mv a0, t0

    .globl sommeMem
sommeMem:
/*  Contexte : à préciser */


    .globl somme8
somme8:
/*  Contexte : à préciser */

    .data
/* uint32_t res;
 la variable globale res étant définie dans ce fichier, il est nécessaire de
 la définir dans la section .data du programme assembleur : par exemple, avec 
 la directive .comm vu qu'elle n'est pas initialisée (idem pour res8)
*/

