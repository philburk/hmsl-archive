
anew task-Status.f

variable Secs1  0 ,    : Mics1  Secs1 cell+ ;
variable Secs2  0 ,    : Mics2  Secs2 cell+ ;


.NEED CurrentTime()
    : CurrentTime()  ( &secs &mics -- )
      swap >abs swap >abs  call intuition_lib CurrentTime drop
    ;
.THEN


: MarkSecs1  ( -- )
  Secs1   Mics1   CurrentTime()
;


variable MaxSecs  1 maxsecs !



: DisplayTime?  ( -- flag )
  Secs2   Mics2   CurrentTime()
  \
  \ subtract them
  \
  Secs2 @   Secs1 @  -  0 max   MaxSecs @ >=  dup
  IF
     Secs2 @  Secs1 !
  THEN
;



: CSIType  ( string -- )
  out @ swap     $ 9b emit  count type  out !   ;


: +pos  ( n1 -- #add )  n>text nip 1- 2/  ;


: IsStatus  ( #words size -- )  base @ >r  decimal   swap
  " 0 p" CSIType  ( turn curs off )
  " 2A" CSIType   " K" CSIType  " 33;40m" CSIType
  9 spaces  dup +pos 7 + .r    bl 27 emit-to-column
            dup +pos 6 + .r  13 emit  " 2B" CSIType
  " 31;40m" CSIType  "  p" CSIType  flushemit   r> base !
;


: InitStatus  ( -- )  intuition?
  >newline cr
  9 spaces  " 3m" CSIType
  ." Words Cloned      Target Size"  " 0m" CSIType  2 0
  DO
     cr  9 spaces
     ." ============      ===========" cr
  LOOP
  0 0 IsStatus  marksecs1
;


defer #cloned     defer TargetSize


: .Status        #cloned  Targetsize  IsStatus   ;

: Status?  ( -- , update screen if time )
  DisplayTime?
  IF
     .Status
  THEN
;
