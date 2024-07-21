\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_MATHLIBRARY_H NOT .IF
: LIBRARIES_MATHLIBRARY_H ;
EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

:STRUCT MathIEEEBase
	STRUCT Library MathIEEEBase_LibNode
18 BYTES MathIEEEBase_reserved ( %M )
APTR MathIEEEBase_TaskOpenLib ( %M )
APTR MathIEEEBase_TaskCloseib ( %M )

;STRUCT

.THEN
