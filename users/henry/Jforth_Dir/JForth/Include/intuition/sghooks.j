\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_SGHOOKS_H NOT .IF
TRUE   constant INTUITION_SGHOOKS_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT StringExtend
	( %M JForth prefix ) APTR sex_Font
	( %?) 2 BYTES sex_Pens
	( %?) 2 BYTES sex_ActivePens
	ULONG sex_InitialModes
	APTR sex_EditHook
	APTR sex_WorkBuffer
	( %?) 4 4 *  BYTES sex_Reserved
;STRUCT

:STRUCT SGWork
	( %M JForth prefix ) APTR sgw_Gadget
	APTR sgw_StringInfo
	APTR sgw_WorkBuffer
	APTR sgw_PrevBuffer
	ULONG sgw_Modes
	APTR sgw_IEvent
	USHORT sgw_Code
	SHORT sgw_BufferPos
	SHORT sgw_NumChars
	ULONG sgw_Actions
	LONG sgw_LongInt
	APTR sgw_GadgetInfo
	USHORT sgw_EditOp
;STRUCT

$ 0001   constant EO_NOOP

$ 0002   constant EO_DELBACKWARD

$ 0003   constant EO_DELFORWARD

$ 0004   constant EO_MOVECURSOR

$ 0005   constant EO_ENTER

$ 0006   constant EO_RESET

$ 0007   constant EO_REPLACECHAR

$ 0008   constant EO_INSERTCHAR

$ 0009   constant EO_BADFORMAT

$ 000A   constant EO_BIGCHANGE

$ 000B   constant EO_UNDO

$ 000C   constant EO_CLEAR

$ 000D   constant EO_SPECIAL


1 0 <<  constant SGM_REPLACE
1 1 <<  constant SGM_FIXEDFIELD

1 2 <<  constant SGM_NOFILTER

1 7 <<  constant SGM_EXITHELP

1 3 <<  constant SGM_NOCHANGE
1 4 <<  constant SGM_NOWORKB
1 5 <<  constant SGM_CONTROL
1 6 <<  constant SGM_LONGINT

$ 1  constant SGA_USE
$ 2  constant SGA_END
$ 4  constant SGA_BEEP
$ 8  constant SGA_REUSE
$ 10  constant SGA_REDISPLAY

$ 20  constant SGA_NEXTACTIVE
$ 40  constant SGA_PREVACTIVE

1  constant SGH_KEY
2  constant SGH_CLICK

.THEN
