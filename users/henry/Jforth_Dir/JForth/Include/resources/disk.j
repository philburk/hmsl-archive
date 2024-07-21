\ AMIGA JForth Include file.
decimal
EXISTS? RESOURCES_DISK_H NOT .IF
: RESOURCES_DISK_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? EXEC_INTERRUPTS_H NOT .IF
include ji:exec/interrupts.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

:STRUCT DiscResourceUnit
	STRUCT Message dru_Message
	STRUCT Interrupt dru_DiscBlock
	STRUCT Interrupt dru_DiscSync
	STRUCT Interrupt dru_Index
;STRUCT

:STRUCT DiscResource
	STRUCT Library	dr_Library
	APTR dr_Current
	UBYTE dr_Flags
	UBYTE dr_pad
	APTR dr_SysLib
	APTR dr_CiaResource
	( %?) 4 4 *  BYTES dr_UnitID
	STRUCT List	dr_Waiting
	STRUCT Interrupt	dr_DiscBlock
	STRUCT Interrupt	dr_DiscSync
	STRUCT Interrupt	dr_Index
	APTR dr_CurrTask
;STRUCT

0   constant DRB_ALLOC0
1   constant DRB_ALLOC1
2   constant DRB_ALLOC2
3   constant DRB_ALLOC3
7   constant DRB_ACTIVE

1  0 <<  constant DRF_ALLOC0
1  1 <<  constant DRF_ALLOC1
1  2 <<  constant DRF_ALLOC2
1  3 <<  constant DRF_ALLOC3
1  7 <<  constant DRF_ACTIVE

$ 4000   constant DSKDMAOFF

0" disk.resource" 0string DISKNAME ( %M )

LIB_BASE  0 LIB_VECTSIZE * - constant DR_ALLOCUNIT
LIB_BASE  1 LIB_VECTSIZE * - constant DR_FREEUNIT
LIB_BASE  2 LIB_VECTSIZE * - constant DR_GETUNIT
LIB_BASE  3 LIB_VECTSIZE * - constant DR_GIVEUNIT
LIB_BASE  4 LIB_VECTSIZE * - constant DR_GETUNITID
LIB_BASE  5 LIB_VECTSIZE * - constant DR_READUNITID

DR_READUNITID   constant DR_LASTCOMM

$ 00000000   constant DRT_AMIGA
$ 55555555   constant DRT_37422D2S
$ FFFFFFFF   constant DRT_EMPTY
$ AAAAAAAA   constant DRT_150RPM

.THEN
