
\ PFALength  ( PFA -- #bytes )  calculate size of code.

only forth definitions

anew task-pfalength.f

also TGT definitions


: PFALength?  ( pfa -- #bytes )
  0 swap  0 >r              ( -- totsize opadr )   ( -r- hibra )
  BEGIN
     \ ?pause
     dup w@  $ 4e75 -   r@ or
  WHILE
     dup w@ >r dup +NextOp  ( -- totsize opadr opsize )  ( -r- hibra opc )
     rot over +             ( -- opadr opsize newsize )
     -rot over + swap       ( -- size nextopa opadr )
     r> dup BranchOp?       ( -- size nextadr opadr opcode flag )
     IF
          BRAto? dup r@ >   ( -- size nextadr dest replaceflag )
          IF
               dup r> drop >r
          THEN
          drop              ( -- size nextadr )
     ELSE
          2drop
     THEN
     r@ -dup
     IF
          ( -- size nextadr hibra )
          over <=
          IF
               r> drop  0 >r
          THEN
     THEN
  REPEAT
  r> 2drop
;

only forth definitions
also TGT
