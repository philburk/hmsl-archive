\ RexxView by Martin Kees
\ JForth REXX peeker
\ CLI utility to monitor REXX message traffic
\ Usage: rexxview outfile
\ Terminate by sending: closerexxview to REXX port
\ i.e. from CLI: rx CLOSEREXXVIEW
\ 3/JUN/91
\ Freely Distributable
\
\ MOD: PLB 7/21/91 00001 Added print of CommAddr:
\			Added include? for VALUE, c/TASK_REXXVIEW/TASK-REXXVIEW/
\ MOD: MCK 12/8/91 00002 fixed rm_CommAdr call c/../s@/
\ MOD: MCK 12/8/91 00003 check for NULL 0string in ?0type
\ MOD: MCK 12/8/91 00004  added abort if REXX port vanishes
\ MOD: MCK 12/8/91 00005  c /quit/exit/

getmodule includes
getmodule arexxmod    \ ji:arexx/storage.j ji:arexx/rxslib.j
include? value ju:value
include? addport()   ju:exec_support
\ include? rexxsyslib? jrx:ArexxCalls.f

anew task-rexxview

0 value rxpri
0 value myport
0 value rxport
0 value rmsg
0 value ofile

.NEED RXFF_NOIO
1   RXFB_NOIO   <<  constant RXFF_NOIO
.THEN

.NEED forbid()
: FORBID() ( -- )
    callvoid exec_lib forbid
;
.THEN

.NEED permit()
: PERMIT() ( -- )
    callvoid exec_lib permit 
;
.THEN

: dscanlist ( port -- rexxport true | 0 )
  begin
    s@ ln_succ dup
    IF dup s@ ln_name ?dup
      IF
       RXSDIR 4 compare
       IF-NOT true exit
       THEN
      THEN 
    THEN
    dup
  until-not  
;

\ Not needed after I found that the message port list
\ is priority sorted but ...
: uscanlist ( port -- rexxport true | 0 )
  begin
    s@ ln_pred dup
    IF dup s@ ln_name ?dup
      IF
       RXSDIR 4 compare
       IF-NOT true exit
       THEN
      THEN
    THEN
    dup
  until-not
;

: Openmyport ( -- flag )
  0 -> myport
  forbid()
  RXSDIR findport() dup -> rxport
  IF  rxport ..@ ln_pri -> rxpri
      RXSDIR rxpri 1+ Createport() -> myport
  THEN
  permit()
  myport
;

: Closemyport ( -- )
  myport   ?dup IF deleteport()
                   0 -> myport
                THEN
;

: msg>taskname ( msg -- 0$task )
  s@ mn_replyport
  s@ mp_SigTask
  s@ ln_name
;

: msg>arg0 ( msg -- 0str )
  .. rm_args @ >rel 
;

: fcr
  10 pad c! ofile pad 1 fwrite drop
;


: >ofile ( srt -- )
  ofile swap count fwrite drop
;

: ?0type ( 0str str -- )
  ofile swap count fwrite drop
  ?dup                         \ MCK 00003
  IF-NOT " Null" >ofile        \     00003
  ELSE  0count
  ?dup IF ofile -rot fwrite drop
       ELSE drop " Null" >ofile
       THEN
  THEN
  fcr
;

: term.rv ( msg -- )
   replymsg()
   begin myport getmsg() ?dup
   while replymsg()
   repeat
   closemyport
   ofile fclose
;

: SendToRexx ( msg -- flag )
  forbid()
  myport dscanlist
  ?dup IF-NOT  myport uscanlist
       THEN
  IF swap putmsg()   true
  ELSE   false
  THEN
  permit()
  IF-NOT
     " REXX port closed!" >ofile
     term.rv abort                  \ MCK 00004
  THEN
;

: aboutmsg
  ofile " RexxView by Martin Kees " count fwrite drop fcr
  ofile " (c) 1991 M C Kees"        count fwrite drop fcr
  ofile " Freely Distributable"     count fwrite drop fcr
;


: .action ( msg -- )
  " Action: " swap
  ..@ rm_action  RXCODEMASK AND
CASE
RXCOMM   OF   0" RXCOMM"
         ENDOF
RXFUNC   OF   0" RXFUNC"
         ENDOF
RXCLOSE  OF   0" RXCLOSE"
         ENDOF
RXQUERY  OF   0" RXQUERY"
         ENDOF
RXADDFH  OF   0" RXADDFH"
         ENDOF
RXADDLIB OF   0" RXADDLIB"
         ENDOF
RXREMLIB OF   0" RXREMLIB"
         ENDOF
RXADDCON OF   0" RXADDCON"
         ENDOF
RXREMCON OF   0" RXREMCON"
         ENDOF
RXTCOPN  OF   0" RXTCOPN"
         ENDOF
RXTCCLS  OF   0" RXTCCLS"
         ENDOF
         0" UNKNOWN" swap
ENDCASE
    swap ?0type
;

: .modifier ( msg -- )
  " Modifier: " >ofile
  ..@ rm_action
  dup RXFF_RESULT  and IF " RXFB_RESULT " >ofile
                       THEN
  dup RXFF_STRING  and IF " RXFB_STRING " >ofile
                       THEN
  dup RXFF_TOKEN   and IF " RXFB_TOKEN  " >ofile
                       THEN
  dup RXFF_NONRET  and IF " RXFB_NONRET " >ofile
                       THEN
  dup RXFF_NOIO    and IF " RXFB_NOIO   " >ofile
                       THEN
  drop fcr
;



: rexxview ( -- )
  new fileword
  dup 1+ c@ ascii ? = over c@ 0= OR
  IF drop cr
     ." Usage: rexxview  OutputFileName" cr
     ." Terminate by sending to REXX: closerexxview"  cr
     exit
  THEN
  $fopen -> ofile
  ofile
 IF
  openmyport
  IF aboutmsg
    BEGIN
     myport waitport() drop
     myport getmsg() -> rmsg
     rmsg msg>taskname " From Task: " ?0type
     rmsg .action
     rmsg .modifier
     rmsg s@ rm_CommAddr " CommAddr: " ?0type  \ PLB 00001 MCK 00002
     rmsg msg>arg0
      dup " Arg0: " ?0type fcr
       0" closerexxview" 0count compare
       IF-NOT rmsg term.rv
              exit                   \ MCK 00005
       THEN
     rmsg sendtorexx
    AGAIN
  ELSE ofile fclose
       rxport IF-NOT ." REXX not found " cr exit
              THEN
  THEN
  myport IF-NOT ." No memory for RexxView port!" cr exit
         THEN
 ELSE
  ." Couldn't open output file" cr
 THEN
;
