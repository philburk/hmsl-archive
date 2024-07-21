\ AMIGA JForth Include file.
decimal
EXISTS? DOS_RECORD_H NOT .IF
: DOS_RECORD_H ;
EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

0   constant REC_EXCLUSIVE
1   constant REC_EXCLUSIVE_IMMED
2   constant REC_SHARED
3   constant REC_SHARED_IMMED

:STRUCT RecordLock
	LONG rec_FH
	ULONG rec_Offset
	ULONG rec_Length
	ULONG rec_Mode
;STRUCT

.THEN
