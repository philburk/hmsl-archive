\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_LAYERS_H NOT .IF
: GRAPHICS_LAYERS_H ;
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

EXISTS? EXEC_SEMAPHORES_H NOT .IF
include ji:exec/semaphores.j
.THEN

1   constant LAYERSIMPLE
2   constant LAYERSMART
4   constant LAYERSUPER
$ 10   constant LAYERUPDATING
$ 40   constant LAYERBACKDROP
$ 80   constant LAYERREFRESH
$ 100   constant LAYER_CLIPRECTS_LOST


-1   constant LMN_REGION

:STRUCT Layer_Info
	( %M JForth prefix ) APTR li_top_layer
	APTR li_check_lp
	APTR li_obs
	STRUCT MinList	li_FreeClipRects
	STRUCT SignalSemaphore li_Lock
	STRUCT List li_gs_Head
	LONG li_longreserved
	USHORT li_Flags
	BYTE li_fatten_count
	BYTE li_LockLayersCount
	USHORT li_LayerInfo_extra_size
	APTR li_blitbuff
APTR li_LayerInfo_extra ( %M )
;STRUCT

1   constant NEWLAYERINFO_CALLED
$ 83010000   constant ALERTLAYERSNOMEM

.THEN
