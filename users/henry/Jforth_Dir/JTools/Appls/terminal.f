\ Simple terminal emulator
\
\ Author: Phil Burk
\ Copyright 1987 Delta Research

\ MOD: PLB 1989 Various improvements
\ MOD: PLB 4/9/91 Fix stack in TERMINAL.TERM

getmodule includes
include? io_message ji:exec/exec.j
include? serial.open ju:serial

ANEW TASK-JTERM

CREATE READ-MESSAGE 20 allot
VARIABLE TERM-BUF
VARIABLE IORQ-WRITE
VARIABLE IORQ-READ
VARIABLE BAUD-RATE
variable OLD-CONSOLE
variable HALF-DUPLEX
1200 baud-rate !

: TERMINAL.SETUP ( serreq -- )
    4096 over ..! io_rbuflen
    7 over ..! io_ReadLen
    7 over ..! io_WriteLen
    baud-rate @ over ..! io_Baud
    0 over ..! io_Serflags
    2 over ..! io_stopbits
    serial.setparams .hex
;

: TERMINAL.INIT  ( -- , open serial devices )
    old-console off
    " RAW:0/10/640/100/JForth Terminal" $fopen ?dup
    IF  console@ old-console !  ( save original console )
        console!
    THEN
    SERF_SHARED 0" ser-read" serial.open .hex iorq-read !
    SERF_SHARED 0" ser-write" serial.open .hex iorq-write !
    iorq-read @ terminal.setup
    iorq-write @ terminal.setup cr
;

: TERMINAL.TERM  ( -- , restore original window, close serial )
    old-console @ ?dup
    IF
    	console@   fclose
    	console!  
    THEN
    iorq-read @ serial.close
    iorq-write @ serial.close
;

: TERMINAL.START.READ ( -- )
    read-message 1 iorq-read @ serial.read.async
;

: TERMINAL.FINISH.READ ( -- )
    iorq-read @ waitio() ?dup
    IF ." Read error = " .hex cr
    THEN
\    read-message c@ dup ." Recieved = " emit space .hex cr
    read-message c@ emit flushemit
;

: TERMINAL.READ  ( -- , print any characters read )
    iorq-read @ checkio()
    IF 
       terminal.finish.read
       terminal.start.read
    THEN
;

: TERMINAL.ABORT.READ
    iorq-read @ abortio() .hex
;

: TERMINAL.WRITE ( -- done?, send any characters hit to serial )
    ?terminal
    IF key dup ascii ~ =
        IF drop true
        ELSE half-duplex @
             IF dup emit flushemit
             THEN
             term-buf c! term-buf 1 iorq-write @
             serial.write drop ( returns strange errors! )
             false
        THEN
    ELSE false
    THEN
;

: TERMINAL ( -- )
    terminal.init
    terminal.start.read
    BEGIN
        terminal.read
        terminal.write
    UNTIL
    terminal.abort.read
    terminal.term
;

