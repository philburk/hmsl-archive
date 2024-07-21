\ EXEC structure definitions for JFORTH
\
\ Author: Phil Burk
\ Copyright 1986
ANEW TASK-EXEC.J

( exec/nodes.h )
\ Node Structure, doubley linked list node.
:STRUCT LIST_NODE    ( alias NODE )
    aptr    LN_SUCC  \ successor
    aptr    LN_PRED  \ predecessor
    ubyte   LN_TYPE
    byte    LN_PRI
    aptr    LN_NAME
;STRUCT

( exec/lists.h )
:STRUCT LIST_HEADER ( alias LIST )
    aptr  LH_HEAD   \ pointer to first node
    aptr  LH_TAIL   \ pointer to last node
    aptr  LH_TAILPRED
    ubyte LH_TYPE
    ubyte LH_PAD    \ pad byte?
;STRUCT

( exec/tasks.h )
\ TASK - not defined

( exec/lists.h )
\ MSGPORT - not defined
:STRUCT MESSAGE 
    struct list_node MN_NODE
    aptr   MN_REPLYPORT
    ushort  MN_LENGTH
;STRUCT
