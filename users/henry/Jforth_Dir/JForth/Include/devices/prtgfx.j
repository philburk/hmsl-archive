\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_PRTGFX_H NOT .IF
: DEVICES_PRTGFX_H ;
EXISTS?  EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

0   constant PCMYELLOW
1   constant PCMMAGENTA
2   constant PCMCYAN
3   constant PCMBLACK
PCMYELLOW   constant PCMBLUE
PCMMAGENTA   constant PCMGREEN
PCMCYAN   constant PCMRED
PCMBLACK   constant PCMWHITE

\ Treat union definition as structure, strange construct!
:STRUCT colorEntry
	union{
		union{
			ULONG colorLong
		}union{
			4 BYTES colorByte
		}union
	}union{
		4 BYTES colorSByte
	}union
;STRUCT


:STRUCT PrtInfo
APTR pi_render ( %M )
	APTR pi_rp
	APTR pi_temprp
	APTR pi_RowBuf
	APTR pi_HamBuf
APTR pi_ColorMap ( %M )
APTR pi_ColorInt ( %M )
APTR pi_HamInt ( %M )
APTR pi_Dest1Int ( %M)
APTR pi_Dest2Int ( %M)
	APTR pi_ScaleX
	APTR pi_ScaleXAlt
	APTR pi_dmatrix
	APTR pi_TopBuf
	APTR pi_BotBuf
	USHORT pi_RowBufSize
	USHORT pi_HamBufSize
	USHORT pi_ColorMapSize
	USHORT pi_ColorIntSize
	USHORT pi_HamIntSize
	USHORT pi_Dest1IntSize
	USHORT pi_Dest2IntSize
	USHORT pi_ScaleXSize
	USHORT pi_ScaleXAltSize
	USHORT pi_PrefsFlags
	ULONG pi_special
	USHORT pi_xstart
	USHORT pi_ystart
	USHORT pi_width
	USHORT pi_height
	ULONG pi_pc
	ULONG pi_pr
	USHORT pi_ymult
	USHORT pi_ymod
	SHORT pi_ety
	USHORT pi_xpos
	USHORT pi_threshold
	USHORT pi_tempwidth
	USHORT pi_flags
;STRUCT

.THEN
