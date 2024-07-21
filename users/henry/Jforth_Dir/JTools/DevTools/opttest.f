anew task-test.f

decimal

1,000,000 constant #tests

>newline ." TEST1: add all the bytes in JForth image..." cr

: test1  ( -- , add all the bytes from adr 0 t0 initial stack adr )
  0 0 s0 @ 0  ( -- running-tot #done limit 0 ) DO
     dup c@   ( -- rt #d byte )
     rot + swap  ( -- rt+byte #d )  1+
  LOOP
  2drop
;

measure test1
cr

>newline ." TEST2: 'SWAP 1+ SWAP 1+', " #tests . ." times..." cr

: test2  ( -- )
  0 0 #tests 0 DO
     swap 1+ swap 1+
  LOOP
  2drop
;

measure test2
cr

\ >newline ." FORGET test words" y/n
\ .IF
\    forget task-test.f
\ .THEN
