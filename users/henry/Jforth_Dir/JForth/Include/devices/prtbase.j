\ AMIGA JForth Include file.
decimal
EXISTS?  DEVICES_PRTBASE_H NOT .IF
: DEVICES_PRTBASE_H ;
EXISTS?  EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN
EXISTS?  EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN
EXISTS?  EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN
EXISTS?  EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN
EXISTS?  EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN
EXISTS?  EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN

EXISTS?  DEVICES_PARALLEL_H NOT .IF
include ji:devices/parallel.j
.THEN
EXISTS?  DEVICES_SERIAL_H NOT .IF
include ji:devices/serial.j
.THEN
EXISTS?  DEVICES_TIMER_H NOT .IF
include ji:devices/timer.j
.THEN
EXISTS?  LIBRARIES_DOSEXTENS_H NOT .IF
include ji:libraries/dosextens.j
.THEN
EXISTS?  INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

:STRUCT DeviceData
	STRUCT Library dd_Device
	APTR dd_Segment
	APTR dd_ExecBase
	APTR dd_CmdVectors
	APTR dd_CmdBytes
	USHORT dd_NumCommands
;STRUCT

$ 0800   constant P_OLDSTKSIZE
$ 1000   constant P_STKSIZE
256   constant P_BUFSIZE
128   constant P_SAFESIZE

:STRUCT PrinterData
	STRUCT DeviceData pd_Device
	STRUCT MsgPort pd_Unit
	LONG pd_PrinterSegment
	USHORT pd_PrinterType
	APTR pd_SegmentData
	APTR pd_PrintBuf
APTR pd_PWrite ( %M )
APTR pd_PBothReady ( %M )
\ Fake unions
	STRUCT IOExtSer pd_ior0  ( use Ser since it's bigger )
	STRUCT IOExtSer pd_ior1
		STRUCT timerequest pd_TIOR
		STRUCT MsgPort pd_IORPort
		STRUCT Exec_Task pd_TC ( %M !!! TASK renamed )
		( %?) P_OLDSTKSIZE BYTES pd_OldStk
		UBYTE pd_Flags
		UBYTE pd_pad
		STRUCT Preferences pd_Preferences
		UBYTE pd_PWaitEnabled
		UBYTE pd_Flags1
		( %?) P_STKSIZE BYTES pd_Stk
;STRUCT

0   constant PPCB_GFX
$ 1   constant PPCF_GFX
1   constant PPCB_COLOR
$ 2   constant PPCF_COLOR

$ 00   constant PPC_BWALPHA
$ 01   constant PPC_BWGFX
$ 02   constant PPC_COLORALPHA
$ 03   constant PPC_COLORGFX

$ 01   constant PCC_BW
$ 02   constant PCC_YMC
$ 03   constant PCC_YMC_BW
$ 04   constant PCC_YMCB
$ 04   constant PCC_4COLOR
$ 08   constant PCC_ADDITIVE
$ 09   constant PCC_WB
$ 0A   constant PCC_BGR
$ 0B   constant PCC_BGR_WB
$ 0C   constant PCC_BGRW
$ 10   constant PCC_MULTI_PASS

:STRUCT PrinterExtendedData
	APTR ped_PrinterName
APTR ped_Init ( %M )
APTR ped_Expunge ( %M )
APTR ped_Open ( %M )
APTR ped_Close ( %M )
	UBYTE ped_PrinterClass
	UBYTE ped_ColorClass
	UBYTE ped_MaxColumns
	UBYTE ped_NumCharSets
	USHORT ped_NumRows
	ULONG ped_MaxXDots
	ULONG ped_MaxYDots
	USHORT ped_XDotsInch
	USHORT ped_YDotsInch
	APTR ped_Commands
APTR ped_DoSpecial ( %M )
APTR ped_Render ( %M )
	LONG ped_TimeoutSecs
	APTR ped_8BitChars
	LONG ped_PrintMode
APTR ped_ConvFunc ( %M )
;STRUCT

:STRUCT PrinterSegment
	ULONG ps_NextSegment
	ULONG ps_runAlert
	USHORT ps_Version
	USHORT ps_Revision
	STRUCT PrinterExtendedData ps_PED
;STRUCT

.THEN
