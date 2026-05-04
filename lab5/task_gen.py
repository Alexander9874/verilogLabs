def fout(fin, m, d, o):
    return round((fin * m) / (d * o))

fin = 425
O0 = 26
O1 = 79

Fout0 = 41
Fout1 = 14
Fout2 = 54
Fout3 = 18
Fout4 = 14
Fout5 = 26

for m in range(2, 64):
    for d in range(1, 56):
        if ( fout(fin, m, d, O0) == Fout0 and
             fout(fin, m, d, O1) == Fout1 and
             fin * m / d >= 800 and
             fin * m / d <= 1600
        ):
            for o in range(1, 128):
                if (fout(fin, m, d, o) == Fout2):
                    print(f'm={m}\td={d}\tO2={o}\tFvco={fin * m / d}')
                if (fout(fin, m, d, o) == Fout3):
                    print(f'm={m}\td={d}\tO3={o}\tFvco={fin * m / d}')
                if (fout(fin, m, d, o) == Fout4):
                    print(f'm={m}\td={d}\tO4={o}\tFvco={fin * m / d}')
                if (fout(fin, m, d, o) == Fout5):
                    print(f'm={m}\td={d}\tO5={o}\tFvco={fin * m / d}')
