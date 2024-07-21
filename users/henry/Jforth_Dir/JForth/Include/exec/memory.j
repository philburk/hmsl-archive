\ AMIGA JForth Include file.
\ 00001 PLB 12/3/91 Fixed ML_ME , thanks Jerry Kallaus

decimal
EXISTS? EXEC_MEMORY_H NOT .IF
: EXEC_MEMORY_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT MemChunk
	APTR mc_Next
	ULONG mc_Bytes
;STRUCT

:STRUCT MemHeader
	STRUCT Node mh_Node
	USHORT mh_Attributes
	APTR mh_First
	APTR mh_Lower
	APTR mh_Upper
	ULONG mh_Free
;STRUCT

:STRUCT MemEntry
union{
	ULONG meu_Reqs
}union{
	APTR meu_Addr
}union \ %? } me_Un;
	ULONG me_Length
;STRUCT

\ me_Un   constant me_un
\ %? #define me_Reqs     me_Un.meu_Reqs
\ %? #define me_Addr     me_Un.meu_Addr

:STRUCT MemList
	STRUCT Node ml_Node
	USHORT ml_NumEntries
	STRUCT MemEntry ml_ME \ the first of several, 00001
;STRUCT

\ me_Un  me_Un  ml_ME   constant ml_me

\ 0  constant MEMF_ANY
1 0 <<  constant MEMF_PUBLIC
1 1 <<  constant MEMF_CHIP
1 2 <<  constant MEMF_FAST
1 8 <<  constant MEMF_LOCAL
1 9 <<  constant MEMF_24BITDMA

1 16 <<  constant MEMF_CLEAR
1 17 <<  constant MEMF_LARGEST
1 18 <<  constant MEMF_REVERSE
1 19 <<  constant MEMF_TOTAL

8  constant MEM_BLOCKSIZE
MEM_BLOCKSIZE  1-   constant MEM_BLOCKMASK ( %M )

.THEN
