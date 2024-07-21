\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_VIEW_H NOT .IF
: GRAPHICS_VIEW_H ;
: ECS_SPECIFIC ;

EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? GRAPHICS_GFX_H NOT .IF
include ji:graphics/gfx.j
.THEN

EXISTS? GRAPHICS_COPPER_H NOT .IF
include ji:graphics/copper.j
.THEN

EXISTS? GRAPHICS_GFXNODES_H NOT .IF
include ji:graphics/gfxnodes.j
.THEN

EXISTS? GRAPHICS_MONITOR_H NOT .IF
include ji:graphics/monitor.j
.THEN

EXISTS? HARDWARE_CUSTOM_H NOT .IF
include ji:hardware/custom.j
.THEN

:STRUCT ViewPort
	( %M JForth prefix ) APTR vp_Next
	APTR vp_ColorMap

	APTR vp_DspIns
	APTR vp_SprIns
	APTR vp_ClrIns
	APTR vp_UCopIns
	SHORT vp_DWidth
	SHORT vp_DHeight
	SHORT vp_DxOffset
	SHORT vp_DyOffset
	USHORT vp_Modes
	UBYTE vp_SpritePriorities
	UBYTE vp_ExtendedModes
	APTR vp_RasInfo
;STRUCT

:STRUCT View
	( %M JForth prefix ) APTR v_ViewPort
	APTR v_LOFCprList
	APTR v_SHFCprList
	SHORT v_DyOffset
	SHORT v_DxOffset

	USHORT v_Modes
;STRUCT

:STRUCT ViewExtra
	( %M JForth prefix ) STRUCT ExtendedNode ve_n
	APTR ve_View
	APTR ve_Monitor
;STRUCT

:STRUCT ViewPortExtra
	( %M JForth prefix ) STRUCT ExtendedNode vpe_n
	APTR vpe_ViewPort
	STRUCT Rectangle vpe_DisplayClip
;STRUCT

$ 1000   constant EXTEND_VSTRUCT

$ 0002   constant GENLOCK_VIDEO
$ 0004   constant LACE
$ 0020   constant SUPERHIRES
$ 0040   constant PFBA
$ 0080   constant EXTRA_HALFBRITE
$ 0100   constant GENLOCK_AUDIO
$ 0400   constant DUALPF
$ 0800   constant HAM
$ 1000   constant EXTENDED_MODE
$ 2000   constant VP_HIDE
$ 4000   constant SPRITES
$ 8000   constant HIRES

$ 40   constant VPF_A2024
$ 20   constant VPF_AGNUS
$ 20   constant VPF_TENHZ

:STRUCT RasInfo
	( %M JForth prefix ) APTR ri_Next
	APTR ri_BitMap
	SHORT ri_RxOffset
	SHORT ri_RyOffset
;STRUCT

:STRUCT ColorMap
	( %M JForth prefix ) UBYTE cm_Flags
	UBYTE cm_Type
	USHORT cm_Count
	APTR cm_ColorTable
	APTR cm_vpe
	APTR cm_TransparencyBits
	UBYTE cm_TransparencyPlane
	UBYTE cm_reserved1
	USHORT cm_reserved2
	APTR cm_vp
	APTR cm_NormalDisplayInfo
	APTR cm_CoerceDisplayInfo
	APTR cm_batch_items
	ULONG cm_VPModeID
;STRUCT

$ 00   constant COLORMAP_TYPE_V1_2
$ 01   constant COLORMAP_TYPE_V1_4
COLORMAP_TYPE_V1_4   constant COLORMAP_TYPE_V36

$ 01   constant COLORMAP_TRANSPARENCY
$ 02   constant COLORPLANE_TRANSPARENCY
$ 04   constant BORDER_BLANKING
$ 08   constant BORDER_NOTRANSPARENCY
$ 10   constant VIDEOCONTROL_BATCH
$ 20   constant USER_COPPER_CLIP

.THEN
