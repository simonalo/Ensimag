/*
uint32_t affine(uint32_t a, uint32_t b, uint32_t x)
{
   return mult(x, a) + b;
}
*/

    .text
    .globl affine
    /* uint32_t affine(uint32_t a, uint32_t b, uint32_t x) */

/* Contexte:
	Fonction non feuille : espace réservée dans la pile pour le paramètres b [nr = 1],
    On a pas variable locale dans la pile [nv=0]
    On sauvegarde ra dans la pile [nr=1]

    => La fonction doit réserver dans la pile (np+nv+nr)*4 octets
    => Pile + 8
Conventions utilisées
    adresse de retour : ra ou pile sp+4
    b : a0 ou pile sp+0
    PILE:
    sp+0 : place pour permetre à la fonction de sauvegarder son registre a0 ou b
    sp+4 : place pour permetre à la fonction de sauvegarder son registre ra

*/

affine:
    /* On réserve la place nécessaire dans la pile */
    addi sp, sp, 8
    /* On y sauvegarde l'adresse de retour */
    sw ra, 4(sp)
    /* Et le paramètre b */
    sw a0, 0(sp)

    /* On appelle la fonction mult */
    jal mult

    /* On récupère b qu'on addition à mult(a,x) */
    lw t0, 0(sp)
    add a0, t0, a0

    lw   ra, 4(sp)  /* on recharge ra avec l'adresse de retour de la pile */
    addi sp, sp, 8 /* on libère la pile */
    ret
