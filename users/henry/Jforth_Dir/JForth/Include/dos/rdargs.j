\ AMIGA JForth Include file.
decimal
EXISTS? DOS_RDARGS_H NOT .IF
: DOS_RDARGS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT CSource
	APTR CS_Buffer
	LONG CS_Length
	LONG CS_CurChr
;STRUCT

:STRUCT RDArgs
	STRUCT CSource RDA_Source
	LONG RDA_DAList
	APTR RDA_Buffer
	LONG RDA_BufSiz
	APTR RDA_ExtHelp
	LONG RDA_Flags
;STRUCT

0   constant RDAB_STDIN
1   constant RDAF_STDIN
1   constant RDAB_NOALLOC
2   constant RDAF_NOALLOC
2   constant RDAB_NOPROMPT
4   constant RDAF_NOPROMPT

100   constant MAX_TEMPLATE_ITEMS

128   constant MAX_MULTIARGS

.THEN
