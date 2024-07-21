\ This file compiles Specific TEXTRA interface words to allow
\ compiling the current Textra window.  Compile errors
\ are highlighted in the window.

\ 00000 06-aug-91 mdh     Initial version
\ 00001 18-aug-91 mdh     Removed unnecessary code due to phil's underkey. 
\                         Section 4. described above no longer applies.
\                         Incorporated AREXXMOD module
\ 00002 23-sep-91 plb     changed JAR: to JRX:
\ 00003 05-dec-91 plb     Changed to new system using ARexxTools
\                         Added some comments and PUT.TEXTRA
\                         Added DROPs to {REXXCLQUIT}
\ 00004 12-dec-91 plb     Added JForthToFront

\ =============== get all the system support stuff...

getmodule includes
getmodule arexxmod  \ 00001

include? CreatePort()       ju:exec_support
include? tolower            ju:char-macros
include? JForthToFront      ju:find_window
include? task-ARexxTools.f  JRX:ARexxTools.f   \ 00003
include? task-RXUnderKey.f  JRX:RXUnderKey.f

ANEW TASK-REXXCLUDE.F

decimal

0 .if  \ debugging tools
: TRY  ( -- , send "this" 10 times )
	10 0
	DO
		0" @textn this"  rx.put.textra .
	LOOP
;

: >TEXTRA  ( <command_line> -- , "string" )
	eol word count >dos  dos0 rx.put.textra .
;
.then

: 10N>TEXT  ( n -- adr cnt , in decimal )
  base @ >r  decimal  n>text  r> base !
;

variable RLINE   \ line number being compiled
variable RX_WASRXCLQUIT

: TEMPQUIT ( -- , quit without telling textra )
	xblk off   quit
;

\ Make strings that contain difficult characters " and EOL
\ by replacing the 'x'
: "quote"  " x"  ;  ascii " "quote" 1+ c!
: "eol"    " x"  ;  eol "eol" 1+ c!

: "append  ( $strfrom $strto -- )  swap count rot $append ;

: {REXXCLQUIT} ( -- , tell Textra to show error then QUIT )
\ >newline ." quitting (REXXCLUDE)..."  clinestart @ . clinenum @ .
	xblk off  #tib off  >in off
\
\ tell Textra to highlight offending line
	" @selectline " here $move
	RLINE @ 1- 0 max 10n>text here $append
	here +null   here 1+ rx.put.textra
	drop \ 00003
\
\ tell Textra to notify user of error
	" @notify " here $move  "quote" here "append
	" JForth says 'Problem with line " here "append
	RLINE @ 10n>text here $append
	" '." here "append  "quote" here "append
	here +null   here 1+ rx.put.textra
	drop \ 00003
\
\ now do real old quit
	RX_WASRXCLQUIT dup @ swap off  dup is quit  execute
;

: InitRexxCLQuit   ( -- , vector QUIT )
  RX_WASRXCLQUIT @ 0=
  IF
     what's quit RX_WASRXCLQUIT !   ' {REXXCLQUIT} is quit
  THEN
;

: RestoreRexxCLQuit  ( -- , unvector )
  RX_WASRXCLQUIT @ ?dup
  IF
     is quit   RX_WASRXCLQUIT off
  THEN
;


: RDREXXCLUDE  ( -- , include next line from Textra )
  tib  1024
  over clinestart !  cprevstart off
\
\ get next line
  here off  " @get line " count here $append
  RLINE @ 10n>text here $append    1 rline +!
  here count >dos  dos0
\ >newline ." sending: " dos0 0count dump
  rx.put.textra 0=
  IF
     rx-result1 @ 0=
     IF
        "eol" here "append
        ( tib maxlen )  here count  rot over <
        IF
           >newline ." Line from AREXX too long"   quit
        THEN
        ( tib text cnt )  >r  swap r@ move  r> #TIB !  >in off
        \ 1 clinenum +!
\ >newline ." read in: " tib #tib @ type cr \ dump
     ELSE
\ compile ;;; for FILE?
        2drop XBLK off
        even-up  redef? dup @  >r off   $ 033b3b3b here !
        skip-word? on  [compile] :   [compile] ;
        r> redef? !
        pulltib  >newline ." -- TEXTRA compilation finished" cr
        RestoreRexxCLQuit
        JForthToFront \ 00004
     THEN
  ELSE
     2drop  >newline ." PutRexxMsg failed"   tempquit
  THEN
;

: XBLKON  xblk on  interpret ;

: REXXCLUDE ( $filename-for-header -- )
  BLK @
  IF
     >newline ." Can't REXXCLUDE if LOADing from screens"  quit
  THEN
  XBLK @
  IF
     >newline ." REXXCLUDE already active"  quit
  THEN
  count >dos  >newline ." -- From TEXTRA: "  dosstring 1+ $type  cr
  FILEHEADERS @
  IF
\
\ this IF section is identical with INCLUDE, should make a subroutine
\ in the kernal.
\
     redef? dup @ >r off
     dosstring 1+ dup c@ dup >r 1+ here cell+ swap move  ( -- )
     here r> 4 + over c!  ( -- here )
     $ 3a3a3a3a swap 1+ odd!
     here count UPPER
     skip-word? on
     [compile] :    [compile] ;
     r> redef? !
     latest
  ELSE
     0
  THEN
  ( -- nfa? )
  ( here -- add later for error checking )
  pushtib clinefile ( -- nfa? clinefile ) !  \ ( -- here &clinefile )
\
  CLINENUM off     tib CLINESTART !     CPREVSTART off
  ( FSP @  sp@ FSP ! -- add later for error checking )
  ' RDREXXCLUDE is XFillTIB  ' XBLKON is RX.AFTER.INTERPRET
  RLINE off   #TIB @  >IN !
  InitRexxCLQuit
;
