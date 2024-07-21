\ AMIGA JForth Include file.
decimal
EXISTS? DOS_VAR_H NOT .IF
: DOS_VAR_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT LocalVar
	STRUCT Node lv_Node
	USHORT lv_Flags
	APTR lv_Value
	ULONG lv_Len
;STRUCT

0   constant LV_VAR
1   constant LV_ALIAS
7   constant LVB_IGNORE
$ 80   constant LVF_IGNORE

8   constant GVB_GLOBAL_ONLY
$ 100   constant GVF_GLOBAL_ONLY
9   constant GVB_LOCAL_ONLY
$ 200   constant GVF_LOCAL_ONLY
10   constant GVB_BINARY_VAR
$ 400   constant GVF_BINARY_VAR

.THEN
