\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_SEMAPHORES_H NOT .IF
: EXEC_SEMAPHORES_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN

:STRUCT SemaphoreRequest
	STRUCT MinNode sr_Link
	APTR sr_Waiter
;STRUCT

:STRUCT SignalSemaphore
	STRUCT Node ss_Link
	SHORT ss_NestCount
	STRUCT MinList ss_WaitQueue
	STRUCT SemaphoreRequest ss_MultipleLink
	APTR ss_Owner
	SHORT ss_QueueCount
;STRUCT

:STRUCT Semaphore
	STRUCT MsgPort sm_MsgPort
	SHORT sm_Bids
;STRUCT

\ ( %M ) mp_SigTask   constant sm_LockMsg

.THEN
