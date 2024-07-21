\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_GFXNODES_H NOT .IF
: GRAPHICS_GFXNODES_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT ExtendedNode
	APTR xln_Succ
	APTR xln_Pred
	UBYTE xln_Type
	BYTE xln_Pri
	APTR xln_Name
	UBYTE xln_Subsystem
	UBYTE xln_Subtype
	LONG xln_Library
	APTR xln_Init
;STRUCT

$ 02   constant SS_GRAPHICS

1   constant VIEW_EXTRA_TYPE
2   constant VIEWPORT_EXTRA_TYPE
3   constant SPECIAL_MONITOR_TYPE
4   constant MONITOR_SPEC_TYPE

.THEN
