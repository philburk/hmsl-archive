\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_IOBSOLETE_H NOT .IF
: INTUITION_IOBSOLETE_H ;

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

EXISTS? INTUI_V36_NAMES_ONLY NOT .IF

GFLG_GADGHIGHBITS   constant GADGHIGHBITS
GFLG_GADGHCOMP   constant GADGHCOMP
GFLG_GADGHBOX   constant GADGHBOX
GFLG_GADGHIMAGE   constant GADGHIMAGE
GFLG_GADGHNONE   constant GADGHNONE
GFLG_GADGIMAGE   constant GADGIMAGE
GFLG_RELBOTTOM   constant GRELBOTTOM
GFLG_RELRIGHT   constant GRELRIGHT
GFLG_RELWIDTH   constant GRELWIDTH
GFLG_RELHEIGHT   constant GRELHEIGHT
GFLG_SELECTED   constant SELECTED
GFLG_DISABLED   constant GADGDISABLED
GFLG_LABELMASK   constant LABELMASK
GFLG_LABELITEXT   constant LABELITEXT
GFLG_LABELSTRING   constant LABELSTRING
GFLG_LABELIMAGE   constant LABELIMAGE

GACT_RELVERIFY   constant RELVERIFY
GACT_IMMEDIATE   constant GADGIMMEDIATE
GACT_ENDGADGET   constant ENDGADGET
GACT_FOLLOWMOUSE   constant FOLLOWMOUSE
GACT_RIGHTBORDER   constant RIGHTBORDER
GACT_LEFTBORDER   constant LEFTBORDER
GACT_TOPBORDER   constant TOPBORDER
GACT_BOTTOMBORDER   constant BOTTOMBORDER
GACT_BORDERSNIFF   constant BORDERSNIFF
GACT_TOGGLESELECT   constant TOGGLESELECT
GACT_BOOLEXTEND   constant BOOLEXTEND
GACT_STRINGLEFT   constant STRINGLEFT
GACT_STRINGCENTER   constant STRINGCENTER
GACT_STRINGRIGHT   constant STRINGRIGHT
GACT_LONGINT   constant LONGINT
GACT_ALTKEYMAP   constant ALTKEYMAP
GACT_STRINGEXTEND   constant STRINGEXTEND
GACT_ACTIVEGADGET   constant ACTIVEGADGET

GTYP_GADGETTYPE   constant GADGETTYPE
GTYP_SYSGADGET   constant SYSGADGET
GTYP_SCRGADGET   constant SCRGADGET
GTYP_GZZGADGET   constant GZZGADGET
GTYP_REQGADGET   constant REQGADGET
GTYP_SIZING   constant SIZING
GTYP_WDRAGGING   constant WDRAGGING
GTYP_SDRAGGING   constant SDRAGGING
GTYP_WUPFRONT   constant WUPFRONT
GTYP_SUPFRONT   constant SUPFRONT
GTYP_WDOWNBACK   constant WDOWNBACK
GTYP_SDOWNBACK   constant SDOWNBACK
GTYP_CLOSE   constant CLOSE
GTYP_BOOLGADGET   constant BOOLGADGET
GTYP_GADGET0002   constant GADGET0002
GTYP_PROPGADGET   constant PROPGADGET
GTYP_STRGADGET   constant STRGADGET
GTYP_CUSTOMGADGET   constant CUSTOMGADGET
GTYP_GTYPEMASK   constant GTYPEMASK

IDCMP_SIZEVERIFY   constant SIZEVERIFY
IDCMP_NEWSIZE   constant NEWSIZE
IDCMP_REFRESHWINDOW   constant REFRESHWINDOW
IDCMP_MOUSEBUTTONS   constant MOUSEBUTTONS
IDCMP_MOUSEMOVE   constant MOUSEMOVE
IDCMP_GADGETDOWN   constant GADGETDOWN
IDCMP_GADGETUP   constant GADGETUP
IDCMP_REQSET   constant REQSET
IDCMP_MENUPICK   constant MENUPICK
IDCMP_CLOSEWINDOW   constant CLOSEWINDOW
IDCMP_RAWKEY   constant RAWKEY
IDCMP_REQVERIFY   constant REQVERIFY
IDCMP_REQCLEAR   constant REQCLEAR
IDCMP_MENUVERIFY   constant MENUVERIFY
IDCMP_NEWPREFS   constant NEWPREFS
IDCMP_DISKINSERTED   constant DISKINSERTED
IDCMP_DISKREMOVED   constant DISKREMOVED
IDCMP_WBENCHMESSAGE   constant WBENCHMESSAGE
IDCMP_ACTIVEWINDOW   constant ACTIVEWINDOW
IDCMP_INACTIVEWINDOW   constant INACTIVEWINDOW
IDCMP_DELTAMOVE   constant DELTAMOVE
IDCMP_VANILLAKEY   constant VANILLAKEY
IDCMP_INTUITICKS   constant INTUITICKS
IDCMP_IDCMPUPDATE   constant IDCMPUPDATE
IDCMP_MENUHELP   constant MENUHELP
IDCMP_CHANGEWINDOW   constant CHANGEWINDOW
IDCMP_LONELYMESSAGE   constant LONELYMESSAGE

WFLG_SIZEGADGET   constant WINDOWSIZING
WFLG_DRAGBAR   constant WINDOWDRAG
WFLG_DEPTHGADGET   constant WINDOWDEPTH
WFLG_CLOSEGADGET   constant WINDOWCLOSE
WFLG_SIZEBRIGHT   constant SIZEBRIGHT
WFLG_SIZEBBOTTOM   constant SIZEBBOTTOM
WFLG_REFRESHBITS   constant REFRESHBITS
WFLG_SMART_REFRESH   constant SMART_REFRESH
WFLG_SIMPLE_REFRESH   constant SIMPLE_REFRESH
WFLG_SUPER_BITMAP   constant SUPER_BITMAP
WFLG_OTHER_REFRESH   constant OTHER_REFRESH
WFLG_BACKDROP   constant BACKDROP
WFLG_REPORTMOUSE   constant REPORTMOUSE
WFLG_GIMMEZEROZERO   constant GIMMEZEROZERO
WFLG_BORDERLESS   constant BORDERLESS
WFLG_ACTIVATE   constant ACTIVATE
WFLG_WINDOWACTIVE   constant WINDOWACTIVE
WFLG_INREQUEST   constant INREQUEST
WFLG_MENUSTATE   constant MENUSTATE
WFLG_RMBTRAP   constant RMBTRAP
WFLG_NOCAREREFRESH   constant NOCAREREFRESH
WFLG_WINDOWREFRESH   constant WINDOWREFRESH
WFLG_WBENCHWINDOW   constant WBENCHWINDOW
WFLG_WINDOWTICKED   constant WINDOWTICKED
WFLG_NW_EXTENDED   constant NW_EXTENDED
WFLG_VISITOR   constant VISITOR
WFLG_ZOOMED   constant ZOOMED
WFLG_HASZOOM   constant HASZOOM

\ These just redefine things with a different case.
\ 'C' is case sensitive!! Can you believe it?
0 .IF
GA_Left   constant GA_LEFT
GA_RelRight   constant GA_RELRIGHT
GA_Top   constant GA_TOP
GA_RelBottom   constant GA_RELBOTTOM
GA_Width   constant GA_WIDTH
GA_RelWidth   constant GA_RELWIDTH
GA_Height   constant GA_HEIGHT
GA_RelHeight   constant GA_RELHEIGHT
GA_Text   constant GA_TEXT
GA_Image   constant GA_IMAGE
GA_Border   constant GA_BORDER
GA_SelectRender   constant GA_SELECTRENDER
GA_Highlight   constant GA_HIGHLIGHT
GA_Disabled   constant GA_DISABLED
GA_GZZGadget   constant GA_GZZGADGET
GA_UserData   constant GA_USERDATA
GA_SpecialInfo   constant GA_SPECIALINFO
GA_Selected   constant GA_SELECTED
GA_EndGadget   constant GA_ENDGADGET
GA_Immediate   constant GA_IMMEDIATE
GA_RelVerify   constant GA_RELVERIFY
GA_FollowMouse   constant GA_FOLLOWMOUSE
GA_RightBorder   constant GA_RIGHTBORDER
GA_LeftBorder   constant GA_LEFTBORDER
GA_TopBorder   constant GA_TOPBORDER
GA_BottomBorder   constant GA_BOTTOMBORDER
GA_ToggleSelect   constant GA_TOGGLESELECT
GA_SysGadget   constant GA_SYSGADGET
GA_SysGType   constant GA_SYSGTYPE
GA_Previous   constant GA_PREVIOUS
GA_Next   constant GA_NEXT
GA_DrawInfo   constant GA_DRAWINFO
GA_IntuiText   constant GA_INTUITEXT
GA_LabelImage   constant GA_LABELIMAGE

PGA_Freedom   constant PGA_FREEDOM
PGA_Borderless   constant PGA_BORDERLESS
PGA_HorizPot   constant PGA_HORIZPOT
PGA_HorizBody   constant PGA_HORIZBODY
PGA_VertPot   constant PGA_VERTPOT
PGA_VertBody   constant PGA_VERTBODY
PGA_Total   constant PGA_TOTAL
PGA_Visible   constant PGA_VISIBLE
PGA_Top   constant PGA_TOP

LAYOUTA_LayoutObj   constant LAYOUTA_LAYOUTOBJ
LAYOUTA_Spacing   constant LAYOUTA_SPACING
LAYOUTA_Orientation   constant LAYOUTA_ORIENTATION

IA_Dummy   constant IMAGE_ATTRIBUTES
IA_Left   constant IA_LEFT
IA_Top   constant IA_TOP
IA_Width   constant IA_WIDTH
IA_Height   constant IA_HEIGHT
IA_FGPen   constant IA_FGPEN
IA_BGPen   constant IA_BGPEN
IA_Data   constant IA_DATA
IA_LineWidth   constant IA_LINEWIDTH
IA_Pens   constant IA_PENS
IA_Resolution   constant IA_RESOLUTION
IA_APattern   constant IA_APATTERN
IA_APatSize   constant IA_APATSIZE
IA_Mode   constant IA_MODE
IA_Font   constant IA_FONT
IA_Outline   constant IA_OUTLINE
IA_Recessed   constant IA_RECESSED
IA_DoubleEmboss   constant IA_DOUBLEEMBOSS
IA_EdgesOnly   constant IA_EDGESONLY
IA_ShadowPen   constant IA_SHADOWPEN
IA_HighlightPen   constant IA_HIGHLIGHTPEN

DETAILPEN   constant detailPen
BLOCKPEN   constant blockPen
TEXTPEN   constant textPen
SHINEPEN   constant shinePen
SHADOWPEN   constant shadowPen
FILLPEN   constant hifillPen
FILLTEXTPEN   constant hifilltextPen
BACKGROUNDPEN   constant backgroundPen
HIGHLIGHTTEXTPEN   constant hilighttextPen
NUMDRIPENS   constant numDrIPens
.THEN

.THEN

EXISTS? INTUI_V36_BETA_NAMES .IF

WA_Dummy   constant W_Dummy
WA_Left   constant W_LEFT
WA_Top   constant W_TOP
WA_Width   constant W_WIDTH
WA_Height   constant W_HEIGHT
WA_DetailPen   constant W_DETAILPEN
WA_BlockPen   constant W_BLOCKPEN
WA_IDCMP   constant W_IDCMP
WA_Flags   constant W_FLAGS
WA_Gadgets   constant W_GADGETS
WA_Checkmark   constant W_CHECKMARK
WA_Title   constant W_TITLE
WA_ScreenTitle   constant W_SCREENTITLE
WA_CustomScreen   constant W_CUSTOMSCREEN
WA_SuperBitMap   constant W_SUPERBITMAP
WA_MinWidth   constant W_MINWIDTH
WA_MinHeight   constant W_MINHEIGHT
WA_MaxWidth   constant W_MAXWIDTH
WA_MaxHeight   constant W_MAXHEIGHT
WA_InnerWidth   constant W_INNERWIDTH
WA_InnerHeight   constant W_INNERHEIGHT
WA_PubScreenName   constant W_PUBSCNAME
WA_PubScreen   constant W_PUBSC
WA_PubScreenFallBack   constant W_PUBSCFALLBACK
WA_WindowName   constant W_WINDOWNAME
WA_Colors   constant W_COLORS
WA_Zoom   constant W_ZOOM
WA_MouseQueue   constant W_MOUSEQUEUE
WA_BackFill   constant W_BACKFILL
WA_RptQueue   constant W_RPTQUEUE
WA_SizeGadget   constant W_SIZEGADGET
WA_DragBar   constant W_DRAGBAR
WA_DepthGadget   constant W_DEPTHGADGET
WA_CloseGadget   constant W_CLOSEGADGET
WA_Backdrop   constant W_BACKDROP
WA_ReportMouse   constant W_REPORTMOUSE
WA_NoCareRefresh   constant W_NOCAREREFRESH
WA_Borderless   constant W_BORDERLESS
WA_Activate   constant W_ACTIVATE
WA_RMBTrap   constant W_RMBTRAP
WA_WBenchWindow   constant W_WBENCHWINDOW
WA_SimpleRefresh   constant W_SIMPLE_REFRESH
WA_SmartRefresh   constant W_SMART_REFRESH
WA_SizeBRight   constant W_SIZEBRIGHT
WA_SizeBBottom   constant W_SIZEBBOTTOM
WA_AutoAdjust   constant W_AUTOADJUST
WA_GimmeZeroZero   constant W_GIMMEZEROZERO

SA_Dummy   constant S_DUMMY
SA_Left   constant S_LEFT
SA_Top   constant S_TOP
SA_Width   constant S_WIDTH
SA_Height   constant S_HEIGHT
SA_Depth   constant S_DEPTH
SA_DetailPen   constant S_DETAILPEN
SA_BlockPen   constant S_BLOCKPEN
SA_Title   constant S_TITLE
SA_Colors   constant S_COLORS
SA_ErrorCode   constant S_ERRORCODE
SA_Font   constant S_FONT
SA_SysFont   constant S_SYSFONT
SA_Type   constant S_TYPE
SA_BitMap   constant S_BITMAP
SA_PubName   constant S_PUBNAME
SA_PubSig   constant S_PUBSIG
SA_PubTask   constant S_PUBTASK
SA_DisplayID   constant S_DISPLAYID
SA_DClip   constant S_DCLIP
SA_Overscan   constant S_STDDCLIP
SA_Obsolete1   constant S_MONITORNAME
SA_ShowTitle   constant S_SHOWTITLE
SA_Behind   constant S_BEHIND
SA_Quiet   constant S_QUIET
SA_AutoScroll   constant S_AUTOSCROLL

.THEN

.THEN
