\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_IMAGECLASS_H NOT .IF
TRUE   constant INTUITION_IMAGECLASS_H
EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

-1 constant CUSTOMIMAGEDEPTH ( %M )
\ %? #define GADGET_BOX( g )	( (struct IBox *) &((struct Gadget *)(g))->LeftEdge ): GADGET_BOX ;
\ %? #define IM_BOX( im )	( (struct IBox *) &((struct Image *)(im))->LeftEdge ): IM_BOX ;
\ %? #define IM_FGPEN( im )	( (im)->PlanePick ): IM_FGPEN ;
\ %? #define IM_BGPEN( im )	( (im)->PlaneOnOff ): IM_BGPEN ;

TAG_USER  $ 20000 +  constant IA_Dummy
IA_Dummy  $ 01 +  constant IA_Left
IA_Dummy  $ 02 +  constant IA_Top
IA_Dummy  $ 03 +  constant IA_Width
IA_Dummy  $ 04 +  constant IA_Height
IA_Dummy  $ 05 +  constant IA_FGPen

IA_Dummy  $ 06 +  constant IA_BGPen

IA_Dummy  $ 07 +  constant IA_Data

IA_Dummy  $ 08 +  constant IA_LineWidth
IA_Dummy  $ 0E +  constant IA_Pens

IA_Dummy  $ 0F +  constant IA_Resolution

IA_Dummy  $ 10 +  constant IA_APattern
IA_Dummy  $ 11 +  constant IA_APatSize
IA_Dummy  $ 12 +  constant IA_Mode
IA_Dummy  $ 13 +  constant IA_Font
IA_Dummy  $ 14 +  constant IA_Outline
IA_Dummy  $ 15 +  constant IA_Recessed
IA_Dummy  $ 16 +  constant IA_DoubleEmboss
IA_Dummy  $ 17 +  constant IA_EdgesOnly

IA_Dummy  $ 0B +  constant SYSIA_Size

IA_Dummy  $ 0C +  constant SYSIA_Depth

IA_Dummy  $ 0D +  constant SYSIA_Which

IA_Dummy  $ 18 +  constant SYSIA_DrawInfo


IA_Pens   constant SYSIA_Pens
IA_Dummy  $ 09 +  constant IA_ShadowPen
IA_Dummy  $ 0A +  constant IA_HighlightPen

0   constant SYSISIZE_MEDRES
1   constant SYSISIZE_LOWRES
2   constant SYSISIZE_HIRES

$ 00  constant DEPTHIMAGE
$ 01  constant ZOOMIMAGE
$ 02  constant SIZEIMAGE
$ 03  constant CLOSEIMAGE
$ 05  constant SDEPTHIMAGE
$ 0A  constant LEFTIMAGE
$ 0B  constant UPIMAGE
$ 0C  constant RIGHTIMAGE
$ 0D  constant DOWNIMAGE
$ 0E  constant CHECKIMAGE
$ 0F  constant MXIMAGE

$ 202  constant IM_DRAW
$ 203  constant IM_HITTEST
$ 204  constant IM_ERASE
$ 205  constant IM_MOVE

$ 206  constant IM_DRAWFRAME
$ 207  constant IM_FRAMEBOX
$ 208  constant IM_HITFRAME
$ 209  constant IM_ERASEFRAME

0  constant IDS_NORMAL
1  constant IDS_SELECTED
2  constant IDS_DISABLED
3  constant IDS_BUSY
4  constant IDS_INDETERMINATE
5  constant IDS_INACTIVENORMAL
6  constant IDS_INACTIVESELECTED
7  constant IDS_INACTIVEDISABLED

IDS_INDETERMINATE   constant IDS_INDETERMINANT

:STRUCT impFrameBox
	ULONG MethodID
	APTR impf_ContentsBox
	APTR impf_FrameBox
	APTR impf_DrInfo
	ULONG impf_FrameFlags
;STRUCT

1  0 <<  constant FRAMEF_SPECIFY

:STRUCT impDraw
	ULONG MethodID
	APTR impd_RPort
	SHORT impd_Offset.X
	SHORT impd_Offset.Y
	ULONG impd_State
	APTR impd_DrInfo
	SHORT impd_Dimensions.Width
	SHORT impd_Dimensions.Height
;STRUCT

:STRUCT impErase
	ULONG MethodID
	APTR impe_RPort
	SHORT impe_Offset.X
	SHORT impe_Offset.Y
	SHORT impe_Dimensions.Width
	SHORT impe_Dimensions.Height
;STRUCT

:STRUCT impHitTest
	ULONG MethodID
	SHORT imph_Point.X
	SHORT imph_Point.Y
	SHORT imph_Dimensions.Width
	SHORT imph_Dimensions.Height
;STRUCT

EXISTS? INTUITION_IOBSOLETE_H NOT .IF
include ji:intuition/iobsolete.j
.THEN

.THEN
