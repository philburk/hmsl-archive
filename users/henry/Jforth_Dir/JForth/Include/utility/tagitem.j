\ AMIGA JForth Include file.
decimal
EXISTS? UTILITY_TAGITEM_H NOT .IF
TRUE   constant UTILITY_TAGITEM_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

\ %? typedef ULONG	Tag;

:STRUCT TagItem
ULONG ti_Tag ( %M )
	ULONG ti_Data
;STRUCT

0  constant TAG_DONE
TAG_DONE   constant TAG_END
1  constant TAG_IGNORE
2  constant TAG_MORE
3  constant TAG_SKIP

1 31 <<  constant TAG_USER

0   constant TAGFILTER_AND
1   constant TAGFILTER_NOT

.THEN
