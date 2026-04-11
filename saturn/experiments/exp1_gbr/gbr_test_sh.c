/*
 * Hitachi SHC test: can we get mov.? @(disp,gbr) output using #pragma gbr_base?
 *
 * Expected: yes. The v5.0 manual documents this exact use case.
 */

struct game_state {
    unsigned char  flag_a;    /* offset 0 */
    unsigned char  flag_b;    /* offset 1 */
    unsigned short word_c;    /* offset 2 */
    unsigned long  long_d;    /* offset 4 */
    unsigned char  flag_e;    /* offset 8 */
    unsigned char  pad[3];    /* offset 9-11 */
    unsigned long  long_f;    /* offset 12 */
    unsigned short word_g;    /* offset 16 */
};

#pragma gbr_base (gs)
struct game_state gs;

void store_all(unsigned char a, unsigned char b, unsigned short c,
               unsigned long d, unsigned char e, unsigned long f,
               unsigned short g)
{
    gs.flag_a = a;
    gs.flag_b = b;
    gs.word_c = c;
    gs.long_d = d;
    gs.flag_e = e;
    gs.long_f = f;
    gs.word_g = g;
}

unsigned long load_sum(void)
{
    return (unsigned long)gs.flag_a
         + (unsigned long)gs.flag_b
         + (unsigned long)gs.word_c
         + gs.long_d
         + (unsigned long)gs.flag_e
         + gs.long_f
         + (unsigned long)gs.word_g;
}
