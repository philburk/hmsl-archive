\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_NODES_H NOT .IF
: EXEC_NODES_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT Node
	APTR ln_Succ
	APTR ln_Pred
	UBYTE ln_Type
	BYTE ln_Pri
	APTR ln_Name
;STRUCT


:STRUCT MinNode
	APTR mln_Succ
	APTR mln_Pred
;STRUCT

0   constant NT_UNKNOWN
1   constant NT_TASK
2   constant NT_INTERRUPT
3   constant NT_DEVICE
4   constant NT_MSGPORT
5   constant NT_MESSAGE
6   constant NT_FREEMSG
7   constant NT_REPLYMSG
8   constant NT_RESOURCE
9   constant NT_LIBRARY
10   constant NT_MEMORY
11   constant NT_SOFTINT
12   constant NT_FONT
13   constant NT_PROCESS
14   constant NT_SEMAPHORE
15   constant NT_SIGNALSEM
16   constant NT_BOOTNODE
17   constant NT_KICKMEM
18   constant NT_GRAPHICS
19   constant NT_DEATHMESSAGE

254   constant NT_USER
255   constant NT_EXTENDED

.THEN
