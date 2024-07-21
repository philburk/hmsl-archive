\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_PARALLEL_H NOT .IF
: DEVICES_PARALLEL_H ;
EXISTS?   EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN

:STRUCT IOPArray
	ULONG PTermArray0
	ULONG PTermArray1
;STRUCT

:STRUCT IOExtPar
	STRUCT IOStdReq IOPar
	ULONG io_PExtFlags
	UBYTE io_Status
	UBYTE io_ParFlags
	STRUCT IOPArray io_PTermArray
;STRUCT

5   constant PARB_SHARED
1  5 <<  constant PARF_SHARED
4   constant PARB_SLOWMODE
1  4 <<  constant PARF_SLOWMODE
3   constant PARB_FASTMODE
1  3 <<  constant PARF_FASTMODE
3   constant PARB_RAD_BOOGIE
1  3 <<  constant PARF_RAD_BOOGIE

2   constant PARB_ACKMODE
1  2 <<  constant PARF_ACKMODE

1   constant PARB_EOFMODE
1  1 <<  constant PARF_EOFMODE

6   constant IOPARB_QUEUED
1  6 <<  constant IOPARF_QUEUED
5   constant IOPARB_ABORT
1  5 <<  constant IOPARF_ABORT
4   constant IOPARB_ACTIVE
1  4 <<  constant IOPARF_ACTIVE
3   constant IOPTB_RWDIR
1  3 <<  constant IOPTF_RWDIR
2   constant IOPTB_PARSEL
1  2 <<  constant IOPTF_PARSEL
1   constant IOPTB_PAPEROUT
1  1 <<  constant IOPTF_PAPEROUT
0   constant IOPTB_PARBUSY
1  0 <<  constant IOPTF_PARBUSY
0" parallel.device" 0string PARALLELNAME ( %M )

CMD_NONSTD   constant PDCMD_QUERY
CMD_NONSTD  1 +  constant PDCMD_SETPARAMS

1   constant ParErr_DevBusy
2   constant ParErr_BufTooBig
3   constant ParErr_InvParam
4   constant ParErr_LineErr
5   constant ParErr_NotOpen
6   constant ParErr_PortReset
7   constant ParErr_InitErr

.THEN
