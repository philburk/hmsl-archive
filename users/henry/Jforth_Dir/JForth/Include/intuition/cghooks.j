\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_CGHOOKS_H NOT .IF
1   constant INTUITION_CGHOOKS_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

:STRUCT GadgetInfo
	APTR gi_Screen
	APTR gi_Window
	APTR gi_Requester
	APTR gi_RastPort
	APTR gi_Layer
	STRUCT IBox	gi_Domain
UBYTE gi_pens.DetailPen ( %M )
UBYTE gi_pens.BlockPen
	APTR gi_DrInfo
	( %?) 6 4 *  BYTES gi_Reserved
;STRUCT

:STRUCT PGX
	STRUCT IBox	pgx_Container
	STRUCT IBox	pgx_NewKnob
;STRUCT

\ %? #define CUSTOM_HOOK( gadget ) ( (struct Hook *) (gadget)->MutualExclude): CUSTOM_HOOK ;

.THEN
