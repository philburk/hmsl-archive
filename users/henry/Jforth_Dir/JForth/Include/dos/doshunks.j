\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DOSHUNKS_H NOT .IF
: DOS_DOSHUNKS_H ;
999   constant HUNK_UNIT
1000   constant HUNK_NAME
1001   constant HUNK_CODE
1002   constant HUNK_DATA
1003   constant HUNK_BSS
1004   constant HUNK_RELOC32
1005   constant HUNK_RELOC16
1006   constant HUNK_RELOC8
1007   constant HUNK_EXT
1008   constant HUNK_SYMBOL
1009   constant HUNK_DEBUG
1010   constant HUNK_END
1011   constant HUNK_HEADER

1013   constant HUNK_OVERLAY
1014   constant HUNK_BREAK

1015   constant HUNK_DREL32
1016   constant HUNK_DREL16
1017   constant HUNK_DREL8

1018   constant HUNK_LIB
1019   constant HUNK_INDEX

0   constant EXT_SYMB
1   constant EXT_DEF
2   constant EXT_ABS
3   constant EXT_RES
129   constant EXT_REF32
130   constant EXT_COMMON
131   constant EXT_REF16
132   constant EXT_REF8
133   constant EXT_DEXT32
134   constant EXT_DEXT16
135   constant EXT_DEXT8

.THEN
