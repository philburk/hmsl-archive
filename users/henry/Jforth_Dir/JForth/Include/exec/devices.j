\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_DEVICES_H NOT .IF
: EXEC_DEVICES_H ;
EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

:STRUCT Device
	STRUCT Library dd_Library
;STRUCT

:STRUCT Unit
	STRUCT MsgPort unit_MsgPort

	UBYTE unit_flags
	UBYTE unit_pad
	USHORT unit_OpenCnt
;STRUCT

1  0 <<  constant UNITF_ACTIVE
1  1 <<  constant UNITF_INTASK

.THEN
