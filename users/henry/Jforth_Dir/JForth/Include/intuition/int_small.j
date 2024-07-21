." INT_SMALL.J isn't really needed now that JForth has" cr
." MODULES.  Just use GETMODULE INCLUDES ." cr
." This file is only included for compatibility with V1.2" cr

\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? INTUITION_INTUITION_H NOT .IF 

\ This is the Delta Research CONDENSED version of INTUITION.J
\ If you are not using Preferences, the Printer device, or Gadgets
\ then you probably can use this file instead of INTUITION.J .
\
\ You may want to create your own version of INTUITION.J if you
\ are having problems with using too much memory.
\ You may want to use the UNUSED.WORDS facility to find out
\ what you are not using from this file.
\
\ Remember that if any part of a structure is used, then you must
\ compile the entire structure definition.

\ This include is for MISCELLANEOUS code at end.
include? devices_inputevent_h ji:devices/inputevent.j

TRUE  constant INTUITION_INTUITION_H

:STRUCT Menu
  APTR mu_NextMenu
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

$ 0001  constant MENUENABLED
$ 0100  constant MIDRAWN

:STRUCT MenuItem
  APTR mi_NextItem
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

$ 0001  constant CHECKIT
$ 0002  constant ITEMTEXT
$ 0004  constant COMMSEQ
$ 0008  constant MENUTOGGLE
$ 0010  constant ITEMENABLED
$ 00C0  constant HIGHFLAGS
$ 0000  constant HIGHIMAGE
$ 0040  constant HIGHCOMP
$ 0080  constant HIGHBOX
$ 00C0  constant HIGHNONE
$ 0100  constant CHECKED
$ 1000  constant ISDRAWN
$ 2000  constant HIGHITEM
$ 4000  constant MENUTOGGLED

:STRUCT IntuiText
  UBYTE it_FrontPen
  UBYTE it_BackPen
  UBYTE it_DrawMode
  SHORT it_LeftEdge
  SHORT it_TopEdge
  APTR it_ITextFont
  APTR it_IText
  APTR it_NextText
;STRUCT 


:STRUCT Border
  SHORT bd_LeftEdge
  SHORT bd_TopEdge
  UBYTE bd_FrontPen
  UBYTE bd_BackPen
  UBYTE bd_DrawMode
  BYTE bd_Count
  APTR bd_XY
  APTR bd_NextBorder
;STRUCT 


:STRUCT Image
  SHORT ig_LeftEdge
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
  STRUCT Message    im_ExecMessage
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

$ 00000001  constant SIZEVERIFY
$ 00000002  constant NEWSIZE
$ 00000004  constant REFRESHWINDOW
$ 00000008  constant MOUSEBUTTONS
$ 00000010  constant MOUSEMOVE
$ 00000020  constant GADGETDOWN
$ 00000040  constant GADGETUP
$ 00000080  constant REQSET
$ 00000100  constant MENUPICK
$ 00000200  constant CLOSEWINDOW
$ 00000400  constant RAWKEY
$ 00000800  constant REQVERIFY
$ 00001000  constant REQCLEAR
$ 00002000  constant MENUVERIFY
$ 00004000  constant NEWPREFS
$ 00008000  constant DISKINSERTED
$ 00010000  constant DISKREMOVED
$ 00020000  constant WBENCHMESSAGE
$ 00040000  constant ACTIVEWINDOW
$ 00080000  constant INACTIVEWINDOW
$ 00100000  constant DELTAMOVE
$ 00200000  constant VANILLAKEY
$ 00400000  constant INTUITICKS
$ 80000000  constant LONELYMESSAGE
$ 0001  constant MENUHOT
$ 0002  constant MENUCANCEL
$ 0003  constant MENUWAITING
MENUHOT  constant OKOK
$ 0004  constant OKABORT
MENUCANCEL  constant OKCANCEL
$ 0001  constant WBENCHOPEN
$ 0002  constant WBENCHCLOSE

:STRUCT Window
  APTR wd_NextWindow
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
;STRUCT 

$ 0001  constant WINDOWSIZING
$ 0002  constant WINDOWDRAG
$ 0004  constant WINDOWDEPTH
$ 0008  constant WINDOWCLOSE
$ 0010  constant SIZEBRIGHT
$ 0020  constant SIZEBBOTTOM
$ 00C0  constant REFRESHBITS
$ 0000  constant SMART_REFRESH
$ 0040  constant SIMPLE_REFRESH
$ 0080  constant SUPER_BITMAP
$ 00C0  constant OTHER_REFRESH
$ 0100  constant BACKDROP
$ 0200  constant REPORTMOUSE
$ 0400  constant GIMMEZEROZERO
$ 0800  constant BORDERLESS
$ 1000  constant ACTIVATE
$ 2000  constant WINDOWACTIVE
$ 4000  constant INREQUEST
$ 8000  constant MENUSTATE
$ 00010000  constant RMBTRAP
$ 00020000  constant NOCAREREFRESH
$ 01000000  constant WINDOWREFRESH
$ 02000000  constant WBENCHWINDOW
$ 04000000  constant WINDOWTICKED
$ FCFC0000  constant SUPER_UNUSED

:STRUCT NewWindow
  SHORT nw_LeftEdge
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


\ NewScreen ============================================
$ 000F  constant SCREENTYPE
$ 0001  constant WBENCHSCREEN
$ 000F  constant CUSTOMSCREEN
$ 0010  constant SHOWTITLE
$ 0020  constant BEEPING
$ 0040  constant CUSTOMBITMAP
$ 0080  constant SCREENBEHIND
$ 0100  constant SCREENQUIET
-1  constant STDSCREENHEIGHT

:STRUCT NewScreen
    SHORT ns_LeftEdge
    SHORT ns_TopEdge
    SHORT ns_Width
    SHORT ns_Height
    SHORT ns_Depth
    BYTE ns_DetailPen
    BYTE ns_BlockPen
    SHORT ns_ViewModes
    SHORT ns_Type
    APTR ns_Font
    APTR ns_DefaultTitle
    APTR ns_Gadgets
    APTR ns_CustomBitMap
;STRUCT 

:STRUCT Remember
  APTR rm_NextRemember
  ULONG rm_RememberSize
  APTR rm_Memory
;STRUCT 

\ %? #define    MENUNUM(n)    (n    &    0x1F): MENUNUM ;
\ %? #define    ITEMNUM(n)    ((n    >>    5)    &    0x003F): ITEMNUM ;
\ %? #define    SUBNUM(n)    ((n    >>    11)    &    0x001F): SUBNUM ;
\ %? #define    SHIFTMENU(n)    (n    &    0x1F): SHIFTMENU ;
\ %? #define    SHIFTITEM(n)    ((n    &    0x3F)    <<    5): SHIFTITEM ;
\ %? #define    SHIFTSUB(n)    ((n    &    0x1F)    <<    11): SHIFTSUB ;
\ %? #define    SRBNUM(n)    (0x08    -    (n    >>    4)): SRBNUM ;
\ %? #define    SWBNUM(n)    (0x08    -    (n    &    0x0F)): SWBNUM ;
\ %? #define    SSBNUM(n)    (0x01    +    (n    >>    4)): SSBNUM ;
\ %? #define    SPARNUM(n)    (n    >>    4): SPARNUM ;
\ %? #define    SHAKNUM(n)    (n    &    0x0F): SHAKNUM ;
$ 001F  constant NOMENU
$ 003F  constant NOITEM
$ 001F  constant NOSUB
$ FFFF  constant MENUNULL
\ %? #define    FOREVER    for(;;)
\ %? #define    SIGN(x)    (    ((x)    >    0)    -    ((x)    <    0)    ): SIGN ;
\ %? #define    NOT    !
19  constant CHECKWIDTH
27  constant COMMWIDTH
13  constant LOWCHECKWIDTH
16  constant LOWCOMMWIDTH
$ 80000000  constant ALERT_TYPE
$ 00000000  constant RECOVERY_ALERT
$ 80000000  constant DEADEND_ALERT
0  constant AUTOFRONTPEN
1  constant AUTOBACKPEN
EXISTS? JAM1 NOT .IF
    0 constant JAM1
    1 constant JAM2
.THEN
JAM2  constant AUTODRAWMODE
6  constant AUTOLEFTEDGE
3  constant AUTOTOPEDGE
NULL  constant AUTOITEXTFONT
NULL  constant AUTONEXTTEXT
IECODE_LBUTTON IECODE_UP_PREFIX | constant SELECTUP
IECODE_LBUTTON  constant SELECTDOWN
IECODE_RBUTTON IECODE_UP_PREFIX |  constant MENUUP
IECODE_RBUTTON  constant MENUDOWN
IEQUALIFIER_LALT  constant ALTLEFT
IEQUALIFIER_RALT  constant ALTRIGHT
IEQUALIFIER_LCOMMAND  constant AMIGALEFT
IEQUALIFIER_RCOMMAND  constant AMIGARIGHT
AMIGALEFT AMIGARIGHT |  constant AMIGAKEYS
$ 4C  constant CURSORUP
$ 4F  constant CURSORLEFT
$ 4E  constant CURSORRIGHT
$ 4D  constant CURSORDOWN
$ 10  constant KEYCODE_Q
$ 32  constant KEYCODE_X
$ 36  constant KEYCODE_N
$ 37  constant KEYCODE_M
$ 34  constant KEYCODE_V
$ 35  constant KEYCODE_B

.THEN
