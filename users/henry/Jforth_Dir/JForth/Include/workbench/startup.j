\ AMIGA JForth Include file.
decimal
EXISTS? WORKBENCH_STARTUP_H NOT .IF
: WORKBENCH_STARTUP_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? LIBRARIES_DOS_H NOT .IF
include ji:libraries/dos.j
.THEN

:STRUCT WBStartup
	STRUCT Message	sm_Message
	APTR sm_Process
	LONG sm_Segment
	LONG sm_NumArgs
	APTR sm_ToolWindow
	APTR sm_ArgList
;STRUCT

:STRUCT WBArg
	LONG wa_Lock
	APTR wa_Name
;STRUCT

.THEN
