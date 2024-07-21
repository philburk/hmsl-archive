\ AMIGA JForth Include file.
decimal
EXISTS? DEVICES_KEYMAP_H NOT .IF
: DEVICES_KEYMAP_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN
EXISTS? EXEC_LISTS_H NOT .IF
include ji:exec/lists.j
.THEN

:STRUCT KeyMap
	APTR km_LoKeyMapTypes
	APTR km_LoKeyMap
	APTR km_LoCapsable
	APTR km_LoRepeatable
	APTR km_HiKeyMapTypes
	APTR km_HiKeyMap
	APTR km_HiCapsable
	APTR km_HiRepeatable
;STRUCT

:STRUCT KeyMapNode
	STRUCT Node kn_Node
	STRUCT KeyMap kn_KeyMap
;STRUCT

:STRUCT KeyMapResource
	STRUCT Node kr_Node
	STRUCT List kr_List
;STRUCT

0   constant KC_NOQUAL
7   constant KC_VANILLA
0   constant KCB_SHIFT
$ 01   constant KCF_SHIFT
1   constant KCB_ALT
$ 02   constant KCF_ALT
2   constant KCB_CONTROL
$ 04   constant KCF_CONTROL
3   constant KCB_DOWNUP
$ 08   constant KCF_DOWNUP

5   constant KCB_DEAD
$ 20   constant KCF_DEAD

6   constant KCB_STRING
$ 40   constant KCF_STRING

7   constant KCB_NOP
$ 80   constant KCF_NOP

0   constant DPB_MOD
$ 01   constant DPF_MOD
3   constant DPB_DEAD
$ 08   constant DPF_DEAD

$ 0f   constant DP_2DINDEXMASK
4   constant DP_2DFACSHIFT

.THEN
