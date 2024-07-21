\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_HARDBLOCKS_H NOT .IF
: DEVICES_HARDBLOCKS_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

:STRUCT RigidDiskBlock
	ULONG rdb_ID
	ULONG rdb_SummedLongs
	LONG rdb_ChkSum
	ULONG rdb_HostID
	ULONG rdb_BlockBytes
	ULONG rdb_Flags
	ULONG rdb_BadBlockList
	ULONG rdb_PartitionList
	ULONG rdb_FileSysHeaderList
	ULONG rdb_DriveInit

	( %?) 6 4 *  BYTES rdb_Reserved1
	ULONG rdb_Cylinders
	ULONG rdb_Sectors
	ULONG rdb_Heads
	ULONG rdb_Interleave
	ULONG rdb_Park
	( %?) 3 4 *  BYTES rdb_Reserved2
	ULONG rdb_WritePreComp
	ULONG rdb_ReducedWrite
	ULONG rdb_StepRate
	( %?) 5 4 *  BYTES rdb_Reserved3
	ULONG rdb_RDBBlocksLo
	ULONG rdb_RDBBlocksHi
	ULONG rdb_LoCylinder
	ULONG rdb_HiCylinder
	ULONG rdb_CylBlocks
	ULONG rdb_AutoParkSeconds
	( %?) 2 4 *  BYTES rdb_Reserved4
	( %?) 8 BYTES rdb_DiskVendor
	( %?) 16 BYTES rdb_DiskProduct
	( %?) 4 BYTES rdb_DiskRevision
	( %?) 8 BYTES rdb_ControllerVendor
	( %?) 16 BYTES rdb_ControllerProduct
	( %?) 4 BYTES rdb_ControllerRevision
	( %?) 10 4 *  BYTES rdb_Reserved5
;STRUCT

$ 5244534B   constant IDNAME_RIGIDDISK

16   constant RDB_LOCATION_LIMIT

0   constant RDBFB_LAST
$ 01  constant RDBFF_LAST
1   constant RDBFB_LASTLUN
$ 02  constant RDBFF_LASTLUN
2   constant RDBFB_LASTTID
$ 04  constant RDBFF_LASTTID
3   constant RDBFB_NORESELECT
$ 08  constant RDBFF_NORESELECT
4   constant RDBFB_DISKID
$ 10  constant RDBFF_DISKID
5   constant RDBFB_CTRLRID
$ 20  constant RDBFF_CTRLRID

:STRUCT BadBlockEntry
	ULONG bbe_BadBlock
	ULONG bbe_GoodBlock
;STRUCT

:STRUCT BadBlockBlock
	ULONG bbb_ID
	ULONG bbb_SummedLongs
	LONG bbb_ChkSum
	ULONG bbb_HostID
	ULONG bbb_Next
	ULONG bbb_Reserved
61 sizeof() BadBlockEntry * BYTES bbb_BlockPairs ( %M )
;STRUCT

$ 42414442   constant IDNAME_BADBLOCK

:STRUCT PartitionBlock
	ULONG pb_ID
	ULONG pb_SummedLongs
	LONG pb_ChkSum
	ULONG pb_HostID
	ULONG pb_Next
	ULONG pb_Flags
	( %?) 2 4 *  BYTES pb_Reserved1
	ULONG pb_DevFlags
	( %?) 32 BYTES pb_DriveName

	( %?) 15 4 *  BYTES pb_Reserved2
	( %?) 17 4 *  BYTES pb_Environment
	( %?) 15 4 *  BYTES pb_EReserved
;STRUCT

$ 50415254   constant IDNAME_PARTITION

0   constant PBFB_BOOTABLE
1  constant PBFF_BOOTABLE
1   constant PBFB_NOMOUNT
2  constant PBFF_NOMOUNT

:STRUCT FileSysHeaderBlock
	ULONG fhb_ID
	ULONG fhb_SummedLongs
	LONG fhb_ChkSum
	ULONG fhb_HostID
	ULONG fhb_Next
	ULONG fhb_Flags
	( %?) 2 4 *  BYTES fhb_Reserved1
	ULONG fhb_DosType

	ULONG fhb_Version
	ULONG fhb_PatchFlags



	ULONG fhb_Type
	ULONG fhb_Task
	ULONG fhb_Lock
	ULONG fhb_Handler
	ULONG fhb_StackSize
	LONG fhb_Priority
	LONG fhb_Startup
	LONG fhb_SegListBlocks


	LONG fhb_GlobalVec
	( %?) 23 4 *  BYTES fhb_Reserved2
	( %?) 21 4 *  BYTES fhb_Reserved3
;STRUCT

$ 46534844   constant IDNAME_FILESYSHEADER

:STRUCT LoadSegBlock
	ULONG lsb_ID
	ULONG lsb_SummedLongs
	LONG lsb_ChkSum
	ULONG lsb_HostID
	ULONG lsb_Next
	( %?) 123 4 *  BYTES lsb_LoadData
;STRUCT

$ 4C534547   constant IDNAME_LOADSEG

.THEN
