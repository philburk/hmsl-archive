\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_ASL_H NOT .IF
1   constant LIBRARIES_ASL_H

EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? UTILITY_HOOKS_H NOT .IF
include ji:utility/hooks.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

EXISTS? WBArg NOT .IF
include ji:workbench/startup.j
.THEN

EXISTS? GRAPHICS_TEXT_H NOT .IF
include ji:graphics/text.j
.THEN

0" asl.library" 0string AslName ( %M )

:STRUCT FileRequester
	APTR rf_Reserved1
	APTR rf_File
	APTR rf_Dir
	ULONG rf_Reserved2
	UBYTE rf_Reserved3
	UBYTE rf_Reserved4
	APTR rf_Reserved5
	SHORT rf_LeftEdge
	SHORT rf_TopEdge
		SHORT rf_Width
	SHORT rf_Height
		SHORT rf_Reserved6
		LONG rf_NumArgs
		APTR rf_ArgList
		APTR rf_UserData
		APTR rf_Reserved7
		APTR rf_Reserved8
		APTR rf_Pat
		;STRUCT


7  constant FILB_DOWILDFUNC

6  constant FILB_DOMSGFUNC



5  constant FILB_SAVE
4  constant FILB_NEWIDCMP
3  constant FILB_MULTISELECT

0  constant FILB_PATGAD

1 FILB_DOWILDFUNC <<  constant FILF_DOWILDFUNC
1 FILB_DOMSGFUNC <<  constant FILF_DOMSGFUNC

1 FILB_SAVE <<  constant FILF_SAVE
1 FILB_NEWIDCMP <<  constant FILF_NEWIDCMP
1 FILB_MULTISELECT <<  constant FILF_MULTISELECT
1 FILB_PATGAD <<  constant FILF_PATGAD

0  constant FIL1B_NOFILES
1  constant FIL1B_MATCHDIRS

1 FIL1B_NOFILES <<  constant FIL1F_NOFILES
1 FIL1B_MATCHDIRS <<  constant FIL1F_MATCHDIRS

:STRUCT FontRequester
	( %?) 2 4 *  BYTES fo_Reserved1
	STRUCT TextAttr fo_Attr
	UBYTE fo_FrontPen
	UBYTE fo_BackPen
	UBYTE fo_DrawMode
	APTR fo_UserData
	;STRUCT

0   constant FONB_FRONTCOLOR
1   constant FONB_BACKCOLOR
2   constant FONB_STYLES
3   constant FONB_DRAWMODE
4   constant FONB_FIXEDWIDTH
5   constant FONB_NEWIDCMP
6   constant FONB_DOMSGFUNC



7   constant FONB_DOWILDFUNC


1 FONB_FRONTCOLOR <<  constant FONF_FRONTCOLOR
1 FONB_BACKCOLOR <<  constant FONF_BACKCOLOR
1 FONB_STYLES <<  constant FONF_STYLES
1 FONB_DRAWMODE <<  constant FONF_DRAWMODE
1 FONB_FIXEDWIDTH <<  constant FONF_FIXEDWIDTH
1 FONB_NEWIDCMP <<  constant FONF_NEWIDCMP
1 FONB_DOMSGFUNC <<  constant FONF_DOMSGFUNC
1 FONB_DOWILDFUNC <<  constant FONF_DOWILDFUNC

0   constant ASL_FileRequest
1   constant ASL_FontRequest

TAG_USER  $ 80000 +  constant ASL_Dummy

ASL_Dummy  1 +  constant ASL_Hail
ASL_Dummy  2 +  constant ASL_Window
ASL_Dummy  3 +  constant ASL_LeftEdge
ASL_Dummy  4 +  constant ASL_TopEdge
ASL_Dummy  5 +  constant ASL_Width
ASL_Dummy  6 +  constant ASL_Height
ASL_Dummy  7 +  constant ASL_HookFunc

ASL_Dummy  8 +  constant ASL_File
ASL_Dummy  9 +  constant ASL_Dir

ASL_Dummy  10 +  constant ASL_FontName
ASL_Dummy  11 +  constant ASL_FontHeight
ASL_Dummy  12 +  constant ASL_FontStyles
ASL_Dummy  13 +  constant ASL_FontFlags
ASL_Dummy  14 +  constant ASL_FrontPen
ASL_Dummy  15 +  constant ASL_BackPen
ASL_Dummy  16 +  constant ASL_MinHeight
ASL_Dummy  17 +  constant ASL_MaxHeight

ASL_Dummy  18 +  constant ASL_OKText
ASL_Dummy  19 +  constant ASL_CancelText
ASL_Dummy  20 +  constant ASL_FuncFlags

ASL_Dummy  21 +  constant ASL_ModeList
ASL_Dummy  22 +  constant ASL_ExtFlags1

ASL_FontName   constant ASL_Pattern

.THEN
