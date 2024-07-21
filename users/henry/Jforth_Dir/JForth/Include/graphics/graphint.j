\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? GRAPHICS_GRAPHINT_H NOT .IF
: GRAPHICS_GRAPHINT_H ;
.THEN   \ %? Forced .THEN to prevent nesting!!!
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT Isrvstr
	STRUCT Node	is_Node
	APTR is_Iptr
	APTR is_code
	APTR is_ccode
	SHORT is_carg
;STRUCT

\ .THEN   %? Eliminated because of nesting!
