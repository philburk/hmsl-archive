\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_GADTOOLS_H NOT .IF
: LIBRARIES_GADTOOLS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

0   constant GENERIC_KIND
1   constant BUTTON_KIND
2   constant CHECKBOX_KIND
3   constant INTEGER_KIND
4   constant LISTVIEW_KIND
5   constant MX_KIND
6   constant NUMBER_KIND
7   constant CYCLE_KIND
8   constant PALETTE_KIND
9   constant SCROLLER_KIND
11   constant SLIDER_KIND
12   constant STRING_KIND
13   constant TEXT_KIND

14   constant NUM_KINDS

$ 8000   constant GADTOOLBIT
GADTOOLBIT COMP constant GADTOOLMASK ( %M )

IDCMP_INTUITICKS IDCMP_MOUSEBUTTONS |
IDCMP_GADGETUP | IDCMP_GADGETDOWN | constant ARROWIDCMP ( %M )

IDCMP_GADGETUP   constant BUTTONIDCMP
IDCMP_GADGETUP   constant CHECKBOXIDCMP
IDCMP_GADGETUP   constant INTEGERIDCMP
IDCMP_GADGETUP  IDCMP_GADGETDOWN |
IDCMP_MOUSEMOVE | ARROWIDCMP | constant LISTVIEWIDCMP

IDCMP_GADGETDOWN  constant MXIDCMP
NULL   constant NUMBERIDCMP
IDCMP_GADGETUP   constant CYCLEIDCMP
IDCMP_GADGETUP   constant PALETTEIDCMP

IDCMP_GADGETUP  IDCMP_GADGETDOWN | IDCMP_MOUSEMOVE |  constant SCROLLERIDCMP
IDCMP_GADGETUP  IDCMP_GADGETDOWN | IDCMP_MOUSEMOVE |  constant SLIDERIDCMP
IDCMP_GADGETUP   constant STRINGIDCMP

NULL   constant TEXTIDCMP

8   constant INTERWIDTH
4   constant INTERHEIGHT

:STRUCT NewGadget
	SHORT ng_LeftEdge
	SHORT ng_TopEdge
	SHORT ng_Width
	SHORT ng_Height
	APTR ng_GadgetText
	APTR ng_TextAttr
	USHORT ng_GadgetID
	ULONG ng_Flags
	APTR ng_VisualInfo
	APTR ng_UserData
	;STRUCT

$ 0001   constant PLACETEXT_LEFT
$ 0002   constant PLACETEXT_RIGHT
$ 0004   constant PLACETEXT_ABOVE
$ 0008   constant PLACETEXT_BELOW
$ 0010   constant PLACETEXT_IN

$ 0020   constant NG_HIGHLABEL

:STRUCT NewMenu
	UBYTE nm_Type
	APTR nm_Label
	APTR nm_CommKey
	USHORT nm_Flags
	LONG nm_MutualExclude
	APTR nm_UserData
;STRUCT

1   constant NM_TITLE
2   constant NM_ITEM
3   constant NM_SUB
0   constant NM_END

128   constant MENU_IMAGE
NM_ITEM  MENU_IMAGE |  constant IM_ITEM
NM_SUB  MENU_IMAGE |  constant IM_SUB

\ STRPTR 1- constant NM_BARLABEL ( %M )

MENUENABLED   constant NM_MENUDISABLED
ITEMENABLED   constant NM_ITEMDISABLED

COMMSEQ ITEMTEXT | HIGHFLAGS | COMP constant NM_FLAGMASK ( %M )
\ %? #define GTMENU_USERDATA(menu) (* ( (APTR *)(((struct Menu *)menu)+1) ) ): GTMENU_USERDATA ;
\ %? #define GTMENUITEM_USERDATA(menuitem) (* ( (APTR *)(((struct MenuItem *)menuitem)+1) ) ): GTMENUITEM_USERDATA ;

\ %? #define MENU_USERDATA(menuitem) (* ( (APTR *)(menuitem+1) ) ): MENU_USERDATA ;

$ 00000001   constant GTMENU_TRIMMED
$ 00000002   constant GTMENU_INVALID
$ 00000003   constant GTMENU_NOMEM

TAG_USER  $ 80000 +  constant GT_TagBase

GT_TagBase  1 +  constant GTVI_NewWindow
GT_TagBase  2 +  constant GTVI_NWTags

GT_TagBase  3 +  constant GT_Private0

GT_TagBase  4 +  constant GTCB_Checked

GT_TagBase  5 +  constant GTLV_Top
GT_TagBase  6 +  constant GTLV_Labels
GT_TagBase  7 +  constant GTLV_ReadOnly
GT_TagBase  8 +  constant GTLV_ScrollWidth

GT_TagBase  9 +  constant GTMX_Labels
GT_TagBase  10 +  constant GTMX_Active

GT_TagBase  11 +  constant GTTX_Text
GT_TagBase  12 +  constant GTTX_CopyText
GT_TagBase  13 +  constant GTNM_Number

GT_TagBase  14 +  constant GTCY_Labels
GT_TagBase  15 +  constant GTCY_Active

GT_TagBase  16 +  constant GTPA_Depth
GT_TagBase  17 +  constant GTPA_Color
GT_TagBase  18 +  constant GTPA_ColorOffset
GT_TagBase  19 +  constant GTPA_IndicatorWidth
GT_TagBase  20 +  constant GTPA_IndicatorHeight

GT_TagBase  21 +  constant GTSC_Top
GT_TagBase  22 +  constant GTSC_Total
GT_TagBase  23 +  constant GTSC_Visible
GT_TagBase  24 +  constant GTSC_Overlap

GT_TagBase  38 +  constant GTSL_Min
GT_TagBase  39 +  constant GTSL_Max
GT_TagBase  40 +  constant GTSL_Level
GT_TagBase  41 +  constant GTSL_MaxLevelLen
GT_TagBase  42 +  constant GTSL_LevelFormat
GT_TagBase  43 +  constant GTSL_LevelPlace
GT_TagBase  44 +  constant GTSL_DispFunc
GT_TagBase  45 +  constant GTST_String
GT_TagBase  46 +  constant GTST_MaxChars

GT_TagBase  47 +  constant GTIN_Number
GT_TagBase  48 +  constant GTIN_MaxChars

GT_TagBase  49 +  constant GTMN_TextAttr
GT_TagBase  50 +  constant GTMN_FrontPen

GT_TagBase  51 +  constant GTBB_Recessed

GT_TagBase  52 +  constant GT_VisualInfo

GT_TagBase  53 +  constant GTLV_ShowSelected
GT_TagBase  54 +  constant GTLV_Selected
GT_TagBase  55 +  constant GT_Reserved0
GT_TagBase  56 +  constant GT_Reserved1

GT_TagBase  57 +  constant GTTX_Border
GT_TagBase  58 +  constant GTNM_Border
GT_TagBase  59 +  constant GTSC_Arrows
GT_TagBase  60 +  constant GTMN_Menu
GT_TagBase  61 +  constant GTMX_Spacing
GT_TagBase  62 +  constant GTMN_FullMenu
GT_TagBase  63 +  constant GTMN_SecondaryError
GT_TagBase  64 +  constant GT_Underscore
CYCLE_KIND   constant NWAY_KIND
CYCLEIDCMP   constant NWAYIDCMP
GTCY_Labels   constant GTNW_Labels
GTCY_Active   constant GTNW_Active

.THEN
