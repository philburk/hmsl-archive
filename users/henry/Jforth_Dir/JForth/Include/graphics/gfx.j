\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_GFX_H NOT .IF
: GRAPHICS_GFX_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

$ 8000   constant BITSET
0   constant BITCLR

:STRUCT Rectangle
	( %M JForth prefix ) SHORT ra_MinX
		SHORT ra_MinY
	SHORT ra_MaxX
	SHORT ra_MaxY
;STRUCT

:STRUCT Rect32
	( %M JForth prefix ) LONG r32_MinX
		LONG r32_MinY
	LONG r32_MaxX
	LONG r32_MaxY
;STRUCT

:STRUCT Point
	SHORT pnt_x
	SHORT pnt_y
;STRUCT

:STRUCT BitMap
	( %M JForth prefix ) USHORT bm_BytesPerRow
	USHORT bm_Rows
	UBYTE bm_Flags
	UBYTE bm_Depth
	USHORT bm_pad
4 8 * BYTES bm_planes ( %M )
;STRUCT

\ %? #define RASSIZE(w,h)	((h)*( ((w)+15)>>3&0xFFFE)): RASSIZE ;

.THEN
