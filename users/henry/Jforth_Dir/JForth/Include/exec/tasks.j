\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_TASKS_H NOT .IF
: EXEC_TASKS_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

:STRUCT Exec_Task  ( !!! Renamed to avoid name conflict. )
	STRUCT Node tc_Node
	UBYTE tc_Flags
	UBYTE tc_State
	BYTE tc_IDNestCnt
	BYTE tc_TDNestCnt
	ULONG tc_SigAlloc
	ULONG tc_SigWait
	ULONG tc_SigRecvd
	ULONG tc_SigExcept
	USHORT tc_TrapAlloc
	USHORT tc_TrapAble
	APTR tc_ExceptData
	APTR tc_ExceptCode
	APTR tc_TrapData
	APTR tc_TrapCode
	APTR tc_SPReg
	APTR tc_SPLower
	APTR tc_SPUpper
APTR tc_Switch ( %M )
APTR tc_Launch ( %M )
	STRUCT List tc_MemEntry
	APTR tc_UserData
;STRUCT

0   constant TB_PROCTIME
3   constant TB_ETASK
4   constant TB_STACKCHK
5   constant TB_EXCEPT
6   constant TB_SWITCH
7   constant TB_LAUNCH

1  0 <<  constant TF_PROCTIME
1  3 <<  constant TF_ETASK
1  4 <<  constant TF_STACKCHK
1  5 <<  constant TF_EXCEPT
1  6 <<  constant TF_SWITCH
1  7 <<  constant TF_LAUNCH

0   constant TS_INVALID
1   constant TS_ADDED
2   constant TS_RUN
3   constant TS_READY
4   constant TS_WAIT
5   constant TS_EXCEPT
6   constant TS_REMOVED

0   constant SIGB_ABORT
1   constant SIGB_CHILD
4   constant SIGB_BLIT
4   constant SIGB_SINGLE
5   constant SIGB_INTUITION
8   constant SIGB_DOS

1 0 <<  constant SIGF_ABORT
1 1 <<  constant SIGF_CHILD
1 4 <<  constant SIGF_BLIT
1 4 <<  constant SIGF_SINGLE
1 5 <<  constant SIGF_INTUITION
1 8 <<  constant SIGF_DOS

.THEN
