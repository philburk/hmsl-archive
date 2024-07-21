\ AMIGA JForth Include file.
decimal
EXISTS? REXX_REXXIO_H NOT .IF
: REXX_REXXIO_H ;
EXISTS? REXX_STORAGE_H NOT .IF
include ji:rexx/storage.j
.THEN

204   constant RXBUFFSZ

:STRUCT IoBuff
	( %M JForth prefix ) STRUCT RexxRsrc rxib_iobNode
	APTR rxib_iobRpt
	LONG rxib_iobRct
	LONG rxib_iobDFH
	APTR rxib_iobLock
	LONG rxib_iobBct
	( %?) RXBUFFSZ BYTES rxib_iobArea
	;STRUCT


-1   constant RXIO_EXIST
0   constant RXIO_STRF
1   constant RXIO_READ
2   constant RXIO_WRITE
3   constant RXIO_APPEND

-1  constant RXIO_BEGIN
0  constant RXIO_CURR
1  constant RXIO_END

\ %? #define LLOFFSET(rrp) (rrp->rr_Arg1)   /* "Query" offset		*/: LLOFFSET ;
\ %? #define LLVERS(rrp)   (rrp->rr_Arg2)   /* library version		*/: LLVERS ;

\ %? #define CLVALUE(rrp) ((STRPTR) rrp->rr_Arg1): CLVALUE ;

:STRUCT RexxMsgPort
	STRUCT RexxRsrc rmp_Node
	STRUCT MsgPort rmp_Port
	STRUCT List	rmp_ReplyList
	;STRUCT

0  constant DT_DEV
1  constant DT_DIR
2  constant DT_VOL

2002  constant ACTION_STACK
2003  constant ACTION_QUEUE

.THEN
