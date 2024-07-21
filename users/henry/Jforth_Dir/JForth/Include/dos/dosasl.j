\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DOSASL_H NOT .IF
: DOS_DOSASL_H ;
EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

:STRUCT AnchorPath
	APTR ap_Base
ap_Base   constant ap_First
	APTR ap_Last
ap_Last   constant ap_Current
	LONG ap_BreakBits
	LONG ap_FoundBreak
	BYTE ap_Flags
	BYTE ap_Reserved
	SHORT ap_Strlen
ap_Flags   constant ap_Length
	STRUCT FileInfoBlock ap_Info
	( %?) 1 BYTES ap_Buf

;STRUCT

0   constant APB_DOWILD
1   constant APF_DOWILD

1   constant APB_ITSWILD
2   constant APF_ITSWILD




2   constant APB_DODIR
4   constant APF_DODIR



3   constant APB_DIDDIR
8   constant APF_DIDDIR

4   constant APB_NOMEMERR
16   constant APF_NOMEMERR

5   constant APB_DODOT
32   constant APF_DODOT

6   constant APB_DirChanged
64   constant APF_DirChanged

:STRUCT AChain
	APTR an_Child
	APTR an_Parent
	LONG an_Lock
	STRUCT FileInfoBlock an_Info
	BYTE an_Flags
	( %?) 1 BYTES an_String
;STRUCT

0   constant DDB_PatternBit
1   constant DDF_PatternBit
1   constant DDB_ExaminedBit
2   constant DDF_ExaminedBit
2   constant DDB_Completed
4   constant DDF_Completed
3   constant DDB_AllBit
8   constant DDF_AllBit
4   constant DDB_Single
16   constant DDF_Single

$ 80   constant P_ANY
$ 81   constant P_SINGLE
$ 82   constant P_ORSTART
$ 83   constant P_ORNEXT
$ 84   constant P_OREND
$ 85   constant P_NOT
$ 86   constant P_NOTEND
$ 87   constant P_NOTCLASS
$ 88   constant P_CLASS
$ 89   constant P_REPBEG
$ 8A   constant P_REPEND
$ 8B   constant P_STOP

1   constant COMPLEX_BIT
2   constant EXAMINE_BIT

303   constant ERROR_BUFFER_OVERFLOW
304   constant ERROR_BREAK
305   constant ERROR_NOT_EXECUTABLE

.THEN
