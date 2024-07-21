\ AMIGA JForth Include file.
decimal
EXISTS? RESOURCES_MISC_H NOT .IF
: RESOURCES_MISC_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

0   constant MR_SERIALPORT
1   constant MR_SERIALBITS
2   constant MR_PARALLELPORT
3   constant MR_PARALLELBITS
LIB_BASE   constant MR_ALLOCMISCRESOURCE
LIB_BASE  LIB_VECTSIZE -   constant MR_FREEMISCRESOURCE

0" misc.resource" 0string MISCNAME ( %M )

.THEN
