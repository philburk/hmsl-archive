\ AMIGA JForth Include file.
include? :struct ju:c_struct
decimal
EXISTS? LIBRARIES_ROMBOOTBASE_H NOT .IF	
: LIBRARIES_ROMBOOTBASE_H ;

include? EXEC_TYPES_H ji:exec/types.j	
include? EXEC_NODES_H ji:exec/nodes.j	
include? EXEC_LISTS_H ji:exec/lists.j	
include? EXEC_LIBRARIES_H ji:exec/libraries.j	
include? EXEC_EXECBASE_H ji:exec/execbase.j	
include? EXEC_EXECNAME_H ji:exec/execname.j	

:STRUCT RomBootBase
  STRUCT Library	rbb_LibNode
  APTR rbb_ExecBase
  STRUCT List	rbb_BootList
( %?)   4 4 *  BYTES rbb_Reserved
;STRUCT 


:STRUCT BootNode
  STRUCT Node	bn_Node
  USHORT bn_Flags
APTR bn_DeviceNode
;STRUCT 

0" romboot.library" 0string ROMBOOT_NAME
.THEN
