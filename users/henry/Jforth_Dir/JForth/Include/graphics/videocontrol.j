\ AMIGA JForth Include file.
decimal
EXISTS? GRAPHICS_VIDEOCONTROL_H NOT .IF
: GRAPHICS_VIDEOCONTROL_H ;
EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? UTILITY_TAGITEM_H NOT .IF
include ji:utility/tagitem.j
.THEN

$ 00000000   constant VTAG_END_CM
$ 80000000   constant VTAG_CHROMAKEY_CLR
$ 80000001   constant VTAG_CHROMAKEY_SET
$ 80000002   constant VTAG_BITPLANEKEY_CLR
$ 80000003   constant VTAG_BITPLANEKEY_SET
$ 80000004   constant VTAG_BORDERBLANK_CLR
$ 80000005   constant VTAG_BORDERBLANK_SET
$ 80000006   constant VTAG_BORDERNOTRANS_CLR
$ 80000007   constant VTAG_BORDERNOTRANS_SET
$ 80000008   constant VTAG_CHROMA_PEN_CLR
$ 80000009   constant VTAG_CHROMA_PEN_SET
$ 8000000A   constant VTAG_CHROMA_PLANE_SET
$ 8000000B   constant VTAG_ATTACH_CM_SET
$ 8000000C   constant VTAG_NEXTBUF_CM
$ 8000000D   constant VTAG_BATCH_CM_CLR
$ 8000000E   constant VTAG_BATCH_CM_SET
$ 8000000F   constant VTAG_NORMAL_DISP_GET
$ 80000010   constant VTAG_NORMAL_DISP_SET
$ 80000011   constant VTAG_COERCE_DISP_GET
$ 80000012   constant VTAG_COERCE_DISP_SET
$ 80000013   constant VTAG_VIEWPORTEXTRA_GET
$ 80000014   constant VTAG_VIEWPORTEXTRA_SET
$ 80000015   constant VTAG_CHROMAKEY_GET
$ 80000016   constant VTAG_BITPLANEKEY_GET
$ 80000017   constant VTAG_BORDERBLANK_GET
$ 80000018   constant VTAG_BORDERNOTRANS_GET
$ 80000019   constant VTAG_CHROMA_PEN_GET
$ 8000001A   constant VTAG_CHROMA_PLANE_GET
$ 8000001B   constant VTAG_ATTACH_CM_GET
$ 8000001C   constant VTAG_BATCH_CM_GET
$ 8000001D   constant VTAG_BATCH_ITEMS_GET
$ 8000001E   constant VTAG_BATCH_ITEMS_SET
$ 8000001F   constant VTAG_BATCH_ITEMS_ADD
$ 80000020   constant VTAG_VPMODEID_GET
$ 80000021   constant VTAG_VPMODEID_SET
$ 80000022   constant VTAG_VPMODEID_CLR
$ 80000023   constant VTAG_USERCLIP_GET
$ 80000024   constant VTAG_USERCLIP_SET
$ 80000025   constant VTAG_USERCLIP_CLR

.THEN