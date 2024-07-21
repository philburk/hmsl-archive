\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? GRAPHICS_RASTPORT_H NOT .IF
: GRAPHICS_RASTPORT_H ;
include? GRAPHICS_GFX_H ji:graphics/gfx.j
.THEN

:STRUCT AreaInfo
	APTR ai_VctrTbl
	APTR ai_VctrPtr
	APTR ai_FlagTbl
	APTR ai_FlagPtr
	SHORT ai_Count
	SHORT ai_MaxCount
	SHORT ai_FirstX
	SHORT ai_FirstY
;STRUCT


:STRUCT TmpRas
	APTR tr_RasPtr
	LONG tr_Size
;STRUCT


(  unoptimized for 32bit alignment of pointers )
:STRUCT GelsInfo
\ Warning this has to be quad word aligned, see JU:FILE-TOOLS
	BYTE gi_sprRsrvd
	UBYTE gi_Flags
	APTR gi_gelHead
	APTR gi_gelTail
	APTR gi_nextLine
	APTR gi_lastColor
	APTR gi_collHandler
	SHORT gi_leftmost
	SHORT gi_rightmost
	SHORT gi_topmost
	SHORT gi_bottommost
	APTR gi_firstBlissObj
	APTR gi_lastBlissObj
;STRUCT


:STRUCT RastPort
	APTR rp_Layer
	APTR rp_BitMap
	APTR rp_AreaPtrn
	APTR rp_TmpRas
	APTR rp_AreaInfo
	APTR rp_GelsInfo
	UBYTE rp_Mask
	BYTE rp_FgPen
	BYTE rp_BgPen
	BYTE rp_AOlPen
	BYTE rp_DrawMode
	BYTE rp_AreaPtSz
	BYTE rp_linpatcnt
	BYTE rp_dummy
	USHORT rp_Flags
	USHORT rp_LinePtrn
	SHORT rp_cp_x
	SHORT rp_cp_y
( %?)   8 BYTES rp_minterms
	SHORT rp_PenWidth
	SHORT rp_PenHeight
	APTR rp_Font
	UBYTE rp_AlgoStyle
	UBYTE rp_TxFlags
	USHORT rp_TxHeight
	USHORT rp_TxWidth
	USHORT rp_TxBaseline
	SHORT rp_TxSpacing
	APTR rp_RP_User
( %?)   2 4 *  BYTES rp_longreserved
EXISTS? GFX_RASTPORT_1_2 NOT .IF
( %?)   7 2 *  BYTES rp_wordreserved
( %?)   8 BYTES rp_reserved
.THEN
;STRUCT

0   constant JAM1
1   constant JAM2
2   constant COMPLEMENT
4   constant INVERSVID
$ 01   constant FRST_DOT
$ 02   constant ONE_DOT
$ 04   constant DBUFFER
$ 08   constant AREAOUTLINE
$ 20   constant NOCROSSFILL

\ .THEN

