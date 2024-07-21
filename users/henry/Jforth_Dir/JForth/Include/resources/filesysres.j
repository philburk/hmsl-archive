\ AMIGA JForth Include file.
decimal
EXISTS? RESOURCES_FILESYSRES_H NOT .IF
: RESOURCES_FILESYSRES_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN
EXISTS? DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

0" FileSystem.resource" 0string FSRNAME ( %M )

:STRUCT FileSysResource
	STRUCT Node fsr_Node
	APTR fsr_Creator
	STRUCT List fsr_FileSysEntries
;STRUCT

:STRUCT FileSysEntry
	STRUCT Node fse_Node

	ULONG fse_DosType
	ULONG fse_Version
	ULONG fse_PatchFlags



	ULONG fse_Type
	ULONG fse_Task
	LONG fse_Lock
	APTR fse_Handler
	ULONG fse_StackSize
	LONG fse_Priority
	LONG fse_Startup
	LONG fse_SegList
	LONG fse_GlobalVec
;STRUCT

.THEN
