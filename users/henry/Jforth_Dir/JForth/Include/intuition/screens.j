\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_SCREENS_H NOT .IF
TRUE   constant INTUITION_SCREENS_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN

EXISTS? GRAPHICS_CLIP_H NOT .IF
include ji:graphics/clip.j
.THEN

EXISTS? GRAPHICS_VIEW_H NOT .IF
include ji:graphics/view.j
.THEN

EXISTS? GRAPHICS_RASTPORT_H NOT .IF
include ji:graphics/rastport.j
.THEN

EXISTS? GRAPHICS_LAYERS_H NOT .IF
include ji:graphics/layers.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

1   constant RI_VERSION
1   constant DRI_VERSION

:STRUCT DrawInfo
	USHORT dri_Version
	USHORT dri_NumPens
	APTR dri_Pens
	APTR dri_Font
	USHORT dri_Depth
	USHORT dri_Resolution.X
	USHORT dri_Resolution.Y
	ULONG dri_Flags
	( %?) 7 4 *  BYTES dri_Reserved
;STRUCT

$ 00000001   constant DRIF_NEWLOOK

$ 0000   constant DETAILPEN
$ 0001   constant BLOCKPEN
$ 0002   constant TEXTPEN
$ 0003   constant SHINEPEN
$ 0004   constant SHADOWPEN
$ 0005   constant FILLPEN
$ 0006   constant FILLTEXTPEN
$ 0007   constant BACKGROUNDPEN
$ 0008   constant HIGHLIGHTTEXTPEN

$ 0009   constant NUMDRIPENS

:STRUCT Screen
	( %M JForth prefix ) APTR sc_NextScreen
	APTR sc_FirstWindow
	SHORT sc_LeftEdge
	SHORT sc_TopEdge
	SHORT sc_Width
	SHORT sc_Height
	SHORT sc_MouseY
	SHORT sc_MouseX
	USHORT sc_Flags
	APTR sc_Title
	APTR sc_DefaultTitle
	BYTE sc_BarHeight
	BYTE sc_BarVBorder
	BYTE sc_BarHBorder
	BYTE sc_MenuVBorder
	BYTE sc_MenuHBorder
	BYTE sc_WBorTop
	BYTE sc_WBorLeft
	BYTE sc_WBorRight
	BYTE sc_WBorBottom
	APTR sc_Font
	STRUCT ViewPort sc_ViewPort
	STRUCT RastPort sc_RastPort
	STRUCT BitMap sc_BitMap
	STRUCT Layer_Info sc_LayerInfo
	APTR sc_FirstGadget
	UBYTE sc_DetailPen
	UBYTE sc_BlockPen
	USHORT sc_SaveColor0
	APTR sc_BarLayer
	APTR sc_ExtData
	APTR sc_UserData
;STRUCT

$ 000F   constant SCREENTYPE
$ 0001   constant WBENCHSCREEN
$ 0002   constant PUBLICSCREEN
$ 000F   constant CUSTOMSCREEN

$ 0010   constant SHOWTITLE

$ 0020   constant BEEPING

$ 0040   constant CUSTOMBITMAP

$ 0080   constant SCREENBEHIND
$ 0100   constant SCREENQUIET
$ 0200   constant SCREENHIRES

$ 1000   constant NS_EXTENDED
$ 4000   constant AUTOSCROLL

-1   constant STDSCREENHEIGHT
-1   constant STDSCREENWIDTH

TAG_USER  32 +  constant SA_Dummy
SA_Dummy  $ 0001 +  constant SA_Left
SA_Dummy  $ 0002 +  constant SA_Top
SA_Dummy  $ 0003 +  constant SA_Width
SA_Dummy  $ 0004 +  constant SA_Height

SA_Dummy  $ 0005 +  constant SA_Depth

SA_Dummy  $ 0006 +  constant SA_DetailPen

SA_Dummy  $ 0007 +  constant SA_BlockPen
SA_Dummy  $ 0008 +  constant SA_Title

SA_Dummy  $ 0009 +  constant SA_Colors

SA_Dummy  $ 000A +  constant SA_ErrorCode

SA_Dummy  $ 000B +  constant SA_Font

SA_Dummy  $ 000C +  constant SA_SysFont

SA_Dummy  $ 000D +  constant SA_Type

SA_Dummy  $ 000E +  constant SA_BitMap

SA_Dummy  $ 000F +  constant SA_PubName

SA_Dummy  $ 0010 +  constant SA_PubSig
SA_Dummy  $ 0011 +  constant SA_PubTask

SA_Dummy  $ 0012 +  constant SA_DisplayID

SA_Dummy  $ 0013 +  constant SA_DClip

SA_Dummy  $ 0014 +  constant SA_Overscan

SA_Dummy  $ 0015 +  constant SA_Obsolete1


SA_Dummy  $ 0016 +  constant SA_ShowTitle

SA_Dummy  $ 0017 +  constant SA_Behind

SA_Dummy  $ 0018 +  constant SA_Quiet

SA_Dummy  $ 0019 +  constant SA_AutoScroll

SA_Dummy  $ 001A +  constant SA_Pens

SA_Dummy  $ 001B +  constant SA_FullPalette

EXISTS? NSTAG_EXT_VPMODE NOT .IF
TAG_USER  1 |  constant NSTAG_EXT_VPMODE
.THEN

1   constant OSERR_NOMONITOR
2   constant OSERR_NOCHIPS
3   constant OSERR_NOMEM
4   constant OSERR_NOCHIPMEM
5   constant OSERR_PUBNOTUNIQUE
6   constant OSERR_UNKNOWNMODE

:STRUCT NewScreen
	( %M JForth prefix ) SHORT ns_LeftEdge
	SHORT ns_TopEdge
	SHORT ns_Width
	SHORT ns_Height
	SHORT ns_Depth
	UBYTE ns_DetailPen
	UBYTE ns_BlockPen
	USHORT ns_ViewModes
	USHORT ns_Type
	APTR ns_Font
	APTR ns_DefaultTitle
	APTR ns_Gadgets
	APTR ns_CustomBitMap
;STRUCT

:STRUCT ExtNewScreen
	( %M JForth prefix ) SHORT ens_LeftEdge
	SHORT ens_TopEdge
	SHORT ens_Width
	SHORT ens_Height
	SHORT ens_Depth
	UBYTE ens_DetailPen
	UBYTE ens_BlockPen
	USHORT ens_ViewModes
	USHORT ens_Type
	APTR ens_Font
	APTR ens_DefaultTitle
	APTR ens_Gadgets
	APTR ens_CustomBitMap
	APTR ens_Extension

;STRUCT

1   constant OSCAN_TEXT
2   constant OSCAN_STANDARD
3   constant OSCAN_MAX
4   constant OSCAN_VIDEO

:STRUCT PubScreenNode
	STRUCT Node	psn_Node
	APTR psn_Screen
	USHORT psn_Flags
	SHORT psn_Size
	SHORT psn_VisitorCount
	APTR psn_SigTask
	UBYTE psn_SigBit
;STRUCT

$ 0001   constant PSNF_PRIVATE

139   constant MAXPUBSCREENNAME

$ 0001   constant SHANGHAI
$ 0002   constant POPPUBSCREEN

EXISTS? INTUITION_IOBSOLETE_H NOT .IF
include ji:intuition/iobsolete.j
.THEN

.THEN
