\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_AUDIO_H NOT .IF
: DEVICES_AUDIO_H ;
EXISTS? EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN

0" audio.device" 0string AUDIONAME ( %M )

4   constant ADHARD_CHANNELS

-128   constant ADALLOC_MINPREC
127   constant ADALLOC_MAXPREC

CMD_NONSTD  0 +  constant ADCMD_FREE
CMD_NONSTD  1 +  constant ADCMD_SETPREC
CMD_NONSTD  2 +  constant ADCMD_FINISH
CMD_NONSTD  3 +  constant ADCMD_PERVOL
CMD_NONSTD  4 +  constant ADCMD_LOCK
CMD_NONSTD  5 +  constant ADCMD_WAITCYCLE
32   constant ADCMD_ALLOCATE

4   constant ADIOB_PERVOL
1  4 <<  constant ADIOF_PERVOL
5   constant ADIOB_SYNCCYCLE
1  5 <<  constant ADIOF_SYNCCYCLE
6   constant ADIOB_NOWAIT
1  6 <<  constant ADIOF_NOWAIT
7   constant ADIOB_WRITEMESSAGE
1  7 <<  constant ADIOF_WRITEMESSAGE

-10   constant ADIOERR_NOALLOCATION
-11   constant ADIOERR_ALLOCFAILED
-12   constant ADIOERR_CHANNELSTOLEN

:STRUCT IOAudio
	STRUCT IORequest ioa_Request
	SHORT ioa_AllocKey
	APTR ioa_Data
	ULONG ioa_Length
	USHORT ioa_Period
	USHORT ioa_Volume
	USHORT ioa_Cycles
	STRUCT Message ioa_WriteMsg
;STRUCT

.THEN
