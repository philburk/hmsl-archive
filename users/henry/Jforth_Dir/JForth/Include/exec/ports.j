\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? EXEC_PORTS_H NOT .IF
: EXEC_PORTS_H ;

include? EXEC_NODES_H ji:exec/nodes.j
include? EXEC_LISTS_H ji:exec/lists.j
include? EXEC_TASKS_H ji:exec/tasks.j

:STRUCT MsgPort
	STRUCT Node	mp_Node
	UBYTE mp_Flags
	UBYTE mp_SigBit
		UNION{
			APTR mp_SigTask
		}UNION{
			APTR mp_SoftInt
		}UNION
	STRUCT List	mp_MsgList
;STRUCT

3   constant PF_ACTION
0   constant PA_SIGNAL
1   constant PA_SOFTINT
2   constant PA_IGNORE

:STRUCT Message
	STRUCT Node	mn_Node
	APTR mn_ReplyPort
	USHORT mn_Length
;STRUCT

.THEN
