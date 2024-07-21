\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_INTERRUPTS_H NOT .IF
: EXEC_INTERRUPTS_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

:STRUCT Interrupt
	STRUCT Node is_Node
	APTR is_Data
APTR IS_CODE  \ pointer to a function
;STRUCT

:STRUCT IntVector
	APTR iv_Data
APTR iv_code  \ pointer to a function
	APTR iv_Node
;STRUCT

:STRUCT SoftIntList
	STRUCT List sh_List
	USHORT sh_Pad
;STRUCT

$ f0   constant SIH_PRIMASK

15   constant INTB_NMI
1  15 <<  constant INTF_NMI

.THEN
