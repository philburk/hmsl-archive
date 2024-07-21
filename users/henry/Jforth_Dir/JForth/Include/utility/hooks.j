\ AMIGA JForth Include file.
decimal
EXISTS? UTILITY_HOOKS_H NOT .IF
TRUE   constant UTILITY_HOOKS_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT Hook
	STRUCT MinNode	h_MinNode
	APTR h_Entry ( %M )
	APTR h_SubEntry ( %M )
	APTR h_Data
;STRUCT

.THEN
