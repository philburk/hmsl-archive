\ AMIGA JForth Include file.
decimal
EXISTS? EXEC_LISTS_H NOT .IF
: EXEC_LISTS_H ;
EXISTS? EXEC_NODES_H NOT .IF
include ji:exec/nodes.j
.THEN

:STRUCT List
	APTR lh_Head
	APTR lh_Tail
	APTR lh_TailPred
	UBYTE lh_Type
		UNION{
			BYTE l_pad   ( This was wrong in the .h file )
		}UNION{
			BYTE lh_pad  ( As appears in documentation. )
		}UNION
;STRUCT


:STRUCT MinList \ must be long word aligned!
	APTR mlh_Head
	APTR mlh_Tail
	APTR mlh_TailPred
;STRUCT


\ %? #define IsListEmpty(x) \: IsListEmpty ;
\ %? 	( ((x)->lh_TailPred) == (struct Node *)(x) )

\ %? #define IsMsgPortEmpty(x) \: IsMsgPortEmpty ;
\ %? 	( ((x)->mp_MsgList.lh_TailPred) == (struct Node *)(&(x)->mp_MsgList) )

.THEN
