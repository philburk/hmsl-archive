\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_INTUITIONBASE_H NOT .IF
1   constant INTUITION_INTUITIONBASE_H
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

EXISTS? EXEC_INTERRUPTS_H NOT .IF
include ji:exec/interrupts.j
.THEN

$ 0002   constant DMODECOUNT
$ 0000   constant HIRESPICK
$ 0001   constant LOWRESPICK

10   constant EVENTMAX

2   constant RESCOUNT
0   constant HIRESGADGET
1   constant LOWRESGADGET

8   constant GADGETCOUNT
0   constant UPFRONTGADGET
1   constant DOWNBACKGADGET
2   constant SIZEGADGET
3   constant CLOSEGADGET
4   constant DRAGGADGET
5   constant SUPFRONTGADGET
6   constant SDOWNBACKGADGET
7   constant SDRAGGADGET

:STRUCT IntuitionBase
	( %M JForth prefix ) STRUCT Library ib_LibNode
	STRUCT View ib_ViewLord
	APTR ib_ActiveWindow
	APTR ib_ActiveScreen
	APTR ib_FirstScreen
	ULONG ib_Flags
	SHORT ib_MouseY
	SHORT ib_MouseX

	ULONG ib_Seconds
	ULONG ib_Micros
;STRUCT

.THEN

