\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_CONUNIT_H NOT .IF
: DEVICES_CONUNIT_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? DEVICES_CONSOLE_H NOT .IF
include ji:devices/console.j
.THEN

EXISTS? DEVICES_KEYMAP_H NOT .IF
include ji:devices/keymap.j
.THEN

EXISTS? DEVICES_INPUTEVENT_H NOT .IF
include ji:devices/inputevent.j
.THEN

-1   constant CONU_LIBRARY
0   constant CONU_STANDARD

1   constant CONU_CHARMAP
3   constant CONU_SNIPMAP

0   constant CONFLAG_DEFAULT
1   constant CONFLAG_NODRAW_ON_NEWSIZE

M_LNM  1 +  constant PMB_ASM
PMB_ASM  1 +  constant PMB_AWM
80   constant MAXTABS

:STRUCT ConUnit
	STRUCT MsgPort cu_MP
	APTR cu_Window
	SHORT cu_XCP
	SHORT cu_YCP
	SHORT cu_XMax
	SHORT cu_YMax
	SHORT cu_XRSize
	SHORT cu_YRSize
	SHORT cu_XROrigin
	SHORT cu_YROrigin
	SHORT cu_XRExtant
	SHORT cu_YRExtant
	SHORT cu_XMinShrink
	SHORT cu_YMinShrink
	SHORT cu_XCCP
	SHORT cu_YCCP
	STRUCT KeyMap cu_KeyMapStruct
	( %?) MAXTABS 2 *  BYTES cu_TabStops
	BYTE cu_Mask
	BYTE cu_FgPen
	BYTE cu_BgPen
	BYTE cu_AOLPen
	BYTE cu_DrawMode
	BYTE cu_Obsolete1
	APTR cu_Obsolete2
	( %?) 8 BYTES cu_Minterms
	APTR cu_Font
	UBYTE cu_AlgoStyle
	UBYTE cu_TxFlags
	USHORT cu_TxHeight
	USHORT cu_TxWidth
	USHORT cu_TxBaseline
	SHORT cu_TxSpacing
PMB_AWM 7 + 8 / BYTES cu_modes ( %M )
IECLASS_MAX 8 + 8 / BYTES cu_RawEvents ( %M )
;STRUCT

.THEN
