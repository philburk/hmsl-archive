\ AMIGA JForth Include file.
decimal
EXISTS? REXX_RXSLIB_H NOT .IF
: REXX_RXSLIB_H ;
EXISTS? REXX_STORAGE_H NOT .IF
include ji:rexx/storage.j
.THEN

0" rexxsyslib.library" 0string RXSNAME ( %M )
0" REXX" 0string RXSDIR ( %M )
0" ARexx" 0string RXSTNAME ( %M )

:STRUCT RxsLib
	STRUCT Library rl_Node
	UBYTE rl_Flags
	UBYTE rl_Shadow
	APTR rl_SysBase
	APTR rl_DOSBase
	APTR rl_IeeeDPBase
	LONG rl_SegList
	LONG rl_NIL
	LONG rl_Chunk
	LONG rl_MaxNest
	APTR rl_NULL
	APTR rl_FALSE
	APTR rl_TRUE
	APTR rl_REXX
	APTR rl_COMMAND
	APTR rl_STDIN
	APTR rl_STDOUT
	APTR rl_STDERR
	APTR rl_Version
	APTR rl_TaskName
	LONG rl_TaskPri
	LONG rl_TaskSeg
	LONG rl_StackSize
	APTR rl_RexxDir
	APTR rl_CTABLE
	APTR rl_Notice
	STRUCT MsgPort rl_RexxPort
	USHORT rl_ReadLock
	LONG rl_TraceFH
	STRUCT List rl_TaskList
	SHORT rl_NumTask
	STRUCT List rl_LibList
	SHORT rl_NumLib
	STRUCT List rl_ClipList
	SHORT rl_NumClip
	STRUCT List rl_MsgList
	SHORT rl_NumMsg
	STRUCT List rl_PgmList
	SHORT rl_NumPgm
	USHORT rl_TraceCnt
	SHORT rl_avail
	;STRUCT

RTFB_TRACE   constant RLFB_TRACE
RTFB_HALT   constant RLFB_HALT
RTFB_SUSP   constant RLFB_SUSP
6   constant RLFB_STOP
7   constant RLFB_CLOSE

1  RLFB_TRACE <<  1 RLFB_HALT << |  1 RLFB_SUSP << | constant RLFMASK ( %M)

1024   constant RXSCHUNK
32   constant RXSNEST
0   constant RXSTPRI
4096   constant RXSSTACK

0   constant CTB_SPACE
1   constant CTB_DIGIT
2   constant CTB_ALPHA
3   constant CTB_REXXSYM
4   constant CTB_REXXOPR
5   constant CTB_REXXSPC
6   constant CTB_UPPER
7   constant CTB_LOWER

1  CTB_SPACE <<  constant CTF_SPACE
1  CTB_DIGIT <<  constant CTF_DIGIT
1  CTB_ALPHA <<  constant CTF_ALPHA
1  CTB_REXXSYM <<  constant CTF_REXXSYM
1  CTB_REXXOPR <<  constant CTF_REXXOPR
1  CTB_REXXSPC <<  constant CTF_REXXSPC
1  CTB_UPPER <<  constant CTF_UPPER
1  CTB_LOWER <<  constant CTF_LOWER

.THEN
