\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_TRACKDISK_H NOT .IF
: DEVICES_TRACKDISK_H ;

EXISTS? EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN

EXISTS? EXEC_DEVICES_H NOT .IF
include ji:exec/devices.j
.THEN



11   constant NUMSECS
4   constant NUMUNITS

512   constant TD_SECTOR
9   constant TD_SECSHIFT

0" trackdisk.device" 0string TD_NAME ( %M )

1  15 <<  constant TDF_EXTCOM

CMD_NONSTD  0 +  constant TD_MOTOR
CMD_NONSTD  1 +  constant TD_SEEK
CMD_NONSTD  2 +  constant TD_FORMAT
CMD_NONSTD  3 +  constant TD_REMOVE
CMD_NONSTD  4 +  constant TD_CHANGENUM
CMD_NONSTD  5 +  constant TD_CHANGESTATE
CMD_NONSTD  6 +  constant TD_PROTSTATUS
CMD_NONSTD  7 +  constant TD_RAWREAD
CMD_NONSTD  8 +  constant TD_RAWWRITE
CMD_NONSTD  9 +  constant TD_GETDRIVETYPE
CMD_NONSTD  10 +  constant TD_GETNUMTRACKS
CMD_NONSTD  11 +  constant TD_ADDCHANGEINT
CMD_NONSTD  12 +  constant TD_REMCHANGEINT
CMD_NONSTD  13 +  constant TD_GETGEOMETRY
CMD_NONSTD  14 +  constant TD_EJECT
CMD_NONSTD  15 +  constant TD_LASTCOMM

CMD_WRITE  TDF_EXTCOM |  constant ETD_WRITE
CMD_READ  TDF_EXTCOM |  constant ETD_READ
TD_MOTOR  TDF_EXTCOM |  constant ETD_MOTOR
TD_SEEK  TDF_EXTCOM |  constant ETD_SEEK
TD_FORMAT  TDF_EXTCOM |  constant ETD_FORMAT
CMD_UPDATE  TDF_EXTCOM |  constant ETD_UPDATE
CMD_CLEAR  TDF_EXTCOM |  constant ETD_CLEAR
TD_RAWREAD  TDF_EXTCOM |  constant ETD_RAWREAD
TD_RAWWRITE  TDF_EXTCOM |  constant ETD_RAWWRITE

:STRUCT IOExtTD
	STRUCT IOStdReq iotd_Req
	ULONG iotd_Count
	ULONG iotd_SecLabel
;STRUCT

:STRUCT DriveGeometry
	ULONG dg_SectorSize
	ULONG dg_TotalSectors
	ULONG dg_Cylinders
	ULONG dg_CylSectors
	ULONG dg_Heads
	ULONG dg_TrackSectors
	ULONG dg_BufMemType

	UBYTE dg_DeviceType
	UBYTE dg_Flags
	USHORT dg_Reserved
;STRUCT

0   constant DG_DIRECT_ACCESS
1   constant DG_SEQUENTIAL_ACCESS
2   constant DG_PRINTER
3   constant DG_PROCESSOR
4   constant DG_WORM
5   constant DG_CDROM
6   constant DG_SCANNER
7   constant DG_OPTICAL_DISK
8   constant DG_MEDIUM_CHANGER
9   constant DG_COMMUNICATION
31   constant DG_UNKNOWN

0   constant DGB_REMOVABLE
1   constant DGF_REMOVABLE

4   constant IOTDB_INDEXSYNC
1  4 <<  constant IOTDF_INDEXSYNC
5   constant IOTDB_WORDSYNC
1  5 <<  constant IOTDF_WORDSYNC

16   constant TD_LABELSIZE

0   constant TDB_ALLOW_NON_3_5
1  0 <<  constant TDF_ALLOW_NON_3_5

1   constant DRIVE3_5
2   constant DRIVE5_25
3   constant DRIVE3_5_150RPM

20   constant TDERR_NotSpecified
21   constant TDERR_NoSecHdr
22   constant TDERR_BadSecPreamble
23   constant TDERR_BadSecID
24   constant TDERR_BadHdrSum
25   constant TDERR_BadSecSum
26   constant TDERR_TooFewSecs
27   constant TDERR_BadSecHdr
28   constant TDERR_WriteProt
29   constant TDERR_DiskChanged
30   constant TDERR_SeekError
31   constant TDERR_NoMem
32   constant TDERR_BadUnitNum
33   constant TDERR_BadDriveType
34   constant TDERR_DriveInUse
35   constant TDERR_PostReset

:STRUCT TDU_PublicUnit
	STRUCT Unit tdu_Unit
	USHORT tdu_Comp01Track
	USHORT tdu_Comp10Track
	USHORT tdu_Comp11Track
	ULONG tdu_StepDelay
	ULONG tdu_SettleDelay
	UBYTE tdu_RetryCnt
	UBYTE tdu_PubFlags
	USHORT tdu_CurrTrk

	ULONG tdu_CalibrateDelay

	ULONG tdu_Counter

;STRUCT

0   constant TDPB_NOCLICK
1 0 <<  constant TDPF_NOCLICK

.THEN
