\ AMIGA JForth Include file.
decimal
EXISTS? REXX_STORAGE_H NOT .IF
: REXX_STORAGE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

:STRUCT NexxStr
	LONG ns_Ivalue
	USHORT ns_Length
	UBYTE ns_Flags
	UBYTE ns_Hash
	( %?) 8 BYTES ns_Buff
	;STRUCT


9   constant NXADDLEN
\ %? #define IVALUE(nsPtr) (nsPtr->ns_Ivalue): IVALUE ;

0   constant NSB_KEEP
1   constant NSB_STRING
2   constant NSB_NOTNUM
3   constant NSB_NUMBER
4   constant NSB_BINARY
5   constant NSB_FLOAT
6   constant NSB_EXT
7   constant NSB_SOURCE

1  NSB_KEEP <<  constant NSF_KEEP
1  NSB_STRING <<  constant NSF_STRING
1  NSB_NOTNUM <<  constant NSF_NOTNUM
1  NSB_NUMBER <<  constant NSF_NUMBER
1  NSB_BINARY <<  constant NSF_BINARY
1  NSB_FLOAT <<  constant NSF_FLOAT
1  NSB_EXT <<  constant NSF_EXT
1  NSB_SOURCE <<  constant NSF_SOURCE

NSF_NUMBER  NSF_BINARY | NSF_STRING |  constant NSF_INTNUM
NSF_NUMBER  NSF_FLOAT |  constant NSF_DPNUM
NSF_NOTNUM  NSF_STRING |  constant NSF_ALPHA
NSF_SOURCE  NSF_EXT | NSF_KEEP |  constant NSF_OWNED
NSF_STRING  NSF_SOURCE | NSF_NOTNUM |  constant KEEPSTR
NSF_STRING  NSF_SOURCE | NSF_NUMBER | NSF_BINARY |  constant KEEPNUM

:STRUCT RexxArg
	LONG ra_Size
	USHORT ra_Length
	UBYTE ra_Flags
	UBYTE ra_Hash
	( %?) 8 BYTES ra_Buff
	;STRUCT


:STRUCT RexxMsg
	STRUCT Message rm_Node
	APTR rm_TaskBlock
	APTR rm_LibBase
	LONG rm_Action
	LONG rm_Result1
	LONG rm_Result2
	( %?) 16 4 *  BYTES rm_Args
	APTR rm_PassPort
	APTR rm_CommAddr
	APTR rm_FileExt
	LONG rm_Stdin
	LONG rm_Stdout
	LONG rm_avail
	;STRUCT


\ %? #define ARG0(rmp) (rmp->rm_Args[0])    /* start of argblock		*/: ARG0 ;
\ %? #define ARG1(rmp) (rmp->rm_Args[1])    /* first argument		*/: ARG1 ;
\ %? #define ARG2(rmp) (rmp->rm_Args[2])    /* second argument		*/: ARG2 ;

15   constant MAXRMARG

$ 01000000   constant RXCOMM
$ 02000000   constant RXFUNC
$ 03000000   constant RXCLOSE
$ 04000000   constant RXQUERY
$ 07000000   constant RXADDFH
$ 08000000   constant RXADDLIB
$ 09000000   constant RXREMLIB
$ 0A000000   constant RXADDCON
$ 0B000000   constant RXREMCON
$ 0C000000   constant RXTCOPN
$ 0D000000   constant RXTCCLS

16   constant RXFB_NOIO
17   constant RXFB_RESULT
18   constant RXFB_STRING
19   constant RXFB_TOKEN
20   constant RXFB_NONRET

1 RXFB_NOIO <<  constant RXFF_NOIO
1 RXFB_RESULT <<  constant RXFF_RESULT
1 RXFB_STRING <<  constant RXFF_STRING
1 RXFB_TOKEN <<  constant RXFF_TOKEN
1 RXFB_NONRET <<  constant RXFF_NONRET

$ FF000000   constant RXCODEMASK
$ 0000000F   constant RXARGMASK

:STRUCT RexxRsrc
	STRUCT Node rr_Node
	SHORT rr_Func
	APTR rr_Base
	LONG rr_Size
	LONG rr_Arg1
	LONG rr_Arg2
	;STRUCT


0   constant RRT_ANY
1   constant RRT_LIB
2   constant RRT_PORT
3   constant RRT_FILE
4   constant RRT_HOST
5   constant RRT_CLIP

200   constant GLOBALSZ

:STRUCT RexxTask
	( %?) GLOBALSZ BYTES rt_Global
	STRUCT MsgPort rt_MsgPort
	UBYTE rt_Flags
	BYTE rt_SigBit
	APTR rt_ClientID
	APTR rt_MsgPkt
	APTR rt_TaskID
	APTR rt_RexxPort
	APTR rt_ErrTrap
	APTR rt_StackPtr
	STRUCT List rt_Header1
	STRUCT List rt_Header2
	STRUCT List rt_Header3
	STRUCT List rt_Header4
	STRUCT List rt_Header5
	;STRUCT

0   constant RTFB_TRACE
1   constant RTFB_HALT
2   constant RTFB_SUSP
3   constant RTFB_TCUSE
6   constant RTFB_WAIT
7   constant RTFB_CLOSE

16  constant MEMQUANT
$ FFFFFFF0   constant MEMMASK

1 0 <<  constant MEMQUICK
1 16 <<  constant MEMCLEAR

:STRUCT SrcNode
	APTR sn_Succ
	APTR sn_Pred
	APTR sn_Ptr
	LONG sn_Size
	;STRUCT


.THEN
