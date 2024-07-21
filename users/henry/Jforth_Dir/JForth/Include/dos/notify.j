\ AMIGA JForth Include file.
decimal
EXISTS? DOS_NOTIFY_H NOT .IF
: DOS_NOTIFY_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN

$ 40000000   constant NOTIFY_CLASS

$ 1234   constant NOTIFY_CODE

:STRUCT NotifyMessage
	STRUCT Message nm_ExecMessage
	ULONG nm_Class
	USHORT nm_Code
	APTR nm_NReq
	ULONG nm_DoNotTouch
	ULONG nm_DoNotTouch2
;STRUCT

:STRUCT NotifyRequest
	APTR nr_Name
	APTR nr_FullName
	ULONG nr_UserData
	ULONG nr_Flags
	union{
		APTR nr_Port
	}union{
		APTR nr_Task
		UBYTE nr_SignalNum
		( %?) 3 BYTES nr_pad
	}union
	( %?) 4 4 *  BYTES nr_Reserved
	ULONG nr_MsgCount
	APTR nr_Handler
;STRUCT

1   constant NRF_SEND_MESSAGE
2   constant NRF_SEND_SIGNAL
8   constant NRF_WAIT_REPLY
16   constant NRF_NOTIFY_INITIAL

$ 80000000   constant NRF_MAGIC

0   constant NRB_SEND_MESSAGE
1   constant NRB_SEND_SIGNAL
3   constant NRB_WAIT_REPLY
4   constant NRB_NOTIFY_INITIAL

31   constant NRB_MAGIC

$ ffff0000   constant NR_HANDLER_FLAGS

.THEN
