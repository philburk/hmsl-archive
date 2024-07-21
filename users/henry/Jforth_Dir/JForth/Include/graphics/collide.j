\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_COLLIDE_H NOT .IF
: GRAPHICS_COLLIDE_H ;
0   constant BORDERHIT

1   constant TOPHIT
2   constant BOTTOMHIT
4   constant LEFTHIT
8   constant RIGHTHIT

.THEN
