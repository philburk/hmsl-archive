\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_INTUITION_H NOT .IF
TRUE   constant INTUITION_INTUITION_H
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

EXISTS? GRAPHICS_TEXT_H NOT .IF
include ji:graphics/text.j
.THEN

EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? DEVICES_INPUTEVENT_H NOT .IF
include ji:devices/inputevent.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

:STRUCT Menu
	( %M JForth prefix ) APTR mu_NextMenu
	SHORT mu_LeftEdge
	SHORT mu_TopEdge
	SHORT mu_Width
	SHORT mu_Height
	USHORT mu_Flags
	APTR mu_MenuName
	APTR mu_FirstItem
	SHORT mu_JazzX
	SHORT mu_JazzY
	SHORT mu_BeatX
	SHORT mu_BeatY
;STRUCT

$ 0001   constant MENUENABLED

$ 0100   constant MIDRAWN

:STRUCT MenuItem
	( %M JForth prefix ) APTR mi_NextItem
	SHORT mi_LeftEdge
	SHORT mi_TopEdge
	SHORT mi_Width
	SHORT mi_Height
	USHORT mi_Flags
	LONG mi_MutualExclude
	APTR mi_ItemFill
	APTR mi_SelectFill
	BYTE mi_Command
	APTR mi_SubItem
	USHORT mi_NextSelect
;STRUCT

$ 0001   constant CHECKIT
$ 0002   constant ITEMTEXT
$ 0004   constant COMMSEQ
$ 0008   constant MENUTOGGLE
$ 0010   constant ITEMENABLED

$ 00C0   constant HIGHFLAGS
$ 0000   constant HIGHIMAGE
$ 0040   constant HIGHCOMP
$ 0080   constant HIGHBOX
$ 00C0   constant HIGHNONE

$ 0100   constant CHECKED

$ 1000   constant ISDRAWN
$ 2000   constant HIGHITEM
$ 4000   constant MENUTOGGLED

:STRUCT Requester
	( %M JForth prefix ) APTR rq_OlderRequest
	SHORT rq_LeftEdge
	SHORT rq_TopEdge
	SHORT rq_Width
	SHORT rq_Height
	SHORT rq_RelLeft
	SHORT rq_RelTop
	APTR rq_ReqGadget
	APTR rq_ReqBorder
	APTR rq_ReqText
	USHORT rq_Flags
	UBYTE rq_BackFill
	APTR rq_ReqLayer
	( %?) 32 BYTES rq_ReqPad1
	APTR rq_ImageBMap
	APTR rq_RWindow
	APTR rq_ReqImage
	( %?) 32 BYTES rq_ReqPad2
;STRUCT

$ 0001   constant POINTREL

$ 0002   constant PREDRAWN

$ 0004   constant NOISYREQ

$ 0010   constant SIMPLEREQ


$ 0020   constant USEREQIMAGE

$ 0040   constant NOREQBACKFILL


$ 1000   constant REQOFFWINDOW
$ 2000   constant REQACTIVE
$ 4000   constant SYSREQUEST
$ 8000   constant DEFERREFRESH

:STRUCT Gadget
	( %M JForth prefix ) APTR gg_NextGadget
	SHORT gg_LeftEdge
	SHORT gg_TopEdge
	SHORT gg_Width
	SHORT gg_Height
	USHORT gg_Flags
	USHORT gg_Activation
	USHORT gg_GadgetType
	APTR gg_GadgetRender
	APTR gg_SelectRender
	APTR gg_GadgetText
	LONG gg_MutualExclude
	APTR gg_SpecialInfo
	USHORT gg_GadgetID
	APTR gg_UserData
;STRUCT

$ 0003   constant GFLG_GADGHIGHBITS
$ 0000   constant GFLG_GADGHCOMP
$ 0001   constant GFLG_GADGHBOX
$ 0002   constant GFLG_GADGHIMAGE
$ 0003   constant GFLG_GADGHNONE

$ 0004   constant GFLG_GADGIMAGE
$ 0008   constant GFLG_RELBOTTOM
$ 0010   constant GFLG_RELRIGHT
$ 0020   constant GFLG_RELWIDTH
$ 0040   constant GFLG_RELHEIGHT

$ 0080   constant GFLG_SELECTED

$ 0100   constant GFLG_DISABLED

$ 3000   constant GFLG_LABELMASK
$ 0000   constant GFLG_LABELITEXT
$ 1000   constant GFLG_LABELSTRING
$ 2000   constant GFLG_LABELIMAGE

$ 0200   constant GFLG_TABCYCLE
$ 0400   constant GFLG_STRINGEXTEND

$ 0001   constant GACT_RELVERIFY

$ 0002   constant GACT_IMMEDIATE

$ 0004   constant GACT_ENDGADGET

$ 0008   constant GACT_FOLLOWMOUSE

$ 0010   constant GACT_RIGHTBORDER
$ 0020   constant GACT_LEFTBORDER
$ 0040   constant GACT_TOPBORDER
$ 0080   constant GACT_BOTTOMBORDER
$ 8000   constant GACT_BORDERSNIFF

$ 0100   constant GACT_TOGGLESELECT
$ 2000   constant GACT_BOOLEXTEND

$ 0000   constant GACT_STRINGLEFT
$ 0200   constant GACT_STRINGCENTER
$ 0400   constant GACT_STRINGRIGHT
$ 0800   constant GACT_LONGINT
$ 1000   constant GACT_ALTKEYMAP
$ 2000   constant GACT_STRINGEXTEND

$ 4000   constant GACT_ACTIVEGADGET
$ FC00   constant GTYP_GADGETTYPE
$ 8000   constant GTYP_SYSGADGET
$ 4000   constant GTYP_SCRGADGET
$ 2000   constant GTYP_GZZGADGET
$ 1000   constant GTYP_REQGADGET
$ 0010   constant GTYP_SIZING
$ 0020   constant GTYP_WDRAGGING
$ 0030   constant GTYP_SDRAGGING
$ 0040   constant GTYP_WUPFRONT
$ 0050   constant GTYP_SUPFRONT
$ 0060   constant GTYP_WDOWNBACK
$ 0070   constant GTYP_SDOWNBACK
$ 0080   constant GTYP_CLOSE
$ 0001   constant GTYP_BOOLGADGET
$ 0002   constant GTYP_GADGET0002
$ 0003   constant GTYP_PROPGADGET
$ 0004   constant GTYP_STRGADGET
$ 0005   constant GTYP_CUSTOMGADGET
$ 0007   constant GTYP_GTYPEMASK

:STRUCT BoolInfo
	( %M JForth prefix ) USHORT bi_Flags
	APTR bi_Mask
	ULONG bi_Reserved
;STRUCT

$ 0001   constant BOOLMASK

:STRUCT PropInfo
	( %M JForth prefix ) USHORT pi_Flags
	USHORT pi_HorizPot
	USHORT pi_VertPot
	USHORT pi_HorizBody
	USHORT pi_VertBody
	USHORT pi_CWidth
	USHORT pi_CHeight
	USHORT pi_HPotRes
	USHORT pi_VPotRes
	USHORT pi_LeftBorder
	USHORT pi_TopBorder
;STRUCT

$ 0001   constant AUTOKNOB
$ 0002   constant FREEHORIZ
$ 0004   constant FREEVERT
$ 0008   constant PROPBORDERLESS
$ 0100   constant KNOBHIT
$ 0010   constant PROPNEWLOOK
6   constant KNOBHMIN
4   constant KNOBVMIN
$ FFFF   constant MAXBODY
$ FFFF   constant MAXPOT

:STRUCT StringInfo
	( %M JForth prefix ) APTR si_Buffer
	APTR si_UndoBuffer
	SHORT si_BufferPos
	SHORT si_MaxChars
	SHORT si_DispPos
	SHORT si_UndoPos
	SHORT si_NumChars
	SHORT si_DispCount
	SHORT si_CLeft
	SHORT si_CTop
	APTR si_Extension
	LONG si_LongInt
	APTR si_AltKeyMap
;STRUCT

:STRUCT IntuiText
	( %M JForth prefix ) UBYTE it_FrontPen
		UBYTE it_BackPen
	UBYTE it_DrawMode
	SHORT it_LeftEdge
	SHORT it_TopEdge
	APTR it_ITextFont
	APTR it_IText
	APTR it_NextText
;STRUCT

:STRUCT Border
	( %M JForth prefix ) SHORT bd_LeftEdge
		SHORT bd_TopEdge
	UBYTE bd_FrontPen
	UBYTE bd_BackPen
	UBYTE bd_DrawMode
	BYTE bd_Count
	APTR bd_XY
	APTR bd_NextBorder
;STRUCT

:STRUCT Image
	( %M JForth prefix ) SHORT ig_LeftEdge
	SHORT ig_TopEdge
	SHORT ig_Width
	SHORT ig_Height
	SHORT ig_Depth
	APTR ig_ImageData
	UBYTE ig_PlanePick
	UBYTE ig_PlaneOnOff
	APTR ig_NextImage
;STRUCT

:STRUCT IntuiMessage
	( %M JForth prefix ) STRUCT Message im_ExecMessage
	ULONG im_Class
	USHORT im_Code
	USHORT im_Qualifier
	APTR im_IAddress
	SHORT im_MouseX
	SHORT im_MouseY
	ULONG im_Seconds
	ULONG im_Micros
	APTR im_IDCMPWindow
	APTR im_SpecialLink
;STRUCT

$ 00000001   constant IDCMP_SIZEVERIFY
$ 00000002   constant IDCMP_NEWSIZE
$ 00000004   constant IDCMP_REFRESHWINDOW
$ 00000008   constant IDCMP_MOUSEBUTTONS
$ 00000010   constant IDCMP_MOUSEMOVE
$ 00000020   constant IDCMP_GADGETDOWN
$ 00000040   constant IDCMP_GADGETUP
$ 00000080   constant IDCMP_REQSET
$ 00000100   constant IDCMP_MENUPICK
$ 00000200   constant IDCMP_CLOSEWINDOW
$ 00000400   constant IDCMP_RAWKEY
$ 00000800   constant IDCMP_REQVERIFY
$ 00001000   constant IDCMP_REQCLEAR
$ 00002000   constant IDCMP_MENUVERIFY
$ 00004000   constant IDCMP_NEWPREFS
$ 00008000   constant IDCMP_DISKINSERTED
$ 00010000   constant IDCMP_DISKREMOVED
$ 00020000   constant IDCMP_WBENCHMESSAGE
$ 00040000   constant IDCMP_ACTIVEWINDOW
$ 00080000   constant IDCMP_INACTIVEWINDOW
$ 00100000   constant IDCMP_DELTAMOVE
$ 00200000   constant IDCMP_VANILLAKEY
$ 00400000   constant IDCMP_INTUITICKS
$ 00800000   constant IDCMP_IDCMPUPDATE
$ 01000000   constant IDCMP_MENUHELP
$ 02000000   constant IDCMP_CHANGEWINDOW

$ 80000000   constant IDCMP_LONELYMESSAGE

$ 0001   constant MENUHOT
$ 0002   constant MENUCANCEL
$ 0003   constant MENUWAITING

MENUHOT   constant OKOK
$ 0004   constant OKABORT
MENUCANCEL   constant OKCANCEL

$ 0001   constant WBENCHOPEN
$ 0002   constant WBENCHCLOSE

:STRUCT IBox
	( %M JForth prefix ) SHORT ibx_Left
	SHORT ibx_Top
	SHORT ibx_Width
	SHORT ibx_Height
;STRUCT

:STRUCT Window
	( %M JForth prefix ) APTR wd_NextWindow
	SHORT wd_LeftEdge
	SHORT wd_TopEdge
	SHORT wd_Width
	SHORT wd_Height
	SHORT wd_MouseY
	SHORT wd_MouseX
	SHORT wd_MinWidth
	SHORT wd_MinHeight
	USHORT wd_MaxWidth
	USHORT wd_MaxHeight
	ULONG wd_Flags
	APTR wd_MenuStrip
	APTR wd_Title
	APTR wd_FirstRequest
	APTR wd_DMRequest
	SHORT wd_ReqCount
	APTR wd_WScreen
	APTR wd_RPort
	BYTE wd_BorderLeft
	BYTE wd_BorderTop
	BYTE wd_BorderRight
	BYTE wd_BorderBottom
	APTR wd_BorderRPort
	APTR wd_FirstGadget
	APTR wd_Parent
	APTR wd_Descendant
	APTR wd_Pointer
	BYTE wd_PtrHeight
	BYTE wd_PtrWidth
	BYTE wd_XOffset
	BYTE wd_YOffset
	ULONG wd_IDCMPFlags
	APTR wd_UserPort
	APTR wd_WindowPort
	APTR wd_MessageKey
	UBYTE wd_DetailPen
	UBYTE wd_BlockPen
	APTR wd_CheckMark
	APTR wd_ScreenTitle
	SHORT wd_GZZMouseX
	SHORT wd_GZZMouseY
	SHORT wd_GZZWidth
	SHORT wd_GZZHeight
	APTR wd_ExtData
	APTR wd_UserData
	APTR wd_WLayer
	APTR wd_IFont
	ULONG wd_MoreFlags
;STRUCT

$ 00000001   constant WFLG_SIZEGADGET
$ 00000002   constant WFLG_DRAGBAR
$ 00000004   constant WFLG_DEPTHGADGET
$ 00000008   constant WFLG_CLOSEGADGET

$ 00000010   constant WFLG_SIZEBRIGHT
$ 00000020   constant WFLG_SIZEBBOTTOM

$ 000000C0   constant WFLG_REFRESHBITS
$ 00000000   constant WFLG_SMART_REFRESH
$ 00000040   constant WFLG_SIMPLE_REFRESH
$ 00000080   constant WFLG_SUPER_BITMAP
$ 000000C0   constant WFLG_OTHER_REFRESH

$ 00000100   constant WFLG_BACKDROP

$ 00000200   constant WFLG_REPORTMOUSE

$ 00000400   constant WFLG_GIMMEZEROZERO

$ 00000800   constant WFLG_BORDERLESS

$ 00001000   constant WFLG_ACTIVATE

$ 00002000   constant WFLG_WINDOWACTIVE
$ 00004000   constant WFLG_INREQUEST
$ 00008000   constant WFLG_MENUSTATE

$ 00010000   constant WFLG_RMBTRAP
$ 00020000   constant WFLG_NOCAREREFRESH

$ 01000000   constant WFLG_WINDOWREFRESH
$ 02000000   constant WFLG_WBENCHWINDOW
$ 04000000   constant WFLG_WINDOWTICKED

$ 00040000   constant WFLG_NW_EXTENDED


$ 08000000   constant WFLG_VISITOR
$ 10000000   constant WFLG_ZOOMED
$ 20000000   constant WFLG_HASZOOM

5   constant DEFAULTMOUSEQUEUE

:STRUCT NewWindow
	( %M JForth prefix ) SHORT nw_LeftEdge
		SHORT nw_TopEdge
	SHORT nw_Width
	SHORT nw_Height
	UBYTE nw_DetailPen
	UBYTE nw_BlockPen
	ULONG nw_IDCMPFlags
	ULONG nw_Flags
	APTR nw_FirstGadget
	APTR nw_CheckMark
	APTR nw_Title
	APTR nw_Screen
	APTR nw_BitMap
	SHORT nw_MinWidth
	SHORT nw_MinHeight
	USHORT nw_MaxWidth
	USHORT nw_MaxHeight
	USHORT nw_Type
;STRUCT

:STRUCT ExtNewWindow
	( %M JForth prefix ) SHORT enw_LeftEdge
		SHORT enw_TopEdge
	SHORT enw_Width
	SHORT enw_Height
	UBYTE enw_DetailPen
	UBYTE enw_BlockPen
	ULONG enw_IDCMPFlags
	ULONG enw_Flags
	APTR enw_FirstGadget
	APTR enw_CheckMark
	APTR enw_Title
	APTR enw_Screen
	APTR enw_BitMap
	SHORT enw_MinWidth
	SHORT enw_MinHeight
	USHORT enw_MaxWidth
	USHORT enw_MaxHeight
	USHORT enw_Type
	APTR enw_Extension
;STRUCT

TAG_USER  99 +  constant WA_Dummy

WA_Dummy  $ 01 +  constant WA_Left
WA_Dummy  $ 02 +  constant WA_Top
WA_Dummy  $ 03 +  constant WA_Width
WA_Dummy  $ 04 +  constant WA_Height
WA_Dummy  $ 05 +  constant WA_DetailPen
WA_Dummy  $ 06 +  constant WA_BlockPen
WA_Dummy  $ 07 +  constant WA_IDCMP

WA_Dummy  $ 08 +  constant WA_Flags
WA_Dummy  $ 09 +  constant WA_Gadgets
WA_Dummy  $ 0A +  constant WA_Checkmark
WA_Dummy  $ 0B +  constant WA_Title

WA_Dummy  $ 0C +  constant WA_ScreenTitle
WA_Dummy  $ 0D +  constant WA_CustomScreen
WA_Dummy  $ 0E +  constant WA_SuperBitMap

WA_Dummy  $ 0F +  constant WA_MinWidth
WA_Dummy  $ 10 +  constant WA_MinHeight
WA_Dummy  $ 11 +  constant WA_MaxWidth
WA_Dummy  $ 12 +  constant WA_MaxHeight

WA_Dummy  $ 13 +  constant WA_InnerWidth
WA_Dummy  $ 14 +  constant WA_InnerHeight

WA_Dummy  $ 15 +  constant WA_PubScreenName

WA_Dummy  $ 16 +  constant WA_PubScreen

WA_Dummy  $ 17 +  constant WA_PubScreenFallBack

WA_Dummy  $ 18 +  constant WA_WindowName

WA_Dummy  $ 19 +  constant WA_Colors

WA_Dummy  $ 1A +  constant WA_Zoom

WA_Dummy  $ 1B +  constant WA_MouseQueue

WA_Dummy  $ 1C +  constant WA_BackFill

WA_Dummy  $ 1D +  constant WA_RptQueue


WA_Dummy  $ 1E +  constant WA_SizeGadget
WA_Dummy  $ 1F +  constant WA_DragBar
WA_Dummy  $ 20 +  constant WA_DepthGadget
WA_Dummy  $ 21 +  constant WA_CloseGadget
WA_Dummy  $ 22 +  constant WA_Backdrop
WA_Dummy  $ 23 +  constant WA_ReportMouse
WA_Dummy  $ 24 +  constant WA_NoCareRefresh
WA_Dummy  $ 25 +  constant WA_Borderless
WA_Dummy  $ 26 +  constant WA_Activate
WA_Dummy  $ 27 +  constant WA_RMBTrap
WA_Dummy  $ 28 +  constant WA_WBenchWindow
WA_Dummy  $ 29 +  constant WA_SimpleRefresh

WA_Dummy  $ 2A +  constant WA_SmartRefresh

WA_Dummy  $ 2B +  constant WA_SizeBRight
WA_Dummy  $ 2C +  constant WA_SizeBBottom

WA_Dummy  $ 2D +  constant WA_AutoAdjust

WA_Dummy  $ 2E +  constant WA_GimmeZeroZero


WA_Dummy  $ 2F +  constant WA_MenuHelp

EXISTS? INTUITION_SCREENS_H NOT .IF
include ji:intuition/screens.j
.THEN

EXISTS? INTUITION_PREFERENCES_H NOT .IF
include ji:intuition/preferences.j
.THEN

:STRUCT Remember
	( %M JForth prefix ) APTR rm_NextRemember
	ULONG rm_RememberSize
	APTR rm_Memory
;STRUCT

:STRUCT ColorSpec
	( %M JForth prefix ) SHORT cs_ColorIndex
	USHORT cs_Red
	USHORT cs_Green
	USHORT cs_Blue
;STRUCT

:STRUCT EasyStruct
	ULONG es_StructSize
	ULONG es_Flags
	APTR es_Title
	APTR es_TextFormat
	APTR es_GadgetFormat
;STRUCT

\ %? #define MENUNUM(n) (n & 0x1F): MENUNUM ;
\ %? #define ITEMNUM(n) ((n >> 5) & 0x003F): ITEMNUM ;
\ %? #define SUBNUM(n) ((n >> 11) & 0x001F): SUBNUM ;

\ %? #define SHIFTMENU(n) (n & 0x1F): SHIFTMENU ;
\ %? #define SHIFTITEM(n) ((n & 0x3F) << 5): SHIFTITEM ;
\ %? #define SHIFTSUB(n) ((n & 0x1F) << 11): SHIFTSUB ;

\ %? #define FULLMENUNUM( menu, item, sub )	\: FULLMENUNUM ;
\ %? 	( SHIFTSUB(sub) | SHIFTITEM(item) | SHIFTMENU(menu) )

\ %? #define SRBNUM(n)    (0x08 - (n >> 4))	/* SerRWBits -> read bits per char */: SRBNUM ;
\ %? #define SWBNUM(n)    (0x08 - (n & 0x0F))/* SerRWBits -> write bits per chr */: SWBNUM ;
\ %? #define SSBNUM(n)    (0x01 + (n >> 4))	/* SerStopBuf -> stop bits per chr */: SSBNUM ;
\ %? #define SPARNUM(n)   (n >> 4)		/* SerParShk -> parity setting	  */: SPARNUM ;
\ %? #define SHAKNUM(n)   (n & 0x0F)	/* SerParShk -> handshake mode	  */: SHAKNUM ;

$ 001F   constant NOMENU
$ 003F   constant NOITEM
$ 001F   constant NOSUB
$ FFFF   constant MENUNULL

\ %? #define FOREVER for(;;)
\ %? #define SIGN(x) ( ((x) > 0) - ((x) < 0) ): SIGN ;
\ %? #define NOT !

19   constant CHECKWIDTH
27   constant COMMWIDTH
13   constant LOWCHECKWIDTH
16   constant LOWCOMMWIDTH

$ 80000000   constant ALERT_TYPE
$ 00000000   constant RECOVERY_ALERT
$ 80000000   constant DEADEND_ALERT

0   constant AUTOFRONTPEN
1   constant AUTOBACKPEN
JAM2   constant AUTODRAWMODE
6   constant AUTOLEFTEDGE
3   constant AUTOTOPEDGE
NULL   constant AUTOITEXTFONT
NULL   constant AUTONEXTTEXT

IECODE_LBUTTON IECODE_UP_PREFIX | constant SELECTUP ( %M )
IECODE_LBUTTON   constant SELECTDOWN
IECODE_RBUTTON  IECODE_UP_PREFIX |  constant MENUUP
IECODE_RBUTTON   constant MENUDOWN
IECODE_MBUTTON   constant MIDDLEDOWN
IECODE_MBUTTON  IECODE_UP_PREFIX |  constant MIDDLEUP
IEQUALIFIER_LALT   constant ALTLEFT
IEQUALIFIER_RALT   constant ALTRIGHT
IEQUALIFIER_LCOMMAND   constant AMIGALEFT
IEQUALIFIER_RCOMMAND   constant AMIGARIGHT
AMIGALEFT  AMIGARIGHT |  constant AMIGAKEYS

$ 4C   constant CURSORUP
$ 4F   constant CURSORLEFT
$ 4E   constant CURSORRIGHT
$ 4D   constant CURSORDOWN
$ 10   constant KEYCODE_Q
$ 31   constant KEYCODE_Z
$ 32   constant KEYCODE_X
$ 34   constant KEYCODE_V
$ 35   constant KEYCODE_B
$ 36   constant KEYCODE_N
$ 37   constant KEYCODE_M
$ 38   constant KEYCODE_LESS
$ 39   constant KEYCODE_GREATER

EXISTS? INTUITION_IOBSOLETE_H NOT .IF
include ji:intuition/iobsolete.j
.THEN

.THEN
