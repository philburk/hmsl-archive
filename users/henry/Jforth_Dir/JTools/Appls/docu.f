\ Automatically generate documentation fom source code.
\
\ Recognition key:
\ If character in first column
\ and if character not a '\'
\ and if "--" in comment or : in first column.
\
\ Author: Phil Burk
\ Copyright 1988 Phil Burk
\ All Rights Reserved.
\
\ MOD: PLB 1/17/89 Also catch words with local variables.

include? logto ju:logto
include? dolines ju:dolines

ANEW TASK-DOCU

VARIABLE DOCU-SHOW-FILE

: DOCU.DEFINER?  ( $line -- flag , is this worth documenting?)
    >r 0
    r@ c@ 0> ( not empty )
    IF r@ 1+ c@ bl > ( start with non blank )
      IF r@ 1+ c@ ascii \ -
        IF r@ count ascii ( scan dup 0=
           IF 2drop r@ count ascii { scan dup 0>
           ELSE true
           THEN
          IF ( --adr' len' )
            ascii -  scan 0>
            IF 1+ c@ ascii - =
              IF drop true  ( YES!!! )
              THEN
            ELSE drop
            THEN
          ELSE 2drop
          THEN
        THEN
      THEN
    THEN
    rdrop
;

: DOCU.LINE ( $line -- , print if documentable )
    dup docu.definer?
    IF >newline $type
       docu-show-file @
       IF bl 56 emit-to-column dl-filename $type
       THEN
       ?pause cr
    ELSE drop
    THEN
;

: DOCU.FILE ( <filename> -- , print stack diagrams from file)
    ' docu.line is doline
    dolines
;

: .DOCU ( <filename> -- , document to logto file )
    logto-id @
    IF  logged? not
        IF logstart docu.file logstop
        ELSE docu.file
        THEN
    ELSE docu.file
    THEN
;

cr
." For optional file listing, enter:  DOCU-SHOW-FILE ON" cr
." To show stack diagrams, enter:   .DOCU <filename>" cr
