\ AMIGA JForth Include file.
decimal
EXISTS? LIBRARIES_COMMODITIES_H NOT .IF
: LIBRARIES_COMMODITIES_H ;

EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

include? IEQUALIFIER_LSHIFT ji:devices/inputevent.j ( %M )

\ %? #define CxFilter(d)	    CreateCxObj((LONG)CX_FILTER, (LONG) d, 0): CxFilter ;
\ %? #define CxTypeFilter(type)  CreateCxObj((LONG)CX_TYPEFILTER, (LONG) type, 0): CxTypeFilter ;
\ %? #define CxSender(port,id)   CreateCxObj((LONG)CX_SEND, (LONG) port, (LONG) id): CxSender ;
\ %? #define CxSignal(task,sig)  CreateCxObj((LONG)CX_SIGNAL,(LONG) task, (LONG) sig): CxSignal ;
\ %? #define CxTranslate(ie)     CreateCxObj((LONG)CX_TRANSLATE, (LONG) ie, 0): CxTranslate ;
\ %? #define CxDebug(id)	    CreateCxObj((LONG)CX_DEBUG, (LONG) id, 0): CxDebug ;
\ %? #define CxCustom(action,id) CreateCxObj((LONG)CX_CUSTOM,(LONG)action,(LONG)id): CxCustom ;

24   constant CBD_NAMELEN
40   constant CBD_TITLELEN
40   constant CBD_DESCRLEN

0   constant CBERR_OK
1   constant CBERR_SYSERR
2   constant CBERR_DUP
3   constant CBERR_VERSION

5   constant NB_VERSION

:STRUCT NewBroker
	BYTE nb_Version
	APTR nb_Name
	APTR nb_Title
	APTR nb_Descr
	SHORT nb_Unique
	SHORT nb_Flags
	BYTE nb_Pri
	APTR nb_Port
	SHORT nb_ReservedChannel
;STRUCT

0   constant NBU_DUPLICATE
1   constant NBU_UNIQUE
2   constant NBU_NOTIFY

4   constant COF_SHOW_HIDE

EXISTS? CX_H NOT .IF
\ %? typedef LONG   CxObj;
\ %? typedef LONG   CxMsg;
.THEN

\ %? typedef LONG   (*PFL)();

0   constant CX_INVALID
1   constant CX_FILTER
2   constant CX_TYPEFILTER
3   constant CX_SEND
4   constant CX_SIGNAL
5   constant CX_TRANSLATE
6   constant CX_BROKER
7   constant CX_DEBUG
8   constant CX_CUSTOM
9   constant CX_ZERO

1  4 <<  constant CXM_UNIQUE
1  5 <<  constant CXM_IEVENT

1  6 <<  constant CXM_COMMAND

15   constant CXCMD_DISABLE
17   constant CXCMD_ENABLE
19   constant CXCMD_APPEAR
21   constant CXCMD_DISAPPEAR
23   constant CXCMD_KILL
25   constant CXCMD_UNIQUE
27   constant CXCMD_LIST_CHG


0   constant CMDE_OK
-1   constant CMDE_NOBROKER
-2   constant CMDE_NOPORT
-3   constant CMDE_NOMEM

1   constant COERR_ISNULL
2   constant COERR_NULLATTACH
4   constant COERR_BADFILTER
8   constant COERR_BADTYPE

2   constant IX_VERSION

:STRUCT InputXpression
	UBYTE ix_Version
	UBYTE ix_Class
	USHORT ix_Code
	USHORT ix_CodeMask


	USHORT ix_Qualifier
	USHORT ix_QualMask


	USHORT ix_QualSame
	;STRUCT

\ %? typedef struct InputXpression IX;

1   constant IXSYM_SHIFT
2   constant IXSYM_CAPS
4   constant IXSYM_ALT

IEQUALIFIER_LSHIFT  IEQUALIFIER_RSHIFT |  constant IXSYM_SHIFTMASK
IXSYM_SHIFTMASK  IEQUALIFIER_CAPSLOCK |  constant IXSYM_CAPSMASK
IEQUALIFIER_LALT  IEQUALIFIER_RALT |  constant IXSYM_ALTMASK

$ 7FFF constant IX_NORMALQUALS ( %M )

\ %? #define NULL_IX(I)   ((I)->ix_Class == IECLASS_NULL): NULL_IX ;

.THEN
