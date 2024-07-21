\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_DOS_H NOT .IF
: LIBRARIES_DOS_H ;
EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

.THEN
