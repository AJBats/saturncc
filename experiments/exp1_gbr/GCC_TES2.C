/*
 * GCC/Cygnus 2.7 test — using global register variable asm("gbr").
 *
 * This is the closest Cygnus-idiomatic way to request GBR-relative
 * access. We claim GBR as a struct pointer for this whole TU. Any
 * access via *gs_ptr or gs_ptr-> should (in theory) be usable from
 * GBR, though whether Cygnus emits mov.b @(disp,gbr) or mov.b @(reg,rN)
 * is exactly what we're measuring.
 */

struct game_state {
    unsigned char  flag_a;
    unsigned char  flag_b;
    unsigned short word_c;
    unsigned long  long_d;
    unsigned char  flag_e;
    unsigned char  pad[3];
    unsigned long  long_f;
    unsigned short word_g;
};

/* Claim GBR as a pointer to our struct. */
register struct game_state *gs_ptr asm("gbr");

void store_all(unsigned char a, unsigned char b, unsigned short c,
               unsigned long d, unsigned char e, unsigned long f,
               unsigned short g)
{
    gs_ptr->flag_a = a;
    gs_ptr->flag_b = b;
    gs_ptr->word_c = c;
    gs_ptr->long_d = d;
    gs_ptr->flag_e = e;
    gs_ptr->long_f = f;
    gs_ptr->word_g = g;
}

unsigned long load_sum(void)
{
    return (unsigned long)gs_ptr->flag_a
         + (unsigned long)gs_ptr->flag_b
         + (unsigned long)gs_ptr->word_c
         + gs_ptr->long_d
         + (unsigned long)gs_ptr->flag_e
         + gs_ptr->long_f
         + (unsigned long)gs_ptr->word_g;
}
