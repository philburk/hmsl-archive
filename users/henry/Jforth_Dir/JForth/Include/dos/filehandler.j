\ AMIGA JForth Include file.
decimal
EXISTS? DOS_FILEHANDLER_H NOT .IF
: DOS_FILEHANDLER_H ;
EXISTS?   EXEC_PORTS_H NOT .IF
include ji:exec/ports.j
.THEN

EXISTS?   DOS_DOS_H NOT .IF
include ji:dos/dos.j
.THEN

:STRUCT DosEnvec
	ULONG de_TableSize
	ULONG de_SizeBlock
	ULONG de_SecOrg
	ULONG de_Surfaces
	ULONG de_SectorPerBlock
	ULONG de_BlocksPerTrack
	ULONG de_Reserved
	ULONG de_PreAlloc
	ULONG de_Interleave
	ULONG de_LowCyl
	ULONG de_HighCyl
	ULONG de_NumBuffers
	ULONG de_BufMemType
	ULONG de_MaxTransfer
	ULONG de_Mask
	LONG de_BootPri
	ULONG de_DosType
	ULONG de_Baud
	ULONG de_Control
	ULONG de_BootBlocks
;STRUCT

0   constant DE_TABLESIZE
1   constant DE_SIZEBLOCK
2   constant DE_SECORG
3   constant DE_NUMHEADS
4   constant DE_SECSPERBLK
5   constant DE_BLKSPERTRACK
6   constant DE_RESERVEDBLKS
7   constant DE_PREFAC
8   constant DE_INTERLEAVE
9   constant DE_LOWCYL
10   constant DE_UPPERCYL
11   constant DE_NUMBUFFERS
12   constant DE_MEMBUFTYPE
12   constant DE_BUFMEMTYPE
13   constant DE_MAXTRANSFER
14   constant DE_MASK
15   constant DE_BOOTPRI
16   constant DE_DOSTYPE
17   constant DE_BAUD
18   constant DE_CONTROL
19   constant DE_BOOTBLOCKS

:STRUCT FileSysStartupMsg
	ULONG fssm_Unit
	APTR fssm_Device
	LONG fssm_Environ
	ULONG fssm_Flags
;STRUCT

:STRUCT DeviceNode
	LONG dn_Next
	ULONG dn_Type
	APTR dn_Task
	LONG dn_Lock
	APTR dn_Handler
	ULONG dn_StackSize
	LONG dn_Priority
	LONG dn_Startup
	LONG dn_SegList
	LONG dn_GlobalVec
	APTR dn_Name
;STRUCT

.THEN
