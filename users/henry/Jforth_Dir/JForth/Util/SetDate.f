\ JForth words to set the datestamp of an AmigaDOS file...
\
\ SETDATE  ( null-term-file-name datestamp-structure -- flag )
\
\ the returned flag is FALSE if the call did not suceed.
\
\ Another function that is in this file is SENDPKT, which is used to
\ send a "StandardPacket" to DOS to perform some special action, in
\ this case, to set the datestamp of the file.  It is used thusly...
\
\ SENDPKT  ( process type long-args #args -- flag )
\
\ the returned flag is FALSE if the call did not suceed.  :-) Mike Haas

\ 00001 10-may-91 mdh unlock file before sending packet due to bug in 1.3
\                     floppy driver in that it ignores SHARED_LOCKs
\ 00002 21-sep-91 mdh removed >rel needed for beta bug in no@
\ 00003 5/25/92 PLB Changed INCLUDE? for JU:DOS-SUPPORT

0 .IF

Ok, in keeping with Phil's and Andy's simple request, we present...


/* touch.c by Phil Lindsay and Andy Finkel              */
/* (c) 1986 Commodore-Amiga, Inc.                       */
/* Permission to use in any way granted, as long as     */
/* the copyright notice stays intact                    */


This c file was actually encountered as "utime.c" in a "tar" (unix
tape-dump utility) implementation encountered on the nets.  Always
thought c and forth could do nice things for each other.

SETDATE.F was derived from "utime.c", believe it or not.  Mike Haas.

.THEN

\ include? lock() ju:dos-support \ 00003
include? task-dos-support ju:dos-support \ 00003

include? PutMsg() ju:exec_support
include? { ju:locals

.need DeviceProc()
  : DeviceProc()  ( 0name -- process )
    >abs ( can't call>abs on DOS! )  call dos_lib DeviceProc if>rel
  ;
.then

.NEED ACTION_SET_DATE
   34 constant ACTION_SET_DATE
.THEN

anew task-setdate.f


: sendpkt { id type args nargs | replyport packet count pargs res1 -- flag,0=fail }
  0 -> res1  0 -> packet
  NULL NULL CreatePort() ?dup
  IF
     -> replyport   [ MEMF_PUBLIC MEMF_CLEAR | ] literal
     sizeof() StandardPacket allocblock ?dup
     IF
        -> packet
        packet .. sp_Pkt >abs  packet .. sp_Msg .. mn_Node ..! ln_Name
        packet .. sp_Msg >abs  packet .. sp_Pkt ..! dp_Link
        replyport >abs         packet .. sp_Pkt ..! dp_Port
        type                   packet .. sp_Pkt ..! dp_Type
        packet .. sp_Pkt .. dp_Arg1 -> pargs   0 -> count
        BEGIN
           count nargs <  count 7 < AND
        WHILE
           args count cells + @  pargs count cells + !
           count 1+ -> count
        REPEAT
        id packet PutMsg()
        replyport WaitPort() drop
        replyport GetMsg() drop
        packet .. sp_Pkt ..@ dp_Res1 -> res1
        packet freeblock
     THEN
     replyport DeletePort()
  THEN
  res1
;


: SetDate  \ was 544 bytes max-inline 8 no locals, 436 after locals!
  { file ds | task fib arg0 arg1 arg2 arg3 rc lock plock pointer -- 0=fail }
  0 >r  0 -> pointer  0 -> lock  0 -> plock  0 -> fib
  MEMF_PUBLIC 64 Allocblock ?dup
  IF
     -> pointer
     file DeviceProc() ?dup
     IF
        -> task
        file SHARED_LOCK Lock() ?dup
        IF
           dup -> lock  ParentDir() ?dup
           IF
              -> plock
              MEMF_PUBLIC sizeof() FileInfoBlock allocblock ?dup
              IF
                 -> fib
                 lock fib Examine()
                 IF
                    lock Unlock()  0 -> lock  \ 00001
                    Pointer off
                    fib .. fib_FileName  0count  pointer $append
                    NULL -> arg0
                    plock -> arg1
                    pointer >abs 2 -shift  -> arg2
                    ds >abs -> arg3
                    task  ACTION_SET_DATE
                    no@ arg0 yes@ ( 00002 ) 4  sendpkt  ( -- res ) rdrop >r
                 THEN
              THEN
           THEN
        THEN
     THEN
  THEN
  fib ?dup
  IF
     freeblock
  THEN
  lock ?dup
  IF
     Unlock()
  THEN
  plock ?dup
  IF
     Unlock()
  THEN
  pointer ?dup
  IF
     freeblock
  THEN
  r>
;

0 .IF

\ test...

datestamp tds  1 tds ..! ds_Days  1 tds ..! ds_Minute  0 tds ..! ds_Tick

" date >ram:t/jtest" $dos

fopen ram:t/jtest spare !

cr ." ram:t/jtest opened, file pointer placed in SPARE" cr

.THEN
