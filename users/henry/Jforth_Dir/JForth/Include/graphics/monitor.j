\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_MONITOR_H NOT .IF
: GRAPHICS_MONITOR_H ;
EXISTS? EXEC_SEMAPHORES_H NOT .IF
include ji:exec/semaphores.j
.THEN

EXISTS? GRAPHICS_GFXNODES_H NOT .IF
include ji:graphics/gfxnodes.j
.THEN

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN

include? DISPLAYPAL ji:hardware/custom.j ( missing from .h file !!!! )

:STRUCT MonitorSpec
	( %M JForth prefix ) STRUCT ExtendedNode	ms_Node
	USHORT ms_Flags
	LONG ms_ratioh
	LONG ms_ratiov
	USHORT ms_total_rows
	USHORT ms_total_colorclocks
	USHORT ms_DeniseMaxDisplayColumn
	USHORT ms_BeamCon0
	USHORT ms_min_row
	APTR ms_Special
	USHORT ms_OpenCount
	APTR ms_transform
	APTR ms_translate
	APTR ms_scale
	USHORT ms_xoffset
	USHORT ms_yoffset
	STRUCT Rectangle	ms_LegalView
	APTR ms_maxoscan
	APTR ms_videoscan
	USHORT ms_DeniseMinDisplayColumn
	ULONG ms_DisplayCompatible
	STRUCT List ms_DisplayInfoDataBase
	STRUCT SignalSemaphore ms_DisplayInfoDataBaseSemaphore
	ULONG ms_reserved00
	ULONG ms_reserved01
;STRUCT

0   constant TO_MONITOR
1   constant FROM_MONITOR
9   constant STANDARD_XOFFSET
0   constant STANDARD_YOFFSET
1   constant REQUEST_NTSC
2   constant REQUEST_PAL
4   constant REQUEST_SPECIAL
8   constant REQUEST_A2024

0" default.monitor" 0string DEFAULT_MONITOR_NAME ( %M )
0" ntsc.monitor" 0string NTSC_MONITOR_NAME ( %M )
0" pal.monitor" 0string PAL_MONITOR_NAME ( %M )
REQUEST_NTSC  REQUEST_PAL |  constant STANDARD_MONITOR_MASK

262   constant STANDARD_NTSC_ROWS
312   constant STANDARD_PAL_ROWS
226   constant STANDARD_COLORCLOCKS
455   constant STANDARD_DENISE_MAX
93   constant STANDARD_DENISE_MIN
$ 0000   constant STANDARD_NTSC_BEAMCON

exists? ECS_SPECIFIC .IF ( %M)
DISPLAYPAL   constant STANDARD_PAL_BEAMCON

VARVBLANK  LOLDIS | VARVSYNC | VARBEAM | CSBLANK |  constant SPECIAL_BEAMCON
.THEN

21   constant MIN_NTSC_ROW
29   constant MIN_PAL_ROW
$ 81   constant STANDARD_VIEW_X
$ 2C   constant STANDARD_VIEW_Y
$ 06   constant STANDARD_HBSTRT
$ 0B   constant STANDARD_HSSTRT
$ 1C   constant STANDARD_HSSTOP
$ 2C   constant STANDARD_HBSTOP
$ 0122   constant STANDARD_VBSTRT
$ 02A6   constant STANDARD_VSSTRT
$ 03AA   constant STANDARD_VSSTOP
$ 1066   constant STANDARD_VBSTOP

STANDARD_COLORCLOCKS  2 /  constant VGA_COLORCLOCKS
STANDARD_NTSC_ROWS  2 *  constant VGA_TOTAL_ROWS
59   constant VGA_DENISE_MIN
29   constant MIN_VGA_ROW
$ 08   constant VGA_HBSTRT
$ 0E   constant VGA_HSSTRT
$ 1C   constant VGA_HSSTOP
$ 1E   constant VGA_HBSTOP
$ 0000   constant VGA_VBSTRT
$ 0153   constant VGA_VSSTRT
$ 0235   constant VGA_VSSTOP
$ 0CCD   constant VGA_VBSTOP

0" vga.monitor" 0string VGA_MONITOR_NAME ( %M )

STANDARD_COLORCLOCKS  2 /  constant VGA70_COLORCLOCKS
449   constant VGA70_TOTAL_ROWS
59   constant VGA70_DENISE_MIN
35   constant MIN_VGA70_ROW
$ 08   constant VGA70_HBSTRT
$ 0E   constant VGA70_HSSTRT
$ 1C   constant VGA70_HSSTOP
$ 1E   constant VGA70_HBSTOP
$ 0000   constant VGA70_VBSTRT
$ 02A6   constant VGA70_VSSTRT
$ 0388   constant VGA70_VSSTOP
$ 0F73   constant VGA70_VBSTOP

\ %? #define	VGA70_BEAMCON	(SPECIAL_BEAMCON ^ VSYNCTRUE)
0" vga70.monitor" 0string VGA70_MONITOR_NAME ( %M )

$ 01   constant BROADCAST_HBSTRT
$ 06   constant BROADCAST_HSSTRT
$ 17   constant BROADCAST_HSSTOP
$ 27   constant BROADCAST_HBSTOP
$ 0000   constant BROADCAST_VBSTRT
$ 02A6   constant BROADCAST_VSSTRT
$ 054C   constant BROADCAST_VSSTOP
$ 1C40   constant BROADCAST_VBSTOP
EXISTS? ECS_SPECIFIC .IF
LOLDIS CSBLANK | constant BROADCAST_BEAMCON ( %M )
.THEN
4   constant RATIO_FIXEDPART
1  RATIO_FIXEDPART <<  constant RATIO_UNITY

:STRUCT AnalogSignalInterval
	USHORT asi_Start
	USHORT asi_Stop
;STRUCT

:STRUCT SpecialMonitor
	( %M JForth prefix ) STRUCT ExtendedNode	spm_Node
	USHORT spm_Flags
APTR spm_do_monitor ( %M )
APTR spm_reserved1 ( %M )
APTR spm_reserved2 ( %M )
APTR spm_reserved3 ( %M )
	STRUCT AnalogSignalInterval	spm_hblank
	STRUCT AnalogSignalInterval	spm_vblank
	STRUCT AnalogSignalInterval	spm_hsync
	STRUCT AnalogSignalInterval	spm_vsync
;STRUCT

.THEN
