\ AMIGA JForth Include file.
decimal
EXISTS? INTUITION_CLASSES_H NOT .IF
1   constant INTUITION_CLASSES_H
EXISTS? UTILITY_HOOKS_H NOT .IF
include ji:utility/hooks.j
.THEN

EXISTS? INTUITION_CLASSUSR_H NOT .IF
include ji:intuition/classusr.j
.THEN

:STRUCT IClass
	STRUCT Hook	cl_Dispatcher
	ULONG cl_Reserved
	APTR cl_Super
APTR cl_ID ( %M )
	USHORT cl_InstOffset
	USHORT cl_InstSize
	ULONG cl_UserData
	ULONG cl_SubclassCount
	ULONG cl_ObjectCount
	ULONG cl_Flags
$ 00000001   constant CLF_INLIST
;STRUCT

\ %? #define INST_DATA( cl, o )	((VOID *) (((UBYTE *)o)+cl->cl_InstOffset)): INST_DATA ;

\ %? #define SIZEOF_INSTANCE( cl )	((cl)->cl_InstOffset + (cl)->cl_InstSize \: SIZEOF_INSTANCE ;
\ %? 			+ sizeof (struct _Object ))

:STRUCT _Object
	STRUCT MinNode	o_Node
	APTR o_Class
;STRUCT

\ %? #define _OBJ( o )	((struct _Object *)(o)): _OBJ ;

\ %? #define BASEOBJECT( _obj )	( (Object *) (_OBJ(_obj)+1) ): BASEOBJECT ;

\ %? #define _OBJECT( o )		(_OBJ(o) - 1): _OBJECT ;

\ %? #define OCLASS( o )	( (_OBJECT(o))->o_Class ): OCLASS ;

.THEN
