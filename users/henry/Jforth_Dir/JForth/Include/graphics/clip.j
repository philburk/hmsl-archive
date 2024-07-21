\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_CLIP_H NOT .IF
: GRAPHICS_CLIP_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN
EXISTS? EXEC_SEMAPHORES_H NOT .IF
include ji:exec/semaphores.j
.THEN
EXISTS? UTILITY_HOOKS_H NOT .IF
include ji:utility/hooks.j
.THEN

: NEWLOCKS ;

:STRUCT Layer
	( %M JForth prefix ) APTR lr_front
		APTR lr_back
	APTR lr_ClipRect
	APTR lr_rp
	STRUCT Rectangle	lr_bounds
	( %?) 4 BYTES lr_reserved
	USHORT lr_priority
	USHORT lr_Flags
	APTR lr_SuperBitMap
	APTR lr_SuperClipRect

	APTR lr_Window
	SHORT lr_Scroll_X
	SHORT lr_Scroll_Y
	APTR lr_cr
	APTR lr_cr2
	APTR lr_crnew
	APTR lr_SuperSaveClipRects
	APTR lr__cliprects
	APTR lr_LayerInfo
	STRUCT SignalSemaphore lr_Lock
	APTR lr_BackFill
	ULONG lr_reserved1
	APTR lr_ClipRegion
	APTR lr_saveClipRects
	SHORT lr_Width
	SHORT lr_Height
	( %?) 18 BYTES lr_reserved2
	APTR lr_DamageList
;STRUCT

:STRUCT ClipRect
	( %M JForth prefix ) APTR cr_Next
	APTR cr_prev
	APTR cr_lobs
	APTR cr_BitMap
	STRUCT Rectangle	cr_bounds
	APTR cr__p1
	APTR cr__p2
	LONG cr_reserved
EXISTS? NEWCLIPRECTS_1_1 .IF
	LONG cr_Flags
.THEN
;STRUCT

1   constant CR_NEEDS_NO_CONCEALED_RASTERS
2   constant CR_NEEDS_NO_LAYERBLIT_DAMAGE

1   constant ISLESSX
2   constant ISLESSY
4   constant ISGRTRX
8   constant ISGRTRY

.THEN
