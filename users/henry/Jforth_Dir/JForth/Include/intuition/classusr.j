\ AMIGA JForth Include file.
\ 00001 PLB 10/4/91 Fixed opAddMember

decimal
EXISTS? INTUITION_CLASSUSR_H NOT .IF
1   constant INTUITION_CLASSUSR_H
EXISTS? UTILITY_HOOKS_H NOT .IF
include ji:utility/hooks.j
.THEN

\ %? typedef ULONG	Object;		/* abstract handle */

\ %? typedef	UBYTE	*ClassID;

0" rootclass"	0string ROOTCLASS
0" imageclass" 0string IMAGECLASS
0" frameiclass" 0string FRAMEICLASS
0" sysiclass" 0string SYSICLASS
0" fillrectclass" 0string FILLRECTCLASS
0" gadgetclass" 0string GADGETCLASS
0" propgclass" 0string PROPGCLASS
0" strgclass" 0string STRGCLASS
0" buttongclass" 0string BUTTONGCLASS
0" frbuttonclass" 0string FRBUTTONCLASS
0" groupgclass" 0string GROUPGCLASS
0" icclass" 0string ICCLASS
0" modelclass" 0string MODELCLASS

$ 100   constant OM_Dummy
$ 101   constant OM_NEW
$ 102   constant OM_DISPOSE
$ 103   constant OM_SET
$ 104   constant OM_GET
$ 105   constant OM_ADDTAIL
$ 106   constant OM_REMOVE
$ 107   constant OM_NOTIFY
$ 108   constant OM_UPDATE
$ 109   constant OM_ADDMEMBER
$ 10A   constant OM_REMMEMBER

:STRUCT opSet
	ULONG MethodID
	APTR ops_AttrList
	APTR ops_GInfo
;STRUCT

:STRUCT opUpdate
	ULONG MethodID
	APTR opu_AttrList
	APTR opu_GInfo
	ULONG opu_Flags
;STRUCT

1  0 <<  constant OPUF_INTERIM

:STRUCT opGet
	ULONG MethodID
	ULONG opg_AttrID
	APTR opg_Storage
;STRUCT

:STRUCT opAddTail
	ULONG MethodID
	APTR opat_List
;STRUCT

\ opMember   constant opAddMember WRONG! 00001
:STRUCT opMember
	ULONG MethodID
	APTR opm_object ( %M )
;STRUCT

:STRUCT opAddMember \ 00001
	ULONG MethodID
	APTR opam_object ( %M )
;STRUCT

.THEN
