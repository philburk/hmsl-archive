\ AMIGA JForth Include file.
decimal
EXISTS? RESOURCES_MATHRESOURCE_H NOT .IF
: RESOURCES_MATHRESOURCE_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT MathIEEEResource
	STRUCT Node	MathIEEEResource_Node
USHORT MathIEEEResource_Flags ( %M )
APTR MathIEEEResource_BaseAddr ( %M )
APTR MathIEEEResource_DblBaseInit ( %M )
APTR MathIEEEResource_DblTransInit ( %M )
APTR MathIEEEResource_SglBasInit ( %M )
APTR MathIEEEResource_SglTransInit ( %M )
APTR MathIEEEResource_ExtBasInit ( %M )
APTR MathIEEEResource_ExtTransInit ( %M )
;STRUCT

1 constant MATHIEEERESOURCE_DBLBAS ( %M )
1  1 <<  constant MATHIEEERESOURCEF_DBLTRANS
1  2 <<  constant MATHIEEERESOURCEF_SGLBAS
1  3 <<  constant MATHIEEERESOURCEF_SGLTRANS
1  4 <<  constant MATHIEEERESOURCEF_EXTBAS
1  5 <<  constant MATHIEEERESOURCEF_EXTTRANS

.THEN
