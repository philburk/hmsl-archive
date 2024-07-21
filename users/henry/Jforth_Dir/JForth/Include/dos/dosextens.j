\ AMIGA JForth Include file.
decimal
EXISTS? DOS_DOSEXTENS_H NOT .IF
: DOS_DOSEXTENS_H ;
EXISTS? EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN
EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN
EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN
EXISTS? EXEC_SEMAPHORES_H NOT .IF
include ji:exec/semaphores.j
.THEN
EXISTS? DEVICES_TIMER_H NOT .IF
include ji:devices/timer.j
.THEN

EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

:STRUCT Process
	STRUCT Exec_Task pr_Task ( %M !!! TASK renamed )
	STRUCT MsgPort pr_MsgPort
	SHORT pr_Pad
	LONG pr_SegList
	LONG pr_StackSize
	APTR pr_GlobVec
	LONG pr_TaskNum
	LONG pr_StackBase
	LONG pr_Result2
	LONG pr_CurrentDir
	LONG pr_CIS
	LONG pr_COS
	APTR pr_ConsoleTask
	APTR pr_FileSystemTask
	LONG pr_CLI
	APTR pr_ReturnAddr
	APTR pr_PktWait
	APTR pr_WindowPtr
	LONG pr_HomeDir
	LONG pr_Flags
APTR pr_ExitCode ( %M )
	LONG pr_ExitData
	APTR pr_Arguments
	STRUCT MinList pr_LocalVars
	ULONG pr_ShellPrivate
	LONG pr_CES
;STRUCT
0   constant PRB_FREESEGLIST
1   constant PRF_FREESEGLIST
1   constant PRB_FREECURRDIR
2   constant PRF_FREECURRDIR
2   constant PRB_FREECLI
4   constant PRF_FREECLI
3   constant PRB_CLOSEINPUT
8   constant PRF_CLOSEINPUT
4   constant PRB_CLOSEOUTPUT
16   constant PRF_CLOSEOUTPUT
5   constant PRB_FREEARGS
32   constant PRF_FREEARGS

:STRUCT FileHandle
	APTR fh_Link
	APTR fh_Port
	APTR fh_Type
	LONG fh_Buf
	LONG fh_Pos
	LONG fh_End
	union{
		LONG fh_Funcs
	}union{
		LONG fh_Func1
	}union
		LONG fh_Func2
		LONG fh_Func3
	union{
		LONG fh_Args
	}union{
		LONG fh_Arg1
	}union
		LONG fh_Arg2
;STRUCT

:STRUCT DosPacket
	APTR dp_Link
	APTR dp_Port
  union{ ( %M)
      LONG dp_Type
      LONG dp_Res1
      LONG dp_Res2
      LONG dp_Arg1
  }union{
      LONG dp_Action
      LONG dp_Status
      LONG dp_Status2
      LONG dp_BufAddr
  }union
	LONG dp_Arg2
	LONG dp_Arg3
	LONG dp_Arg4
	LONG dp_Arg5
	LONG dp_Arg6
	LONG dp_Arg7
;STRUCT
:STRUCT StandardPacket
	STRUCT Message sp_Msg
	STRUCT DosPacket sp_Pkt
;STRUCT
0   constant ACTION_NIL
0   constant ACTION_STARTUP
2   constant ACTION_GET_BLOCK
4   constant ACTION_SET_MAP
5   constant ACTION_DIE
6   constant ACTION_EVENT
7   constant ACTION_CURRENT_VOLUME
8   constant ACTION_LOCATE_OBJECT
9   constant ACTION_RENAME_DISK
ascii W constant ACTION_WRITE ( %M )
ascii R constant ACTION_READ ( %M )
15   constant ACTION_FREE_LOCK
16   constant ACTION_DELETE_OBJECT
17   constant ACTION_RENAME_OBJECT
18   constant ACTION_MORE_CACHE
19   constant ACTION_COPY_DIR
20   constant ACTION_WAIT_CHAR
21   constant ACTION_SET_PROTECT
22   constant ACTION_CREATE_DIR
23   constant ACTION_EXAMINE_OBJECT
24   constant ACTION_EXAMINE_NEXT
25   constant ACTION_DISK_INFO
26   constant ACTION_INFO
27   constant ACTION_FLUSH
28   constant ACTION_SET_COMMENT
29   constant ACTION_PARENT
30   constant ACTION_TIMER
31   constant ACTION_INHIBIT
32   constant ACTION_DISK_TYPE
33   constant ACTION_DISK_CHANGE
34   constant ACTION_SET_DATE

994   constant ACTION_SCREEN_MODE

1001   constant ACTION_READ_RETURN
1002   constant ACTION_WRITE_RETURN
1008   constant ACTION_SEEK
1004   constant ACTION_FINDUPDATE
1005   constant ACTION_FINDINPUT
1006   constant ACTION_FINDOUTPUT
1007   constant ACTION_END
1022   constant ACTION_SET_FILE_SIZE
1023   constant ACTION_WRITE_PROTECT

40   constant ACTION_SAME_LOCK
995   constant ACTION_CHANGE_SIGNAL
1020   constant ACTION_FORMAT
1021   constant ACTION_MAKE_LINK

1024   constant ACTION_READ_LINK
1026   constant ACTION_FH_FROM_LOCK
1027   constant ACTION_IS_FILESYSTEM
1028   constant ACTION_CHANGE_MODE

1030   constant ACTION_COPY_DIR_FH
1031   constant ACTION_PARENT_FH
1033   constant ACTION_EXAMINE_ALL
1034   constant ACTION_EXAMINE_FH

2008   constant ACTION_LOCK_RECORD
2009   constant ACTION_FREE_RECORD

4097   constant ACTION_ADD_NOTIFY
4098   constant ACTION_REMOVE_NOTIFY

:STRUCT ErrorString
	APTR estr_Nums
	APTR estr_Strings
;STRUCT

:STRUCT DosLibrary
	STRUCT Library dl_lib
	APTR dl_Root
	APTR dl_GV
	LONG dl_A2
	LONG dl_A5
	LONG dl_A6
	APTR dl_Errors
	APTR dl_TimeReq
	APTR dl_UtilityBase
;STRUCT
:STRUCT RootNode
	LONG rn_TaskArray
	LONG rn_ConsoleSegment
	STRUCT DateStamp rn_Time
	LONG rn_RestartSeg
	LONG rn_Info
	LONG rn_FileHandlerSegment
	STRUCT MinList rn_CliList

	APTR rn_BootProc
	LONG rn_ShellSegment
	LONG rn_Flags
;STRUCT
24   constant RNB_WILDSTAR
1 24 <<  constant RNF_WILDSTAR
1   constant RNB_PRIVATE1
2   constant RNF_PRIVATE1

:STRUCT CliProcList
	STRUCT MinNode cpl_Node
	LONG cpl_First
	APTR cpl_Array

;STRUCT

:STRUCT DosInfo
	LONG di_McName
di_McName   constant di_ResList
	LONG di_DevInfo
	LONG di_Devices
	LONG di_Handlers
	APTR di_NetHand
	STRUCT SignalSemaphore di_DevLock
	STRUCT SignalSemaphore di_EntryLock
	STRUCT SignalSemaphore di_DeleteLock
;STRUCT
:STRUCT Segment
	LONG seg_Next
	LONG seg_UC
	LONG seg_Seg
	( %?) 4 BYTES seg_Name
;STRUCT

-1   constant CMD_SYSTEM
-2   constant CMD_INTERNAL
-999   constant CMD_DISABLED

:STRUCT CommandLineInterface
	LONG cli_Result2
	APTR cli_SetName
	LONG cli_CommandDir
	LONG cli_ReturnCode
	APTR cli_CommandName
	LONG cli_FailLevel
	APTR cli_Prompt
	LONG cli_StandardInput
	LONG cli_CurrentInput
	APTR cli_CommandFile
	LONG cli_Interactive
	LONG cli_Background
	LONG cli_CurrentOutput
	LONG cli_DefaultStack
	LONG cli_StandardOutput
	LONG cli_Module
;STRUCT

:STRUCT DeviceList
	LONG dl_Next
	LONG dl_Type
	APTR dl_Task
	LONG dl_Lock
	STRUCT DateStamp	dl_VolumeDate
	LONG dl_LockList
	LONG dl_DiskType
	LONG dl_unused
	APTR dl_Name
;STRUCT

:STRUCT DevInfo
	LONG dvi_Next
	LONG dvi_Type
	APTR dvi_Task
	LONG dvi_Lock
	APTR dvi_Handler
	LONG dvi_StackSize
	LONG dvi_Priority
	LONG dvi_Startup
	LONG dvi_SegList
	LONG dvi_GlobVec
	APTR dvi_Name
;STRUCT

:STRUCT DosList
	LONG dol_Next
	LONG dol_Type
	APTR dol_Task
	LONG dol_Lock
	union{
		LONG dol_Handler
		LONG dol_StackSize
		LONG dol_Priority
		ULONG dol_Startup
		LONG dol_SegList
		LONG dol_GlobVec
	}union{
		struct DateStamp dol_VolumeDate
		LONG dol_LockList
		LONG dol_DiskType
	}union{
		APTR dol_AssignName
		APTR dol_List
	}union
	APTR dol_Name
	;STRUCT

:STRUCT AssignList
	APTR al_Next
	LONG al_Lock
;STRUCT

0   constant DLT_DEVICE
1   constant DLT_DIRECTORY
2   constant DLT_VOLUME
3   constant DLT_LATE
4   constant DLT_NONBINDING
-1   constant DLT_PRIVATE

:STRUCT DevProc
	APTR dvp_Port
	LONG dvp_Lock
	ULONG dvp_Flags
	APTR dvp_DevNode
;STRUCT

0   constant DVPB_UNLOCK
1 DVPB_UNLOCK <<  constant DVPF_UNLOCK
1   constant DVPB_ASSIGN
1 DVPB_ASSIGN <<  constant DVPF_ASSIGN

2   constant LDB_DEVICES
1 LDB_DEVICES <<  constant LDF_DEVICES
3   constant LDB_VOLUMES
1 LDB_VOLUMES <<  constant LDF_VOLUMES
4   constant LDB_ASSIGNS
1 LDB_ASSIGNS <<  constant LDF_ASSIGNS
5   constant LDB_ENTRY
1 LDB_ENTRY <<  constant LDF_ENTRY
6   constant LDB_DELETE
1 LDB_DELETE <<  constant LDF_DELETE

0   constant LDB_READ
1 LDB_READ <<  constant LDF_READ
1   constant LDB_WRITE
1 LDB_WRITE <<  constant LDF_WRITE

LDF_DEVICES  LDF_VOLUMES | LDF_ASSIGNS |  constant LDF_ALL

:STRUCT FileLock
	LONG fl_Link
	LONG fl_Key
	LONG fl_Access
	APTR fl_Task
	LONG fl_Volume
;STRUCT

0   constant REPORT_STREAM
1   constant REPORT_TASK
2   constant REPORT_LOCK
3   constant REPORT_VOLUME
4   constant REPORT_INSERT

296   constant ABORT_DISK_ERROR
288   constant ABORT_BUSY

-1   constant RUN_EXECUTE
-2   constant RUN_SYSTEM
-3   constant RUN_SYSTEM_ASYNCH

1   constant ST_ROOT
2   constant ST_USERDIR
3   constant ST_SOFTLINK
4   constant ST_LINKDIR
-3   constant ST_FILE
-4   constant ST_LINKFILE

.THEN
