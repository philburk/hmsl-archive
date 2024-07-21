\ AMIGA JForth Include file.
decimal
EXISTS? UTILITY_DATE_H NOT .IF
1   constant UTILITY_DATE_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT ClockData

	( %M JForth prefix ) USHORT cld_sec
	USHORT cld_min
	USHORT cld_hour
	USHORT cld_mday
	USHORT cld_month
	USHORT cld_year
	USHORT cld_wday
	;STRUCT

.THEN
