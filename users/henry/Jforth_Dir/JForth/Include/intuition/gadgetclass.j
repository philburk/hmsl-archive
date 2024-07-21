\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_GADGETCLASS_H NOT .IF
1   constant INTUITION_GADGETCLASS_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

TAG_USER  $ 30000 +  constant GA_Dummy
GA_Dummy  $ 0001 +  constant GA_Left
GA_Dummy  $ 0002 +  constant GA_RelRight
GA_Dummy  $ 0003 +  constant GA_Top
GA_Dummy  $ 0004 +  constant GA_RelBottom
GA_Dummy  $ 0005 +  constant GA_Width
GA_Dummy  $ 0006 +  constant GA_RelWidth
GA_Dummy  $ 0007 +  constant GA_Height
GA_Dummy  $ 0008 +  constant GA_RelHeight
GA_Dummy  $ 0009 +  constant GA_Text
GA_Dummy  $ 000A +  constant GA_Image
GA_Dummy  $ 000B +  constant GA_Border
GA_Dummy  $ 000C +  constant GA_SelectRender
GA_Dummy  $ 000D +  constant GA_Highlight
GA_Dummy  $ 000E +  constant GA_Disabled
GA_Dummy  $ 000F +  constant GA_GZZGadget
GA_Dummy  $ 0010 +  constant GA_ID
GA_Dummy  $ 0011 +  constant GA_UserData
GA_Dummy  $ 0012 +  constant GA_SpecialInfo
GA_Dummy  $ 0013 +  constant GA_Selected
GA_Dummy  $ 0014 +  constant GA_EndGadget
GA_Dummy  $ 0015 +  constant GA_Immediate
GA_Dummy  $ 0016 +  constant GA_RelVerify
GA_Dummy  $ 0017 +  constant GA_FollowMouse
GA_Dummy  $ 0018 +  constant GA_RightBorder
GA_Dummy  $ 0019 +  constant GA_LeftBorder
GA_Dummy  $ 001A +  constant GA_TopBorder
GA_Dummy  $ 001B +  constant GA_BottomBorder
GA_Dummy  $ 001C +  constant GA_ToggleSelect

GA_Dummy  $ 001D +  constant GA_SysGadget

GA_Dummy  $ 001E +  constant GA_SysGType


GA_Dummy  $ 001F +  constant GA_Previous

GA_Dummy  $ 0020 +  constant GA_Next


GA_Dummy  $ 0021 +  constant GA_DrawInfo

GA_Dummy  $ 0022 +  constant GA_IntuiText


GA_Dummy  $ 0023 +  constant GA_LabelImage

GA_Dummy  $ 0024 +  constant GA_TabCycle

TAG_USER  $ 31000 +  constant PGA_Dummy
PGA_Dummy  $ 0001 +  constant PGA_Freedom

PGA_Dummy  $ 0002 +  constant PGA_Borderless
PGA_Dummy  $ 0003 +  constant PGA_HorizPot
PGA_Dummy  $ 0004 +  constant PGA_HorizBody
PGA_Dummy  $ 0005 +  constant PGA_VertPot
PGA_Dummy  $ 0006 +  constant PGA_VertBody
PGA_Dummy  $ 0007 +  constant PGA_Total
PGA_Dummy  $ 0008 +  constant PGA_Visible
PGA_Dummy  $ 0009 +  constant PGA_Top
PGA_Dummy  $ 000A +  constant PGA_NewLook

TAG_USER  $ 32000 +  constant STRINGA_Dummy
STRINGA_Dummy  $ 0001 +  constant STRINGA_MaxChars
STRINGA_Dummy  $ 0002 +  constant STRINGA_Buffer
STRINGA_Dummy  $ 0003 +  constant STRINGA_UndoBuffer
STRINGA_Dummy  $ 0004 +  constant STRINGA_WorkBuffer
STRINGA_Dummy  $ 0005 +  constant STRINGA_BufferPos
STRINGA_Dummy  $ 0006 +  constant STRINGA_DispPos
STRINGA_Dummy  $ 0007 +  constant STRINGA_AltKeyMap
STRINGA_Dummy  $ 0008 +  constant STRINGA_Font
STRINGA_Dummy  $ 0009 +  constant STRINGA_Pens
STRINGA_Dummy  $ 000A +  constant STRINGA_ActivePens
STRINGA_Dummy  $ 000B +  constant STRINGA_EditHook
STRINGA_Dummy  $ 000C +  constant STRINGA_EditModes

STRINGA_Dummy  $ 000D +  constant STRINGA_ReplaceMode
STRINGA_Dummy  $ 000E +  constant STRINGA_FixedFieldMode
STRINGA_Dummy  $ 000F +  constant STRINGA_NoFilterMode

STRINGA_Dummy  $ 0010 +  constant STRINGA_Justification

STRINGA_Dummy  $ 0011 +  constant STRINGA_LongVal
STRINGA_Dummy  $ 0012 +  constant STRINGA_TextVal

STRINGA_Dummy  $ 0013 +  constant STRINGA_ExitHelp

128   constant SG_DEFAULTMAXCHARS

TAG_USER  $ 38000 +  constant LAYOUTA_Dummy
LAYOUTA_Dummy  $ 0001 +  constant LAYOUTA_LayoutObj
LAYOUTA_Dummy  $ 0002 +  constant LAYOUTA_Spacing
LAYOUTA_Dummy  $ 0003 +  constant LAYOUTA_Orientation

0   constant LORIENT_NONE
1   constant LORIENT_HORIZ
2   constant LORIENT_VERT

-1   constant GM_Dummy
0   constant GM_HITTEST
1   constant GM_RENDER
2   constant GM_GOACTIVE
3   constant GM_HANDLEINPUT
4   constant GM_GOINACTIVE

:STRUCT gpHitTest
	ULONG MethodID
	APTR gpht_GInfo
	SHORT gpht_Mouse.X
	SHORT gpht_Mouse.Y
;STRUCT

$ 00000004   constant GMR_GADGETHIT

:STRUCT gpRender
	ULONG MethodID
	APTR gpr_GInfo
	APTR gpr_RPort
	LONG gpr_Redraw
;STRUCT

2   constant GREDRAW_UPDATE
1   constant GREDRAW_REDRAW
0   constant GREDRAW_TOGGLE

:STRUCT gpInput
	ULONG MethodID
	APTR gpi_GInfo
	APTR gpi_IEvent
	APTR gpi_Termination
	SHORT gpi_Mouse.X
	SHORT gpi_Mouse.Y
;STRUCT

0   constant GMR_MEACTIVE
1  1 <<  constant GMR_NOREUSE
1  2 <<  constant GMR_REUSE
1  3 <<  constant GMR_VERIFY

1  4 <<  constant GMR_NEXTACTIVE
1  5 <<  constant GMR_PREVACTIVE

:STRUCT gpGoInactive
	ULONG MethodID
	APTR gpgi_GInfo
	ULONG gpgi_Abort
;STRUCT

EXISTS? INTUITION_IOBSOLETE_H NOT .IF
include ji:intuition/iobsolete.j
.THEN

.THEN
