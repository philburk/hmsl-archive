
only forth definitions


anew task-memrefs.f


\ Words to handle the actual target area building........................

variable MaxImageSize   \   64 1024 * MaxImageSize !


also TGT definitions

0 DynamicStack TargetImage

also forth definitions

: InitClone
  TargetImageVAR FreeStack
  InitClone
;

previous definitions


: TargetHERE   ( -- addr )    TargetImageBase FreeByte      ;


EXISTS? Status? .IF
  ' TargetHERE is TargetSize
.THEN


: TargetHas?   ( addr -- addr )
  \ dup MaxImageSize @ U> ?ABORT" Increase 'MaxImageSize'...limit reached."
  TargetImage over cell+ enlarge?
;

: TargetAllot  ( #bytes -- )
  TargetHERE +    ( -- newused )  TargetHas?
  TargetImageBase freebytea !  ;

: Target@  ( adr -- data )   TargetImageBase + @    ;
: TargetW@ ( adr -- data )   TargetImageBase + w@   ;
: Targetc@ ( adr -- data )   TargetImageBase + c@   ;

: Target!  ( data adr -- )   TargetHas?  TargetImageBase + !    ;
: TargetW! ( data adr -- )   TargetHas?  TargetImageBase + W!   ;
: TargetC! ( data adr -- )   TargetHas?  TargetImageBase + C!   ;

: Target,  ( n1 -- )   TargetHERE    4 TargetAllot  Target!   ;
: TargetW, ( n1 -- )   TargetHERE    2 TargetAllot  TargetW!  ;
: TargetC, ( n1 -- )   TargetHERE    1 TargetAllot  TargetC!  ;


: TargetMove  ( from to cnt -- )
  2dup +       TargetHas? drop
  dup 3 pick + TargetHas? drop
  >r  2 0
  DO  TargetImageBase + swap
  LOOP
  r> move
;


: TargetFill  ( addr cnt byte -- )
  >r  2dup + TargetHas? drop  >r
  TargetImageBase +
  r> r> fill
;


: TargetErase ( adr cnt -- )
  0 TargetFill
;

also Forth Definitions

: +t  ( offset -- address )
  targetimagebase +
;

.need RelDism
: RelDism  2drop ;
>newline
cr ." NOTE: disassembler not available; SHOWME will not display code."
cr cr
.then

previous definitions

: showcfa  ( cfa -- )  Substitute?  base @ >r  hex
  >newline  dup >name id. space   dup
  References stackfind 0=  swap drop
  IF
     ." is not compiled within the current TargetImage."
  ELSE
     dup cell- @ $ f,0000 and  dup VARIABLE_ID = swap USER_ID = or
     IF
        ." is Target Compiled as a VARIABLE at $ "  false
     ELSE
        ." is code residing at target address $ "   true
     THEN
     ( -- cfa flag )
     over PacketFor ..@ ref_TgtAdr dup . swap   ( -- cfa tgtadr flag )
     IF
        0 +t  over +t  RelDism
      \ dup +t cr dism
     THEN
     drop
  THEN
  drop  r> base !  cr
;

also Forth Definitions

: Showme  ( -- , name )
  [compile] '  showcfa
;


: >TargetAdr  ( cfa -- target-relative-adr )
  dup References stackfind  swap drop  0=
  ?ABORT" Specified resident CFA (on stack) does not exist in Target!"
  PacketFor ..@ ref_TgtAdr
;

only forth definitions
also TGT
