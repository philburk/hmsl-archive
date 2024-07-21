\ AMIGA JForth Include file.
\ 00001 PLB 5/22/92 Fix VSIZEBITS, thanks Jerry Kallaus
decimal
EXISTS? HARDWARE_BLIT_H NOT .IF
: HARDWARE_BLIT_H ;
6   constant HSIZEBITS
16  HSIZEBITS -  constant VSIZEBITS \ 00001
$ 3f   constant HSIZEMASK
$ 3FF   constant VSIZEMASK

EXISTS?  NO_BIG_BLITS NOT .IF
128   constant MINBYTESPERROW
4096   constant MAXBYTESPERROW
.ELSE
128   constant MAXBYTESPERROW
.THEN

$ 80   constant ABC
$ 40   constant ABNC
$ 20   constant ANBC
$ 10   constant ANBNC
$ 8   constant NABC
$ 4   constant NABNC
$ 2   constant NANBC
$ 1   constant NANBNC

ABC  ANBC | NABC | ABNC | ANBNC | NABNC |  constant A_OR_B
ABC  NABC | ABNC | ANBC | NANBC | ANBNC |  constant A_OR_C
NABC  ABNC | NANBC | ANBNC |  constant A_XOR_C
ABC  ANBC | ABNC | ANBNC |  constant A_TO_D

8   constant BC0B_DEST
9   constant BC0B_SRCC
10   constant BC0B_SRCB
11   constant BC0B_SRCA
$ 100   constant BC0F_DEST
$ 200   constant BC0F_SRCC
$ 400   constant BC0F_SRCB
$ 800   constant BC0F_SRCA

2   constant BC1F_DESC

$ 100   constant DEST
$ 200   constant SRCC
$ 400   constant SRCB
$ 800   constant SRCA

12   constant ASHIFTSHIFT
12   constant BSHIFTSHIFT

$ 1   constant LINEMODE
$ 8   constant FILL_OR
$ 10   constant FILL_XOR
$ 4   constant FILL_CARRYIN
$ 2   constant ONEDOT
$ 20   constant OVFLAG
$ 40   constant SIGNFLAG
$ 2   constant BLITREVERSE

$ 10   constant SUD
$ 8   constant SUL
$ 4   constant AUL

24   constant OCTANT8
4   constant OCTANT7
12   constant OCTANT6
28   constant OCTANT5
20   constant OCTANT4
8   constant OCTANT3
0   constant OCTANT2
16   constant OCTANT1

:STRUCT bltnode
	( %M JForth prefix ) APTR bn_n
APTR bn_function ( %M )
	BYTE bn_stat
	SHORT bn_blitsize
	SHORT bn_beamsync
APTR bn_cleanup ( %M )
;STRUCT

$ 40   constant CLEANUP
CLEANUP   constant CLEANME

.THEN
