\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DOS_H NOT .IF
: DOS_DOS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

0" dos.library" 0string DOSNAME ( %M )

-1  constant DOSTRUE
0  constant DOSFALSE

1005   constant MODE_OLDFILE
1006   constant MODE_NEWFILE
1004   constant MODE_READWRITE
-1   constant OFFSET_BEGINNING
0   constant OFFSET_CURRENT
1   constant OFFSET_END

OFFSET_BEGINNING   constant OFFSET_BEGINING

8   constant BITSPERBYTE
4   constant BYTESPERLONG
32   constant BITSPERLONG
$ 7FFFFFFF   constant MAXINT
$ 80000000   constant MININT

-2   constant SHARED_LOCK
-2   constant ACCESS_READ
-1   constant EXCLUSIVE_LOCK
-1   constant ACCESS_WRITE

:STRUCT DateStamp
	LONG ds_Days
	LONG ds_Minute
	LONG ds_Tick
;STRUCT
50   constant TICKS_PER_SECOND

:STRUCT FileInfoBlock
	LONG fib_DiskKey
	LONG fib_DirEntryType
	( %?) 108 BYTES fib_FileName
	LONG fib_Protection
	LONG fib_EntryType
	LONG fib_Size
	LONG fib_NumBlocks
	STRUCT DateStamp fib_Date
	( %?) 80 BYTES fib_Comment
	( %?) 36 BYTES fib_Reserved
;STRUCT
6   constant FIBB_SCRIPT
5   constant FIBB_PURE
4   constant FIBB_ARCHIVE
3   constant FIBB_READ
2   constant FIBB_WRITE
1   constant FIBB_EXECUTE
0   constant FIBB_DELETE
1  FIBB_SCRIPT <<  constant FIBF_SCRIPT
1  FIBB_PURE <<  constant FIBF_PURE
1  FIBB_ARCHIVE <<  constant FIBF_ARCHIVE
1  FIBB_READ <<  constant FIBF_READ
1  FIBB_WRITE <<  constant FIBF_WRITE
1  FIBB_EXECUTE <<  constant FIBF_EXECUTE
1  FIBB_DELETE <<  constant FIBF_DELETE

82   constant FAULT_MAX

\ %? typedef long  BPTR;		    /* Long word pointer */
\ %? typedef long  BSTR;		    /* Long word pointer to BCPL string	 */

EXISTS? OBSOLETE_LIBRARIES_DOS_H .IF
\ %? #define BADDR( bptr )	(((ULONG)bptr) << 2): BADDR ;
.ELSE
\ %? #define BADDR(x)	((APTR)((ULONG)(x) << 2)): BADDR ;
.THEN
\ %? #define MKBADDR(x)	(((LONG)(x)) >> 2): MKBADDR ;

:STRUCT InfoData
	LONG id_NumSoftErrors
	LONG id_UnitNumber
	LONG id_DiskState
	LONG id_NumBlocks
	LONG id_NumBlocksUsed
	LONG id_BytesPerBlock
	LONG id_DiskType
	LONG id_VolumeNode
	LONG id_InUse
;STRUCT

80   constant ID_WRITE_PROTECTED
81   constant ID_VALIDATING
82   constant ID_VALIDATED


-1   constant ID_NO_DISK_PRESENT
$ 42414400  constant ID_UNREADABLE_DISK
$ 444F5300  constant ID_DOS_DISK
$ 444F5301  constant ID_FFS_DISK
$ 4E444F53  constant ID_NOT_REALLY_DOS
$ 4B49434B  constant ID_KICKSTART_DISK
$ 4d534400  constant ID_MSDOS_DISK

103   constant ERROR_NO_FREE_STORE
105   constant ERROR_TASK_TABLE_FULL
114   constant ERROR_BAD_TEMPLATE
115   constant ERROR_BAD_NUMBER
116   constant ERROR_REQUIRED_ARG_MISSING
117   constant ERROR_KEY_NEEDS_ARG
118   constant ERROR_TOO_MANY_ARGS
119   constant ERROR_UNMATCHED_QUOTES
120   constant ERROR_LINE_TOO_LONG
121   constant ERROR_FILE_NOT_OBJECT
122   constant ERROR_INVALID_RESIDENT_LIBRARY
201   constant ERROR_NO_DEFAULT_DIR
202   constant ERROR_OBJECT_IN_USE
203   constant ERROR_OBJECT_EXISTS
204   constant ERROR_DIR_NOT_FOUND
205   constant ERROR_OBJECT_NOT_FOUND
206   constant ERROR_BAD_STREAM_NAME
207   constant ERROR_OBJECT_TOO_LARGE
209   constant ERROR_ACTION_NOT_KNOWN
210   constant ERROR_INVALID_COMPONENT_NAME
211   constant ERROR_INVALID_LOCK
212   constant ERROR_OBJECT_WRONG_TYPE
213   constant ERROR_DISK_NOT_VALIDATED
214   constant ERROR_DISK_WRITE_PROTECTED
215   constant ERROR_RENAME_ACROSS_DEVICES
216   constant ERROR_DIRECTORY_NOT_EMPTY
217   constant ERROR_TOO_MANY_LEVELS
218   constant ERROR_DEVICE_NOT_MOUNTED
219   constant ERROR_SEEK_ERROR
220   constant ERROR_COMMENT_TOO_BIG
221   constant ERROR_DISK_FULL
222   constant ERROR_DELETE_PROTECTED
223   constant ERROR_WRITE_PROTECTED
224   constant ERROR_READ_PROTECTED
225   constant ERROR_NOT_A_DOS_DISK
226   constant ERROR_NO_DISK
232   constant ERROR_NO_MORE_ENTRIES
233   constant ERROR_IS_SOFT_LINK
234   constant ERROR_OBJECT_LINKED
235   constant ERROR_BAD_HUNK
236   constant ERROR_NOT_IMPLEMENTED
240   constant ERROR_RECORD_NOT_LOCKED
241   constant ERROR_LOCK_COLLISION
242   constant ERROR_LOCK_TIMEOUT
243   constant ERROR_UNLOCK_ERROR

0   constant RETURN_OK
5   constant RETURN_WARN
10   constant RETURN_ERROR
20   constant RETURN_FAIL

12   constant SIGBREAKB_CTRL_C
13   constant SIGBREAKB_CTRL_D
14   constant SIGBREAKB_CTRL_E
15   constant SIGBREAKB_CTRL_F

1  SIGBREAKB_CTRL_C <<  constant SIGBREAKF_CTRL_C
1  SIGBREAKB_CTRL_D <<  constant SIGBREAKF_CTRL_D
1  SIGBREAKB_CTRL_E <<  constant SIGBREAKF_CTRL_E
1 SIGBREAKB_CTRL_F << constant SIGBREAKF_CTRL_F ( %M )

0   constant LOCK_SAME
1   constant LOCK_SAME_HANDLER
-1   constant LOCK_DIFFERENT

0   constant CHANGE_LOCK
1   constant CHANGE_FH

0   constant LINK_HARD
1   constant LINK_SOFT

-2   constant ITEM_EQUAL
-1   constant ITEM_ERROR
0   constant ITEM_NOTHING
1   constant ITEM_UNQUOTED
2   constant ITEM_QUOTED

0   constant DOS_FILEHANDLE
1   constant DOS_EXALLCONTROL
2   constant DOS_FIB
3   constant DOS_STDPKT
4   constant DOS_CLI
5   constant DOS_RDARGS

.THEN

