\ MOD: Hand coded struct arrays in ExecBase
\ MOD: Fixed 1 L 8 << by removing L

\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_EXECBASE_H NOT .IF
: EXEC_EXECBASE_H ;
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_INTERRUPTS_H NOT .IF
include ji:exec/interrupts.j
.THEN

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? EXEC_TASKS_H NOT .IF
include ji:exec/tasks.j
.THEN

:STRUCT ExecBase
	STRUCT Library EB_LibNode
	USHORT EB_SoftVer
	SHORT EB_LowMemChkSum
	ULONG EB_ChkBase
	APTR EB_ColdCapture
	APTR EB_CoolCapture
	APTR EB_WarmCapture
	APTR EB_SysStkUpper
	APTR EB_SysStkLower
	ULONG EB_MaxLocMem
	APTR EB_DebugEntry
	APTR EB_DebugData
	APTR EB_AlertData
	APTR EB_MaxExtMem
	USHORT EB_ChkSum
sizeof() Intvector 16 * BYTES EB_IntVects
	APTR EB_ThisTask
	ULONG EB_IdleCount
	ULONG EB_DispCount
	USHORT EB_Quantum
	USHORT EB_Elapsed
	USHORT EB_SysFlags
	BYTE EB_IDNestCnt
	BYTE EB_TDNestCnt
	USHORT EB_AttnFlags
	USHORT EB_AttnResched
	APTR EB_ResModules
	APTR EB_TaskTrapCode
	APTR EB_TaskExceptCode
	APTR EB_TaskExitCode
	ULONG EB_TaskSigAlloc
	USHORT EB_TaskTrapAlloc
	STRUCT List EB_MemList
	STRUCT List EB_ResourceList
	STRUCT List EB_DeviceList
	STRUCT List EB_IntrList
	STRUCT List EB_LibList
	STRUCT List EB_PortList
	STRUCT List EB_TaskReady
	STRUCT List EB_TaskWait
sizeof() SoftIntList 5 * BYTES EB_SOFTINTS  \ bad name in 2.0
	( %?)   4 4 *  BYTES EB_LastAlert
		UBYTE EB_VBlankFrequency
		UBYTE EB_PowerSupplyFrequency
		STRUCT List EB_SemaphoreList
		APTR EB_KickMemPtr
		APTR EB_KickTagPtr
		APTR EB_KickCheckSum
		USHORT EB_ex_Pad0
		ULONG EB_ex_Reserved0
		APTR EB_ex_RamLibPrivate
		ULONG EB_ex_EClockFrequency
		ULONG EB_ex_CacheControl
		ULONG EB_ex_TaskID
		ULONG EB_ex_PuddleSize
		ULONG EB_ex_PoolThreshold
		STRUCT MinList EB_ex_PublicPool
		APTR EB_ex_MMULock
	( %?)   12 BYTES EB_ex_Reserved
;STRUCT

0   constant AFB_68010
1   constant AFB_68020
2   constant AFB_68030
3   constant AFB_68040
4   constant AFB_68881
5   constant AFB_68882

1  0 <<  constant AFF_68010
1  1 <<  constant AFF_68020
1  2 <<  constant AFF_68030
1  3 <<  constant AFF_68040
1  4 <<  constant AFF_68881
1  5 <<  constant AFF_68882

1  0 <<  constant CACRF_EnableI
1  1 <<  constant CACRF_FreezeI
1  3 <<  constant CACRF_ClearI
1  4 <<  constant CACRF_IBE
1  8 <<  constant CACRF_EnableD
1  9 <<  constant CACRF_FreezeD
1  11 <<  constant CACRF_ClearD
1  12 <<  constant CACRF_DBE
1  13 <<  constant CACRF_WriteAllocate
1  31 <<  constant CACRF_CopyBack

.THEN
