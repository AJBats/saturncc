/*  name = test.c, February 8, 1994, P. Hack for HMSI           */
/*  purpose = test file to check out E7000PC                    */

void  fill(void);
void  clear(void);

main()
{
        while(1)
                {
                fill();
                clear();
                }
}

void fill(void)
{
        static int i=0;
        int *ip;

        ip=(int *) 0x9000;

        for(i=1;i<=10;i++)
                {
                *ip = i;
                ++ip;
                }
}

void clear(void)
{
        static int j=0;
        int *ip;

        ip=(int *) 0x9000;

        for(j=1;j<=10;j++)
                {
                *ip = 0x0000;
                ++ip;
                }
}

