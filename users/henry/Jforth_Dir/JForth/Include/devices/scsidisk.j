\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_SCSIDISK_H NOT .IF
: DEVICES_SCSIDISK_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

28   constant HD_SCSICMD




:STRUCT SCSICmd
	APTR scsi_Data


	ULONG scsi_Length


	ULONG scsi_Actual
	APTR scsi_Command
	USHORT scsi_CmdLength
	USHORT scsi_CmdActual
	UBYTE scsi_Flags
	UBYTE scsi_Status
	APTR scsi_SenseData


	USHORT scsi_SenseLength

	USHORT scsi_SenseActual
;STRUCT

0   constant SCSIF_WRITE
1   constant SCSIF_READ
0   constant SCSIB_READ_WRITE

0   constant SCSIF_NOSENSE
2   constant SCSIF_AUTOSENSE

6   constant SCSIF_OLDAUTOSENSE

1   constant SCSIB_AUTOSENSE
2   constant SCSIB_OLDAUTOSENSE

40   constant HFERR_SelfUnit
41   constant HFERR_DMA
42   constant HFERR_Phase
43   constant HFERR_Parity
44   constant HFERR_SelTimeout
45   constant HFERR_BadStatus

50   constant HFERR_NoBoard

.THEN
