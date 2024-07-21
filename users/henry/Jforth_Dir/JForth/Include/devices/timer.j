\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_TIMER_H NOT .IF
1   constant DEVICES_TIMER_H
include ji:exec/types.j
include ji:exec/io.j

0   constant UNIT_MICROHZ
1   constant UNIT_VBLANK
2   constant UNIT_ECLOCK
3   constant UNIT_WAITUNTIL
4   constant UNIT_WAITECLOCK

0" timer.device" 0string TIMERNAME ( %M )

:STRUCT timeval
	ULONG tv_secs
	ULONG tv_micro
;STRUCT

:STRUCT EClockVal
	ULONG ev_hi
	ULONG ev_lo
;STRUCT

:STRUCT timerequest
	STRUCT IORequest tr_node
	STRUCT timeval tr_time
;STRUCT

CMD_NONSTD   constant TR_ADDREQUEST
CMD_NONSTD  1 +  constant TR_GETSYSTIME
CMD_NONSTD  2 +  constant TR_SETSYSTIME

.THEN
