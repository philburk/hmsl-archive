\ AMIGA JForth Include file.
decimal
EXISTS? IFF_IFFPARSE_H NOT .IF
: IFF_IFFPARSE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN
EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN
EXISTS? DEVICES_CLIPBOARD_H NOT .IF
include ji:devices/clipboard.j
.THEN

:STRUCT IFFHandle
	ULONG iff_Stream
	ULONG iff_Flags
	LONG iff_Depth

;STRUCT

0  constant IFFF_READ
1  constant IFFF_WRITE
IFFF_READ  IFFF_WRITE |  constant IFFF_RWBITS
1 1 <<  constant IFFF_FSEEK
1 2 <<  constant IFFF_RSEEK
$ FFFF0000  constant IFFF_RESERVED

:STRUCT IFFStreamCmd
	LONG sc_Command
	APTR sc_Buf
	LONG sc_NBytes
;STRUCT

:STRUCT ContextNode
	STRUCT MinNode	cn_Node
	LONG cn_ID
	LONG cn_Type
	LONG cn_Size
	LONG cn_Scan
;STRUCT

:STRUCT LocalContextItem
	STRUCT MinNode	lci_Node
	ULONG lci_ID
	ULONG lci_Type ( %M )
	ULONG lci_Ident
;STRUCT

:STRUCT StoredProperty
	LONG sp_Size
	APTR sp_Data
;STRUCT

:STRUCT CollectionItem
	APTR ci_Next
	LONG ci_Size
	APTR ci_Data
;STRUCT

:STRUCT ClipboardHandle
	STRUCT IOClipReq	cbh_Req
	STRUCT MsgPort	cbh_CBport
	STRUCT MsgPort	cbh_SatisfyPort
;STRUCT

-1  constant IFFERR_EOF
-2  constant IFFERR_EOC
-3  constant IFFERR_NOSCOPE
-4  constant IFFERR_NOMEM
-5  constant IFFERR_READ
-6  constant IFFERR_WRITE
-7  constant IFFERR_SEEK
-8  constant IFFERR_MANGLED
-9  constant IFFERR_SYNTAX
-10  constant IFFERR_NOTIFF
-11  constant IFFERR_NOHOOK
-12  constant IFF_RETURN2CLIENT


: CHKID ( <chkid> <name> -- , define chkid )
	32 lword count drop odd@ constant
;

chkid FORM ID_FORM ( %M these done by hand )
chkid LIST ID_LIST
chkid PROP ID_PROP
chkid CAT  ID_CAT
$ 20202020 constant ID_NULL

chkid prop IFFLCI_PROP
chkid coll IFFLCI_COLLECTION
chkid enhd IFFLCI_ENTRYHANDLER
chkid exhd IFFLCI_EXITHANDLER
0 constant IFFPARSE_SCAN

1  constant IFFPARSE_STEP
2  constant IFFPARSE_RAWSTEP

1  constant IFFSLI_ROOT
2  constant IFFSLI_TOP
3  constant IFFSLI_PROP

-1  constant IFFSIZE_UNKNOWN

0   constant IFFCMD_INIT
1   constant IFFCMD_CLEANUP
2   constant IFFCMD_READ
3   constant IFFCMD_WRITE
4   constant IFFCMD_SEEK
5   constant IFFCMD_ENTRY
6   constant IFFCMD_EXIT
7   constant IFFCMD_PURGELCI

IFFCMD_INIT   constant IFFSCC_INIT
IFFCMD_CLEANUP   constant IFFSCC_CLEANUP
IFFCMD_READ   constant IFFSCC_READ
IFFCMD_WRITE   constant IFFSCC_WRITE
IFFCMD_SEEK   constant IFFSCC_SEEK

.THEN
