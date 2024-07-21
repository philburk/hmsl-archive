\ AMIGA JForth Include file.
decimal
EXISTS? HARDWARE_ADKBITS_H NOT .IF
: HARDWARE_ADKBITS_H ;
15   constant ADKB_SETCLR
14   constant ADKB_PRECOMP1
13   constant ADKB_PRECOMP0
12   constant ADKB_MFMPREC
11   constant ADKB_UARTBRK
10   constant ADKB_WORDSYNC
9   constant ADKB_MSBSYNC
8   constant ADKB_FAST
7   constant ADKB_USE3PN
6   constant ADKB_USE2P3
5   constant ADKB_USE1P2
4   constant ADKB_USE0P1
3   constant ADKB_USE3VN
2   constant ADKB_USE2V3
1   constant ADKB_USE1V2
0   constant ADKB_USE0V1

1  15 <<  constant ADKF_SETCLR
1  14 <<  constant ADKF_PRECOMP1
1  13 <<  constant ADKF_PRECOMP0
1  12 <<  constant ADKF_MFMPREC
1  11 <<  constant ADKF_UARTBRK
1  10 <<  constant ADKF_WORDSYNC
1  9 <<  constant ADKF_MSBSYNC
1  8 <<  constant ADKF_FAST
1  7 <<  constant ADKF_USE3PN
1  6 <<  constant ADKF_USE2P3
1  5 <<  constant ADKF_USE1P2
1  4 <<  constant ADKF_USE0P1
1  3 <<  constant ADKF_USE3VN
1  2 <<  constant ADKF_USE2V3
1  1 <<  constant ADKF_USE1V2
1  0 <<  constant ADKF_USE0V1

0   constant ADKF_PRE000NS
ADKF_PRECOMP0   constant ADKF_PRE140NS
ADKF_PRECOMP1   constant ADKF_PRE280NS
ADKF_PRECOMP0  ADKF_PRECOMP1 |  constant ADKF_PRE560NS

.THEN
