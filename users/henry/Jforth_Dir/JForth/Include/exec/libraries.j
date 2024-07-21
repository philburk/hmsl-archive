\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_LIBRARIES_H NOT .IF
: EXEC_LIBRARIES_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

6   constant LIB_VECTSIZE
4   constant LIB_RESERVED
LIB_VECTSIZE negate  constant LIB_BASE ( %M fixed H2J -L bug! )
( %M ) LIB_BASE LIB_RESERVED LIB_VECTSIZE * - constant LIB_USERDEF
LIB_USERDEF   constant LIB_NONSTD

-6   constant LIB_OPEN
-12   constant LIB_CLOSE
-18   constant LIB_EXPUNGE
-24   constant LIB_EXTFUNC

:STRUCT Library
	STRUCT Node lib_Node
	UBYTE lib_Flags
	UBYTE lib_pad
	USHORT lib_NegSize
	USHORT lib_PosSize
	USHORT lib_Version
	USHORT lib_Revision
	APTR lib_IdString
	ULONG lib_Sum
	USHORT lib_OpenCnt
;STRUCT


1  0 <<  constant LIBF_SUMMING
1  1 <<  constant LIBF_CHANGED
1  2 <<  constant LIBF_SUMUSED
1  3 <<  constant LIBF_DELEXP

( %M , removed LH_NODE aliases , etc. )

.THEN
