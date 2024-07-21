\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_CONFIGVARS_H NOT .IF
: LIBRARIES_CONFIGVARS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? LIBRARIES_CONFIGREGS_H NOT .IF
include ji:libraries/configregs.j
.THEN

:STRUCT ConfigDev
	STRUCT Node	cd_Node
	UBYTE cd_Flags
	UBYTE cd_Pad
	STRUCT ExpansionRom	cd_Rom
	APTR cd_BoardAddr
	ULONG cd_BoardSize
	USHORT cd_SlotAddr
	USHORT cd_SlotSize
	APTR cd_Driver
	APTR cd_NextCD
	( %?) 4 4 *  BYTES cd_Unused
;STRUCT

0   constant CDB_SHUTUP
1   constant CDB_CONFIGME
2   constant CDB_BADMEMORY

$ 01   constant CDF_SHUTUP
$ 02   constant CDF_CONFIGME
$ 04   constant CDF_BADMEMORY

:STRUCT CurrentBinding
	APTR cb_ConfigDev
	APTR cb_FileName
	APTR cb_ProductString
	APTR cb_ToolTypes
;STRUCT

.THEN
