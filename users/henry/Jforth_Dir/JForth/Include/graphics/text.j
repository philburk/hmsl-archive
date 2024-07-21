\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_TEXT_H NOT .IF
: GRAPHICS_TEXT_H ;
EXISTS? EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

0   constant FS_NORMAL
0   constant FSB_UNDERLINED
$ 01   constant FSF_UNDERLINED
1   constant FSB_BOLD
$ 02   constant FSF_BOLD
2   constant FSB_ITALIC
$ 04   constant FSF_ITALIC
3   constant FSB_EXTENDED
$ 08   constant FSF_EXTENDED

6   constant FSB_COLORFONT
$ 40   constant FSF_COLORFONT
7   constant FSB_TAGGED
$ 80   constant FSF_TAGGED

0   constant FPB_ROMFONT
$ 01   constant FPF_ROMFONT
1   constant FPB_DISKFONT
$ 02   constant FPF_DISKFONT
2   constant FPB_REVPATH
$ 04   constant FPF_REVPATH
3   constant FPB_TALLDOT
$ 08   constant FPF_TALLDOT
4   constant FPB_WIDEDOT
$ 10   constant FPF_WIDEDOT
5   constant FPB_PROPORTIONAL
$ 20   constant FPF_PROPORTIONAL
6   constant FPB_DESIGNED




$ 40   constant FPF_DESIGNED
7   constant FPB_REMOVED
1  7 <<  constant FPF_REMOVED

:STRUCT TextAttr
	APTR ta_Name
	USHORT ta_YSize
	UBYTE ta_Style
	UBYTE ta_Flags
;STRUCT

:STRUCT TTextAttr
	APTR tta_Name
	USHORT tta_YSize
	UBYTE tta_Style
	UBYTE tta_Flags
	APTR tta_Tags
;STRUCT

1  TAG_USER |  constant TA_DeviceDPI


32767   constant MAXFONTMATCHWEIGHT

:STRUCT TextFont
	STRUCT Message tf_Message

	USHORT tf_YSize
	UBYTE tf_Style
	UBYTE tf_Flags
	USHORT tf_XSize
	USHORT tf_Baseline
	USHORT tf_BoldSmear
	USHORT tf_Accessors
	UBYTE tf_LoChar
	UBYTE tf_HiChar
	APTR tf_CharData
	USHORT tf_Modulo
	APTR tf_CharLoc

	APTR tf_CharSpace
	APTR tf_CharKern
;STRUCT

\ %? #define	tf_Extension	tf_Message.mn_ReplyPort

0   constant TE0B_NOREMFONT
$ 01   constant TE0F_NOREMFONT

:STRUCT TextFontExtension
	USHORT tfe_MatchWord
	UBYTE tfe_Flags0
	UBYTE tfe_Flags1
	APTR tfe_BackPtr
	APTR tfe_OrigReplyPort
	APTR tfe_Tags
	APTR tfe_OFontPatchS
	APTR tfe_OFontPatchK
;STRUCT

$ 000F   constant CT_COLORMASK
$ 0001   constant CT_COLORFONT
$ 0002   constant CT_GREYFONT

$ 0004   constant CT_ANTIALIAS

0   constant CTB_MAPCOLOR
$ 0001   constant CTF_MAPCOLOR

:STRUCT ColorFontColors
	USHORT cfc_Reserved
	USHORT cfc_Count
	APTR cfc_ColorTable
;STRUCT

:STRUCT ColorTextFont
	STRUCT TextFont ctf_TF
	USHORT ctf_Flags
	UBYTE ctf_Depth
	UBYTE ctf_FgColor
	UBYTE ctf_Low
	UBYTE ctf_High
	UBYTE ctf_PlanePick
	UBYTE ctf_PlaneOnOff
	APTR ctf_ColorFontColors
	( %?) 8 4 *  BYTES ctf_CharData
;STRUCT

:STRUCT TextExtent
	USHORT te_Width
	USHORT te_Height
	STRUCT Rectangle te_Extent
;STRUCT

.THEN
