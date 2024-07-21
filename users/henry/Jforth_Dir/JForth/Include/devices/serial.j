\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_SERIAL_H NOT .IF
: DEVICES_SERIAL_H ;
EXISTS?   EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN




:STRUCT IOTArray
	ULONG TermArray0
	ULONG TermArray1
;STRUCT

$ 11130000   constant SER_DEFAULT_CTLCHAR
:STRUCT IOExtSer
	STRUCT IOStdReq IOSer
	ULONG io_CtlChar
	ULONG io_RBufLen
	ULONG io_ExtFlags
	ULONG io_Baud
	ULONG io_BrkTime
	STRUCT IOTArray io_TermArray
	UBYTE io_ReadLen
	UBYTE io_WriteLen
	UBYTE io_StopBits
	UBYTE io_SerFlags
	USHORT io_Status
;STRUCT

CMD_NONSTD   constant SDCMD_QUERY
CMD_NONSTD  1 +  constant SDCMD_BREAK
CMD_NONSTD  2 +  constant SDCMD_SETPARAMS

7   constant SERB_XDISABLED
1  7 <<  constant SERF_XDISABLED
6   constant SERB_EOFMODE
1  6 <<  constant SERF_EOFMODE
5   constant SERB_SHARED
1  5 <<  constant SERF_SHARED
4   constant SERB_RAD_BOOGIE
1  4 <<  constant SERF_RAD_BOOGIE
3   constant SERB_QUEUEDBRK
1  3 <<  constant SERF_QUEUEDBRK
2   constant SERB_7WIRE
1  2 <<  constant SERF_7WIRE
1   constant SERB_PARTY_ODD
1  1 <<  constant SERF_PARTY_ODD
0   constant SERB_PARTY_ON
1  0 <<  constant SERF_PARTY_ON

12   constant IO_STATB_XOFFREAD
1  12 <<  constant IO_STATF_XOFFREAD
11   constant IO_STATB_XOFFWRITE
1  11 <<  constant IO_STATF_XOFFWRITE
10   constant IO_STATB_READBREAK
1  10 <<  constant IO_STATF_READBREAK
9   constant IO_STATB_WROTEBREAK
1  9 <<  constant IO_STATF_WROTEBREAK
8   constant IO_STATB_OVERRUN
1  8 <<  constant IO_STATF_OVERRUN

1   constant SEXTB_MSPON

1  1 <<  constant SEXTF_MSPON
0   constant SEXTB_MARK
1  0 <<  constant SEXTF_MARK

1   constant SerErr_DevBusy
2   constant SerErr_BaudMismatch
4   constant SerErr_BufErr
5   constant SerErr_InvParam
6   constant SerErr_LineErr
9   constant SerErr_ParityErr
11   constant SerErr_TimerErr
12   constant SerErr_BufOverflow
13   constant SerErr_NoDSR
15   constant SerErr_DetectedBreak

EXISTS? DEVICES_SERIAL_H_OBSOLETE .IF
3   constant SerErr_InvBaud
7   constant SerErr_NotOpen
8   constant SerErr_PortReset
10   constant SerErr_InitErr
14   constant SerErr_NoCTS

4   constant IOSTB_XOFFREAD
1  4 <<  constant IOSTF_XOFFREAD
3   constant IOSTB_XOFFWRITE
1  3 <<  constant IOSTF_XOFFWRITE
2   constant IOSTB_READBREAK
1  2 <<  constant IOSTF_READBREAK
1   constant IOSTB_WROTEBREAK
1  1 <<  constant IOSTF_WROTEBREAK
0   constant IOSTB_OVERRUN
1  0 <<  constant IOSTF_OVERRUN

7   constant IOSERB_BUFRREAD
1  7 <<  constant IOSERF_BUFRREAD
6   constant IOSERB_QUEUED
1  6 <<  constant IOSERF_QUEUED
5   constant IOSERB_ABORT
1  5 <<  constant IOSERF_ABORT
4   constant IOSERB_ACTIVE
1  4 <<  constant IOSERF_ACTIVE
.THEN

0" serial.device" 0string SERIALNAME ( %M )

.THEN
