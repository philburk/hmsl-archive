\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_DISKFONT_H NOT .IF
: LIBRARIES_DISKFONT_H ;
EXISTS?     EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN
EXISTS?     EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN
EXISTS?     EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN
EXISTS?     GRAPHICS_TEXT_H NOT .IF
include ji:graphics/text.j
.THEN

256   constant MAXFONTPATH

:STRUCT FontContents
	( %?) MAXFONTPATH BYTES fc_FileName
	USHORT fc_YSize
	UBYTE fc_Style
	UBYTE fc_Flags
;STRUCT

:STRUCT TFontContents
MAXFONTPATH 2- BYTES tcf_FileName ( %M )
	USHORT tfc_TagCount
	USHORT tfc_YSize
	UBYTE tfc_Style
	UBYTE tfc_Flags
;STRUCT

$ 0f00   constant FCH_ID
$ 0f02   constant TFCH_ID

:STRUCT FontContentsHeader
	USHORT fch_FileID
	USHORT fch_NumEntries
;STRUCT

$ 0f80   constant DFH_ID
32   constant MAXFONTNAME

:STRUCT DiskFontHeader
	STRUCT Node dfh_DF
	USHORT dfh_FileID
	USHORT dfh_Revision
	LONG dfh_Segment
	( %?) MAXFONTNAME BYTES dfh_Name
	STRUCT TextFont dfh_TF
;STRUCT

\ dfh_Segment   constant dfh_TagList ( %M )

0   constant AFB_MEMORY
$ 0001   constant AFF_MEMORY
1   constant AFB_DISK
$ 0002   constant AFF_DISK
2   constant AFB_SCALED
$ 0004   constant AFF_SCALED

16   constant AFB_TAGGED
$ 10000  constant AFF_TAGGED

:STRUCT AvailFonts
	USHORT af_Type
	STRUCT TextAttr af_Attr
;STRUCT

:STRUCT TAvailFonts
	USHORT taf_Type
	STRUCT TTextAttr taf_Attr
;STRUCT

:STRUCT AvailFontsHeader
	USHORT afh_NumEntries
;STRUCT

.THEN
