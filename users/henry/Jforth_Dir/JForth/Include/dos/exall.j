\ AMIGA JForth Include file.
decimal
EXISTS? DOS_EXALL_H NOT .IF
: DOS_EXALL_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? UTILITY_HOOKS_H NOT .IF
include ji:utility/hooks.j
.THEN

1   constant ED_NAME
2   constant ED_TYPE
3   constant ED_SIZE
4   constant ED_PROTECTION
5   constant ED_DATE
6   constant ED_COMMENT

:STRUCT ExAllData
	APTR ed_Next
	APTR ed_Name
	LONG ed_Type
	ULONG ed_Size
	ULONG ed_Prot
	ULONG ed_Days
	ULONG ed_Mins
	ULONG ed_Ticks
	APTR ed_Comment
;STRUCT

:STRUCT ExAllControl
	ULONG eac_Entries
	ULONG eac_LastKey
	APTR eac_MatchString
	APTR eac_MatchFunc
;STRUCT

.THEN
