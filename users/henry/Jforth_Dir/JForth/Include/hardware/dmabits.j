\ AMIGA JForth Include file.
decimal
EXISTS? HARDWARE_DMABITS_H NOT .IF
: HARDWARE_DMABITS_H ;
$ 8000   constant DMAF_SETCLR
$ 000F   constant DMAF_AUDIO
$ 0001   constant DMAF_AUD0
$ 0002   constant DMAF_AUD1
$ 0004   constant DMAF_AUD2
$ 0008   constant DMAF_AUD3
$ 0010   constant DMAF_DISK
$ 0020   constant DMAF_SPRITE
$ 0040   constant DMAF_BLITTER
$ 0080   constant DMAF_COPPER
$ 0100   constant DMAF_RASTER
$ 0200   constant DMAF_MASTER
$ 0400   constant DMAF_BLITHOG
$ 01FF   constant DMAF_ALL

$ 4000   constant DMAF_BLTDONE
$ 2000   constant DMAF_BLTNZERO

15   constant DMAB_SETCLR
0   constant DMAB_AUD0
1   constant DMAB_AUD1
2   constant DMAB_AUD2
3   constant DMAB_AUD3
4   constant DMAB_DISK
5   constant DMAB_SPRITE
6   constant DMAB_BLITTER
7   constant DMAB_COPPER
8   constant DMAB_RASTER
9   constant DMAB_MASTER
10   constant DMAB_BLITHOG
14   constant DMAB_BLTDONE
13   constant DMAB_BLTNZERO

.THEN
