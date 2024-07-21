\ AMIGA JForth Include file.
decimal
EXISTS? HARDWARE_INTBITS_H NOT .IF
: HARDWARE_INTBITS_H ;
15   constant INTB_SETCLR


14   constant INTB_INTEN
13   constant INTB_EXTER
12   constant INTB_DSKSYNC
11   constant INTB_RBF
10   constant INTB_AUD3
9   constant INTB_AUD2
8   constant INTB_AUD1
7   constant INTB_AUD0
6   constant INTB_BLIT
5   constant INTB_VERTB
4   constant INTB_COPER
3   constant INTB_PORTS
2   constant INTB_SOFTINT
1   constant INTB_DSKBLK
0   constant INTB_TBE

1  15 <<  constant INTF_SETCLR
1  14 <<  constant INTF_INTEN
1  13 <<  constant INTF_EXTER
1  12 <<  constant INTF_DSKSYNC
1  11 <<  constant INTF_RBF
1  10 <<  constant INTF_AUD3
1  9 <<  constant INTF_AUD2
1  8 <<  constant INTF_AUD1
1  7 <<  constant INTF_AUD0
1  6 <<  constant INTF_BLIT
1  5 <<  constant INTF_VERTB
1  4 <<  constant INTF_COPER
1  3 <<  constant INTF_PORTS
1  2 <<  constant INTF_SOFTINT
1  1 <<  constant INTF_DSKBLK
1  0 <<  constant INTF_TBE

.THEN
