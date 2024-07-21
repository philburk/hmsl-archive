\ A test program to demonstrate the direct variable interface to ARexx.
\  Opens a public port called "VarTest" and then waits for REXX messages.
\  The port stays open until a "CLOSE" command is received.
\  Usage:  vartest            ( from Forth window )
\          rx testrvi.rexx    ( from shell window )
\  Then send commands from within ARexx by "address 'VarTest' command"
\ 
\ This version translated to JFORTH by Martin C Kees

\ 00001 PLB 1/24/92 Added INCLUDE? VALUE

getmodule includes
getmodule arexxmod
include? createport() ju:exec_support
include? rexxsyslib?  jrx:ArexxCalls.f
include? CheckRexxMsg jrx:RexxVars.f
include? value        ju:value

anew TASK_VARTEST.F

0 value VARTESTPORT
0 value RMSG

: VARPORT.INIT ( -- ok? )
	0" VarTest" 0 createport()
	dup -> vartestport
;  

: VARPORT.TERM ( -- )
	vartestport dup
	IF
		deleteport()
		0 -> vartestport
	THEN    
;                  

: VARTEST.SHOWVAR ( 0name -- , show value of variable )
	>r
	rmsg r@ GetRexxVar ?dup
	." Vartest: value of " r> 0count type ."  is: "
	IF \ error!
		." No Value" cr
		." VarTest: error from get " .
		drop
	ELSE
		0count dup  
		IF type 
		ELSE ddrop ." NULL STRING"
		THEN
	THEN cr
;

: VARTEST  ( -- , test variable interface )
\ initialize
	rexxsyslib?
	varport.init
	IF
		." Waiting for commands from TestRVI.rexx" cr
		BEGIN
\ get command message from ARexx
			vartestport waitport() drop
			vartestport getMsg() -> rmsg
			cr ." VarTest: received command "
			rmsg .. rm_args @ >rel 0count type cr
			rmsg CheckRexxMsg
			IF
				." VarTest: valid REXX context" cr
\
\ get variables and print them
				0" A.1" vartest.showvar
				0" A.2" vartest.showvar
\
\ change value of STATUS variable
				rmsg 0" STATUS" " A-OK" count
				SetRexxVar ?dup
				IF ." VarTest: error from set " . cr
				THEN
			THEN
\
\ did we get CLOSE command?
			0" CLOSE" 0count rmsg .. rm_args @ >rel text=?
\
\ reply to message
			0 rmsg ..! rm_result1
			0 rmsg ..! rm_result2
			rmsg ReplyMsg()
		UNTIL
\ cleanup
		varport.term
	THEN
	-rexxsyslib
;     

cr
." Enter in JForth:  VARTEST" cr
." Enter in shell:   RX JRX:TESTS/TestRVI" cr

