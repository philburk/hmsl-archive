\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_SCALE_H NOT .IF
: GRAPHICS_SCALE_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT BitScaleArgs
	USHORT bsa_SrcX
	USHORT bsa_SrcY
	USHORT bsa_SrcWidth
	USHORT bsa_SrcHeight
	USHORT bsa_XSrcFactor
	USHORT bsa_YSrcFactor
	USHORT bsa_DestX
	USHORT bsa_DestY
	USHORT bsa_DestWidth
	USHORT bsa_DestHeight
	USHORT bsa_XDestFactor
	USHORT bsa_YDestFactor
	APTR bsa_SrcBitMap
	APTR bsa_DestBitMap
	ULONG bsa_Flags
	USHORT bsa_XDDA
	USHORT bsa_YDDA
	LONG bsa_Reserved1
	LONG bsa_Reserved2
;STRUCT

.THEN
