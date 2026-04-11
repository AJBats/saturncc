/*
 * GCC/Cygnus 2.7 test — baseline without any GBR annotation.
 *
 * Question: does Cygnus 2.7 automatically use GBR-relative addressing
 * for any struct access, or does it treat 'gs' as a normal global
 * reached via constant-pool pointer load?
 *
 * Expected (best guess): Cygnus emits constant-pool-loaded pointer +
 * mov.b @(disp,rN), NOT mov.b @(disp,gbr). GBR is not auto-used.
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
