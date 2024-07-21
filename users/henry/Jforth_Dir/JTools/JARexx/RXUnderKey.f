\ Wedge ARexx listening under KEY
\
\ Author: Phil Burk & Mike Haas
\ Copyright 1991 Delta Research
\ All Rights Reserved.
\
\ 00001 PLB 9/23/91 Replace Delay() with ?TERMINAL.DELAY
\	because Delay() is buggy and can cause errors on floppies.
\ 00002 PLB 12/4/91 Change TRX. prefix to RXUK.
\     Change to use ARexxTools
\ 00003 MDH 26-jan-92 Add TYPE of strings to be INTERPRETed
\                     cleaned up messages

include? task-ARexxTools.f jrx:ARexxTools.f

ANEW TASK-RXUnderKey.f

defer RXUK.OLD.KEY
defer RXUK.OLD.QUIT

variable RXUK-RMPTR

: RXUK.QUIT ( -- )
  #tib off  >in off skip-word? off
  rxuk-rmptr @ ?dup
  IF
     >newline  
     dup .. rm_args @ >rel 0count  ascii ' emit  type  ascii ' emit
\ send error message back
     10 rx-result1 !
     rxuk-rmptr @ rx.reply.msg
     rxuk-rmptr off
     ."  from AREXX caused an ABORT" cr
  THEN
  rxuk.old.quit
;

variable rxuk-INSTALLED \ true if installed

: RX.DEINSTALL
	rxuk-installed @
	IF
		what's rxuk.old.key is key
		what's rxuk.old.quit is quit
		rx.term
		rxuk-installed off
		>newline ." JForth no longer listening to AREXX." cr
	THEN
;


: RXUK.INTERPRET ( -- got-one? )
    ' noop is RX.AFTER.INTERPRET
	rx.get.msg ?dup
	IF
		rxuk-rmptr !  \ don't wait
    	rxuk-rmptr @ .. rm_args @ >rel
    	0count  >newline ." From AREXX: " 2dup type cr  \ 00003
    	$interpret   0 clinenum !
    	rxuk-rmptr @ rx.reply.msg  rxuk-rmptr off
    	RX.AFTER.INTERPRET  flushemit
		true \ got one!
	ELSE
		false
	THEN
;

: RXUK.INTERP.LOOP ( -- quit? , loop as long as we get messages )
	RX-QUIT off   skip-word? off
   	BEGIN
   		rxuk.interpret ( -- got-one? ) NOT
   		RX-QUIT @ OR
   	UNTIL
   	rx-quit @
;

variable rxuk-DELAY
200,000 rxuk-delay ! \ 1/5 second

: RXUK.KEY  ( -- char ,listen to Textra and wait for char )
	flushemit
	BEGIN
		rxuk-delay @ ?terminal.delay not
	WHILE
		rxuk.interp.loop
		IF
			rx.deinstall
		THEN
	REPEAT
	rxuk.old.key
;

: RX.INSTALL ( -- )
	rxuk-installed @ 0=
	IF
		jforth_name rx.init 0=
		IF
			what's key is rxuk.old.key
			' rxuk.key is key
			what's quit is rxuk.old.quit
			' rxuk.quit is quit
			rxuk-installed on
			>newline ." JForth listening to ARexx!" cr
		ELSE
			>newline  ( 00003 )
			." ARexx interface could not be initialized!" cr
		THEN
	ELSE
		>newline ." ARexx interface already installed!" cr  ( 00003 )
	THEN
;

if.forgotten rx.deinstall

: AUTO.INIT  auto.init rx.install
;
: AUTO.TERM  rx.deinstall auto.term ;

cr
." To install ARexx listener under KEY, enter:" cr
."    RX.INSTALL" cr
." When done, enter:" cr
."    RX.DEINSTALL" cr

