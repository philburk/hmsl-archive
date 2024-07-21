\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_IO_H NOT .IF
: EXEC_IO_H ;
EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

:STRUCT IORequest
	STRUCT Message io_Message
	APTR io_Device
	APTR io_Unit
	USHORT io_Command
	UBYTE io_Flags
	BYTE io_Error
;STRUCT

:STRUCT IOStdReq
	STRUCT Message io_Message
	APTR io_Device
	APTR io_Unit
	USHORT io_Command
	UBYTE io_Flags
	BYTE io_Error
	ULONG io_Actual
	ULONG io_Length
	APTR io_Data
	ULONG io_Offset
;STRUCT

-30   constant DEV_BEGINIO
-36   constant DEV_ABORTIO

0   constant IOB_QUICK
1  0 <<  constant IOF_QUICK

0   constant CMD_INVALID
1   constant CMD_RESET
2   constant CMD_READ
3   constant CMD_WRITE
4   constant CMD_UPDATE
5   constant CMD_CLEAR
6   constant CMD_STOP
7   constant CMD_START
8   constant CMD_FLUSH

9   constant CMD_NONSTD

.THEN
