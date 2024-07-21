\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_NARRATOR_H NOT .IF
: DEVICES_NARRATOR_H ;
EXISTS? EXEC_IO_H NOT .IF
include ji:exec/io.j
.THEN



0   constant NDB_NEWIORB
1   constant NDB_WORDSYNC
2   constant NDB_SYLSYNC

1  NDB_NEWIORB <<  constant NDF_NEWIORB
1  NDB_WORDSYNC <<  constant NDF_WORDSYNC
1  NDB_SYLSYNC <<  constant NDF_SYLSYNC



-2   constant ND_NoMem
-3   constant ND_NoAudLib
-4   constant ND_MakeBad
-5   constant ND_UnitErr
-6   constant ND_CantAlloc
-7   constant ND_Unimpl
-8   constant ND_NoWrite
-9   constant ND_Expunged
-20   constant ND_PhonErr
-21   constant ND_RateErr
-22   constant ND_PitchErr
-23   constant ND_SexErr
-24   constant ND_ModeErr
-25   constant ND_FreqErr
-26   constant ND_VolErr
-27   constant ND_DCentErr
-28   constant ND_CentPhonErr



110   constant DEFPITCH
150   constant DEFRATE
64   constant DEFVOL
22200   constant DEFFREQ
0   constant MALE
1   constant FEMALE
0   constant NATURALF0
1   constant ROBOTICF0
2   constant MANUALF0
MALE   constant DEFSEX
NATURALF0   constant DEFMODE
100   constant DEFARTIC
0   constant DEFCENTRAL
0   constant DEFF0PERT
32   constant DEFF0ENTHUS
100   constant DEFPRIORITY



40   constant MINRATE
400   constant MAXRATE
65   constant MINPITCH
320   constant MAXPITCH
5000   constant MINFREQ
28000   constant MAXFREQ
0   constant MINVOL
64   constant MAXVOL
0   constant MINCENT
100   constant MAXCENT



:STRUCT narrator_rb
	( %M JForth prefix ) STRUCT IOStdReq ndi_message
	USHORT ndi_rate
	USHORT ndi_pitch
	USHORT ndi_mode
	USHORT ndi_sex
	APTR ndi_ch_masks
	USHORT ndi_nm_masks
	USHORT ndi_volume
	USHORT ndi_sampfreq
	UBYTE ndi_mouths
	UBYTE ndi_chanmask
	UBYTE ndi_numchan
	UBYTE ndi_flags
	UBYTE ndi_F0enthusiasm
	UBYTE ndi_F0perturb
	BYTE ndi_F1adj
	BYTE ndi_F2adj
	BYTE ndi_F3adj
	BYTE ndi_A1adj
	BYTE ndi_A2adj
	BYTE ndi_A3adj
	UBYTE ndi_articulate
	UBYTE ndi_centralize
	APTR ndi_centphon
	BYTE ndi_AVbias
	BYTE ndi_AFbias
	BYTE ndi_priority
	BYTE ndi_pad1
	;STRUCT



:STRUCT mouth_rb
	( %M JForth prefix ) STRUCT narrator_rb mrb_voice
	UBYTE mrb_width
	UBYTE mrb_height
	UBYTE mrb_shape
	UBYTE mrb_sync
	;STRUCT

.THEN
