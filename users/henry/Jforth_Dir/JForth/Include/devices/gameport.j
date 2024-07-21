\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_GAMEPORT_H NOT .IF
: DEVICES_GAMEPORT_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN

CMD_NONSTD  0 +  constant GPD_READEVENT
CMD_NONSTD  1 +  constant GPD_ASKCTYPE
CMD_NONSTD  2 +  constant GPD_SETCTYPE
CMD_NONSTD  3 +  constant GPD_ASKTRIGGER
CMD_NONSTD  4 +  constant GPD_SETTRIGGER

0   constant GPTB_DOWNKEYS
1  0 <<  constant GPTF_DOWNKEYS
1   constant GPTB_UPKEYS
1  1 <<  constant GPTF_UPKEYS

:STRUCT GamePortTrigger
	USHORT gpt_Keys
	USHORT gpt_Timeout
	USHORT gpt_XDelta
	USHORT gpt_YDelta
;STRUCT

-1   constant GPCT_ALLOCATED
0   constant GPCT_NOCONTROLLER

1   constant GPCT_MOUSE
2   constant GPCT_RELJOYSTICK
3   constant GPCT_ABSJOYSTICK

1   constant GPDERR_SETCTYPE

.THEN
