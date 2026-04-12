extern void stub0(int);
extern void stub1(int);
extern void stub2(int);
extern void stub3(int);
extern void stub4(int);

int test(int state, int x) {
    switch (state) {
    case 0: stub0(x); break;
    case 1: stub1(x); break;
    case 2: stub2(x); break;
    case 3: stub3(x); break;
    case 4: stub4(x); break;
    }
    return 0;
}
