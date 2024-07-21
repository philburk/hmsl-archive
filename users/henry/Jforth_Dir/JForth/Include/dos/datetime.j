\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DATETIME_H NOT .IF
: DOS_DATETIME_H ;

EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

:STRUCT DateTime
	STRUCT DateStamp dat_Stamp
	UBYTE dat_Format
	UBYTE dat_Flags
	APTR dat_StrDay
	APTR dat_StrDate
	APTR dat_StrTime
;STRUCT

16   constant LEN_DATSTRING

0   constant DTB_SUBST
1   constant DTF_SUBST
1   constant DTB_FUTURE
2   constant DTF_FUTURE

0   constant FORMAT_DOS
1   constant FORMAT_INT
2   constant FORMAT_USA
3   constant FORMAT_CDN
FORMAT_CDN   constant FORMAT_MAX

.THEN
