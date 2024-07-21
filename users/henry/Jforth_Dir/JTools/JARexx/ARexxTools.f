
\ JForth specific ARexx Tools
\
\ Author: Phil Burk
\ Based on a design by Martin Kees, Mike Haas and Phil Burk
\ Copyright 1991 Phil Burk, Martin Kees, Mike Haas
\
\ 00001 PLB 1/21/92 Added DUP and SWAP to ERR.#>$ for default.
\ 00002 PLB 1/28/92 Save RX-SAVE-MSG, Check stack depth in RX.EXEC.LINE
\ 00003 PLB/Kees 4/23/92 Add R to parsing format.
\ 00004 MDH/PLB 4/27/92 Open RexxSysLib in RX.TERM

getmodule includes
getmodule arexxmod

include? CreatePort() ju:exec_support
include? tolower ju:char-macros
include? { ju:locals
include? task-error_codes ju:error_codes
include? task-arexxcalls.f jrx:ARexxCalls.f

ANEW TASK-ARexxTools.F

\ Define errors
RXERR_BASE
ERR: RXERR_ILLEGAL_PARAMETER
ERR: RXERR_ILLEGAL_COMMAND
ERR: RXERR_NOT_INITIALIZED
ERR: RXERR_NO_LIBRARY
ERR: RXERR_NAME_IN_USE
drop

: ERR.#>$ ( error_code -- $message )
	CASE
		RXERR_ILLEGAL_PARAMETER OF " Illegal ARexx parameter!" ENDOF
		RXERR_ILLEGAL_COMMAND OF " Illegal ARexx command!" ENDOF
		RXERR_NOT_INITIALIZED OF " RX.INIT not called!" ENDOF
		RXERR_NO_LIBRARY OF " No ARexx library!" ENDOF
		RXERR_NAME_IN_USE OF " ARexx Port name already in use!" ENDOF
		dup err.#>$ swap \ 00001
	ENDCASE
;

variable RX-PORT-PTR  \ Our port for receiving commands
variable RX-MESSAGE-PTR \ rexxmsg for sending commands
variable RX-QUIT    \ set TRUE to stop scanning
variable RX-DATA    \ for use from outside
variable RX-RESULT1 \ corresponds to result fields in RexxMsg
variable RX-RESULT2
variable RX-ERROR
variable RX-SAVE-MSG  \ save in case of abort 00002

\ This is used internally by REXXCLUDE and RXUnderKey
defer RX.AFTER.INTERPRET   ' noop is RX.AFTER.INTERPRET

: RX.GET.MSG ( -- rexxmsg | 0 )
    rx-port-ptr @ GetMsg()
    dup rx-save-msg ! \ 00002
;

: RX.WAIT.MSG ( -- rexxmsg )
    rx-port-ptr @ WaitPort() drop
    rx.get.msg
;

: RX.ARG[]  ( n rexxmsg -- arg-addr , index into argument array )
	.. rm_args
	swap cells +
;

: RX.PARSE.NUM ( 0string -- num 0scan true | false )
{ 0str | &token 0scan cnt quote result -- 0scan num true | false }
	0 -> result
\ parse out number
	0str StcToken() -> quote -> cnt -> 0scan -> &token
\
\ don't try with quoted strings
	quote 0=
	IF
		cnt here c!
		&token here 1+ cnt cmove
		here number?
		IF
			drop 0scan
			true -> result
		THEN
	THEN
	result
;

: RX.PARSE.STRING ( $format 0string -- ...params... 0left true | false )
{ $format 0str | &token cnt quote #params result &format #added -- ....... }
\ Parse input string based on formatted string containing "NNSSN"
\ For N , return NUM
\ For S , return ADDR COUNT
	true -> result
	0 -> #added
	$format count -> #params -> &format
	#params 0
	DO
		&format i + c@ toupper \ what is next parameter
		CASE
\ get number
			ascii N
			OF
				0str rx.parse.num
				IF ( -- num 0str )
					-> 0str
					1 +-> #added
				ELSE
					." RX.PARSE.STRING - Bad Number!" cr
					#added xdrop
					false -> result
					LEAVE
				THEN
			ENDOF
\
\ get string
			ascii S
			OF
				0str StcToken() -> quote -> cnt -> 0str -> &token
				cnt
				IF
					quote
					IF
						&token 1+ cnt 1-  \ remove ' or "
					ELSE
						&token cnt
					THEN
					2 +-> #added
				ELSE
					." RX.PARSE.STRING - Bad String" cr
					#added xdrop
					false -> result
					LEAVE
				THEN
			ENDOF
\
\ get Remainder of line as string (by Marty Kees) 00003
            ascii R
            OF
            	i #params 1- = NOT
            	IF
            		." RX.PARSE.STRING - R must be last format!" cr
            	THEN
            	0str StcToken() -> quote -> cnt -> 0str -> &token
            	cnt
                IF quote
                   IF &token 1+ cnt 1-  \ remove ' or "
                   ELSE
                      &token 0COUNT  \ GET REST OF LINE
                   THEN
                   2 +-> #added
                ELSE
                    ." RX.PARSE.STRING - Bad String" cr
                    #added xdrop
                    false -> result
                    LEAVE
                THEN
            ENDOF
\
			." Invalid format = " emit cr
			#added xdrop
			false -> result
			LEAVE
		ENDCASE
	LOOP
\
	result
	IF
		0str true
	ELSE
		false
	THEN
;

:STRUCT  RX_COMMAND
	rptr  rxc_name    \ command name, eg. " DRAWXYTEXT"
	rptr  rxc_format  \ parameter format, eg. " NNS"
	rptr  rxc_cfa
;STRUCT

variable RX-NUM-COMMANDS
variable RX-MAX-COMMANDS
variable RX-COMMAND-TABLE
variable ""  \ empty string, keep zero

: RX.FREE.CTABLE ( -- , free allocated table )
	rx-command-table freevar
	rx-num-commands off
	rx-max-commands off
;

if.forgotten rx.free.ctable

: RX.COMMAND[] ( n -- &command )
	dup rx-max-commands @ >= abort" RX.COMMAND[] - index too large!"
	sizeof() rx_command *
	rx-command-table @ +
;

: RX.ADD.COMMAND ( $name $format cfa -- )
	rx-num-commands @ rx.command[] >r
	r@ s! rxc_cfa
	r@ s! rxc_format
	r@ s! rxc_name
	rdrop
	1 rx-num-commands +!
;

: RX.ALLOC.CTABLE ( n -- table | 0 , allocate table for commands )
	rx.free.ctable
	memf_clear swap
	dup rx-max-commands !
	sizeof() rx_command * allocblock
	dup rx-command-table !
	dup
	IF
\ initialize table to noops
		rx-max-commands @ 0
		DO
			" NOOP" "" 'c noop rx.add.command
		LOOP
		0 rx-num-commands !
	ELSE
		0 rx-max-commands !
	THEN
;
                 
: RX.KILL.SCRIPT ( rexxmsg -- , send CTRL-C to rexx script )
	dup s@ mn_replyport
	dup ..@ mp_flags 0=
	IF ..@ mp_SigTask sigbreakf_ctrl_c
		callvoid exec_lib signal
	ELSE drop   
	THEN
;

: RX.FIND.COMMAND { addr cnt | comm -- index true | false }
\ look for matching command in table
	0 \ default result
	rx-num-commands @ 0
	DO
		i rx.command[] s@ rxc_name -> comm
		comm c@ cnt =
		IF
			addr cnt comm 1+ text=?
			IF
				drop i true
				LEAVE
			THEN
		THEN
	LOOP
;

: RX.EXEC.LINE { 0arg | indx stdepth -- error? }
	depth -> stdepth \ 00002
	rx-error off
\ parse out command
	0arg StcToken() ( -- token scan len quote )
	drop \ don't need quote
\
\ look for command in command list
	swap >r ( -- token len ) rx.find.command
	IF
		-> indx
		indx rx.command[] s@ rxc_format
		r@ rx.parse.string
		IF
			drop \ don't need string
			indx rx.command[] s@ rxc_cfa execute
			rx-error @
		ELSE
			RXERR_ILLEGAL_PARAMETER
		THEN
	ELSE
		RXERR_ILLEGAL_COMMAND
	THEN
	rdrop
\
\ There should now be just one more item on stack than
\ when we started.  If not, abort! Otherwise we would crash
\ horribly.  This would be a programming error! 00002
	depth 1- stdepth = not
	abort" RX.EXEC.LINE - stack depth error in command!"
;

: RX.EXEC.MSG ( rexxmsg -- )
\ The first arg is an absolute pointer to a NULL terminated string.
	0 swap rx.arg[] @ if>rel ?dup
	IF
		rx.exec.line ?dup
		IF
\ set error return if error in processing command
			rx-result1 !
		THEN
	THEN
;    		

: RX.REPLY.MSG ( rexxmsg -- )
	>r
\ do we have an argstring result?
	rx-result2 @
	IF
\ did caller request result and no error?
		r@ s@ rm_action rxff_result AND \ test bit
		rx-result1 @ 0= AND
		IF
\ ." Result2 = " rx-result2 @ 0count type cr
			rx-result2 @ >abs r@ ..!  rm_result2
		ELSE
			rx-result2 @ DeleteArgString() \ don't send it
			0 r@ s!  rm_result2
		THEN
	ELSE
		0 r@ s!  rm_result2
	THEN
    rx-result1 @ r@ s!  rm_result1
	r> ReplyMsg()
	rx-result1 off
	rx-result2 off
;

: RX.SLAVE ( -- , process ARexx commands until RX-QUIT on )
	rx-quit off
   	BEGIN
   		rx.wait.msg  ?dup
   		dup rx.exec.msg
   		rx.reply.msg
		rx-quit @
   	UNTIL
;

: RX.SLAVE.SAFE ( -- )
	>newline ." Waiting for commands from ARexx!" cr
	rx-quit off
    BEGIN
    	20,000 ?terminal.delay  \ wait 1/50 second between commands
    	rx-quit @ OR not
    WHILE
    	BEGIN
    		rx.get.msg  ?dup
    		IF
    			dup rx.exec.msg
    			rx.reply.msg false
    		ELSE
    			true
			THEN
			rx-quit @ or
    	UNTIL
    REPEAT
;

\ =============== words to send messages to another port...
\ We must Forbid so that the port doesn't disappear
\ between FindPort() and PutMsg()
0 .IF
/* example from 'FindPort()' entry in 1.3 'exec.doc' */
	#include "exec/types.h"
	struct MsgPort *FindPort();
	
	ULONG SafePutToPort(message, portname)
	struct Message *message;
	char	       *portname;
	{
	struct MsgPort *port;
	
	    Forbid();
		port = FindPort(portname);
		if (port)
		    PutMsg(port,message);
	    Permit();
	    return((ULONG)port); /* If zero, the port has gone away */
	}
.THEN

\ the JFORTH equivalent...

: SafePutToPort()    ( msg 0portname -- ok? )
  Forbid()           ( -- msg portname )
  FindPort() dup>r   ( -- msg port? )
  IF
     r@ swap         ( -- port msg )
     PutMsg()        ( -- )
  ELSE
     drop            ( -- )
  THEN
  Permit()  r>       ( -- flag )   \ If zero, the port has gone away
;

: RX.PUT.MSG  ( 0arg 0portname -- error? , send message to ARexx port)
\ sets RX-RESULT1 and RX-RESULT2
{ 0arg 0portname | rmptr result -- error? }
	true -> result \ default is error
	rx-result1 off
	rx-result2 off
\
\ are we initialized
	rx-message-ptr @ ?dup
	IF
		-> rmptr
\ set argument and flags
		0arg if>abs 0 rmptr rx.arg[] !
\
\ convert our simple 0string to ARexx ArgString
		rmptr 1 0 FillRexxmsg()
		IF
			rmptr 0portname SafePutToPort()
			IF
\ wait for this specific reply
				BEGIN
					rx.wait.msg dup rmptr =
					IF drop true
					ELSE
\ process messages from macro
						dup rx.exec.msg
						rx.reply.msg
						false
					THEN
				UNTIL
				false -> result
			THEN
		ELSE
			." RX.PUT.MSG - could not FillRexxMsg!" cr
		THEN
\
\ handle results
		rmptr ..@ rm_result1 dup rx-result1 ! 0=
		IF
\ copy Result2 to HERE if so we can DeleteArgString
			rmptr ..@ rm_result2 if>rel ?dup
			IF
				dup 0count dup>r here 1+ swap move r> here c!
				DeleteArgString()
				here rx-result2 !
			THEN
		THEN
		rmptr 1 clearRexxmsg()
	ELSE
		RXERR_NOT_INITIALIZED -> result
  	THEN
  	result
;

: RX.PUT.ACTION ( action -- , set in rx-message-ptr )
	rx-message-ptr @ ?dup
	IF
		s! rm_action
	ELSE
		drop
	THEN
;

: RX.PUT.TEXTRA ( 0arg -- error? , send message to resident Textra )
	rxcomm rxff_result | rxff_string | rx.put.action
	0" TEXTRA" rx.put.msg
	rxcomm rx.put.action
;

: RX.PUT.REXX ( 0arg -- error? , send message to resident process REXX )
	0" REXX" rx.put.msg
;

: RX.FLUSH.MESSAGES ( -- #msgs , flush all pending messages from ARexx )
	0
	BEGIN
		rx.get.msg ?dup
	WHILE
		10 rx-result1 !
		rx.reply.msg \ return error=10 for unprocessed messages
		1+
	REPEAT
;
	
: RX.TERM  ( -- , terminate if initialized )
	RexxSysLib?		\ 00004
	rx-port-ptr @  \ check so we don't do this twice by accident, boom!
    IF
    	rx.flush.messages ?dup
    	IF
    		. ." ARexx messages unprocessed." cr
    	THEN
    	rx-port-ptr @  DeletePort()
    	rx-port-ptr off
    THEN
\
    rx-message-ptr @ ?dup
    IF
		DeleteRexxmsg()
		rx-message-ptr off
    THEN
    -RexxSysLib
;

: RX.INIT  { 0hostname | result -- error? }
	rx.term
\
	true -> result \ default error return
	rx-port-ptr @ 0=  \ are we already initialized?
\ Open Library
	IF  lib_quit off \ don't abort if can't open
		RexxSysLib?
		
		RexxSysLib_lib @ 0=
		IF
			RXERR_NO_LIBRARY -> result
		ELSE
\
\ check to see if that name is in use
			0hostname FindPort()
			IF
				RXERR_NAME_IN_USE -> result
			ELSE
\ Initialize our message port for return calls.
				0hostname 0 CreatePort() ?dup
				IF  rx-port-ptr !
\
\ allocate a message port for use in calling macros
					rx-port-ptr @  0" rexx"  0hostname
					createRexxMsg() ?dup
					IF
						rx-message-ptr !
						rxcomm rx.put.action
						false -> result \ everything worked!!
					ELSE
						ERR_INSUFFICIENT_MEMORY -> result
					THEN
				ELSE
					ERR_INSUFFICIENT_MEMORY -> result
				THEN
			THEN
		THEN
	THEN
	result
;

: JFORTH_NAME    0" JFORTH"  ;

: RX.JFORTH.INIT ( -- error? , initialize port as "JFORTH" )
	JFORTH_NAME rx.init
;

if.forgotten rx.term
