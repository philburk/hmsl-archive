\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_SPRITE_H NOT .IF
: GRAPHICS_SPRITE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

$ 80   constant SPRITE_ATTACHED

:STRUCT SimpleSprite
	( %M JForth prefix ) APTR ss_posctldata
	USHORT ss_height
	USHORT ss_x
	USHORT ss_y
	USHORT ss_num
;STRUCT

.THEN
