\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_GFXBASE_H NOT .IF
: GRAPHICS_GFXBASE_H ;
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN
EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN
EXISTS? EXEC_INTERRUPTS_H NOT .IF
include ji:exec/interrupts.j
.THEN

:STRUCT GfxBase
	( %M JForth prefix ) STRUCT Library gb_LibNode
	APTR gb_ActiView
	APTR gb_copinit
	APTR gb_cia
	APTR gb_blitter
	APTR gb_LOFlist
	APTR gb_SHFlist
	APTR gb_blthd
	APTR gb_blttl
	APTR gb_bsblthd
	APTR gb_bsblttl
	STRUCT Interrupt gb_vbsrv
	STRUCT Interrupt gb_timsrv
	STRUCT Interrupt gb_bltsrv
	STRUCT List gb_TextFonts
	APTR gb_DefaultFont
	USHORT gb_Modes
	BYTE gb_VBlank
	BYTE gb_Debug
	SHORT gb_BeamSync
	SHORT gb_system_bplcon0
	UBYTE gb_SpriteReserved
	UBYTE gb_bytereserved
	USHORT gb_Flags
	SHORT gb_BlitLock
	SHORT gb_BlitNest
	STRUCT List	gb_BlitWaitQ
	APTR gb_BlitOwner
	STRUCT List	gb_TOF_WaitQ
	USHORT gb_DisplayFlags

	APTR gb_SimpleSprites
	USHORT gb_MaxDisplayRow
	USHORT gb_MaxDisplayColumn
	USHORT gb_NormalDisplayRows
	USHORT gb_NormalDisplayColumns

	USHORT gb_NormalDPMX
	USHORT gb_NormalDPMY
	APTR gb_LastChanceMemory
	APTR gb_LCMptr
	USHORT gb_MicrosPerLine
	USHORT gb_MinDisplayColumn
	UBYTE gb_ChipRevBits0
	( %?) 5 BYTES gb_crb_reserved
	USHORT gb_monitor_id
	( %?) 8 4 *  BYTES gb_hedley
	( %?) 8 4 *  BYTES gb_hedley_sprites
	( %?) 8 4 *  BYTES gb_hedley_sprites1
	SHORT gb_hedley_count
	USHORT gb_hedley_flags
	SHORT gb_hedley_tmp
	APTR gb_hash_table
	USHORT gb_current_tot_rows
	USHORT gb_current_tot_cclks
	UBYTE gb_hedley_hint
	UBYTE gb_hedley_hint2
	( %?) 4 4 *  BYTES gb_nreserved
	APTR gb_a2024_sync_raster
	SHORT gb_control_delta_pal
	SHORT gb_control_delta_ntsc
	APTR gb_current_monitor
	STRUCT List gb_MonitorList
	APTR gb_default_monitor
	APTR gb_MonitorListSemaphore
APTR gb_DisplayInfoDataBase ( %M )
	APTR gb_ActiViewCprSemaphore
	APTR gb_UtilityBase
	APTR gb_ExecBase
	;STRUCT

1   constant NTSC
2   constant GENLOC
4   constant PAL
8   constant TODA_SAFE

4   constant BLITMSG_FAULT

0   constant GFXB_BIG_BLITS
0   constant GFXB_HR_AGNUS
1   constant GFXB_HR_DENISE

1   constant GFXF_BIG_BLITS
1   constant GFXF_HR_AGNUS
2   constant GFXF_HR_DENISE

0" graphics.library" 0string GRAPHICSNAME ( %M )

.THEN
