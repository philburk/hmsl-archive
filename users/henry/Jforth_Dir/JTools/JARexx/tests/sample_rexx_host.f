0 .IF
Example REXX Host that responds to several ARexx Commands
The command set for this host was chosen to demonstrate a
variety of formats, not for their usefulness.

Command Set:

	CALCSUM  a b                - returns A+B
	TYPETEXT "a string" ntimes  - types text N times
	TYPEREM "a string"          - types remainder of line
	INCTEXT "a string" inc      - add to chars in string
	GOAWAY                      - quit
	
.THEN

\ Author: Phil Burk
\ Copyright 1991 Phil Burk

\ 00001 PLB 4/23/92 Add TYPEREM to test "R" format.

getmodule includes
getmodule arexxmod

include? CreatePort() ju:exec_support
include? tolower ju:char-macros
include? task-arexxTools.f jrx:ARexxTools.f
include? { ju:locals

ANEW TASK-SAMPLE_REXX_HOST.F

\ These are the words that implement the command set --------
: SRH.CALCSUM ( A B -- , add two numbers and print )
	+  \ calculate sum
	." Sum = " dup . cr  \ print it just for fun
\
\ now pass it back to caller via argstring result2
	n>text CreateARgString() rx-result2 !
;

: SRH.TYPETEXT ( addr count num -- , type string N times )
	>newline
	0
	DO
		2dup type cr
	LOOP
	2drop
;

: SRH.TYPEREM ( addr count -- )
	type cr
;

: SRH.INCTEXT { addr cnt inc -- , add INC to each char of string }
	cnt 0
	DO
		addr i + c@ inc +
		addr i + c!
	LOOP
\
\ now pass it back to caller via argstring result2
	addr cnt CreateARgString() rx-result2 !
;

: SRH.GOAWAY ( --  , quit )
	rx-quit on
;

\ These words setup the ARexx interface and run it. ----------
: SRH.INIT ( -- error? )
	0" SAMPLEREXXHOST" rx.init 0=
	IF
\
\ set optional filename extension, eg. macro1.SRH
		0" srh" rx-message-ptr @ s! rm_FileExt
\
\ Allocate space for some commands
		5 rx.alloc.ctable
		IF
\ Define command set
			" CALCSUM"  " NN" 'c srh.calcsum  rx.add.command
			" TYPETEXT" " SN" 'c srh.typetext rx.add.command
			" TYPEREM"  " R"  'c srh.typerem rx.add.command
			" INCTEXT"  " SN" 'c srh.inctext rx.add.command
\ For no parameters, use "" which is one Forth word with 2 doublequotes!
			" GOAWAY"   "" 'c srh.goaway   rx.add.command
			false
		ELSE
			." SRH.INIT - Could not allocate CTABLE!" cr
			true
		THEN
	ELSE
		." SRH.INIT - Could not initialize port!" cr
		true
	THEN
;

: SRH.TERM ( -- , cleanup )
	rx.free.ctable
	rx.term
;

if.forgotten srh.term

\ Here are two possible ways of running this program.
: SRH.SLAVE  ( -- , accept ARexx commands until RX-QUIT )
	srh.init 0=
	IF
		rx.slave.safe
		srh.term
	THEN
;

: SRH.MACRO  ( -- , fire off an ARexx macro that talks back to us )
	srh.init 0=
	IF
		0" jrx:tests/macro1" rx.put.rexx
		IF
			." SRH.MACRO error reported!" cr
		THEN
		srh.term
	THEN
;

cr
." Enter in JForth:   SRH.MACRO" cr cr
." OR enter in JForth:   SRH.SLAVE" cr
."    then enter in the CLI:   RX  JRX:TESTS/DRIVE.SRH" cr

