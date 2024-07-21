\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_EXPANSIONBASE_H NOT .IF
: LIBRARIES_EXPANSIONBASE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? EXEC_SEMAPHORES_H NOT .IF
include ji:exec/semaphores.j
.THEN

EXISTS? LIBRARIES_CONFIGVARS_H NOT .IF
include ji:libraries/configvars.j
.THEN

:STRUCT BootNode
	STRUCT Node bn_Node
	USHORT bn_Flags
	APTR bn_DeviceNode
;STRUCT

:STRUCT ExpansionBase
	STRUCT Library	eb_LibNode ( %M )
	UBYTE eb_Flags
	UBYTE eb_Private01
	ULONG eb_Private02
	ULONG eb_Private03
	STRUCT CurrentBinding	eb_Private04
	STRUCT List	eb_Private05
	STRUCT List	eb_MountList

;STRUCT

0   constant EE_OK
40   constant EE_LASTBOARD
41   constant EE_NOEXPANSION
42   constant EE_NOMEMORY
43   constant EE_NOBOARD
44   constant EE_BADMEM

0   constant EBB_CLOGGED
1  0 <<  constant EBF_CLOGGED
1   constant EBB_SHORTMEM
1  1 <<  constant EBF_SHORTMEM
2   constant EBB_BADMEM
1  2 <<  constant EBF_BADMEM
3   constant EBB_DOSFLAG
1  3 <<  constant EBF_DOSFLAG
4   constant EBB_KICKBACK33
1  4 <<  constant EBF_KICKBACK33
5   constant EBB_KICKBACK36
1  5 <<  constant EBF_KICKBACK36
6   constant EBB_SILENTSTART
1  6 <<  constant EBF_SILENTSTART

.THEN
