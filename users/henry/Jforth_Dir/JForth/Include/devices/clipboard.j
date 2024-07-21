\ AMIGA JForth Include file.
decimal
EXISTS?     DEVICES_CLIPBOARD_H NOT .IF
: DEVICES_CLIPBOARD_H ;
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

include? CMD_NONSTD ji:exec/io.j ( %M)

CMD_NONSTD  0 +  constant CBD_POST
CMD_NONSTD  1 +  constant CBD_CURRENTREADID
CMD_NONSTD  2 +  constant CBD_CURRENTWRITEID
CMD_NONSTD  3 +  constant CBD_CHANGEHOOK

1   constant CBERR_OBSOLETEID

:STRUCT ClipboardUnitPartial
	STRUCT Node cu_Node
	ULONG cu_UnitNum
;STRUCT

:STRUCT IOClipReq
	STRUCT Message io_Message
	APTR io_Device
	APTR io_Unit
	USHORT io_Command
	UBYTE io_Flags
	BYTE io_Error
	ULONG io_Actual
	ULONG io_Length
	APTR io_Data
	ULONG io_Offset
	LONG io_ClipID
;STRUCT

0   constant PRIMARY_CLIP

:STRUCT SatisfyMsg
	STRUCT Message sm_Msg
	USHORT sm_Unit
	LONG sm_ClipID
;STRUCT

:STRUCT ClipHookMsg
	ULONG chm_Type
	LONG chm_ChangeCmd

	LONG chm_ClipID
;STRUCT

.THEN
