only Forth Definitions

anew task-stats.f

also TGT definitions

decimal


0 DynamicStack InTGT    \ Array of sorted Target Addresses...
0 DynamicStack InDict   \ ... and their original Dictionary addresses...
0 DynamicStack NOADDR   \ ...addresses called but never resolved

also forth definitions

: InitClone
  InTGTVAR    FreeStack
  NoAddrVAR   FreeStack
  InDictVAR   FreeStack
  InitClone  ;

previous definitions


: TargetTables  ( -- , build/check 3 tables )
  \
  \ Arrange in Target Address order...
  \
  ReferencesBase dup freecell  0
  DO
     ( -- base )  dup @ dup PacketFor  dup ..@ ref_resolved
     IF
        ( -- base ref pkt )    ..@ ref_TgtAdr
        dup InTGT StackFind    ( -- base ref adr index flag )
        IF
           2drop drop          ( -- base )
        ELSE
           dup >r
           InTGT  StackInsert  ( -- base ref )  r> InDict StackInsert
        THEN
     ELSE
        ( -- base ref pkt )  drop
        dup NoAddr StackFind
        IF
           2drop
        ELSE
           NoAddr StackInsert
        THEN
     THEN
     cell+
  LOOP
  drop  ( -- )
;


also Forth Definitions

: Stats   ( -- , show resident dictionary references )
  TargetTables
  cr  cr base @ >r  decimal
  InTGTBase freecell dup . ." PFAs referenced ..." cr  ?dup
  IF
       0
       DO   i 20 mod 0=
            IF
               cr
               ."   Resident     Target  Times     Name" cr
               ."   --------     ------  -----  ----------" cr
            THEN
            i cells  InDictBase + @   ( -- pfa )  dup >r
            hex  10 .r space
            i cells  InTGTBase + @  10 .r  space
            r@ PacketFor dup 
            ..@ ref_#times   decimal  6 .r  2 spaces
            ..@ ref_ISPFA
            IF    r@ >name id.
            ELSE  ." -- No NFA --"
            THEN  r> drop
            ( -- packet )   ( flushemit )  ?pause cr
       LOOP
  THEN
  \
  \ Check Unresolveds...
  \
  NoAddrBase freebyte -dup
  IF
     cr  ." UNRESOLVED references to:" cr  hex 0
     DO
        NoAddrBase i + @ 10 .r  ?pause  cr   cell
     +LOOP
  THEN
  decimal   cr ." Target image occupies "  TargetImageBase freebyte .
               ." bytes." cr cr
  r> base !
;

only forth definitions

also TGT
