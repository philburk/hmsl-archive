\ AMIGA JForth Include file.
decimal
EXISTS? WORKBENCH_WORKBENCH_H NOT .IF
: WORKBENCH_WORKBENCH_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN

EXISTS? INTUITION_INTUITION_H NOT .IF
include ji:intuition/intuition.j
.THEN

1   constant WBDISK
2   constant WBDRAWER
3   constant WBTOOL
4   constant WBPROJECT
5   constant WBGARBAGE
6   constant WBDEVICE
7   constant WBKICK
8   constant WBAPPICON

:STRUCT OldDrawerData
	STRUCT NewWindow	dd_NewWindow
	LONG dd_CurrentX
	LONG dd_CurrentY
;STRUCT

sizeof() OldDrawerData  constant OLDDRAWERDATAFILESIZE

:STRUCT DrawerData
	STRUCT NewWindow	dd_NewWindow
	LONG dd_CurrentX
	LONG dd_CurrentY
	ULONG dd_Flags
	USHORT dd_ViewModes
;STRUCT

sizeof() DrawerData  constant DRAWERDATAFILESIZE

:STRUCT DiskObject
	USHORT do_Magic
	USHORT do_Version
	STRUCT Gadget	do_Gadget
	UBYTE do_Type
	APTR do_DefaultTool
	APTR do_ToolTypes
	LONG do_CurrentX
	LONG do_CurrentY
	APTR do_DrawerData
	APTR do_ToolWindow
	LONG do_StackSize
;STRUCT

$ e310   constant WB_DISKMAGIC
1   constant WB_DISKVERSION
1   constant WB_DISKREVISION
255   constant WB_DISKREVISIONMASK

:STRUCT FreeList
	SHORT fl_NumFree
	STRUCT List	fl_MemList
;STRUCT

1   constant MTYPE_PSTD
2   constant MTYPE_TOOLEXIT
3   constant MTYPE_DISKCHANGE
4   constant MTYPE_TIMER
5   constant MTYPE_CLOSEDOWN
6   constant MTYPE_IOPROC
7   constant MTYPE_APPWINDOW
8   constant MTYPE_APPICON
9   constant MTYPE_APPMENUITEM
10   constant MTYPE_COPYEXIT
11   constant MTYPE_ICONPUT

$ 0001   constant GADGBACKFILL

$ 80000000   constant NO_ICON_POSITION

0" workbench.library" 0string WORKBENCH_NAME ( %M )

1   constant AM_VERSION

:STRUCT AppMessage
	STRUCT Message am_Message
	USHORT am_Type
	ULONG am_UserData
	ULONG am_ID
	LONG am_NumArgs
	APTR am_ArgList
	USHORT am_Version
	USHORT am_Class
	SHORT am_MouseX
	SHORT am_MouseY
	ULONG am_Seconds
	ULONG am_Micros
	( %?) 8 4 *  BYTES am_Reserved
;STRUCT

\ %? struct	AppWindow	{ void *aw_PRIVATE;  };
\ %? struct	AppIcon		{ void *ai_PRIVATE;  };
\ %? struct		AppMenuItem	{ void *ami_PRIVATE; };
.THEN ( %M )
