\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_BOOTBLOCK_H NOT .IF
: DEVICES_BOOTBLOCK_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT BootBlock
	( %?) 4 BYTES bb_id
	LONG bb_chksum
	LONG bb_dosblock
;STRUCT

2   constant BOOTSECTS

$ 444F5300 constant BBID_DOS \ 'DOS' ( %M )
$ 4B49434B constant BBID_KICK ( %M )

$ 444F5300   constant BBNAME_DOS
$ 4B49434B   constant BBNAME_KICK

.THEN
