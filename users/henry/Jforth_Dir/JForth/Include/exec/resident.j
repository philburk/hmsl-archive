\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_RESIDENT_H NOT .IF
: EXEC_RESIDENT_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT Resident
	USHORT rt_MatchWord
	APTR rt_MatchTag
	APTR rt_EndSkip
	UBYTE rt_Flags
	UBYTE rt_Version
	UBYTE rt_Type
	BYTE rt_Pri
	APTR rt_Name
	APTR rt_IdString
	APTR rt_Init
;STRUCT

$ 4AFC   constant RTC_MATCHWORD

1  7 <<  constant RTF_AUTOINIT
1  2 <<  constant RTF_AFTERDOS
1  1 <<  constant RTF_SINGLETASK
1  0 <<  constant RTF_COLDSTART

0   constant RTW_NEVER
1   constant RTW_COLDSTART

.THEN
