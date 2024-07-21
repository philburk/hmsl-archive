\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? GRAPHICS_REGIONS_H NOT .IF
: GRAPHICS_REGIONS_H ;

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN

:STRUCT RegionRectangle
	APTR rr_Next
	APTR rr_Prev
	STRUCT Rectangle	rr_bounds
;STRUCT


:STRUCT Region
	STRUCT Rectangle	rg_bounds
	APTR rg_RegionRectangle
;STRUCT

.THEN

