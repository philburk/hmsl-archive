\ ARexx Test
\
\ This is an example of a minimal JForth program that
\ sets up an ARexx port, receives messages, interprets
\ them, then cleans up.
\
\ It uses the tools in the file jrx:ARexxTools.f
\
\ Send a string to this program using the ARexx command:
\     address   'JFORTH'   'some Forth command'
\
\ Author: Phil Burk
\ Copyright 1991 Phil Burk

getmodule includes
getmodule arexxmod

include? CreatePort() ju:exec_support
include? tolower ju:char-macros
include? task-arexxTools.f jrx:ARexxTools.f

ANEW TASK-TEST_RXTOOLS.F

: TR.INTERPRET ( -- , wait.for a message then interpret it)
    rx.wait.msg  >r
\
\ The first arg is an absolute pointer to a NULL terminated string.
    0 r@ rx.arg[] @ if>rel 0count
	cr ." Received: " 2dup type cr     \ for debugging
\
\ Interpret message as a Forth command line.
\ In a cloned aplication you will need to use your own command set.
    ( -- addr count ) $interpret
\
\ reply so ARexx can continue
    r> rx.reply.msg
;

: TR.INTERP.LOOP ( -- )
	>newline ." Waiting for messages from ARexx!" cr
	rx-quit off
	rx-data off
    BEGIN
    	tr.interpret
    	rx-quit @
    	?terminal or 
    UNTIL
;

: TEST.AREXX  ( -- )
	jforth_name rx.init 0=
	IF
		tr.interp.loop
		rx.term
	THEN
;

cr
." Enter in JForth: TEST.AREXX" cr
." Then enter in the CLI:   RX  TOJF" cr
." to run the ARexx program that controls JForth" cr
